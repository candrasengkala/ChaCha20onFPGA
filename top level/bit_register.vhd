library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity bit_register is
    port (
        clk             : in    std_logic;                         -- clock signal
        Reset           : in    std_logic;                         -- reset signal
        input_reg       : in    std_logic_vector (511 downto 0);    -- data input
        en_reg_text     : in    std_logic;                         -- enable signal
        output_reg      : out   std_logic_vector (511 downto 0)     -- data output
    );
end entity;

architecture rtl of bit_register is
    -- Signal internal 512-bit
    signal v_data : std_logic_vector (511 downto 0) := (others => '0');
begin
    process (Clk)
    begin
        -- jika sinyal clock berubah dan bernilai 1
        if rising_edge (Clk) then
            -- check sinyal reset. jika bernilai 1, maka reset 
            if (Reset = '1') then
                -- data diubah menjadi 0
                v_data <= (others => '0');
            else
                -- sinyal reset bernilai 0
                -- jika sinyal enable bernilai 1, maka simpan data 
                if (en_reg_text = '1') then
                    -- input reg disimpan ke sinyal data
                    v_data <= input_reg;
                end if;
            end if;
        end if;
    end process;

    -- sinyal data dimasukkan ke luaran output_reg
    output_reg <= v_data;
end architecture;