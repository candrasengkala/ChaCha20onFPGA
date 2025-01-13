library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity mux512to8 is
    port(
        sel     :   in integer range 0 to 504 := 0;
        datain  :   in std_logic_vector (511 downto 0);
        dataout :   out std_logic_vector (7 downto 0) := (others => '0')
    );
end entity;

architecture behavior of mux512to8 is
begin
    dataout <= datain((sel+7) downto sel);
end architecture;
-- mux512to8
-- FSM_mux_UART_transmit
