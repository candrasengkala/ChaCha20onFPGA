library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity QuarterRoundFSM_ref is
    port (
        clock, enable, reset    : in std_logic;                     
        -- Sinyal clock, enable, dan reset
        sel_inA                 : out std_logic;                    
        -- Selektor input A
        sel_inB                 : out std_logic;                    
        -- Selektor input B
        sel_inC                 : out std_logic;                    
        -- Selektor input C
        sel_inD                 : out std_logic;                    
        -- Selektor input D
        En_inA                  : out std_logic;                    
        -- Enable register A
        En_inB                  : out std_logic;                    
        -- Enable register B
        En_inC                  : out std_logic;                    
        -- Enable register C
        En_inD                  : out std_logic;                    
        -- Enable register D
        Sel_addin               : out std_logic_vector (1 downto 0);
        -- Selektor input adder
        Sel_addindmux           : out std_logic;                    
        -- Selektor demux untuk adder
        Sel_xorin               : out std_logic;                    
        -- Selektor input XOR
        Sel_xorindmux           : out std_logic;                    
        -- Selektor demux untuk XOR
        shift_amount            : out std_logic_vector(4 downto 0); 
        -- Jumlah bit rotasi
        cu_done                 : out std_logic;                    
        -- Sinyal done
        Enable_xor              : out std_logic;                    
        -- Enable untuk operasi XOR
        Enable_add              : out std_logic                     
        -- Enable untuk operasi adder
    );
end entity;


architecture rtl of QuarterRoundFSM_ref is
    -- 11 state FSM
    type states is (
        State_Idle, 
        State_0, State_1, State_2, State_3, 
        State_4, State_5, State_6, State_7, 
        State_Done, state_8
    );


    signal curr_state, next_state : states;
   
begin
    state_register: process(clock, reset)
    begin
        if (reset = '1') then
            curr_state <= State_Idle; -- Reset ke state awal
        elsif (rising_edge(clock)) then
            curr_state <= next_state; -- lanjut ke state berikutnya
        end if;
    end process;

    state_logic: process(curr_state, enable, clock, reset)
    begin
        next_state <= curr_state;
        
        -- Inisialisasi default sinyal out
        sel_inA       <= '0';
        sel_inB       <= '0';
        sel_inC       <= '0';
        sel_inD       <= '0';
        En_inA        <= '0';
        En_inB        <= '0';
        En_inC        <= '0';
        En_inD        <= '0';
        Sel_addin     <= (others => '0');
        Sel_addindmux <= '0';
        Sel_xorin     <= '0';
        Sel_xorindmux <= '0';
        shift_amount  <= (others => '0');
        cu_done       <= '0';
        Enable_xor    <= '0';
        Enable_add    <= '0';
   -- end process;
--end architecture rtl;
        
        case curr_state is
            when State_Idle =>
            if (enable = '1') then 
                -- jika enable 1 maka lanjut ke state_0 
                --atau proses quarter round dimuali 
                next_state <= State_0;
            else
                next_state <= State_Idle; --menunggu hingga enable bernilai 1 
            end if;
        
            when State_0 => 
            --State untuk menyimpan input awal 
            --pada register A dan register B
                Sel_addin     <= "00";
                En_inA        <= '1';
                En_inB        <= '1';
                Sel_addindmux <= '0';
                
                next_state    <= State_1;

            when State_1 =>  
            --State untuk menjumlahan data keluaran 
            --dari register A dan register B dan menyimpan 
            --hasil penjumlahan pada register A
                Enable_add    <= '1';
                En_inD        <= '1';
                Sel_addindmux <= '0';
                En_inC        <= '1';
                next_state    <= State_2;
    
            when State_2 => 
            --State untuk melakukan operasi xor pada keluaran 
            --register D dan register A dilanjutkan dengan ROTL-16 
                
                Sel_xorin     <= '0';
                Sel_xorindmux <= '1';
                En_inA        <= '1';
                shift_amount  <= "10000";
                Enable_xor    <= '1';
                sel_inA       <= '1';
                
                
                next_state    <= State_3;
    
            when State_3 => 
            --State untuk menjumlahkan keluaran dari 
            --register C dan register D dan menyimpan 
            --hasil xor pada register D
                Sel_addin     <= "01";
                Sel_xorindmux <= '1';
                Enable_add    <= '1';
                Sel_addindmux <= '1';
                sel_inD       <= '1';
                sel_inA       <= '1';
                En_inD        <= '1';
                
                
                next_state    <= State_4;
            

            when State_4 => 
            --State menyimpan hasil penjumlahan pada 
            --register c dan mlakukan operasi xor pada 
            --keluaran register B dan register C dilanjutkan 
            --dengan ROTL 12
 
                Sel_xorin     <= '1';
                Sel_xorindmux <= '0';
                Sel_addindmux <= '1'; 
                shift_amount  <= "01100"; 
                Enable_xor    <= '1';
                sel_inD       <= '1';
                sel_inA       <= '1';
                sel_inC       <= '1';
                En_inC        <= '1';
                

                next_state    <= State_5;
    
            when State_5 =>  
            --State untuk menjumlahkan keluaran 
            --dari register A dan register B dan 
            --menyimpan hasil xor pada register B 
                Enable_add    <= '1';
                Sel_addin     <= "10";
                Sel_xorindmux <= '0';
                Sel_addindmux <= '0';
                sel_inD       <= '1';
                sel_inA       <= '1';
                sel_inC       <= '1';
                sel_inB       <= '1';
                En_inB        <= '1';
           
                next_state    <= State_6;
    
            when State_6 => 
            --State menyimpan hasil penjumlahan pada 
            --register A dan mlakukan operasi xor pada 
            --keluaran register A dan register D dilanjutkan dengan ROTL 8
                Sel_addindmux <= '0';
                Sel_xorin     <= '0';
                Sel_xorindmux <= '1'; 
                Enable_xor    <= '1';
                shift_amount  <= "01000"; 
                sel_inD       <= '1';
                sel_inA       <= '1';
                sel_inC       <= '1';
                sel_inB       <= '1';
                En_inA        <= '1';
                next_state    <= State_7;
    
            when State_7 => 
            --State untuk menjumlahkan keluaran dari 
            --register C dan register D dan menyimpan 
            --hasil xor pada register D 
                Sel_addin     <= "01";
                Sel_xorindmux <= '1';
                Sel_addindmux <= '1';
                Enable_add    <= '1';
                sel_inD       <= '1';
                sel_inA       <= '1';
                sel_inC       <= '1';
                sel_inB       <= '1';
                En_inD        <= '1';
                next_state    <= State_8;
    
            when State_8 => 
            --State menyimpan hasil penjumlahan pada 
            --register C dan mlakukan operasi xor pada 
            --keluaran register C dan register B dilanjutkan dengan ROTL 7
                Sel_xorin     <= '1';
                Sel_xorindmux <= '0';
                Sel_addindmux <= '1'; 
                shift_amount  <= "00111"; 
                Enable_xor    <= '1';
                sel_inD       <= '1';
                sel_inA       <= '1';
                sel_inC       <= '1';
                sel_inB       <= '1';
                En_inC        <= '1';
                
                next_state    <= State_Done;
    
            when State_Done => 
            --State Done dengan mengeluarkan flag cu_done 
            --yang menandakan proses quarter round telah selesai 
                cu_done <= '1';
                sel_inB       <= '1';
                En_inB        <= '1';
                next_state <= State_Idle;  
    
            when others =>
                next_state <= State_Idle;
        end case;
    end process;
    end architecture;