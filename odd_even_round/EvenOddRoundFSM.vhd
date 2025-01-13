library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity EvenOddRoundFSM is
	port(
        clock       : in std_logic;
        reset     : in std_logic;
        enable    : in std_logic;
        cu_done   : in std_logic;
        sel_A11   : out std_logic;
        sel_A12   : out std_logic;
        sel_A13   : out std_logic;
        sel_A14   : out std_logic;
        sel_A21   : out std_logic;
        sel_A22   : out std_logic;
        sel_A23   : out std_logic;
        sel_A24   : out std_logic;
        sel_A31   : out std_logic;
        sel_A32   : out std_logic;
        sel_A33   : out std_logic;
        sel_A34   : out std_logic;
        sel_A41   : out std_logic;
        sel_A42   : out std_logic;
        sel_A43   : out std_logic;
        sel_A44   : out std_logic;
        en_regA11 : out std_logic;
        en_regA12 : out std_logic;
        en_regA13 : out std_logic;
        en_regA14 : out std_logic;
        en_regA21 : out std_logic;
        en_regA22 : out std_logic;
        en_regA23 : out std_logic;
        en_regA24 : out std_logic;
        en_regA31 : out std_logic;
        en_regA32 : out std_logic;
        en_regA33 : out std_logic;
        en_regA34 : out std_logic;
        en_regA41 : out std_logic;
        en_regA42 : out std_logic;
        en_regA43 : out std_logic;
        en_regA44 : out std_logic;
        sel_mux16to4    : out std_logic_vector (2 downto 0);
        en_QR           : out std_logic;
        en_demux4to16   : out std_logic;
        sel_demux4to16  : out std_logic_vector (2 downto 0);
        flag_evenodd    : out std_logic
    );
end EvenOddRoundFSM;

