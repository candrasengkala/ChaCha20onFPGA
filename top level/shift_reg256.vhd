library ieee;
use ieee.std_logic_1164.all;

entity shift_reg256 is
    port(
        clk           : in std_logic;                        --clock
        reset         : in std_logic;                        --reset
        enables_shift : in std_logic;                        --enable yang dikontrol oleh valid_o rng
        Input_Data    : in std_logic_vector (7 downto 0);    --input 8 bit dari hasil keluaran rng
        Q            : out std_logic_vector(255 downto 0)    -- output 256 setelah semua terisi
    );
end shift_reg256;

architecture rtl of shift_reg256 is
    -- Register geser 256-bit dengan nilai awal 0
    signal shift_reg : std_logic_vector(255 downto 0) := (others => '0'); 
 begin

    process (clk)     
    begin
        if (reset = '1') then          
            shift_reg <= (others => '0');
            
        elsif (rising_edge(clk)) then
            if (enables_shift = '1') then              
                shift_reg(255 downto 8) <= shift_reg(247 downto 0); --menggeser 8 bit ke kiri (MSB)          
                shift_reg(7 downto 0) <= Input_Data;  --input 8 bit (LSB)                             
            end if;
        end if;
    end process;
  
    Q <= shift_reg;
 end rtl;