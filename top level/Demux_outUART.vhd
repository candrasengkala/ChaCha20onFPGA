library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Demux_outUART is
    port (
        Input_UART              : in  std_logic;   --input uart tx
        Sel_switch_mode         : in  std_logic;   --selector 1-bit sebagai menentu arah komunikasi                    
        Comp_A                  : out std_logic := '1';  --output ke laptop 1
        Comp_B                  : out std_logic := '1'  --output ke laptop 2
    );
end entity Demux_outUART;

architecture rtl of Demux_outUART is
begin
    process(Input_UART, Sel_switch_mode)
    begin
        -- Default outputs 1 agar tx tidak mulai mengirim 
        Comp_A <= '1';
        Comp_B <=  '1';

        case Sel_switch_mode is
            when '0' =>
                Comp_B <= Input_UART;  -- Input  ke Comp_B
            when '1' =>
                Comp_A <= Input_UART;  -- Input ke Comp_A
            when others =>
                null; -- Semua output tetap nol
        end case;
    end process;
end architecture rtl;