library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity keystream is
    port (
        Clk                                  : in    std_logic;                         -- clock signal
        Res                                  : in    std_logic;                         -- reset signal
        input_key                            : in    std_logic_vector (511 downto 0);    -- data input
        En_reg_keystream                     : in    std_logic;                         -- enable signal
        out_register_keystream               : out   std_logic_vector (511 downto 0)     -- data output
    );
end entity;

architecture rtl of keystream is
    -- Signal internal 512-bit
    signal v_data : std_logic_vector (511 downto 0) := (others => '0');
begin
    process (Clk)
    begin
        -- jika sinyal clock berubah dan bernilai 1
        if rising_edge (Clk) then
            -- check sinyal reset. jika bernilai 1, maka reset 
            if (Res = '1') then
                -- data diubah menjadi 0
                v_data <= (others => '0');
            else
                -- sinyal reset bernilai 0
                -- jika sinyal enable bernilai 1, maka simpan data 
                if (En_reg_keystream = '1') then
                    -- input key disimpan ke sinyal data
                    v_data <= input_key;
                end if;
            end if;
        end if;
    end process;

    -- sinyal data dimasukkan ke luaran out_register_keystream
    out_register_keystream <= v_data;
end architecture;