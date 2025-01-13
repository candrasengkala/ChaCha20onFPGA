library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity transmittingtodone is
	port(	clk				:	in 	std_logic;
			transmitting	:	in 	std_logic;
			done			:	out 	std_logic := '0');
end entity;

architecture rtl of transmittingtodone is
	type state is (s1, s2, s3);
	signal currentstate : state;	
	begin
	process(clk, transmitting, currentstate)
		begin
		if(rising_edge(clk)) then
			case currentstate is
				when s1 =>
					done <= '0';
					if (transmitting = '1') then
						currentstate <= s2;
					end if;
				when s2 =>
					done <= '1';	
					currentstate <= s3;
				when s3 =>
					done <= '0';
					if(transmitting = '0') then
						currentstate <= s1;
					end if;
				end case;
			end if;
	end process;
end architecture;