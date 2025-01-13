library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity shift_reg256_FSM is
    port (
        clk               : in std_logic;
        reset             : in std_logic;
        enables_shift_FSM : in std_logic;
        en_reg_text      : out std_logic;
        enables_shift    : in std_logic;
        flag_done        : out std_logic
    );
end entity;

architecture rtl of shift_reg256_FSM is
	 signal counter	:	integer range 0 to 64 := 0;
begin
    done_32_proc    :   process(clk)
    begin
        if(rising_edge(clk)) then
            if(reset = '0') then
					if(enables_shift_FSM = '1') then
						 if((enables_shift = '1') and (counter /= 64)) then
							  counter <= counter + 1;
							  flag_done <= '0';
							  en_reg_text <= '1';
						 elsif ((enables_shift = '0') and (counter /= 64)) then
							  counter <= counter;
							  flag_done <= '0';
							  en_reg_text <= '1';
						 else
							  counter <= counter;
							  flag_done <= '1';
							  en_reg_text <= '1';
						 end if;
					else 
						counter <= counter;
					end if;
            else
                counter <= 0;
                flag_done <= '0';

            end if;
        end if;
    end process;

end architecture;