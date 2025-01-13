---------------------------------------------------------------------------------------
-- Nama         : Dharma Anargya Jowandy  
-- NIM          : 13223075			      
-- Tanggal      : 19-11-2024
---------------------------------------------------------------------------------------
-- Deskripsi
-- Fungsi    : Modul ROTL (Rotate Left) untuk melakukan rotasi bit ke kiri pada sebuah 
--             data 32-bit berdasarkan nilai offset.
-- Input     : A                         - Data input 32-bit yang akan dirotasi ke kiri
--             C                         - Offset rotasi dalam bentuk data 5-bit
--                                           (jumlah posisi rotasi)
-- Output    : B                         - Hasil rotasi bit ke kiri (32-bit)
---------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROTL is
    port(
        A : in std_logic_vector(31 downto 0);  -- Input d 32-bit
        C : in std_logic_vector(4 downto 0);   -- Input jumlah bit rotasi 5-bit
        B : out std_logic_vector(31 downto 0)  -- Output hasil rotasi 32-bit
    );
end ROTL;

architecture behavioral of ROTL is
begin
    process(A, C)
        variable shift_amount : integer range 0 to 31; -- Variabel jumlah bit rotasi
    begin
        shift_amount := to_integer(unsigned(C)); 
        

        case shift_amount is
            when 7 =>  B <= A(24 downto 0) & A(31 downto 25); -- Rotasi 7 bit ke kiri
            when 8 =>  B <= A(23 downto 0) & A(31 downto 24); -- Rotasi 8 bit ke kiri
            when 12 => B <= A(19 downto 0) & A(31 downto 20); -- Rotasi 12 bit ke kiri
            when 16 => B <= A(15 downto 0) & A(31 downto 16); -- Rotasi 16 bit ke kiri
            when others => B <= A;                            -- Tidak ada rotasi 
        end case;
    end process;
end behavioral;


