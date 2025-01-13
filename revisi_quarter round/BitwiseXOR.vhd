library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BitwiseXOR is
    port(
        A : in std_logic_vector (31 downto 0); --Input A
        B : in std_logic_vector (31 downto 0); --Input B
        C : out std_logic_vector (31 downto 0)  --Hasil xor
    );
end BitwiseXOR;

architecture behavioral of BitwiseXOR is
   

begin

    C <= A XOR B; --hasil xor

end behavioral;