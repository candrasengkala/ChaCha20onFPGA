library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity BitwiseXOR_512bits is     
    port(         
        In_plaintext : in std_logic_vector (511 downto 0);  -- input plaintext 512-bit
        In_keystream : in std_logic_vector (511 downto 0);  -- input keystream 512-bit
        Out_CPRtxt : out std_logic_vector (511 downto 0)    -- output xor 512-bit
    ); 
end BitwiseXOR_512bits;


architecture behavioral of BitwiseXOR_512bits is      
begin      
    --plaintext di xor dengan keystream menghasilkan cipertext
    Out_CPRtxt <= In_plaintext XOR In_keystream;  
end behavioral;