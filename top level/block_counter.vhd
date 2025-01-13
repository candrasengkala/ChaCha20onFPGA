library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity block_counter is
	port (
        clk      	            : in  std_logic;                         -- sinyal clock
        counter_switch       	: in  std_logic;                         -- sinyal enable
        output_counter    	    : out std_logic_vector (31 downto 0)    -- hasil penghitungan
    );
end block_counter;

architecture rtl of block_counter is
    signal Count_temp : unsigned (31 downto 0) := (others => '0');
begin

    process (Clk)
    begin
        if rising_edge(Clk) then
            if counter_switch = '1' then
                if Count_temp = "11111111111111111111111111111111" then -- Nilai maksimum
                    Count_temp <= (others => '0'); -- Reset ke nol
                else
                    Count_temp <= Count_temp + 1;
                end if;
            end if;
        end if;
    end process;

    output_counter <= std_logic_vector(Count_temp);

end rtl;

		