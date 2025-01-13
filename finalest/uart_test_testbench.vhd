library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity uart_test_testbench is
end uart_test_testbench;

architecture testbench of uart_test_testbench is
    component uart_recieve is
        port(
            clk					:	in 	std_logic;
            serial_in			:	in 	STD_LOGIC;
            en_uart_recieve		:	in	std_logic;
            reg_out				:	out STD_LOGIC_VECTOR (511 downto 0);
            uart_recieved_flag	:	out std_logic
        );
    end component;

    component UART_transmit is
        port(
            clk                     :   in  std_logic;
            en_uart_transmit        :   in  std_logic;
            paralel_in              :   in  std_logic_vector(511 downto 0);
            serial_out              :   out std_logic;
            uart_transmitted_flag   :   out std_logic   
        );
    end component;

    component Register512bits_text is
        port (
            Input_mux       : in    std_logic_vector (511 downto 0);    -- data input
            En_Input512    : in    std_logic;                         -- enable signal
            Res     : in    std_logic;                         -- reset signal
            Clk     : in    std_logic;                         -- clock signal
            Data_out512  : out   std_logic_vector (511 downto 0)     -- data output
        );
    end component;

    signal clk  :   std_logic := '1';   
    signal data_reg : std_logic_vector(511 downto 0);
    signal enable_reg : std_logic := '0';
    signal reset : std_logic := '0';
    signal data2 : std_logic_vector(511 downto 0);
    signal en_uart_transmit_1 : std_logic := '0';
    signal data1 : std_logic_vector(511 downto 0) := "01001100010011010101001001001111010001100101001101000001010101110100100001010100010100100100000101000101010001010100100001010100010101110100111101001110010010000101010001010010010000010100010101000101010010000101010001000100010011100100000101010011010011100100010101010110010000010100010101001000010001010100100001010100010001000100010101010100010000010100010101010010010000110100010001001111010001110100011101001110010010010100111001001110010010010100011101000101010000100100010101001000010101000100111001001001";
    signal serial1 : std_logic := '1';
    signal en_uart_recieve_1 : std_logic := '0';
    signal en_uart_transmit_2 : std_logic := '0';
    signal uart_transmitted_flag_1 : std_logic := '0';
    signal uart_recieved_flag_1 : std_logic := '0';
    signal uart_transmitted_flag_2 : std_logic := '0';
    signal en_uart_recieve_2       : std_logic := '0';
    signal data_Reg2               : std_logic_vector(511 downto 0);
    signal uart_recieved_flag_2     : std_logic := '0';

    signal serial2      :   std_logic := '1';
    type state is (s1, s2, checksent, s3, s4);
    signal currentstate : state;
begin
    register_instantiation : Register512bits_text   port map(data_reg, enable_reg, reset, clk, data2);
    uart_transmit_1              : UART_Transmit    port map(clk, en_uart_transmit_1, data1, serial1, uart_transmitted_flag_1);
    uart_recieve_1               : UART_recieve     port map(clk, serial1, en_uart_recieve_1, data_reg, uart_recieved_flag_1);
    uart_transmit_2              : UART_transmit    port map(clk, en_uart_transmit_2, data2, serial2, uart_transmitted_flag_2);
    uart_recieve_2               : UART_recieve     port map(clk, serial2, en_uart_recieve_2, data_reg2, uart_recieved_flag_2);
    clkgen : process
    begin
        wait for 10 ns;
        clk <= not clk;
    end process;

    psuedofsm   :   process(currentstate, clk, uart_transmitted_flag_1, uart_transmitted_flag_2)
    begin
        if (rising_edge (clk)) then
            case currentstate is
                when s1 =>
                    data1 <= "01001001010011100101010001001000010001010100001001000101010001110100100101001110010011100100100101001110010001110100011101001111010001000100001101010010010001010100000101010100010001010100010001010100010010000100010101001000010001010100000101010110010001010100111001010011010000010100111001000100010101000100100001000101010001010100000101010010010101000100100001001110010011110101011101010100010010000100010101000101010000010101001001010100010010000101011101000001010100110100011001001111010100100100110101001100";
                    enable_reg <= '1';
                    en_uart_transmit_1 <= '1';
                    en_uart_recieve_1 <= '1';
                    en_uart_transmit_2 <= '0';
                    en_uart_recieve_2 <= '0';
                    currentstate <= checksent;
					 when checksent =>
						  data1 <= "01001001010011100101010001001000010001010100001001000101010001110100100101001110010011100100100101001110010001110100011101001111010001000100001101010010010001010100000101010100010001010100010001010100010010000100010101001000010001010100000101010110010001010100111001010011010000010100111001000100010101000100100001000101010001010100000101010010010101000100100001001110010011110101011101010100010010000100010101000101010000010101001001010100010010000101011101000001010100110100011001001111010100100100110101001100";
                    enable_reg <= '1';
                    en_uart_transmit_1 <= '0';
                    en_uart_recieve_1 <= '1';
                    en_uart_transmit_2 <= '0';
                    en_uart_recieve_2 <= '0';
						  if(uart_transmitted_flag_1 = '1') then
								currentstate <= s2;
						  else
								currentstate <= checksent;
						  end if;
                when s2 =>
                    data1 <= "01001001010011100101010001001000010001010100001001000101010001110100100101001110010011100100100101001110010001110100011101001111010001000100001101010010010001010100000101010100010001010100010001010100010010000100010101001000010001010100000101010110010001010100111001010011010000010100111001000100010101000100100001000101010001010100000101010010010101000100100001001110010011110101011101010100010010000100010101000101010000010101001001010100010010000101011101000001010100110100011001001111010100100100110101001100";
                    en_uart_transmit_1 <= '0';
                    en_uart_recieve_1 <= '0';
                    en_uart_transmit_2 <= '0';
                    enable_reg <= '1';
                    reset <= '0';
                    currentstate <= s3;
                when s3 =>
                    data1 <= "01001111011011100110010100100000011011010110111101110010011011100110100101101110011001110010110000100000011101110110100001100101011011100010000001000111011100100110010101100111011011110111001000100000010100110110000101101101011100110110000100100000011101110110111101101011011001010010000001100110011100100110111101101101001000000111010001110010011011110111010101100010011011000110010101100100001000000110010001110010011001010110000101101101011100110010110000100000011010000110010100100000011001100110111101110101";
                    en_uart_transmit_1 <= '0';
                    en_uart_recieve_1 <= '0';
                    en_uart_transmit_2 <= '1';
                    en_uart_recieve_2 <= '1';
                    enable_reg <= '0';
                    reset <= '0';
                    if(uart_recieved_flag_2 = '1') then
                        currentstate <= s4;
                    else
                        currentstate <= s3;
                    end if;
                when s4 => 
                    data1 <= "01001111011011100110010100100000011011010110111101110010011011100110100101101110011001110010110000100000011101110110100001100101011011100010000001000111011100100110010101100111011011110111001000100000010100110110000101101101011100110110000100100000011101110110111101101011011001010010000001100110011100100110111101101101001000000111010001110010011011110111010101100010011011000110010101100100001000000110010001110010011001010110000101101101011100110010110000100000011010000110010100100000011001100110111101110101";
                    en_uart_transmit_1 <= '0';
                    en_uart_recieve_1 <= '0';
                    en_uart_transmit_2 <= '0';
                    en_uart_recieve_2 <= '0';
                    enable_reg <= '0';
                    reset <= '0';
                end case;
            end if;
    end process;
    --stopping once it have sent 64 byte.Clk
end architecture;