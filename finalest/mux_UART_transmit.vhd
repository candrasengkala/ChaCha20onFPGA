library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity mux_UART_transmit is 
    port(
        clk                  :   in  std_logic;   
        data_in              :   in  std_logic_vector (511 downto 0);
        increment_selector   :   in  std_logic;
        reset_selector       :   in  std_logic;
        data_out             :   out std_logic_vector (7 downto 0) := (others => '0');
        done_64              :   out std_logic 
    );
end entity;


architecture behavior of mux_UART_transmit is

    component selector is
    port(
        clk         :   in  std_logic;
        increment_selector      :   in  std_logic;
        reset_selector        :   in  std_logic;
        sel_out                 :   out integer range 0 to 504 := 0;
        done_64       :   out std_logic
    );
    end component;
    
    component mux512to8 is
        port(
            sel     :   in integer range 0 to 504;
            datain  :   in std_logic_vector (511 downto 0);
            dataout :   out std_logic_vector (7 downto 0)
        );
    end component;

    signal reset_count   :   std_logic := '0';
    signal increment_count   :   std_logic := '0';
    signal sel_out          :   integer := 0;
begin
    mux512to8_implemented               :   mux512to8               port map (sel_out, data_in, data_out);
    selector_implemented        :   selector        port map (clk, increment_selector, reset_selector, sel_out, done_64);
end architecture;
