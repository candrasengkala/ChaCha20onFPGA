library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity mux4to2_add is
    port (
        A_add       : in    std_logic_vector (31 downto 0);    -- data A
        B_add       : in    std_logic_vector (31 downto 0);    -- data B
        C_add       : in    std_logic_vector (31 downto 0);    -- data C
        D_add       : in    std_logic_vector (31 downto 0);    -- data D
        E_add       : in    STD_LOGIC_VECTOR (31 downto 0);    -- data E
        Sel_add     : in    STD_LOGIC_VECTOR (1 downto 0);     -- selector 2 bit
        Data1_add   : out   std_logic_vector (31 downto 0);    -- output 1
        Data2_add   : out   std_logic_vector (31 downto 0)     -- output 2
    );
end entity;

architecture rtl of mux4to2_add is
begin
    process (Sel_add, A_add, B_add, C_add, D_add, E_add)
    begin
        if (Sel_add = "00") then 
            Data1_add <= A_add; --data A diteruskan ke luaran 1
            Data2_add <= B_add; --data B diteruskan ke luaran 2
        elsif (Sel_add = "01") then
            Data1_add <= C_add; --data A diteruskan ke luaran 1
            Data2_add <= D_add; --data B diteruskan ke luaran 2
        elsif (Sel_add = "10") then
            Data1_add <= A_add; --data A diteruskan ke luaran 1
            Data2_add <= E_add; --data B diteruskan ke luaran 2
        else
            Data1_add <= (others => '0');  -- luaran 0
            Data2_add <= (others => '0');  -- luaran 0 
        end if;
    end process;
end architecture;
