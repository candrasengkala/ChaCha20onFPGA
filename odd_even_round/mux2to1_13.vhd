library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.math_real.all;  

entity mux2to1_13 is     
    port (         
        A_a13      : in    std_logic_vector (31 downto 0);    -- data A 
        B_a13       : in    std_logic_vector (31 downto 0);    -- data B
        Sel_a13     : in    std_logic;                         -- selector
        Data_a13    : out   std_logic_vector (31 downto 0)     -- output data
    ); 
end entity;  

architecture rtl of mux2to1_13 is  
begin 
    process (Sel_a13, A_a13, B_a13) 
    begin 
        -- jika selector bernilai 1, maka data B yang diteruskan ke luaran 
        if (Sel_a13 = '1') then 
            Data_a13 <= B_a13; 
        else 
            -- jika selector bernilai 0, maka data A yang diteruskan ke luaran 
            Data_a13 <= A_a13; 
        end if; 
    end process; 
end architecture;