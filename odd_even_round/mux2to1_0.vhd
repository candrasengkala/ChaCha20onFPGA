library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.math_real.all;  

entity mux2to1_0 is     
    port (         
        A_a0       : in    std_logic_vector (31 downto 0);    -- data A 
        B_a0       : in    std_logic_vector (31 downto 0);    -- data B
        Sel_a0     : in    std_logic;                         -- selector
        Data_a0    : out   std_logic_vector (31 downto 0)     -- output data
    ); 
end entity;  

architecture rtl of mux2to1_0 is  
begin 
    process (Sel_a0, A_a0, B_a0) 
    begin 
        -- jika selector bernilai 1, maka data B yang diteruskan ke luaran 
        if (Sel_a0 = '1') then 
            Data_a0 <= B_a0; 
        else 
            -- jika selector bernilai 0, maka data A yang diteruskan ke luaran 
            Data_a0 <= A_a0; 
        end if; 
    end process; 
end architecture;