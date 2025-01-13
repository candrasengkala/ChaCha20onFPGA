library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity QuarterRound_ref is
  port (
    stop_button                : in std_logic; 
    start_button               : in std_logic; 
    clock                      : in std_logic; 
    A, B, C, D                 : in std_logic_vector(31 downto 0); 
    A_out, B_out, C_out, D_out : out std_logic_vector(31 downto 0);
    cu_done_out                : out STD_LOGIC
  );
end entity;

architecture rtl of QuarterRound_ref is

  -- Sinyal kontrol dasar
  signal start, reset : std_logic;

  --demux add
  signal demux_Addin_A : std_logic_vector (31 downto 0);
  signal demux_Addin_C : std_logic_vector (31 downto 0);
  signal Sel_addindmux : std_logic;
  --demux xor
  signal demux_XORin_B : std_logic_vector (31 downto 0);
  signal demux_XORin_D : std_logic_vector (31 downto 0);
  signal Sel_xorindmux : std_logic;

  --add
  signal adder_out   : std_logic_vector (31 downto 0);
  signal Enable_add  : std_logic;
  signal Data_Addout : std_logic_vector (31 downto 0);

  --xor
  signal xor_out     : std_logic_vector (31 downto 0);
  signal Enable_xor  : std_logic;
  signal Data_Xorout : std_logic_vector (31 downto 0);

  --rotl
  signal shift_amount : std_logic_vector(4 downto 0);
  signal rotl_out     : std_logic_vector (31 downto 0);

  --mux
  signal sel_inA     : std_logic;
  signal sel_inB     : std_logic;
  signal sel_inC     : std_logic;
  signal sel_inD     : std_logic;
  signal data_outA   : std_logic_vector (31 downto 0);
  signal data_outB   : std_logic_vector (31 downto 0);
  signal data_outC   : std_logic_vector (31 downto 0);
  signal data_outD   : std_logic_vector (31 downto 0);
  signal Sel_addin   : std_logic_vector (1 downto 0);
  signal mux_Addin_A : std_logic_vector (31 downto 0);
  signal mux_Addin_B : std_logic_vector (31 downto 0);

  -- mux xor
  signal mux_xorin_A : std_logic_vector (31 downto 0);
  signal mux_xorin_B : std_logic_vector (31 downto 0);
  signal Sel_xorin   : std_logic;
  --reg
  signal En_inA       : std_logic;
  signal En_inB       : std_logic;
  signal En_inC       : std_logic;
  signal En_inD       : std_logic;
  signal data_outregA : std_logic_vector (31 downto 0);
  signal data_outregB : std_logic_vector (31 downto 0);
  signal data_outregC : std_logic_vector (31 downto 0);
  signal data_outregD : std_logic_vector (31 downto 0);

  component BitwiseXOR is
    port (
      A : in std_logic_vector (31 downto 0);
      B : in std_logic_vector (31 downto 0);
      C : out std_logic_vector (31 downto 0)
    );
  end component;

  component AdderMod32 is
    port (
      A : in std_logic_vector (31 downto 0);
      B : in std_logic_vector (31 downto 0);
      C : out std_logic_vector (31 downto 0)
    );
  end component;
  component ROTL
    port (
      A : in std_logic_vector(31 downto 0);
      C : in std_logic_vector(4 downto 0);
      B : out std_logic_vector(31 downto 0)
    );
  end component;

  component Register32bit_D is
    port (
      D      : in std_logic_vector (31 downto 0); -- data input
      En_D   : in std_logic;                      -- enable signal
      Res    : in std_logic;                      -- reset signal
      Clk    : in std_logic;                      -- clock signal
      Data_D : out std_logic_vector (31 downto 0) -- data output
    );
  end component;

  component Register32bit_C is
    port (
      C      : in std_logic_vector (31 downto 0); -- data input
      En_C   : in std_logic;                      -- enable signal
      Res    : in std_logic;                      -- reset signal
      Clk    : in std_logic;                      -- clock signal
      Data_C : out std_logic_vector (31 downto 0) -- data output
    );
  end component;

  component Register32bit_B is
    port (
      B      : in std_logic_vector (31 downto 0); -- data input
      En_B   : in std_logic;                      -- enable signal
      Res    : in std_logic;                      -- reset signal
      Clk    : in std_logic;                      -- clock signal
      Data_B : out std_logic_vector (31 downto 0) -- data output
    );
  end component;

  component Register32bit_A is
    port (
      A    : in std_logic_vector (31 downto 0); -- data input
      En   : in std_logic;                      -- enable signal
      Res  : in std_logic;                      -- reset signal
      Clk  : in std_logic;                      -- clock signal
      Data : out std_logic_vector (31 downto 0) -- data output
    );
  end component;

  component mux4to2_xor is
    port (
      A_xor       : in    std_logic_vector (31 downto 0);    -- data A 
      B_xor       : in    std_logic_vector (31 downto 0);    -- data B
      C_xor       : in    std_logic_vector (31 downto 0);    -- data C
      D_xor       : in    std_logic_vector (31 downto 0);    -- data D
      Sel_xor     : in    std_logic;                         -- selector 
      Data1_xor   : out   std_logic_vector (31 downto 0);    -- output 1
      Data2_xor   : out   std_logic_vector (31 downto 0)     -- output 2
    );
  end component;

  component mux4to2_add is
    port (
      A_add       : in    std_logic_vector (31 downto 0);    -- data A
      B_add       : in    std_logic_vector (31 downto 0);    -- data B
      C_add       : in    std_logic_vector (31 downto 0);    -- data C
      D_add       : in    std_logic_vector (31 downto 0);    -- data D
      E_add       : in    STD_LOGIC_VECTOR (31 downto 0);    -- data E
      Sel_add     : in    STD_LOGIC_VECTOR (1 downto 0);     -- selector 2 bit
      Data1_add   : out   std_logic_vector (31 downto 0);    -- output 1
      Data2_add   : out   std_logic_vector (31 downto 0)     -- output 2
    );
  end component;

  component demux_1to2_Add is
    port (
      Input_add   : in  std_logic_vector(31 downto 0);  -- Input  32-bit
      Sel_add     : in  std_logic;                      -- Sinyal selektor 1-bit
      Output1_add : out std_logic_vector(31 downto 0);  -- Output  32-bit
      Output2_add : out std_logic_vector(31 downto 0)   -- Output 32-bit
    );
  end component;

  component demux_2to1_xor is
    port (
      Input_xor   : in  std_logic_vector(31 downto 0);  -- Input  32-bit
      Sel_xor     : in  std_logic;                      -- Sinyal selektor 1-bit
      Output1_xor : out std_logic_vector(31 downto 0);  -- Output  32-bit
      Output2_xor : out std_logic_vector(31 downto 0)   -- Output 32-bit
    );
  end component;

  component mux2to1_A is
    port (
      A_a    : in std_logic_vector (31 downto 0); -- data A 
      B_a    : in std_logic_vector (31 downto 0); -- data B
      Sel_a  : in std_logic;                      -- selector
      Data_a : out std_logic_vector (31 downto 0) -- output data
    );
  end component;

  component mux2to1_B is
    port (
      A_b    : in std_logic_vector (31 downto 0); -- data A 
      B_b    : in std_logic_vector (31 downto 0); -- data B
      Sel_b  : in std_logic;                      -- selector
      Data_b : out std_logic_vector (31 downto 0) -- output data
    );
  end component;

  component mux2to1_C is
    port (
      A_c    : in std_logic_vector (31 downto 0); -- data A 
      B_c    : in std_logic_vector (31 downto 0); -- data B
      Sel_c  : in std_logic;                      -- selector
      Data_c : out std_logic_vector (31 downto 0) -- output data
    );
  end component;

  component mux2to1_D is
    port (
      A_d    : in std_logic_vector (31 downto 0); -- data A 
      B_d    : in std_logic_vector (31 downto 0); -- data B
      Sel_d  : in std_logic;                      -- selector
      Data_d : out std_logic_vector (31 downto 0) -- output data
    );
  end component;

  component QuarterRoundFSM_ref is
    port (
      clock, enable, reset : in std_logic;
      sel_inA              : out std_logic;
      sel_inB              : out std_logic;
      sel_inC              : out std_logic;
      sel_inD              : out std_logic;
      En_inA               : out std_logic;
      En_inB               : out std_logic;
      En_inC               : out std_logic;
      En_inD               : out std_logic;
      Sel_addin            : out std_logic_vector (1 downto 0);
      Sel_addindmux        : out std_logic;
      Sel_xorin            : out std_logic;
      Sel_xorindmux        : out std_logic;
      shift_amount         : out std_logic_vector(4 downto 0);
      cu_done              : out std_logic;
      Enable_xor           : out std_logic;
      Enable_add           : out std_logic

    );
  end component;

  component Register32bit_xor is
    port (
      regX       : in    std_logic_vector (31 downto 0);    -- data input
      En_Xor     : in    std_logic;                         -- enable signal
      Res        : in    std_logic;                         -- reset signal
      Clk        : in    std_logic;                         -- clock signal
      Data_Xor   : out   std_logic_vector (31 downto 0)     -- data output
    );
  end component;

  component Register32bit_add is
    port (
      addX       : in    std_logic_vector (31 downto 0);    -- data input
      En_Add     : in    std_logic;                         -- enable signal
      Res        : in    std_logic;                         -- reset signal
      Clk        : in    std_logic;                         -- clock signal
      Data_Add   : out   std_logic_vector (31 downto 0)     -- data output
    );
  end component;
