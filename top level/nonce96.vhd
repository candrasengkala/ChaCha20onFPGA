library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity nonce96 is
    port (
        clk     : in STD_LOGIC;                         --clock
        in_cnt    : in STD_LOGIC;                       --input fsm sebagai enable counter
        in_reg    : in STD_LOGIC;                       --input register 1 bit untuk menentukan ip address
        out_nonce : out STD_LOGIC_VECTOR (95 downto 0)  --output

    );
end entity;

architecture rtl of nonce96 is
   --nilai awal counter 1
   signal counter : STD_LOGIC_VECTOR (95 downto 0) := ("000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001");
   signal Data_out_mux : std_logic_vector(95 downto 0);
   
   component Mux96bit is         
       port (             
           Sel_switch_mode  : in    std_logic;
           Data_out_mux     : out   std_logic_vector(95 downto 0)
       );     
   end component;
   
begin

   mux: Mux96bit      
   port map (         
       Sel_switch_mode => in_reg,
       Data_out_mux => Data_out_mux     
   );
   
   process (clk, counter)   --[roses penjumlahan hasil counter dengan ip address output mux  
   begin         
       if (rising_edge(clk)) then             
           if in_cnt = '1' then                 
               if (not(counter = x"FFFFFFFFFFFFFFFFFFFFFFFF")) then --jika counter belum mencapai maks                  
                   counter <= std_logic_vector(unsigned(counter) + 1); --counter bertambah sebanyak 1 setiap kali in_cnt = '1'                 
                   out_nonce <= std_logic_vector(unsigned(counter) + unsigned(Data_out_mux)); --menjumlahkan counter nengan ip adress                
               else                     
                   counter <= (others => '0');  -- Reset counter jika nilai maksimum
               end if;             
           end if;         
       end if;     
   end process;
end rtl;