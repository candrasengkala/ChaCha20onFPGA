library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_keystream is
    port (
        Input_counter           : in    std_logic_vector(31 downto 0);   --input hasil counter dari block counter
        Input_RNG               : in    std_logic_vector(255 downto 0);  --input yang berasal dari RNG
        Input_keystream_round   : in    std_logic_vector(511 downto 0);  --input hasil odd even round berupa keystream 512 bit
        Input_Nonce             : in    std_logic_vector(95 downto 0);   --input nonce dari nonce generator
        en_mux_keystream        : in    std_logic;                       --selector mux
        Data_out_mux            : out   std_logic_vector(511 downto 0)   --output
    );
end entity mux_keystream;

architecture rtl of mux_keystream is
    -- Konstanta tetap sama
    constant Input_constant : std_logic_vector(127 downto 0) := x"7465616D64656C6170616E62656C6173";
    
    -- Sinyal sementara untuk konstruksi initial state
    signal temporary : std_logic_vector(511 downto 0) := (others => '0');
begin
    process(Input_counter, Input_keystream_round, Input_Nonce, Input_RNG, en_mux_keystream, temporary)
    begin
        temporary <= (others => '0');
        
        -- Konstruksi initial state
        temporary(127 downto 96) <= Input_counter; --counter pada elemen 41
        temporary(95 downto 0) <= Input_Nonce(95 downto 0); --nonce pada elemen 42, 43, dan 44
        temporary(383 downto 128) <= Input_RNG(255 downto 0); -- rng pada baris kedua dan ketiga
        temporary(511 downto 384) <= Input_constant; --constant pada barus pertama 
        
        if (en_mux_keystream = '1') then
            Data_out_mux <= temporary;
			Data_out_mux(383 downto 128) <= Input_RNG(255 downto 0);
        else
            Data_out_mux <= Input_keystream_round;
        end if;
    end process;
end architecture rtl;