architecture behavioral of EvenOddRoundFSM is
      --27 state FSM
	type executionstate is (idle_state, load_state, odd_state1,odd_state1_wait, odd_round1, 
        odd_state2,odd_state2_wait, odd_round2, odd_state3,odd_state3_wait, odd_round3, odd_state4, odd_state4_wait,
        odd_round4, even_state1,even_state1_wait, even_round1, even_state2,even_state2_wait, even_round2, 
        even_state3,even_state3_wait, even_round3, even_state4, even_round4,even_state4_wait, final_state);
	signal current_state, next_state: executionstate;
	
	-- sinyal penghitung round
	constant MAX_ROUNDS : integer := 20; -- batas maks round
      signal round_count : integer range 0 to MAX_ROUNDS := 0; --hitung jumlah round 
      signal round_count_reg : integer range 0 to MAX_ROUNDS; --menyimpan sementara hasil round count
	
      begin
            -- Clock process
            process (clock, reset)
            begin
                if (reset = '1') then
                    current_state <= idle_state; -- Reset ke state awal
                    round_count <= 0; -- reset counter
                elsif (rising_edge(clock)) then
                    current_state <= next_state; -- lanjut ke state berikutnya
                    round_count_reg <= round_count;
                    
                    case current_state is
                        when idle_state =>
                            if enable = '1' then
                                round_count <= 0; 
                                -- reset counter apabila enable '1'
                            end if;
                        when odd_round4 =>  
                            if round_count < MAX_ROUNDS then
                                round_count <= round_count + 1; 
                                --increment counter setiap kali kolom keempat dioperasikan 
                            end if;
                        when even_round4 =>  
                            if round_count < MAX_ROUNDS then
                                round_count <= round_count + 1; 
                                --increment counter setiap kali diagonal terakhir dioperasikan
                            end if;
                        when others => 
                            null;
                    end case;
                end if;
            end process;
	
	process(current_state, enable, clock, reset, cu_done, round_count_reg)
	begin
	next_state <= current_state;
	
	-- Inisialisasi sinyal output default 0 
	sel_A11 <= '0';
	sel_A12 <= '0';
	sel_A13 <= '0';	
	sel_A14 <= '0';	
	sel_A21 <= '0';	
	sel_A22 <= '0';	
	sel_A23 <= '0';	
	sel_A24 <= '0';	
	sel_A31 <= '0';	
	sel_A32 <= '0';	
	sel_A33 <= '0';	
	sel_A34 <= '0';	
	sel_A41 <= '0';	
	sel_A42 <= '0';	
	sel_A43 <= '0';	
	sel_A44 <= '0';	
	
	en_regA11 <= '0';
	en_regA12 <= '0';
	en_regA13 <= '0';
	en_regA14 <= '0';
	en_regA21 <= '0';
	en_regA22 <= '0';
	en_regA23 <= '0';
	en_regA24 <= '0';
	en_regA31 <= '0';
	en_regA32 <= '0';
	en_regA33 <= '0';
	en_regA34 <= '0';
	en_regA41 <= '0';
	en_regA42 <= '0';
	en_regA43 <= '0';
	en_regA44 <= '0';
      sel_mux16to4 <= "000";
      sel_demux4to16 <= "000";
      flag_evenodd <= '0';
	
	en_demux4to16 <= '0';
	en_QR <= '0';
	
	case current_state is
		when idle_state => 
                  if (enable = '1') then
                        -- jika enable 1 maka lanjut ke state_0 
                        -- atau proses quarter round dimuali 
                        next_state <= load_state;
                  else
                        next_state <= idle_state; 
                        --menunggu hingga enable bernilai 1 
                  end if;
                  
            when load_state => 
            -- state menyimpan nilai input awal ke masing masing 
            -- register yang merepresentasikan setiap elemen matriks
                  sel_A11 <= '1';
                  sel_A12 <= '1';
                  sel_A13 <= '1';	
                  sel_A14 <= '1';	
                  sel_A21 <= '1';	
                  sel_A22 <= '1';	
                  sel_A23 <= '1';	
                  sel_A24 <= '1';	
                  sel_A31 <= '1';	
                  sel_A32 <= '1';	
                  sel_A33 <= '1';	
                  sel_A34 <= '1';	
                  sel_A41 <= '1';	
                  sel_A42 <= '1';	
                  sel_A43 <= '1';	
                  sel_A44 <= '1';	
                  
                  en_regA11 <= '1';
                  en_regA12 <= '1';
                  en_regA13 <= '1';
                  en_regA14 <= '1';
                  en_regA21 <= '1';
                  en_regA22 <= '1';
                  en_regA23 <= '1';
                  en_regA24 <= '1';
                  en_regA31 <= '1';
                  en_regA32 <= '1';
                  en_regA33 <= '1';
                  en_regA34 <= '1';
                  en_regA41 <= '1';
                  en_regA42 <= '1';
                  en_regA43 <= '1';
                  en_regA44 <= '1';
                  
                  
            
		    next_state <= odd_state1;
		
		when odd_state1 => 
            -- enable quarter round '1' dan memilih data dari 
            --kolom 1 kemudia dilakukan operasi quarter round 
                  sel_A11 <= '1';
                  sel_A21 <= '1';
                  sel_A31 <= '1';
                  sel_A41 <= '1';

                  sel_mux16to4 <= "000";
                  en_QR <= '1';
                  

                  next_state <= odd_state1_wait;
  

            when odd_state1_wait =>
            -- menunggu hingga proses quarter round selesai. 
            --jika cu_done = '1' maka lanjurt ke state berikut nya
                  sel_A11 <= '1';
                  sel_A21 <= '1';
                  sel_A31 <= '1';
                  sel_A41 <= '1';

                  sel_mux16to4 <= "000";

                  
                  if (cu_done = '1') then
                  next_state <= odd_round1;
                  end if;
                  
		when odd_round1 =>
            --menyimpan hasil output round ke masing masing register pada kolom 1
                  en_demux4to16 <= '1';
                  sel_demux4to16 <= "000";
                  en_regA11 <= '1';
                  en_regA21 <= '1';
                  en_regA31 <= '1';
                  en_regA41 <= '1';
                  
                  next_state <= odd_state2;
		
		when odd_state2 =>
            -- enable quarter round '1' dan memilih data dari 
            --kolom 2 kemudia dilakukan operasi quarter round 
                  sel_A12 <= '1';
                  sel_A22 <= '1';
                  sel_A32 <= '1';
                  sel_A42 <= '1';

                  sel_mux16to4 <= "001";
                  en_QR <= '1';
                  
 
                  next_state <= odd_state2_wait;

            when odd_state2_wait =>
            -- menunggu hingga proses quarter round selesai. 
            --jika cu_done = '1' maka lanjurt ke state berikut nya
                  sel_A12 <= '1';
                  sel_A22 <= '1';
                  sel_A32 <= '1';
                  sel_A42 <= '1';

                  sel_mux16to4 <= "001";

                  
                  if (cu_done = '1') then
                  next_state <= odd_round2;
                  end if;
                  
		when odd_round2 =>
            --menyimpan hasil output round ke masing 
            --masing register pada kolom 2
                  en_demux4to16 <= '1';
                  sel_demux4to16 <= "001";
                  en_regA12 <= '1';
                  en_regA22 <= '1';
                  en_regA32 <= '1';
                  en_regA42 <= '1';
                  
                  next_state <= odd_state3;
            
		when odd_state3 =>
            -- enable quarter round '1' dan memilih data dari 
            --kolom 3 kemudia dilakukan operasi quarter round 
                  sel_A13 <= '1';
                  sel_A23 <= '1';
                  sel_A33 <= '1';
                  sel_A43 <= '1';

                  sel_mux16to4 <= "010";
                  en_QR <= '1';
            
                  next_state <= odd_state3_wait;
  
            when odd_state3_wait => 
            -- menunggu hingga proses quarter round selesai. 
            --jika cu_done = '1' maka lanjurt ke state berikut nya
                  sel_A13 <= '1';
                  sel_A23 <= '1';
                  sel_A33 <= '1';
                  sel_A43 <= '1';

                  sel_mux16to4 <= "010";
                  
            
                  if (cu_done = '1') then
                  next_state <= odd_round3;
                  end if; 
                  
		when odd_round3 =>
            --menyimpan hasil output round ke 
            --masing masing register pada kolom 3
                  en_demux4to16 <= '1';
                  sel_demux4to16 <= "010";
                  en_regA13 <= '1';
                  en_regA23 <= '1';
                  en_regA33 <= '1';
                  en_regA43 <= '1';
                  
                  next_state <= odd_state4;
            
		when odd_state4 =>
            -- enable quarter round '1' dan memilih data dari 
            --kolom 4 kemudia dilakukan operasi quarter round 
                  sel_A14 <= '1';
                  sel_A24 <= '1';
                  sel_A34 <= '1';
                  sel_A44 <= '1';

                  sel_mux16to4 <= "011";
                  en_QR <= '1';
                  
                 
                  next_state <= odd_state4_wait;
            
            when odd_state4_wait => 
            -- menunggu hingga proses quarter round selesai. 
            --jika cu_done = '1' maka lanjurt ke state berikut nya
                  sel_A14 <= '1';
                  sel_A24 <= '1';
                  sel_A34 <= '1';
                  sel_A44 <= '1';
                      
                  sel_mux16to4 <= "011";

                  
                  if (cu_done = '1') then
                  next_state <= odd_round4;
                  end if;
                  
		when odd_round4 =>
            --menyimpan hasil output round ke 
            --masing masing register pada kolom 4
                  en_demux4to16 <= '1';
                  sel_demux4to16 <= "011";
                  en_regA14<= '1';
                  en_regA24 <= '1';
                  en_regA34 <= '1';
                  en_regA44 <= '1';

                  next_state <= even_state1;
                  
		when even_state1 =>
            -- enable quarter round '1' dan memilih data dari 
            --diagonal 1 kemudia dilakukan operasi quarter round 
                  sel_A11 <= '1';
                  sel_A22 <= '1';
                  sel_A33 <= '1';
                  sel_A44 <= '1';

                  sel_mux16to4 <= "100";
                  en_QR <= '1';
                  
                  
                  next_state <= even_state1_wait;
               
            when even_state1_wait =>
            -- menunggu hingga proses quarter round selesai. 
            --jika cu_done = '1' maka lanjurt ke state berikut nya
                  sel_A11 <= '1';
                  sel_A22 <= '1';
                  sel_A33 <= '1';
                  sel_A44 <= '1';

                  sel_mux16to4 <= "100";
                 
                  
                  if (cu_done = '1') then
                  next_state <= even_round1;
                  end if;
                  
		when even_round1 =>
            --menyimpan hasil output round ke 
            --masing masing register pada diagonal 1
                  en_demux4to16 <= '1';	
                  sel_demux4to16 <= "100";
                  en_regA11 <= '1';
                  en_regA22 <= '1';
                  en_regA33 <= '1';
                  en_regA44 <= '1';
                  
                  next_state <= even_state2;
            
		when even_state2 =>
            -- enable quarter round '1' dan memilih data dari 
            --diagonal 2 kemudia dilakukan operasi quarter round 
                  sel_A12 <= '1';
                  sel_A23 <= '1';
                  sel_A34 <= '1';
                  sel_A41 <= '1';

                  sel_mux16to4 <= "101";
                  en_QR <= '1';
                  
             
                  next_state <= even_state2_wait;
         
            when even_state2_wait =>
            -- menunggu hingga proses quarter round selesai. 
            --jika cu_done = '1' maka lanjurt ke state berikut nya
                  sel_A12 <= '1';
                  sel_A23 <= '1';
                  sel_A34 <= '1';
                  sel_A41 <= '1';

                  sel_mux16to4 <= "101";
    
                  
                  if (cu_done = '1') then
                  next_state <= even_round2;
                  end if;
                  
		when even_round2 =>
            --menyimpan hasil output round ke masing 
            --masing register pada diagonal 2
                  en_demux4to16 <= '1';
                  sel_demux4to16 <= "101";
                  en_regA12 <= '1';
                  en_regA23 <= '1';
                  en_regA34 <= '1';
                  en_regA41 <= '1';
                  
                  next_state <= even_state3;
                  
		when even_state3 =>
            -- enable quarter round '1' dan memilih data dari 
            --diagonal 3 kemudia dilakukan operasi quarter round 
                  sel_A13 <= '1';
                  sel_A24 <= '1';
                  sel_A31 <= '1';
                  sel_A42 <= '1';

                  sel_mux16to4 <= "110";
                  en_QR <= '1';
                  
                  next_state <= even_state3_wait;


            when even_state3_wait =>
            -- menunggu hingga proses quarter round selesai. 
            --jika cu_done = '1' maka lanjurt ke state berikut nya
                  sel_A13 <= '1';
                  sel_A24 <= '1';
                  sel_A31 <= '1';
                  sel_A42 <= '1';

                  sel_mux16to4 <= "110";
                           
                  if (cu_done = '1') then
                  next_state <= even_round3;
                  end if;
                  
		when even_round3 =>
            --menyimpan hasil output round ke 
            --masing masing register pada diagonal 3
                  en_demux4to16 <= '1';
                  sel_demux4to16 <= "110";
                  en_regA13 <= '1';
                  en_regA24 <= '1';
                  en_regA31 <= '1';
                  en_regA42 <= '1';
                  
                  next_state <= even_state4;
                  
		when even_state4 =>
            -- enable quarter round '1' dan memilih data dari 
            --diagonal 4 kemudia dilakukan operasi quarter round 
                  sel_A14 <= '1';
                  sel_A21 <= '1';
                  sel_A32 <= '1';
                  sel_A43 <= '1';

                  sel_mux16to4 <= "111";
                  en_QR <= '1';
                  
                  
                  next_state <= even_state4_wait;
            
            when even_state4_wait =>
            -- menunggu hingga proses quarter round selesai. 
            --jika cu_done = '1' maka lanjurt ke state berikut nya
                  sel_A14 <= '1';
                  sel_A21 <= '1';
                  sel_A32 <= '1';
                  sel_A43 <= '1';

                  sel_mux16to4 <= "111";

                  
                  if (cu_done = '1') then
                  next_state <= even_round4;
                  end if;
                  
		when even_round4 =>
            --menyimpan hasil output round ke 
            --masing masing register pada diagonal 4
                  en_demux4to16 <= '1';	
                  sel_demux4to16 <= "111";
                  en_regA14 <= '1';
                  en_regA21 <= '1';
                  en_regA32 <= '1';
                  en_regA43 <= '1';
                  
                  if round_count_reg >= MAX_ROUNDS - 1 then
                        next_state <= final_state;
                  else
                        next_state <= odd_state1;
                  end if;

		when final_state => --
            --State final  mengeluarkan flag_evenodd 
            --sebagai penanda proses odd even  round telah selesai 
                  flag_evenodd <= '1'; 
                  next_state <= idle_state;

		when others =>
                  next_state <= idle_state;	
                  
	    end case;
	end process;
end architecture;