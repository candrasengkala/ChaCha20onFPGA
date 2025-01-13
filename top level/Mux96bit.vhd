library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Mux96bit is
    port (

        Sel_switch_mode : in std_logic;
        Data_out_mux    : out std_logic_vector(95 downto 0)
    );
end entity Mux96bit;

architecture rtl of Mux96bit is
    constant IP_1 : std_logic_vector(95 downto 0) := x"3139322E3136382E302E3132";
    constant IP_2 : std_logic_vector(95 downto 0) := x"3139322E3136382E312E3130";
begin
    process (Sel_switch_mode)
    begin
        if (Sel_switch_mode = '0') then
            Data_out_mux <= IP_2;
        else
            Data_out_mux <= IP_1;
        end if;
    end process;
end architecture rtl;
