library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.math_real.all;  

entity mux2to1_A is     
    port (         
        A_a       : in    std_logic_vector (31 downto 0);    -- data A 
        B_a       : in    std_logic_vector (31 downto 0);    -- data B
        Sel_a     : in    std_logic;                         -- selector
        Data_a    : out   std_logic_vector (31 downto 0)     -- output data
    ); 
end entity;  

architecture rtl of mux2to1_A is  
begin 
    process (Sel_a, A_a, B_a) 
    begin 
        -- jika selector bernilai 1, maka data B yang diteruskan ke luaran 
        if (Sel_a = '1') then 
            Data_a <= B_a; 
        else 
            -- jika selector bernilai 0, maka data A yang diteruskan ke luaran 
            Data_a <= A_a; 
        end if; 
    end process; 
end architecture;
