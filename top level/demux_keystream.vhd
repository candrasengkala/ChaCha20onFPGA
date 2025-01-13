library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity demux_keystream is
    port ( 
        Input_RegKey                     : in  std_logic_vector(511 downto 0);   --Input 512 bit
        En_dmux_keystream                : in  std_logic;                        --selector 1-bit 
        out_odd_even                     : out std_logic_vector(511 downto 0);   --output untuk odd even round dalam bentuk key yang belum diacak
        out_keystream                    : out std_logic_vector(511 downto 0)   -- output berupa keystream yang naninya akan di-XOR dengan plain text
    );
end entity demux_keystream;

architecture rtl of demux_keystream is
begin
    process(Input_RegKey, En_dmux_keystream)
    begin
        -- Inisialisasi output ke nol
        out_odd_even <= (others => '0');
        out_keystream <= (others => '0');

        case En_dmux_keystream is
            when '0' =>
                out_odd_even <= Input_RegKey; -- Input  ke Output1 out_odd_even

            when '1' =>
                out_keystream <= Input_RegKey; -- Input ke out_keystream
            when others =>
                null;    -- Semua output tetap nol
        end case;
    end process;
end architecture rtl;
