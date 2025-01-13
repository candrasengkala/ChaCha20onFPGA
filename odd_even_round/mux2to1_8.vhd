library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.math_real.all;  

entity mux2to1_8 is     
    port (         
        A_a8       : in    std_logic_vector (31 downto 0);    -- data A 
        B_a8       : in    std_logic_vector (31 downto 0);    -- data B
        Sel_a8     : in    std_logic;                         -- selector
        Data_a8    : out   std_logic_vector (31 downto 0)     -- output data
    ); 
end entity;  

architecture rtl of mux2to1_8 is  
begin 
    process (Sel_a8, A_a8, B_a8) 
    begin 
        -- jika selector bernilai 1, maka data B yang diteruskan ke luaran 
        if (Sel_a8 = '1') then 
            Data_a8 <= B_a8; 
        else 
            -- jika selector bernilai 0, maka data A yang diteruskan ke luaran 
            Data_a8 <= A_a8; 
        end if; 
    end process; 
end architecture;