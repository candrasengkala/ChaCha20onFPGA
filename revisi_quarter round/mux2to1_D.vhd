library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.math_real.all;  

entity mux2to1_D is     
    port (         
        A_d       : in    std_logic_vector (31 downto 0);    -- data A 
        B_d       : in    std_logic_vector (31 downto 0);    -- data B
        Sel_d     : in    std_logic;                         -- selector
        Data_d    : out   std_logic_vector (31 downto 0)     -- output data
    ); 
end entity;  

architecture rtl of mux2to1_D is  
begin 
    -- process yang mengamati perubahan di selector 
    process (Sel_d, A_d, B_d) 
    begin 
        -- jika selector bernilai 1, maka data B yang diteruskan ke luaran 
        if (Sel_d = '1') then 
            Data_d <= B_d; 
        else 
            -- jika selector bernilai 0, maka data A yang diteruskan ke luaran 
            Data_d <= A_d; 
        end if; 
    end process; 
end architecture;
