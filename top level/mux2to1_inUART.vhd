library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.math_real.all;  

entity mux2to1_inUART is     
    port (         
        Comp_A              : in    std_logic := '1';    -- data A 
        Comp_B              : in    std_logic := '1';    -- data B
        Sel_switch_mode     : in    std_logic;                         -- selector
        Data_UART           : out   std_logic     -- output data
    ); 
end entity;  

architecture rtl of mux2to1_inUART is  
begin 
    -- process yang mengamati perubahan di selector 
    process (Sel_switch_mode, Comp_A, Comp_B) 
    begin 
        -- jika selector bernilai 1, maka Comp_B yang diteruskan ke luaran 
        if (Sel_switch_mode = '1') then 
            Data_UART <= Comp_B; 
        else 
            -- jika selector bernilai 0, maka Comp_A yang diteruskan ke luaran 
            Data_UART <= Comp_A; 
        end if; 
    end process; 
end architecture;