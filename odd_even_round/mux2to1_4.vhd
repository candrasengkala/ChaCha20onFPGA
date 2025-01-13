library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.math_real.all;  

entity mux2to1_4 is     
    port (         
        A_a4       : in    std_logic_vector (31 downto 0);    -- data A 
        B_a4       : in    std_logic_vector (31 downto 0);    -- data B
        Sel_a4     : in    std_logic;                         -- selector
        Data_a4    : out   std_logic_vector (31 downto 0)     -- output data
    ); 
end entity;  

architecture rtl of mux2to1_4 is  
begin 
    process (Sel_a4, A_a4, B_a4) 
    begin 
        -- jika selector bernilai 1, maka data B yang diteruskan ke luaran 
        if (Sel_a4 = '1') then 
            Data_a4 <= B_a4; 
        else 
            -- jika selector bernilai 0, maka data A yang diteruskan ke luaran 
            Data_a4 <= A_a4; 
        end if; 
    end process; 
end architecture;