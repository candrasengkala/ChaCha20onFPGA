library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.math_real.all;  

entity mux2to1_2 is     
    port (         
        A_a2       : in    std_logic_vector (31 downto 0);    -- data A 
        B_a2       : in    std_logic_vector (31 downto 0);    -- data B
        Sel_a2     : in    std_logic;                         -- selector
        Data_a2    : out   std_logic_vector (31 downto 0)     -- output data
    ); 
end entity;  

architecture rtl of mux2to1_2 is  
begin  
    process (Sel_a2, A_a2, B_a2) 
    begin 
        -- jika selector bernilai 1, maka data B yang diteruskan ke luaran 
        if (Sel_a2 = '1') then 
            Data_a2 <= B_a2; 
        else 
            -- jika selector bernilai 0, maka data A yang diteruskan ke luaran 
            Data_a2 <= A_a2; 
        end if; 
    end process; 
end architecture;