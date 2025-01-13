import struct
import serial
import time
import serial.tools.list_ports

# Impor beberapa library yang diperlukan program:
# - struct: pengolahan data biner (output dari FPGA yang diterima terminal Laptop)
# - serial: memfasilitasi komunikasi melalui port serial
# - time: memperlancar kebutuhan komunikasi (dalam program ini, untuk menambahkan fitur delay)

"""
split_data(data)
---------------
Fungsi ini memisahkan (parse) stream data yang masuk menjadi beberapa komponen berbeda:
- Key (32 bytes)
- Nonce (16 bytes)
- Position (4 bytes)
- Ciphertext (64 bytes)
"""
def split_data(data):
    # Mengekstraksi 256 bit HEX key enkripsi
    key_hex = data[32:96]
    
    # Mengekstraksi 96 bit HEX nonce enkripsi
    nonce_hex = data[104:128]
    
    # Mengekstraksi 32 bit HEX block counter enkripsi
    position_hex = data[96:104]
    
    # Mengekstraksi 512 bit HEX ciphertext
    data_hex = data[128:]
    
    # Menampilkan komponen yang telah diekstrak sebagai tuple
    return key_hex, nonce_hex, position_hex, data_hex

"""
format_state_serialized(state)
-----------------------------
Fungsi ini mengonversi initial-state matrix ChaCha20 ke dalam bentuk string HEX yang terserialisasi. 
Dengan demikian, fungsi ini berguna dalam debugging dan verifikasi state yang digunakan oleh enkripsi dalam FPGA.
"""
def format_state_serialized(state):
    # Mengonversi setiap elemen 32-bit menjadi HEX 8 digit
    state_hex = [f"{x:08x}" for x in state]
    # Menyatukan seluruh HEX yang diperoleh menjadi satu string kontinu yang tidak terputus (serialisasi)
    serialized = "".join(state_hex)
    print(f"Initial State (Serialized): {serialized}")

"""
yield_chacha20_keystream(key, iv, position)
------------------------------------------
Fungsi ini adalah implementasi inti algoritma ChaCha20 yang membangkitkan keystream untuk kebutuhan dekripsi.
Implementasi yang dimaksud antara lain: operasi quarter-round dan bitwise rotations.
"""
def yield_chacha20_keystream(key, iv, position):
    # Validasi input untuk position (sama dengan block counter)
    if not isinstance(position, int):
        raise TypeError
    if position & ~0xffffffff:
        raise ValueError('Position is not uint32.')
    
    # Validasi input untuk key
    if not isinstance(key, bytes) or len(key) != 32:
        raise ValueError('Key must be 32 bytes.')
    
    # Validasi input untuk nonce
    if not isinstance(iv, bytes) or len(iv) != 12:
        raise ValueError('Nonce (IV) must be 12 bytes.')

    # Fungsi pembantu untuk operasi bitwise rotation
    def rotate(v, c):
        return ((v << c) & 0xffffffff) | (v >> (32 - c))

    # Fungsi pembantu untuk operasi quarter-round
    def quarter_round(x, a, b, c, d):
        x[a] = (x[a] + x[b]) & 0xffffffff
        x[d] = rotate(x[d] ^ x[a], 16)
        x[c] = (x[c] + x[d]) & 0xffffffff
        x[b] = rotate(x[b] ^ x[c], 12)
        x[a] = (x[a] + x[b]) & 0xffffffff
        x[d] = rotate(x[d] ^ x[a], 8)
        x[c] = (x[c] + x[d]) & 0xffffffff
        x[b] = rotate(x[b] ^ x[c], 7)

    # Inisialisasi state ChaCha20
    ctx = [0] * 16
    ctx[:4] = (1952801133, 1684368481, 1885433442, 1701601651)  # Konstanta yang digunakan (tidak berubah)
    ctx[4:12] = struct.unpack('>8L', key)  # Key
    ctx[12] = position  # Block counter
    ctx[13] = struct.unpack('>L', iv[:4])[0]  # Nonce (bagian 1)
    ctx[14] = struct.unpack('>L', iv[4:8])[0]  # Nonce (bagian 2)
    ctx[15] = struct.unpack('>L', iv[8:])[0]  # Nonce (bagian 3)

    # Menampilkan initial-state matrix (untuk mempermudah debugging)
    format_state_serialized(ctx)

    # Loop enkripsi utama
    while True:
        x = list(ctx)
        # Melakukan 10 double-round (odd-even rounds)
        for i in range(10):
            quarter_round(x, 0, 4,  8, 12)
            quarter_round(x, 1, 5,  9, 13)
            quarter_round(x, 2, 6, 10, 14)
            quarter_round(x, 3, 7, 11, 15)
            quarter_round(x, 0, 5, 10, 15)
            quarter_round(x, 1, 6, 11, 12)
            quarter_round(x, 2, 7,  8, 13)
            quarter_round(x, 3, 4,  9, 14)
        # Mengambil setiap byte keystream yang dibangkitkan
        for c in struct.pack('<16L', *x):
            yield c

