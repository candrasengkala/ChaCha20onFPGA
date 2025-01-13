library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity demux_1to2_Add is
    port (
        Input_add   : in  std_logic_vector(31 downto 0);  -- Input  32-bit
        Sel_add     : in  std_logic;                      -- Sinyal selektor 1-bit
        Output1_add : out std_logic_vector(31 downto 0);  -- Output  32-bit
        Output2_add : out std_logic_vector(31 downto 0)   -- Output 32-bit
    );
end entity demux_1to2_Add;

architecture rtl of demux_1to2_Add is
begin
    process(Input_add, Sel_add)
    begin
        -- Inisialisasi output nol
        Output1_add <= (others => '0');
        Output2_add <= (others => '0');

        case Sel_add is
            when '0' =>
                Output1_add <= Input_add; -- Input  ke Output1
            when '1' =>
                Output2_add <= Input_add; -- Input ke Output2
            when others =>
                null; -- output tetap nol
        end case;
    end process;
end architecture rtl;

