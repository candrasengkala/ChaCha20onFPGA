library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.math_real.all;  

entity mux2to1_C is     
    port (         
        A_c       : in    std_logic_vector (31 downto 0);    -- data A 
        B_c       : in    std_logic_vector (31 downto 0);    -- data B
        Sel_c     : in    std_logic;                         -- selector
        Data_c    : out   std_logic_vector (31 downto 0)     -- output data
    ); 
end entity;  

architecture rtl of mux2to1_C is  
begin  
    process (Sel_c, A_c, B_c) 
    begin 
        -- jika selector bernilai 1, maka data B yang diteruskan ke luaran 
        if (Sel_c = '1') then 
            Data_c <= B_c; 
        else 
            -- jika selector bernilai 0, maka data A yang diteruskan ke luaran 
            Data_c <= A_c; 
        end if; 
    end process; 
end architecture;
