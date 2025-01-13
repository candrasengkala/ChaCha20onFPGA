library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity demux_2to1_xor is
    port (
        Input_xor   : in  std_logic_vector(31 downto 0);  -- Input  32-bit
        Sel_xor     : in  std_logic;                      -- selektor 1-bit
        Output1_xor : out std_logic_vector(31 downto 0);  -- Output  32-bit
        Output2_xor : out std_logic_vector(31 downto 0)   -- Output 32-bit
    );
end entity demux_2to1_xor;

architecture rtl of demux_2to1_xor is
begin

    process(Input_xor, Sel_xor)
    begin
        -- Inisialisasi output ke nol
        Output1_xor <= (others => '0');
        Output2_xor <= (others => '0');

       
        case Sel_xor is
            when '0' =>
                Output1_xor <= Input_xor; -- Input  ke Output1
            when '1' =>
                Output2_xor <= Input_xor; -- Input ke Output2
            when others =>
                null;                 -- Semua output tetap nol
        end case;
    end process;
end architecture rtl;
