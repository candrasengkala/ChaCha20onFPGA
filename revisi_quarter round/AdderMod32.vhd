library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AdderMod32 is
    port(
        A : in std_logic_vector (31 downto 0); --Input A
        B : in std_logic_vector (31 downto 0); --Input B 
        C : out std_logic_vector (31 downto 0) --Output C hasil adder modulo 32
    );
end AdderMod32;

architecture behavioral of AdderMod32 is

begin

    C <= std_logic_vector(unsigned(A) + unsigned(B)); -- penjumlahan 32-bit tanpa memperhatikan carry (adder mod 32)
    
end behavioral;