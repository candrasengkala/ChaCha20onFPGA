library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;


entity chacha20_control_unit is
    port(
        clk                     :   in std_logic;
        button_start            :   in std_logic;
        button_reset            :   in std_logic;
        en_reg_mode             :   out std_logic;
        en_uart_recieve         :   out std_logic;
        uart_recieved_flag      :   in std_logic;
        en_mux_text             :   out std_logic;
        en_reg_text             :   out std_logic;
        cnt_in                  :   out std_logic;
        counter_switch          :   out std_logic;
        enable_i                :   out std_logic;
        enables_shift           :   out std_logic;
        en_mux_keystream        :   out std_logic;
        En_reg_keystream        :   out std_logic;
        En_dmux_keystream       :   out std_logic;
        start_oddeven           :   out std_logic;
        flag_oddeven_out        :   in std_logic;
        En_mux_transmit         :   out std_logic;
        en_uart_transmit        :   out std_logic;
        uart_transmitted_flag   :   in std_logic;
        register_reset          :   out std_logic;
        led_out                 :   out STD_LOGIC;
        rng_done_flag           :   in std_logic;
		  led_tx                  :    out std_logic 
    );
end entity;


architecture rtl of chacha20_control_unit is
    --16 state FSM
	type states is (
        bgin, reset_reg, load, recieving, genkey_1, genkey_2,
        loadkey, oddevenround, regload, 
        x_or, load_cipher, send1,send1_wait, send2,send2_wait, 
        tamat
    );

    signal currentstate, nextstate     :   states;

begin

    clockedprocess   :   process(clk, button_reset)
    begin
        if (button_reset = '1') then
            currentstate <= bgin; -- Reset ke state awal
        elsif (rising_edge(clk)) then
            currentstate <= nextstate; -- lanjut ke state berikutnya
        end if;
    end process;

    

    state_logic : process(currentstate, clk, button_reset, button_start,uart_recieved_flag, rng_done_flag , uart_transmitted_flag, flag_oddeven_out)
    begin
        -- Inisialisasi sinyal output default 0 
        en_reg_mode <= '0';
        en_uart_recieve <= '0';
        en_mux_text <= '0';
        en_reg_text <= '0';
        cnt_in <= '0';
        counter_switch <= '0';
        enable_i <= '0';
        enables_shift <= '0';
        en_mux_keystream <= '0';
        En_reg_keystream <= '0';
        En_dmux_keystream <= '0';
        start_oddeven <= '0';
        En_mux_transmit <= '0';
        en_uart_transmit <= '0';
        register_reset <= '0';
        led_out <='1';
		led_tx <='1';
       

        case currentstate is
            when bgin           =>
                led_tx <= '0';
                if(button_start = '1') then
                    -- jika enable 1 maka lanjut ke reset reg
                    -- atau proses quarter round dimuali 
                    nextstate <= reset_reg;
                else
                    nextstate <= bgin;
                    --looping hingga enable bernilai 1
                end if;
            
            when reset_reg => 
                --mereset register 512 bits dan 256 bits shift register 
                --enable register 1 bit untuk mengubah arah komunikasi
                --en UART recieve, memulai proses recieve 512 bit
                register_reset <= '1';
                en_reg_mode <= '1';
                en_uart_recieve <= '1';

                nextstate <= load;

            when load =>
                
                --enable register 512 bit text agar setiap bit yang diterima register tetap diperbarui
                en_mux_text <= '0';
                en_reg_text <= '1';
                

                nextstate <= recieving;

            when recieving      =>
                --menyalakan led untuk menandakan state recieve
                --menunggu hingga receiving selesai yang ditandai dengan input uart_recieved_flag = '1'
                led_out <='0';
                en_mux_text <= '0';
                en_reg_text <= '1';
                en_uart_recieve <= '0';
                enable_i <= '0';
                
                if (uart_recieved_flag = '1') then
                    nextstate <= genkey_1;
                else
                    nextstate <= recieving;
                end if;

            when genkey_1         =>
                --increment counter
                --increment nonce
                --enable reg keystrem  agar isi register diperbarui 
                counter_switch <= '1';
                en_mux_keystream <= '1';
                en_reg_keystream <= '1';
                cnt_in <= '1';
                
              
                nextstate <= genkey_2 ;

            when genkey_2         =>
                --enable RNG untuk mulai menghasilkan bit acak
                --enable rng tetap diaktifkan sehingga initial state dapat dihasilkan
                --menunggu hingga shift register terisi penuh yang ditandai dengan input rng_done_flag = '1'
                enable_i <= '1';
                en_mux_keystream <= '1';
                en_reg_keystream <= '1';
                enables_shift <= '1';

                if(rng_done_flag = '1') then
                    nextstate <= send1;
                else
                    nextstate <= genkey_2;
                end if;

            when send1          =>
                --menyalakan led untuk menandakan state transmit
                --enable uart transmit, memulai proses transmit initial state key 512 bits
				led_tx <= '0';
                en_mux_transmit <= '0';
                en_uart_transmit <= '1';
               
                nextstate <= send1_wait;
   
            
            when send1_wait          =>
                --menunggu hingga transmitting selesai yang ditandai dengan input uart_transmitted_flag = '1'
				led_tx <= '0';
                en_mux_transmit <= '0';
 
                if(uart_transmitted_flag = '1') then
                    nextstate <= loadkey;
                else
                    nextstate <= send1_wait;
                end if;

            when loadkey        =>
                --enable oddeven, memulai proses odd even round
                en_dmux_keystream <= '0';
                start_oddeven <= '1';

                nextstate <= oddevenround;

            when oddevenround    =>
                --menunggu hingga proses odd even selesai yang ditandai dengan input flag_oddeven_out = '1'
                en_dmux_keystream <= '0';
                en_mux_keystream <= '0';
                
                if (flag_oddeven_out = '1') then
                    nextstate <= regload;
                else
                    nextstate <= oddevenround;
                end if;

            when regload        =>
                --update register keystream yang semulanya berisi initial state diperbarui menjadi keystream 
                en_reg_keystream <= '1';
                en_mux_keystream <= '0';
                nextstate <= x_or;

            when x_or           =>
                --mengatur selector mux dan demux agar keystrem dapat di xor dengan plain text menghasilkan cipertext
                en_dmux_keystream <= '1';
                en_mux_text       <= '1';
                nextstate         <= load_cipher;

            when load_cipher    =>
                --enable register text agar cipertext dapat disimpan dalam register text 
                en_dmux_keystream <= '1';
                en_reg_text <= '1';
                en_mux_text <= '1';
                nextstate <= send2;

            when send2          =>
                --enable uart transmit unutk memulai proses transmit cipertext
				led_tx <='0';
                en_mux_transmit <= '1';
                en_uart_Transmit <= '1';

             
                nextstate <= send2_wait;


            when send2_wait          =>
                --menunggu hingga transmitting selesai yang ditandai dengan input uart_transmitted_flag = '1'
					led_tx <= '0';
                en_mux_transmit <= '1';

                if(uart_transmitted_flag = '1') then
                    nextstate <= tamat;
                else
                    nextstate <= send2_wait;
                end if;

            when tamat          =>
                --proses enkripsi berakhir dan kembali ke state begin
					led_tx <= '0';
                nextstate <= bgin;

        end case;
    end process;
end architecture;
