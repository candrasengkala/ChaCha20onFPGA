library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity register_switch is
    port (
        Clk                : in    std_logic;  -- clock signal
        Res                : in    std_logic;  -- reset signal
        Input_Switch       : in    std_logic;  -- data input
        en_reg_mode        : in    std_logic;  -- enable signal
        Data_out_Switch  : out   std_logic     -- data output
    );
end entity;

architecture rtl of register_switch is
    -- Signal internal 1-bit
    signal v_data : std_logic;
begin
    process (Clk)
    begin
        -- jika sinyal clock berubah dan bernilai 1
        if rising_edge (Clk) then
            -- check sinyal reset. jika bernilai 1, maka reset 
            if (Res = '1') then
                -- data diubah menjadi 0
                v_data <=  '0';
            else
                -- sinyal reset bernilai 0
                -- jika sinyal enable bernilai 1, maka simpan data 
                if (en_reg_mode = '1') then
                    -- input reg disimpan ke sinyal data
                    v_data <= Input_Switch;
                end if;
            end if;
        end if;
    end process;

    -- sinyal data dimasukkan ke luaran Data_out_Switch
    Data_out_Switch <= v_data;
end architecture;