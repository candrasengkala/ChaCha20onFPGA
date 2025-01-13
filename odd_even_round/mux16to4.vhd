library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity mux16to4 is
    port (
        A0       : in    std_logic_vector (31 downto 0);   -- input 0
        A1       : in    std_logic_vector (31 downto 0);   -- input 1
        A2       : in    std_logic_vector (31 downto 0);   -- input 2
        A3       : in    std_logic_vector (31 downto 0);   -- input 3
        A4       : in    std_logic_vector (31 downto 0);   -- input 4
        A5       : in    std_logic_vector (31 downto 0);   -- input 5
        A6       : in    std_logic_vector (31 downto 0);   -- input 6
        A7       : in    std_logic_vector (31 downto 0);   -- input 7
        A8       : in    std_logic_vector (31 downto 0);   -- input 8
        A9       : in    std_logic_vector (31 downto 0);   -- input 9
        A10      : in    std_logic_vector (31 downto 0);   -- input 10
        A11      : in    std_logic_vector (31 downto 0);   -- input 11
        A12      : in    std_logic_vector (31 downto 0);   -- input 12
        A13      : in    std_logic_vector (31 downto 0);   -- input 13
        A14      : in    std_logic_vector (31 downto 0);   -- input 14
        A15      : in    std_logic_vector (31 downto 0);   -- input 15
        Sel      : in    std_logic_vector (2 downto 0);    -- 3-bit selector
        Data1    : out   std_logic_vector (31 downto 0);   -- output 1
        Data2    : out   std_logic_vector (31 downto 0);   -- output 2
        Data3    : out   std_logic_vector (31 downto 0);   -- output 3
        Data4    : out   std_logic_vector (31 downto 0)    -- output 4
    );
end entity;

architecture rtl of mux16to4 is
begin
    process (Sel, A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15)
    begin
        case Sel is
            when "000" =>  -- [0 4 8 12]
                Data1 <= A0;
                Data2 <= A4;
                Data3 <= A8;
                Data4 <= A12;
            
            when "001" =>  -- [1 5 9 13]
                Data1 <= A1;
                Data2 <= A5;
                Data3 <= A9;
                Data4 <= A13;
            
            when "010" =>  -- [2 6 10 14]
                Data1 <= A2;
                Data2 <= A6;
                Data3 <= A10;
                Data4 <= A14;
            
            when "011" =>  -- [3 7 11 15]
                Data1 <= A3;
                Data2 <= A7;
                Data3 <= A11;
                Data4 <= A15;
            
            when "100" =>  -- [0 5 10 15]
                Data1 <= A0;
                Data2 <= A5;
                Data3 <= A10;
                Data4 <= A15;
            
            when "101" =>  -- [1 6 11 12]
                Data1 <= A1;
                Data2 <= A6;
                Data3 <= A11;
                Data4 <= A12;
            
            when "110" =>  -- [2 7 8 13]
                Data1 <= A2;
                Data2 <= A7;
                Data3 <= A8;
                Data4 <= A13;
            
            when "111" =>  -- [3 4 9 14]
                Data1 <= A3;
                Data2 <= A4;
                Data3 <= A9;
                Data4 <= A14;
            
            when others => 
                Data1 <= (others => '0');
                Data2 <= (others => '0');
                Data3 <= (others => '0');
                Data4 <= (others => '0');
        end case;
    end process;
end architecture;
