library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity chacha20_tb is
end chacha20_tb;

architecture testbench of chacha20_tb is
    -- Component Declaration
    component chacha20 is
        port(
            clock           : in std_logic;
            button_reset    : in std_logic;
            switch          : in std_logic;
            button_start    : in std_logic;
            o_TX_comp1      : out std_logic;
            i_RX_comp1      : in std_logic;
            o_TX_comp2      : out std_logic;
            i_RX_comp2      : in std_logic
        );
    end component;

    component UART_transmit is
        port(
            clk                     : in  std_logic;
            en_uart_transmit        : in  std_logic;
            paralel_in              : in  std_logic_vector(511 downto 0);
            serial_out              : out std_logic;
            uart_transmitted_flag   : out std_logic
        );
    end component;

    -- Signal declarations
    signal clk_tb                : std_logic := '0';
    signal reset_tb              : std_logic := '0';
    signal switch_tb             : std_logic := '0';  -- Set to 1 as requested
    signal start_tb              : std_logic ;  -- Set to 1 as requested
    signal tx_comp1_tb           : std_logic;
    signal rx_comp1_tb           : std_logic := '1';  
    signal tx_comp2_tb           : std_logic;
    signal rx_comp2_tb           : std_logic;
    signal en_uart_transmit      : std_logic := '0';
    signal uart_transmitted_flag : std_logic;

    type state is (s1, s2, s3);
    signal currentstate, nextstate : state := s1; -- Initialize to state s1

    -- Clock period definition
    constant CLK_PERIOD : time := 20 ns;

    -- 512-bit data constant
    constant DATA_512BIT : std_logic_vector(511 downto 0) := 
    "01001001010011100101010001001000010001010100001001000101010001110100100101001110010011100100100101001110010001110100011101001111010001000100001101010010010001010100000101010100010001010100010001010100010010000100010101001000010001010100000101010110010001010100111001010011010000010100111001000100010101000100100001000101010001010100000101010010010101000100100001001110010011110101011101010100010010000100010101000101010000010101001001010100010010000101011101000001010100110100011001001111010100100100110101001100";

begin
    -- Instantiate the Unit Under Test (UUT)
    UUT: chacha20 port map (
        clock         => clk_tb,
        button_reset  => reset_tb,
        switch        => switch_tb,
        button_start  => start_tb,
        o_TX_comp1    => tx_comp1_tb,
        i_RX_comp1    => rx_comp1_tb,
        o_TX_comp2    => tx_comp2_tb,
        i_RX_comp2    => rx_comp2_tb
    );

    SEND_DATA: UART_transmit port map (
        clk                  => clk_tb,
        en_uart_transmit     => en_uart_transmit,
        paralel_in           => DATA_512BIT,
        serial_out           => rx_comp1_tb,
        uart_transmitted_flag => uart_transmitted_flag
    );
    

    -- Clock generation process
    clk_process: process
    begin
        wait for CLK_PERIOD/2;
        clk_tb <= not clk_tb;
    end process;

    -- Data transmission process
    transmit_proc: process(currentstate)
    begin

        start_tb <= '0';
        
        case currentstate is
            when s1 =>
                en_uart_transmit <= '1';
                start_tb <='1';
                nextstate <= s2;

            when s2 =>
                en_uart_transmit <= '0';
                if (uart_transmitted_flag = '1') then
                    nextstate <= s3;
                else
                    nextstate <= s2;
                end if;

            when s3 =>
                en_uart_transmit <= '0'; 
                -- Remain in s3, no further action
        end case;
    end process;

    -- State change process
    statechange: process(clk_tb)
    begin
        if rising_edge(clk_tb) then
            currentstate <= nextstate;
        end if;
    end process;

end architecture;
