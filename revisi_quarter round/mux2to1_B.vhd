library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.math_real.all;  

entity mux2to1_B is     
    port (         
        A_b       : in    std_logic_vector (31 downto 0);    -- data A 
        B_b       : in    std_logic_vector (31 downto 0);    -- data B
        Sel_b     : in    std_logic;                         -- selector
        Data_b    : out   std_logic_vector (31 downto 0)     -- output data
    ); 
end entity;  

architecture rtl of mux2to1_B is  
begin 
    process (Sel_b, A_b, B_b) 
    begin 
        -- jika selector bernilai 1, maka data B yang diteruskan ke luaran 
        if (Sel_b = '1') then 
            Data_b <= B_b; 
        else 
            -- jika selector bernilai 0, maka data A yang diteruskan ke luaran 
            Data_b <= A_b; 
        end if; 
    end process; 
end architecture;
