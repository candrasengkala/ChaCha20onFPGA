library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.math_real.all;  

entity mux2to1_transmitUART is     
    port (         
        Input_dmux_key          : in    std_logic_vector (511 downto 0);    -- input key rng yang sebelumnya disimpan dalam register
        Input_CPRtxt            : in    std_logic_vector (511 downto 0);    -- input cipertext 
        En_mux_transmit         : in    std_logic;                          -- selector
        Data_trasmit            : out   std_logic_vector (511 downto 0)     -- output data
    ); 
end entity;  

architecture rtl of mux2to1_transmitUART is  
begin 
    -- process yang mengamati perubahan di selector 
    process (En_mux_transmit, Input_dmux_key, Input_CPRtxt) 
    begin 
        -- jika selector bernilai 1, maka Input_CPRtxt yang diteruskan ke luaran 
        if (En_mux_transmit = '1') then 
            Data_trasmit <= Input_CPRtxt; 
        else 
            -- jika selector bernilai 0, maka Input_dmux_key yang diteruskan ke luaran 
            Data_trasmit <= Input_dmux_key; 
        end if; 
    end process; 
end architecture;