"""
format_keystream_serialized(key, nonce, position)
-----------------------------------------------
Fungsi ini memformat 64 byte pertama keystream ke dalam bentuk HEX yang terserialisasi.
Dengan demikian, keystream siap untuk di-XOR-kan dengan ciphertext.
"""
def format_keystream_serialized(key, nonce, position):
    # Membangkitkan 64 byte pertama keystream dengan fungsi ChaCha20 yang dibuat sebelumnya
    keystream = [x for _, x in zip(range(64), yield_chacha20_keystream(key, nonce, position))]
    
    # Verifikasi jumlah byte keystream
    if len(keystream) < 64:
        raise ValueError("Keystream less than 64 bytes.")
    
    # Mengonversi format dary byte ke HEX little-endian berukuran 32 bit
    keystream_32bit = [
        f"{keystream[i+3]:02x}{keystream[i+2]:02x}{keystream[i+1]:02x}{keystream[i]:02x}"
        for i in range(0, len(keystream), 4)
    ]
    
    # Serialisasi keystream
    serialized = "".join(keystream_32bit)
    print(f"Keystream (Serialized): {serialized}")
    return serialized

"""
xor_with_keystream(ciphertext_hex, keystream_hex)
-----------------------------------------------
Fungsi ini mendekripsi ciphertext (operasi XOR antara ciphertext dengan keystream).
Kemudian, plaintext dikonversi ke utf-8 untuk mempermudah bacaan.
Khusus jenis plaintext <64 karakter, padding dollar AS "$" dihapus dari belakang (trailing).
"""
def xor_with_keystream(ciphertext_hex, keystream_hex):
    # Konversi string HEX ke byte 
    ciphertext = bytes.fromhex(ciphertext_hex)
    keystream = bytes.fromhex(keystream_hex)
    
    # Operasi XOR
    plaintext = bytes(c ^ k for c, k in zip(ciphertext, keystream))
    
    # Merapikan dan membersihkan plaintext yang diperoleh untuk mempermudah bacaan.
    plaintext_ascii = plaintext.decode('utf-8')
    plaintext_ascii = plaintext_ascii.rstrip('$')
    print(f"Plaintext: {plaintext_ascii}")

"""
read_from_com_port(port, baudrate, timeout=1)
-------------------------------------------
Fungsi utama dalam komunikasi serial; secara kontinu membaca data dari port COM.
Kemudian, data yang diterima diproses melalui dekripsi ChaCha20 untuk menghasilkan plaintext.
Fungsi ini juga mengatasi setup koneksi dan berbagai case eror.
"""
def read_from_com_port(port, baudrate, timeout=1):
    try:
        # Membuka koneksi serial.
        with serial.Serial(port, baudrate, timeout=timeout) as ser:
            print(f"Connected to {port} at {baudrate} baud.")

            while True:
                # Membaca data yang masuk.
                data = ser.readline()

                if data:
                    # Menunggu hingga transmisi data benar-benar selesai.
                    # Waktu 3 detik sudah disesuaikan dengan baud rate dan durasi enkripsi FGPA untuk menghindari
                    # interupsi apabila proses dekripsi telah dimulai.
                    print(f"Data received. Waiting 3 seconds to ensure complete transmission...")
                    time.sleep(3)
                    
                    # Koneksi serial menunggu hingga semua data benar-benar masuk tanpa terkecuali.
                    additional_data = ser.read(ser.in_waiting)
                    data += additional_data
                    
                    # Mengonversi data ke bentuk HEX dan menampilkannya untuk verifikasi.
                    hex_data = data.hex()
                    print(f"Received: {hex_data}")

                    try:
                        # Parsing stream data.
                        key_hex, nonce_hex, position_hex, data_hex = split_data(hex_data)

                        # Mengonversi setiap komponen ke format yang sesuai.
                        key = bytes.fromhex(key_hex)
                        nonce = bytes.fromhex(nonce_hex)
                        position = int(position_hex, 16)

                        # Menampilkan setiap komponen untuk verifikasi.
                        print(f"Key: {key_hex}")
                        print(f"Nonce: {nonce_hex}")
                        print(f"Counter: {position_hex}")

                        # Menghasilkan keystream dan melakukan dekripsi
                        # Dua baris di bawah merupakan yang terpenting dari seluruh program dekripsi.
                        keystream_hex = format_keystream_serialized(key, nonce, position)
                        xor_with_keystream(data_hex, keystream_hex)
                    except IndexError:
                        print("Received data is too short to parse into the required format.")

                    # Memeriksa apakah ada perintah exit.
                    if hex_data.lower() == "65786974":  # "exit" dalam HEX
                        print("Exit command received. Closing connection.")
                        break

    except serial.SerialException as e:
        print(f"Error opening or communicating with {port}: {e}")

"""
select_port()
------------
This function lists all available COM ports for the user to select one for communication.
"""
def select_port():
    ports = serial.tools.list_ports.comports()
    portsList = []

    print("Available Ports:")
    for onePort in ports:
        portsList.append(str(onePort))
        print(str(onePort))

    while True:
        val = input("Select Port: COM")
        for port in portsList:
            if port.startswith("COM" + val):
                return "COM" + val
        print("Invalid selection. Please try again.")

# Entry point.
if __name__ == "__main__":
    com_port = select_port() # Setup port COM (sesuaikan dengan perangkat yang digunakan).
    baud_rate = 9600    # Set baud rate (sesuaikan dengan UART dan preferensi pengguna).
    read_from_com_port(com_port, baud_rate)

    