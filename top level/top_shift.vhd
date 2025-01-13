library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity top_shift is
    port (
        clk                : in std_logic;
        reset              : in std_logic;
        enable             : in std_logic;
		valid_en           : in std_logic;
        Input_Data_S       : in std_logic_vector (7 downto 0);
        Data_out           : out std_logic_vector(255 downto 0);
        rng_done_flag      : out std_logic
    );
end entity;

architecture rtl of top_shift is
    signal data_out_shift : std_logic_vector(255 downto 0);
    signal en_reg_text_o  :  std_logic;
    
    component shift_reg256_FSM is
        port (
            clk               : in std_logic;
            reset             : in std_logic;
            enables_shift_FSM : in std_logic;
            en_reg_text      : out std_logic;
            enables_shift    : in std_logic;
            flag_done        : out std_logic
        );
    end component;
    
    component shift_reg256 is
        port(
            clk           : in std_logic;
            reset         : in std_logic;
            enables_shift : in std_logic;
            Input_Data    : in std_logic_vector (7 downto 0);
            Q            : out std_logic_vector(255 downto 0)
        );
    end component;

begin
    shift_re : shift_reg256
    port map(
        clk           => clk,
        reset         => reset,
        enables_shift => valid_en,
        Input_Data    => Input_Data_S,
        Q            => data_out_shift
    );
    
    shift_FSM : shift_reg256_FSM
    port map(
        clk               => clk,
        reset             => reset,
        enables_shift_FSM => enable,
        en_reg_text      => en_reg_text_o, 
        enables_shift    => valid_en, 
        flag_done        => rng_done_flag
    );
    
   
    process(clk)
    begin
        if rising_edge(clk) then
            if (reset = '1') then
                Data_out <= (others => '0');
            elsif (en_reg_text_o = '1') then  
                Data_out <= data_out_shift;
            end if;
        end if;
    end process;

end architecture;