begin

  mux_a : mux2to1_A
  port map
  (
    A_a    => A,
    B_a    => demux_Addin_A,
    Sel_a  => sel_inA,
    Data_a => data_outA
  );

  mux_b : mux2to1_B
  port map
  (
    A_b    => B,
    B_b    => demux_XORin_B,
    Sel_b  => sel_inB,
    Data_b => data_outB
  );

  mux_c : mux2to1_C
  port map
  (
    A_c    => C,
    B_c    => demux_Addin_C,
    Sel_c  => sel_inC,
    Data_c => data_outC
  );

  mux_d : mux2to1_D
  port map
  (
    A_d    => D,
    B_d    => demux_XORin_D,
    Sel_d  => sel_inD,
    Data_d => data_outD
  );

  reg_A : Register32bit_A
  port map
  (
    A    => data_outA,
    En   => En_inA,
    Res  => stop_button,
    Clk  => clock,
    Data => data_outregA
  );

  reg_B : Register32bit_B
  port map
  (
    B      => data_outB,
    En_B   => En_inB,
    Res    => stop_button,
    Clk    => clock,
    Data_B => data_outregB
  );

  reg_C : Register32bit_C
  port map
  (
    C      => data_outC,
    En_C   => En_inC,
    Res    => stop_button,
    Clk    => clock,
    Data_C => data_outregC
  );

  reg_D : Register32bit_D
  port map
  (
    D      => data_outD,
    En_D   => En_inD,
    Res    => stop_button,
    Clk    => clock,
    Data_D => data_outregD
  );

  mux_add : mux4to2_add
  port map
  (
    A_add     => data_outregA,
    B_add     => data_outregB,
    C_add     => data_outregC,
    D_add     => demux_XORin_D,
    E_add     => demux_XORin_B,
    Sel_add   => Sel_addin,
    Data1_add => mux_Addin_A,
    Data2_add => mux_Addin_B
  );

  adder : AdderMod32
  port map
  (
    A => mux_Addin_A,
    B => mux_Addin_B,
    C => adder_out
  );

  reg_add : Register32bit_add
  port map
  (
    addX     => adder_out,
    En_Add   => Enable_add,
    Res      => stop_button,
    Clk      => clock,
    Data_Add => Data_Addout
  );

  dmux_add : demux_1to2_Add
  port map
  (
    Input_add   => Data_Addout,
    Sel_add     => Sel_addindmux,
    Output1_add => demux_Addin_A,
    Output2_add => demux_Addin_C
  );

  mux_xor : mux4to2_xor
  port map
  (
    A_xor     => demux_Addin_A,
    B_xor     => data_outregD,
    C_xor     => demux_Addin_C,
    D_xor     => data_outregB,
    Sel_xor   => Sel_xorin,
    Data1_xor => mux_xorin_A,
    Data2_xor => mux_xorin_B
  );

  xor_with : BitwiseXOR
  port map
  (
    A => mux_xorin_A,
    B => mux_xorin_B,
    C => xor_out
  );

  n_bit_rotation : ROTL
  port map
  (
    A => xor_out,
    C => shift_amount,
    B => rotl_out
  );

  reg_xor : Register32bit_xor
  port map
  (
    regX     => rotl_out,
    En_Xor   => Enable_xor,
    Res      => stop_button,
    Clk      => clock,
    Data_Xor => Data_Xorout
  );

  dmux_xor : demux_2to1_xor
  port map
  (
    Input_xor   => Data_Xorout,
    Sel_xor     => Sel_xorindmux,
    Output1_xor => demux_XORin_B,
    Output2_xor => demux_XORin_D
  );

  FSM : QuarterRoundFSM_ref
  port map
  (
    clock         => clock,
    enable        => start_button,
    reset         => stop_button,
    sel_inA       => sel_inA,
    sel_inB       => sel_inB,
    sel_inC       => sel_inC,
    sel_inD       => sel_inD,
    En_inA        => En_inA,
    En_inB        => En_inB,
    En_inC        => En_inC,
    En_inD        => En_inD,
    Sel_addin     => Sel_addin,
    Sel_addindmux => Sel_addindmux,
    Sel_xorin     => Sel_xorin,
    Sel_xorindmux => Sel_xorindmux,
    shift_amount  => shift_amount,
    Enable_xor    => Enable_xor,
    Enable_add    => Enable_add,
    cu_done       => cu_done_out
  );

  -- Output  
  A_out <= data_outregA;
  B_out <= data_outregB;
  C_out <= data_outregC;
  D_out <= data_outregD;

end architecture;