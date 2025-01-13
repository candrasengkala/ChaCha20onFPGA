library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.math_real.all;  

entity mux4to2_xor is     
    port (         
        A_xor       : in    std_logic_vector (31 downto 0);    -- data A 
        B_xor       : in    std_logic_vector (31 downto 0);    -- data B
        C_xor       : in    std_logic_vector (31 downto 0);    -- data C
        D_xor       : in    std_logic_vector (31 downto 0);    -- data D
        Sel_xor     : in    std_logic;                         -- selector 
        Data1_xor   : out   std_logic_vector (31 downto 0);    -- output 1
        Data2_xor   : out   std_logic_vector (31 downto 0)     -- output 2
    ); 
end entity;  

architecture rtl of mux4to2_xor is   
begin 
    process (Sel_xor, A_xor, B_xor, C_xor, D_xor) 
    begin 
        if (Sel_xor = '0') then 
            Data1_xor <= A_xor; --data A diteruskan ke luaran 1
            Data2_xor <= B_xor; --data B diteruskan ke luaran 2
        else 
            Data1_xor <= C_xor;  --data C diteruskan ke luaran 1
            Data2_xor <= D_xor;  --data D diteruskan ke luaran 2
        end if;  
    end process;       
end architecture;
