library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity shift_register is
    port(clk        :   in  std_logic;
		reset		  :	in  std_logic;
         enable     :   in  std_logic;
         data_in    :   in std_logic_vector(7 downto 0);
         data_out   :   out std_logic_vector(511 downto 0) := (others => '0');
         done_64    :   out std_logic 
    );
end entity;

architecture rtl of shift_register is
signal firstbit         :   STD_LOGIC_VECTOR(63 downto 0) := (others => '0');--1st bit
signal secondbit        :   STD_LOGIC_VECTOR(63 downto 0) := (others => '0');--2nd bit
signal thirdbit         :   STD_LOGIC_VECTOR(63 downto 0) := (others => '0');--3rd bit
signal fourthbit        :   STD_LOGIC_VECTOR(63 downto 0) := (others => '0');--4th bit
signal fifthbit         :   STD_LOGIC_VECTOR(63 downto 0) := (others => '0');--6th bit
signal sixthbit         :   STD_LOGIC_VECTOR(63 downto 0) := (others => '0');--5th bit
signal seventhbit       :   STD_LOGIC_VECTOR(63 downto 0) := (others => '0');--7th bit
signal eightbit         :   STD_LOGIC_VECTOR(63 downto 0) := (others => '0');--7th bit

--8th bit
signal o_data           :   std_logic_vector(511 downto 0) := (others => '0');
signal counter          :   integer range 0 to 65 := 0;
begin
    --linking, biar sesuai. Atau, perlukan dibalik? Rasanya malah tambah rumit. Nanti saja saat port mapping.
    firstbitgen:   for ii in 0 to 63 generate
            o_data(ii*8) <= firstbit(ii);
    end generate;

    secondbitgen: for ii in 0 to 63 generate
            o_data(ii*8 + 1) <= secondbit(ii);
    end generate;

    thirdbitgen: for ii in 0 to 63 generate
            o_data(ii*8 + 2) <= thirdbit(ii);
    end generate;

    fourthbitgen: for ii in 0 to 63 generate
        o_data(ii*8 + 3) <= fourthbit(ii);
    end generate;

    fifthbitgen: for ii in 0 to 63 generate
        o_data(ii*8 + 4) <= fifthbit(ii);
    end generate;

    sixthbitgen: for ii in 0 to 63 generate
            o_data(ii*8 + 5) <= sixthbit(ii);
    end generate;

    seventhbitgen    :  for ii in 0 to 63 generate
            o_data(ii*8 + 6) <= seventhbit(ii);
    end generate;

    eightbitgen    :   for ii in 0 to 63 generate
            o_data(ii*8 + 7) <= eightbit(ii);
    end generate;

    shiftreg1  : process(clk) 
    begin
		--  firstbit <= (others => '0');
        if(rising_edge(clk)) then
            if((enable = '1') and (reset = '0')) then
                firstbit <= firstbit(firstbit'left-1 downto 0) & data_in(0); --ya ini masuknya dari kanan. coba saja pikirkan. goblok.
            elsif ((enable = '0') and (reset = '0')) then
                firstbit <= firstbit;
            else
				firstbit <= (others => '0');
			end if;
        end if;
    end process;

    shiftreg2  : process(clk) 
    begin
		--  secondbit <= (others => '0');
        if(rising_edge(clk)) then
            if((enable = '1') and (reset = '0')) then
                secondbit <= secondbit(secondbit'left-1 downto 0) & data_in(1); --ya ini masuknya dari kanan. coba saja pikirkan. goblok.
            elsif ((enable = '0') and (reset = '0')) then
                secondbit <= secondbit;
            else
                secondbit <= (others => '0');
            end if;
        end if;
    end process;

    shiftreg3  : process(clk) 
    begin
		--  thirdbit <= (others => '0');
        if(rising_edge(clk)) then
            if((enable = '1') and (reset = '0')) then
                thirdbit <= thirdbit(thirdbit'left-1 downto 0) & data_in(2); --ya ini masuknya dari kanan. coba saja pikirkan. goblok.
            elsif ((enable = '0') and (reset = '0')) then
                thirdbit <= thirdbit;
            else
                thirdbit <= (others => '0');
            end if;
        end if;
    end process;

    shiftreg4  : process(clk) 
    begin
	--	  fourthbit <= (others => '0');
        if(rising_edge(clk)) then
            if((enable = '1') and (reset = '0')) then
                fourthbit <= fourthbit(fourthbit'left-1 downto 0) & data_in(3); --ya ini masuknya dari kanan. coba saja pikirkan. goblok.
            elsif ((enable = '0') and (reset = '0')) then
                fourthbit <= fourthbit;
            else
                fourthbit <= (others => '0');
            end if;
        end if;
    end process;

    shiftreg5  : process(clk) 
    begin
	--	  fifthbit <= (others => '0');
        if(rising_edge(clk)) then
            if((enable = '1') and (reset = '0')) then
                fifthbit <= fifthbit(fifthbit'left-1 downto 0) & data_in(4); --ya ini masuknya dari kanan. coba saja pikirkan. goblok.
            elsif ((enable = '0') and (reset = '0')) then
                fifthbit <= fifthbit;
            else
                fifthbit <= (others => '0');
            end if;
        end if;
    end process;

    shiftreg6  : process(clk) 
    begin
	--	  sixthbit <= (others => '0');
        if(rising_edge(clk)) then
            if((enable = '1') and (reset = '0')) then
                sixthbit <= sixthbit(sixthbit'left-1 downto 0) & data_in(5); --ya ini masuknya dari kanan. coba saja pikirkan. goblok.
            elsif ((enable = '0') and (reset = '0')) then
                sixthbit <= sixthbit;
            else
                sixthbit <= (others => '0');
            end if;
        end if;
    end process;

    shiftreg7  : process(clk) 
    begin
	--	  seventhbit <= (others => '0');
        if(rising_edge(clk)) then
            if((enable = '1') and (reset = '0')) then
                seventhbit <= seventhbit(seventhbit'left-1 downto 0) & data_in(6); --ya ini masuknya dari kanan. coba saja pikirkan. goblok.
            elsif ((enable = '0') and (reset = '0')) then
                seventhbit <= seventhbit;
            else
                seventhbit <= (others => '0');
            end if;
        end if;
    end process;

    shiftreg8  : process(clk) 
    begin
--		  eightbit <= (others => '0');
        if(rising_edge(clk)) then
            if((enable = '1') and (reset = '0')) then
                eightbit <= eightbit(eightbit'left-1 downto 0) & data_in(7); --ya ini masuknya dari kanan. coba saja pikirkan. goblok.
            elsif ((enable = '0') and (reset = '0')) then
                eightbit <= eightbit;
            else
					 eightbit <= (others => '0');
			end if;
        end if;
    end process;
	 
    firstbitoutputlinking    :   for ii in 0 to 63 generate
        data_out(8*ii) <= o_data((ii)*8);
    end generate;

    secondbitoutputlinking    :   for ii in 0 to 63 generate
        data_out(8*ii + 1) <= o_data((ii)*8 + 1);
    end generate;

    thirdbitoutputlinking    :   for ii in 0 to 63 generate
        data_out(8*ii + 2) <= o_data((ii)*8 + 2);
    end generate;

    fourthbitoutputlinking   :   for ii in 0 to 63 generate
        data_out(8*ii + 3) <= o_data((ii)*8 + 3);
    end generate;

    fifthbitoutputlinking   :   for ii in 0 to 63 generate
        data_out(8*ii + 4) <= o_data((ii)*8 + 4);
    end generate;
    --data_out <= o_data;
    sixthbitoutputlinking   :   for ii in 0 to 63 generate
        data_out(8*ii + 5) <= o_data((ii)*8 + 5);
    end generate;
    
    seventhbitoutputlinking   :   for ii in 0 to 63 generate
        data_out(8*ii + 6) <= o_data((ii)*8 + 6);
    end generate;        

    eightbitoutputlinking     :   for ii in 0 to 63 generate
        data_out(8*ii + 7) <= o_data((ii)*8 + 7);
    end generate;
        
    done_64_proc    :   process(clk)
    begin
        if(rising_edge(clk)) then
            if(reset = '0') then
                if((enable = '1') and (counter /= 64)) then
                    counter <= counter + 1;
                    done_64 <= '0';
                elsif ((enable = '0') and (counter /= 64)) then
                    counter <= counter;
                    done_64 <= '0';
                else
                    counter <= counter;
                    done_64 <= '1';
                end if;
            else
                counter <= 0;
                done_64 <= '0';
            end if;
        end if;
    end process;
end architecture;