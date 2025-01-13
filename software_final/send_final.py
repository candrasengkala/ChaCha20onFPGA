import serial
import time
import serial.tools.list_ports

"""
select_port()
------------
Fungsi ini menampilkan semua port COM yang tersedia untuk dipilih sebagai jalur komunikasi.
"""
def select_port():
    # Membuat daftar semua port COM yang tersedia.
    ports = serial.tools.list_ports.comports()
    portsList = []
    
    # Menampilkan setiap port COM yang tersedia kepada pengguna.
    print("Available Ports:")
    for onePort in ports:
        portsList.append(str(onePort))
        print(str(onePort))
    
    # Terus meminta input dari pengguna hingga satu buah port COM dipilih.
    while True:
        val = input("Select Port: COM")
        for port in portsList:
            if port.startswith("COM" + val):
                return "COM" + val
        print("Invalid selection. Please try again.")

"""
Main Program Flow
----------------
Setup koneksi serial dengan FPGA.
"""
try:    
    # Menyimpan port COM yang dipilih pengguna ke dalam sebuah variabel.
    portVar = select_port()
    
    # Inisialisasi komunikasi serial.
    # Baud rate dapat diubah sesuai dengan preferensi pengguna.
    fpga = serial.Serial(
        port=portVar,
        baudrate=9600,
        timeout=1
    )
    print(f"Connected to FPGA on {portVar}.")
    time.sleep(1)
    
    # Loop komunikasi utama.
    while True:
        # Pengguna dapat menuliskan plaintext di sini.
        message = input('Enter message (or "exit"): ')
        
        # Kondisi apabila pesannya "exit" (untuk mengakhiri komunikasi serial).
        if message.lower() == "exit":
            break
        
        # Handling berbagai jumlah karakter (panjang) plaintext.
        if len(message) < 64:
            # Untuk plaintext yang pendek, pad dengan dolar AS "$".
            message = message.ljust(64, '$') 
        elif len(message) > 64:
            # Untuk plaintext yang panjang, potong di karakter ke-64.
            print(f"Message too long. Truncating to 64 characters: {message[:64]}")
            message = message[:64]
        
        # Kirim plaintext ke FPGA.
        fpga.write(f"{message}\n".encode('utf-8'))
        
        # Baca dan tampilkan respon dari FPGA (jika ada).
        # Dalam sistem UART yang dirancang, baris kode ini bermanfaat apabila disandingkan dengan program "uart_test.vhd"
        response = fpga.readline().decode('utf-8').strip()
        if response:
            print(f"FPGA response: {response}")
        
except serial.SerialException as e:
    # Handling kasus eror
    print(f"Connection error: {e}")
except KeyboardInterrupt:
    # Handling kasus interupsi dari keyboard
    print("\nProgram stopped by user.")
finally:
    # Mengakhiri komunikasi serial.
    if 'fpga' in locals() and fpga.is_open:
        fpga.close()
        print("Connection closed.")