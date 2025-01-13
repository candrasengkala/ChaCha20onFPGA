library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.math_real.all;  

entity mux2to1_11 is     
    port (         
        A_a11       : in    std_logic_vector (31 downto 0);    -- data A 
        B_a11       : in    std_logic_vector (31 downto 0);    -- data B
        Sel_a11     : in    std_logic;                         -- selector
        Data_a11    : out   std_logic_vector (31 downto 0)     -- output data
    ); 
end entity;  

architecture rtl of mux2to1_11 is  
begin 
    process (Sel_a11, A_a11, B_a11) 
    begin 
        -- jika selector bernilai 1, maka data B yang diteruskan ke luaran 
        if (Sel_a11 = '1') then 
            Data_a11 <= B_a11; 
        else 
            -- jika selector bernilai 0, maka data A yang diteruskan ke luaran 
            Data_a11 <= A_a11; 
        end if; 
    end process; 
end architecture;