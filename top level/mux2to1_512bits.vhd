library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
use ieee.math_real.all;  

entity mux2to1_512bits is     
    port (         
        in_UART         : in    std_logic_vector (511 downto 0);    -- data input dari UART 
        in_CPRtxt       : in    std_logic_vector (511 downto 0);    -- data cipertext
        en_mux_text     : in    std_logic;                          -- selector
        Data_out        : out   std_logic_vector (511 downto 0)     -- output data
    ); 
end entity;  

architecture rtl of mux2to1_512bits is  
begin 
    -- process yang mengamati perubahan di selector 
    process (en_mux_text, in_UART, in_CPRtxt) 
    begin 
        -- jika selector bernilai 1, maka in_CPRtxt yang diteruskan ke luaran 
        if (en_mux_text = '1') then 
            Data_out <= in_CPRtxt; 
        else 
            -- jika selector bernilai 0, maka in_UART yang diteruskan ke luaran 
            Data_out <= in_UART; 
        end if; 
    end process; 
end architecture;