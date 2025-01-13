library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity Register32bit_9 is
    port (
        B9       : in    std_logic_vector (31 downto 0);    -- data input
        En_B9    : in    std_logic;                         -- enable signal
        Res     : in    std_logic;                         -- reset signal
        Clk     : in    std_logic;                         -- clock signal
        Data_B9  : out   std_logic_vector (31 downto 0)     -- data output
    );
end entity;

architecture rtl of Register32bit_9 is
    -- Signal internal 32-bit
    signal v_data : std_logic_vector (31 downto 0) := (others => '0');
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
                if (En_B9 = '1') then
                    -- data B9 disimpan ke sinyal data
                    v_data <= B9;
                end if;
            end if;
        end if;
    end process;

    -- sinyal data dimasukkan ke luaran Data_B9
    Data_B9 <= v_data;
end architecture;