library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity dmux4to16 is
    port (
        Data1    : in    std_logic_vector (31 downto 0);   -- input 1
        Data2    : in    std_logic_vector (31 downto 0);   -- input 2
        Data3    : in    std_logic_vector (31 downto 0);   -- input 3
        Data4    : in    std_logic_vector (31 downto 0);   -- input 4
        Sel      : in    std_logic_vector (2 downto 0);    -- 3-bit selector
        Sel_En   : in    std_logic;                        -- selection enable
        A0       : out   std_logic_vector (31 downto 0);   -- output 0
        A1       : out   std_logic_vector (31 downto 0);   -- output 1
        A2       : out   std_logic_vector (31 downto 0);   -- output 2
        A3       : out   std_logic_vector (31 downto 0);   -- output 3
        A4       : out   std_logic_vector (31 downto 0);   -- output 4
        A5       : out   std_logic_vector (31 downto 0);   -- output 5
        A6       : out   std_logic_vector (31 downto 0);   -- output 6
        A7       : out   std_logic_vector (31 downto 0);   -- output 7
        A8       : out   std_logic_vector (31 downto 0);   -- output 8
        A9       : out   std_logic_vector (31 downto 0);   -- output 9
        A10      : out   std_logic_vector (31 downto 0);   -- output 10
        A11      : out   std_logic_vector (31 downto 0);   -- output 11
        A12      : out   std_logic_vector (31 downto 0);   -- output 12
        A13      : out   std_logic_vector (31 downto 0);   -- output 13
        A14      : out   std_logic_vector (31 downto 0);   -- output 14
        A15      : out   std_logic_vector (31 downto 0)    -- output 15
    );
end entity;

architecture rtl of dmux4to16 is
begin
    process (Sel, Data1, Data2, Data3, Data4, Sel_En)
    begin
        -- Inisialisasi default sinyal out
        A0 <= (others => '0');
        A1 <= (others => '0');
        A2 <= (others => '0');
        A3 <= (others => '0');
        A4 <= (others => '0');
        A5 <= (others => '0');
        A6 <= (others => '0');
        A7 <= (others => '0');
        A8 <= (others => '0');
        A9 <= (others => '0');
        A10 <= (others => '0');
        A11 <= (others => '0');
        A12 <= (others => '0');
        A13 <= (others => '0');
        A14 <= (others => '0');
        A15 <= (others => '0');

        if Sel_En = '1' then
            case Sel is
                when "000" =>  -- [0 4 8 12]
                    A0 <= Data1;
                    A4 <= Data2;
                    A8 <= Data3;
                    A12 <= Data4;
                
                when "001" =>  -- [1 5 9 13]
                    A1 <= Data1;
                    A5 <= Data2;
                    A9 <= Data3;
                    A13 <= Data4;
                
                when "010" =>  -- [2 6 10 14]
                    A2 <= Data1;
                    A6 <= Data2;
                    A10 <= Data3;
                    A14 <= Data4;
                
                when "011" =>  -- [3 7 11 15]
                    A3 <= Data1;
                    A7 <= Data2;
                    A11 <= Data3;
                    A15 <= Data4;
                
                when "100" =>  -- [0 5 10 15]
                    A0 <= Data1;
                    A5 <= Data2;
                    A10 <= Data3;
                    A15 <= Data4;
                
                when "101" =>  -- [1 6 11 12]
                    A1 <= Data1;
                    A6 <= Data2;
                    A11 <= Data3;
                    A12 <= Data4;
                
                when "110" =>  -- [2 7 8 13]
                    A2 <= Data1;
                    A7 <= Data2;
                    A8 <= Data3;
                    A13 <= Data4;
                
                when "111" =>  -- [3 4 9 14]
                    A3 <= Data1;
                    A4 <= Data2;
                    A9 <= Data3;
                    A14 <= Data4;
                
                when others => null;
            end case;
        end if;
    end process;
end architecture;