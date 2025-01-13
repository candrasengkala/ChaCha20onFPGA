library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.math_real.all;  

entity mux2to1_15 is     
    port (         
        A_a15       : in    std_logic_vector (31 downto 0);    -- data A 
        B_a15       : in    std_logic_vector (31 downto 0);    -- data B
        Sel_a15     : in    std_logic;                         -- selector
        Data_a15    : out   std_logic_vector (31 downto 0)     -- output data
    ); 
end entity;  

architecture rtl of mux2to1_15 is  
begin 
    process (Sel_a15, A_a15, B_a15) 
    begin 
        -- jika selector bernilai 1, maka data B yang diteruskan ke luaran 
        if (Sel_a15 = '1') then 
            Data_a15 <= B_a15; 
        else 
            -- jika selector bernilai 0, maka data A yang diteruskan ke luaran 
            Data_a15 <= A_a15; 
        end if; 
    end process; 
end architecture;