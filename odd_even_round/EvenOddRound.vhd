library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity EvenOddRound is
	port(
        Clk : in std_logic;
		Res : in std_logic;
		start_oddeven : in std_logic;
        flag_oddeven_out : out std_logic ;
		input_Round : in std_logic_vector(511 downto 0);
        output_Round : out std_logic_vector(511 downto 0)
	);
end entity;

architecture rtl of EvenOddRound is

-- sinyal untuk membagi input menjadi 16 bagian 
    signal a11_in : std_logic_vector(31 downto 0);
    signal a12_in : std_logic_vector(31 downto 0);
    signal a13_in : std_logic_vector(31 downto 0);
    signal a14_in : std_logic_vector(31 downto 0);
    signal a21_in : std_logic_vector(31 downto 0);
    signal a22_in : std_logic_vector(31 downto 0);
    signal a23_in : std_logic_vector(31 downto 0);
    signal a24_in : std_logic_vector(31 downto 0);
    signal a31_in : std_logic_vector(31 downto 0);
    signal a32_in : std_logic_vector(31 downto 0);
    signal a33_in : std_logic_vector(31 downto 0);
    signal a34_in : std_logic_vector(31 downto 0);
    signal a41_in : std_logic_vector(31 downto 0);
    signal a42_in : std_logic_vector(31 downto 0);
    signal a43_in : std_logic_vector(31 downto 0);
    signal a44_in : std_logic_vector(31 downto 0);

-- sinyal kontrol dasar
	signal start, reset : std_logic;
 
-- mux2to1
	signal sel_A11 : std_logic;
	signal sel_A12 : std_logic;
	signal sel_A13 : std_logic;
	signal sel_A14 : std_logic;
	signal sel_A21 : std_logic;
	signal sel_A22 : std_logic;
	signal sel_A23 : std_logic;
	signal sel_A24 : std_logic;
	signal sel_A31 : std_logic;
	signal sel_A32 : std_logic;
	signal sel_A33 : std_logic;
	signal sel_A34 : std_logic;
	signal sel_A41 : std_logic;
	signal sel_A42 : std_logic;
	signal sel_A43 : std_logic;
	signal sel_A44 : std_logic;
	signal data_muxA11 : std_logic_vector (31 downto 0);
	signal data_muxA12 : std_logic_vector (31 downto 0);
	signal data_muxA13 : std_logic_vector (31 downto 0);
	signal data_muxA14 : std_logic_vector (31 downto 0);
	signal data_muxA21 : std_logic_vector (31 downto 0);
	signal data_muxA22 : std_logic_vector (31 downto 0);
	signal data_muxA23 : std_logic_vector (31 downto 0);
	signal data_muxA24 : std_logic_vector (31 downto 0);
	signal data_muxA31 : std_logic_vector (31 downto 0);
	signal data_muxA32 : std_logic_vector (31 downto 0);
	signal data_muxA33 : std_logic_vector (31 downto 0);
	signal data_muxA34 : std_logic_vector (31 downto 0);
	signal data_muxA41 : std_logic_vector (31 downto 0);
	signal data_muxA42 : std_logic_vector (31 downto 0);
	signal data_muxA43 : std_logic_vector (31 downto 0);
	signal data_muxA44 : std_logic_vector (31 downto 0);
	
-- register32bit
	signal en_regA11 : std_logic;
	signal en_regA12 : std_logic;
	signal en_regA13 : std_logic;
	signal en_regA14 : std_logic;
	signal en_regA21 : std_logic;
	signal en_regA22 : std_logic;
	signal en_regA23 : std_logic;
	signal en_regA24 : std_logic;
	signal en_regA31 : std_logic;
	signal en_regA32 : std_logic;
	signal en_regA33 : std_logic;
	signal en_regA34 : std_logic;
	signal en_regA41 : std_logic;
	signal en_regA42 : std_logic;
	signal en_regA43 : std_logic;
	signal en_regA44 : std_logic;
	signal data_regA11 : std_logic_vector (31 downto 0);
	signal data_regA12 : std_logic_vector (31 downto 0);
	signal data_regA13 : std_logic_vector (31 downto 0);
	signal data_regA14 : std_logic_vector (31 downto 0);
	signal data_regA21 : std_logic_vector (31 downto 0);
	signal data_regA22 : std_logic_vector (31 downto 0);
	signal data_regA23 : std_logic_vector (31 downto 0);
	signal data_regA24 : std_logic_vector (31 downto 0);
	signal data_regA31 : std_logic_vector (31 downto 0);
	signal data_regA32 : std_logic_vector (31 downto 0);
	signal data_regA33 : std_logic_vector (31 downto 0);
	signal data_regA34 : std_logic_vector (31 downto 0);
	signal data_regA41 : std_logic_vector (31 downto 0);
	signal data_regA42 : std_logic_vector (31 downto 0);
	signal data_regA43 : std_logic_vector (31 downto 0);
	signal data_regA44 : std_logic_vector (31 downto 0);
	
-- mux16to4 
	signal sel_mux16to4 : std_logic_vector (2 downto 0);
	signal data_mux1 : std_logic_vector (31 downto 0);
	signal data_mux2 : std_logic_vector (31 downto 0);
	signal data_mux3 : std_logic_vector (31 downto 0);
	signal data_mux4 : std_logic_vector (31 downto 0);
	
-- demux4to16
	signal en_demux4to16 : std_logic;
	signal sel_demux4to16 : std_logic_vector (2 downto 0);
	signal data_demuxA11 : std_logic_vector (31 downto 0);
	signal data_demuxA12 : std_logic_vector (31 downto 0);
	signal data_demuxA13 : std_logic_vector (31 downto 0);
	signal data_demuxA14 : std_logic_vector (31 downto 0);
	signal data_demuxA21 : std_logic_vector (31 downto 0);
	signal data_demuxA22 : std_logic_vector (31 downto 0);
	signal data_demuxA23 : std_logic_vector (31 downto 0);
	signal data_demuxA24 : std_logic_vector (31 downto 0);
	signal data_demuxA31 : std_logic_vector (31 downto 0);
	signal data_demuxA32 : std_logic_vector (31 downto 0);
	signal data_demuxA33 : std_logic_vector (31 downto 0);
	signal data_demuxA34 : std_logic_vector (31 downto 0);
	signal data_demuxA41 : std_logic_vector (31 downto 0);
	signal data_demuxA42 : std_logic_vector (31 downto 0);
	signal data_demuxA43 : std_logic_vector (31 downto 0);
	signal data_demuxA44 : std_logic_vector (31 downto 0);
	
-- QuarterRound
	signal out_cu_done: std_logic;
	signal en_QR : std_logic;
	signal QR_out1 : std_logic_vector (31 downto 0);
	signal QR_out2 : std_logic_vector (31 downto 0);
	signal QR_out3 : std_logic_vector (31 downto 0);
	signal QR_out4 : std_logic_vector (31 downto 0);
	
	component mux2to1_0 is
        port (         
            A_a0       : in    std_logic_vector (31 downto 0);    -- data A 
            B_a0       : in    std_logic_vector (31 downto 0);    -- data B
            Sel_a0     : in    std_logic;                         -- selector
            Data_a0    : out   std_logic_vector (31 downto 0)     -- output data
        ); 
	end component;
	
	component mux2to1_1 is
		port (         
			A_a1       : in    std_logic_vector (31 downto 0);    -- data A 
			B_a1       : in    std_logic_vector (31 downto 0);    -- data B
			Sel_a1     : in    std_logic;                         -- selector
			Data_a1    : out   std_logic_vector (31 downto 0)     -- output data
		); 
	end component;

	component mux2to1_2 is
        port (         
            A_a2       : in    std_logic_vector (31 downto 0);    -- data A 
            B_a2       : in    std_logic_vector (31 downto 0);    -- data B
            Sel_a2     : in    std_logic;                         -- selector
            Data_a2    : out   std_logic_vector (31 downto 0)     -- output data
        ); 
	end component;

	component mux2to1_3 is
		port (         
			A_a3       : in    std_logic_vector (31 downto 0);    -- data A 
			B_a3       : in    std_logic_vector (31 downto 0);    -- data B
			Sel_a3     : in    std_logic;                         -- selector
			Data_a3    : out   std_logic_vector (31 downto 0)     -- output data
		); 
	end component;

	component mux2to1_4 is
		port (         
			A_a4       : in    std_logic_vector (31 downto 0);    -- data A 
			B_a4       : in    std_logic_vector (31 downto 0);    -- data B
			Sel_a4     : in    std_logic;                         -- selector
			Data_a4    : out   std_logic_vector (31 downto 0)     -- output data
		); 
		end component;
	
	component mux2to1_5 is
        port (         
            A_a5       : in    std_logic_vector (31 downto 0);    -- data A 
            B_a5       : in    std_logic_vector (31 downto 0);    -- data B
            Sel_a5     : in    std_logic;                         -- selector
            Data_a5    : out   std_logic_vector (31 downto 0)     -- output data
        ); 
	end component;

	component mux2to1_6 is
		port (         
			A_a6       : in    std_logic_vector (31 downto 0);    -- data A 
			B_a6       : in    std_logic_vector (31 downto 0);    -- data B
			Sel_a6     : in    std_logic;                         -- selector
			Data_a6    : out   std_logic_vector (31 downto 0)     -- output data
		); 
	end component;

	component mux2to1_7 is
		port (         
			A_a7       : in    std_logic_vector (31 downto 0);    -- data A 
			B_a7       : in    std_logic_vector (31 downto 0);    -- data B
			Sel_a7     : in    std_logic;                         -- selector
			Data_a7    : out   std_logic_vector (31 downto 0)     -- output data
		); 
	end component;

	component mux2to1_8 is
		port (         
			A_a8       : in    std_logic_vector (31 downto 0);    -- data A 
			B_a8       : in    std_logic_vector (31 downto 0);    -- data B
			Sel_a8     : in    std_logic;                         -- selector
			Data_a8    : out   std_logic_vector (31 downto 0)     -- output data
		); 
	end component;

	component mux2to1_9 is
		port (         
			A_a9       : in    std_logic_vector (31 downto 0);    -- data A 
			B_a9       : in    std_logic_vector (31 downto 0);    -- data B
			Sel_a9     : in    std_logic;                         -- selector
			Data_a9    : out   std_logic_vector (31 downto 0)     -- output data
		); 
	end component;

	component mux2to1_10 is
		port (         
			A_a10       : in    std_logic_vector (31 downto 0);    -- data A 
			B_a10       : in    std_logic_vector (31 downto 0);    -- data B
			Sel_a10     : in    std_logic;                         -- selector
			Data_a10    : out   std_logic_vector (31 downto 0)     -- output data
		); 
	end component;

	component mux2to1_11 is
		port (         
			A_a11       : in    std_logic_vector (31 downto 0);    -- data A 
			B_a11       : in    std_logic_vector (31 downto 0);    -- data B
			Sel_a11     : in    std_logic;                         -- selector
			Data_a11    : out   std_logic_vector (31 downto 0)     -- output data
		); 
	end component;

	component mux2to1_12 is
		port (         
			A_a12       : in    std_logic_vector (31 downto 0);    -- data A 
			B_a12       : in    std_logic_vector (31 downto 0);    -- data B
			Sel_a12     : in    std_logic;                         -- selector
			Data_a12    : out   std_logic_vector (31 downto 0)     -- output data
		); 
	end component;

	component mux2to1_13 is
		port (         
			A_a13       : in    std_logic_vector (31 downto 0);    -- data A 
			B_a13       : in    std_logic_vector (31 downto 0);    -- data B
			Sel_a13     : in    std_logic;                         -- selector
			Data_a13    : out   std_logic_vector (31 downto 0)     -- output data
		); 
	end component;

	component mux2to1_14 is
		port (         
			A_a14       : in    std_logic_vector (31 downto 0);    -- data A 
			B_a14       : in    std_logic_vector (31 downto 0);    -- data B
			Sel_a14     : in    std_logic;                         -- selector
			Data_a14    : out   std_logic_vector (31 downto 0)     -- output data
		); 
	end component;

	component mux2to1_15 is
		port (         
			A_a15       : in    std_logic_vector (31 downto 0);    -- data A 
			B_a15       : in    std_logic_vector (31 downto 0);    -- data B
			Sel_a15     : in    std_logic;                         -- selector
			Data_a15    : out   std_logic_vector (31 downto 0)     -- output data
		); 
	end component;

	component Register32bit_0 is
        port (         
            B0       : in    std_logic_vector (31 downto 0);  -- data input
            En_B0    : in    std_logic;                       -- enable signal
            Res      : in    std_logic;                       -- reset signal
            Clk      : in    std_logic;                       -- Clk signal
            Data_B0  : out   std_logic_vector (31 downto 0)   -- data output
        );	
	end component;

	component Register32bit_1 is
        port (
            B1       : in    std_logic_vector (31 downto 0);  -- data input
            En_B1    : in    std_logic;                       -- enable signal
            Res      : in    std_logic;                       -- reset signal
            Clk      : in    std_logic;                       -- Clk signal
            Data_B1  : out   std_logic_vector (31 downto 0)   -- data output
        );
	end component;
	 
	component Register32bit_2 is
        port (
            B2       : in    std_logic_vector (31 downto 0);  -- data input
            En_B2    : in    std_logic;                       -- enable signal
            Res      : in    std_logic;                       -- reset signal
            Clk      : in    std_logic;                       -- Clk signal
            Data_B2 : out   std_logic_vector (31 downto 0)   -- data output
        );
	end component;
	
	component Register32bit_3 is
        port (
            B3       : in    std_logic_vector (31 downto 0);  -- data input
            En_B3    : in    std_logic;                       -- enable signal
            Res      : in    std_logic;                       -- reset signal
            Clk      : in    std_logic;                       -- Clk signal
            Data_B3 : out   std_logic_vector (31 downto 0)   -- data output
        );
	end component;
	 
	component Register32bit_4 is
        port (
            B4      : in    std_logic_vector (31 downto 0);  -- data input
            En_B4   : in    std_logic;                       -- enable signal
            Res      : in    std_logic;                       -- reset signal
            Clk      : in    std_logic;                       -- Clk signal
            Data_B4  : out   std_logic_vector (31 downto 0)   -- data output
        );
	end component;
	 
	component Register32bit_5 is
        port (
            B5       : in    std_logic_vector (31 downto 0);  -- data input
            En_B5   : in    std_logic;                       -- enable signal
            Res      : in    std_logic;                       -- reset signal
            Clk      : in    std_logic;                       -- Clk signal
            Data_B5  : out   std_logic_vector (31 downto 0)   -- data output
        );
	end component;
	
	component Register32bit_6 is
		port (
			B6       : in    std_logic_vector (31 downto 0);  -- data input
			En_B6    : in    std_logic;                       -- enable signal
			Res      : in    std_logic;                       -- reset signal
			Clk      : in    std_logic;                       -- Clk signal
			Data_B6  : out   std_logic_vector (31 downto 0)   -- data output
		);
	end component;

	component Register32bit_7 is
        port (
            B7       : in    std_logic_vector (31 downto 0);  -- data input
            En_B7    : in    std_logic;                       -- enable signal
            Res      : in    std_logic;                       -- reset signal
            Clk      : in    std_logic;                       -- Clk signal
            Data_B7  : out   std_logic_vector (31 downto 0)   -- data output
        );
	end component;
	
	component Register32bit_8 is
		port (
			B8       : in    std_logic_vector (31 downto 0);  -- data input
			En_B8    : in    std_logic;                       -- enable signal
			Res      : in    std_logic;                       -- reset signal
			Clk      : in    std_logic;                       -- Clk signal
			Data_B8  : out   std_logic_vector (31 downto 0)   -- data output
		);
	end component;

	component Register32bit_9 is
		port (
			B9       : in    std_logic_vector (31 downto 0);  -- data input
			En_B9    : in    std_logic;                       -- enable signal
			Res      : in    std_logic;                       -- reset signal
			Clk      : in    std_logic;                       -- Clk signal
			Data_B9  : out   std_logic_vector (31 downto 0)   -- data output
		);
	end component;

	component Register32bit_10 is
		port (
			B10       : in    std_logic_vector (31 downto 0);  -- data input
			En_B10    : in    std_logic;                       -- enable signal
			Res      : in    std_logic;                       -- reset signal
			Clk      : in    std_logic;                       -- Clk signal
			Data_B10  : out   std_logic_vector (31 downto 0)   -- data output
		);
		end component;
	
	component Register32bit_11 is
        port (
            B11       : in    std_logic_vector (31 downto 0);  -- data input
            En_B11    : in    std_logic;                       -- enable signal
            Res      : in    std_logic;                       -- reset signal
            Clk      : in    std_logic;                       -- Clk signal
            Data_B11  : out   std_logic_vector (31 downto 0)   -- data output
        );
	end component;
	
	component Register32bit_12 is
		port (
			B12       : in    std_logic_vector (31 downto 0);  -- data input
			En_B12    : in    std_logic;                       -- enable signal
			Res      : in    std_logic;                       -- reset signal
			Clk      : in    std_logic;                       -- Clk signal
			Data_B12  : out   std_logic_vector (31 downto 0)   -- data output
		);
	end component;
	
	component Register32bit_13 is
        port (
            B13       : in    std_logic_vector (31 downto 0);  -- data input
            En_B13   : in    std_logic;                       -- enable signal
            Res      : in    std_logic;                       -- reset signal
            Clk      : in    std_logic;                       -- Clk signal
            Data_B13  : out   std_logic_vector (31 downto 0)   -- data output
        );
	end component;

	component Register32bit_14 is
		port (
			B14       : in    std_logic_vector (31 downto 0);  -- data input
			En_B14    : in    std_logic;                       -- enable signal
			Res      : in    std_logic;                       -- reset signal
			Clk      : in    std_logic;                       -- Clk signal
			Data_B14  : out   std_logic_vector (31 downto 0)   -- data output
		);
	end component;
	
	component Register32bit_15 is
        port (
            B15       : in    std_logic_vector (31 downto 0);  -- data input
            En_B15    : in    std_logic;                       -- enable signal
            Res      : in    std_logic;                       -- reset signal
            Clk      : in    std_logic;                       -- Clk signal
            Data_B15  : out   std_logic_vector (31 downto 0)   -- data output
        );
	end component;

	component mux16to4 is
        port (         
            A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15       	: in    std_logic_vector (31 downto 0);       -- data A 
            Sel     	                                                                : in    std_logic_vector (2 downto 0);        -- selector
            Data1, Data2, Data3, Data4                                                  : out std_logic_vector (31 downto 0)          -- output data
        ); 
	end component;
	
	component QuarterRound_ref is
        port (
            stop_button                : in std_logic; -- Stop process (reset)
            start_button               : in std_logic; -- Start process
            clock                      : in std_logic; -- External clock
            A, B, C, D                 : in std_logic_vector(31 downto 0); -- Input data
            A_out, B_out, C_out, D_out : out std_logic_vector(31 downto 0);
            cu_done_out                : out STD_LOGIC
        );
	end component;
	
	component dmux4to16 is
        port (
            Data1, Data2, Data3, Data4                                              : in  std_logic_vector(31 downto 0);  -- Single 32-bit input
            Sel     		                                                        : in  std_logic_vector (2 downto 0) ;                      -- 1-bit selector
            Sel_En			                                                        : in std_logic;
            A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15    : out std_logic_vector(31 downto 0)  
        );
	end component;
	
	component EvenOddRoundFSM is
        port(
            Clock       : in std_logic;
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
    end component;
    
	
begin
    --membagi input ke dalam 16 bagian signal 
    a44_in <= input_Round(31 downto 0);
    a43_in <= input_Round(63 downto 32);
    a42_in <= input_Round(95 downto 64);
    a41_in <= input_Round(127 downto 96);
    a34_in <= input_Round(159 downto 128);
    a33_in <= input_Round(191 downto 160);
    a32_in <= input_Round(223 downto 192);
    a31_in <= input_Round(255 downto 224);
    a24_in <= input_Round(287 downto 256);
    a23_in <= input_Round(319 downto 288);
    a22_in <= input_Round(351 downto 320);
    a21_in <= input_Round(383 downto 352);
    a14_in <= input_Round(415 downto 384);
    a13_in <= input_Round(447 downto 416);
    a12_in <= input_Round(479 downto 448);
    a11_in <= input_Round(511 downto 480);

-- instantiation of components
-- komponen mux2to1
	muxA11: mux2to1_0 port map ( A_a0 => data_demuxA11, B_a0 => a11_in, Sel_a0 => sel_A11, Data_a0 => data_muxA11);  
	muxA12: mux2to1_1 port map ( A_a1 => data_demuxA12, B_a1 => a12_in, Sel_a1 => sel_A12, Data_a1 => data_muxA12);  
	muxA13: mux2to1_2 port map ( A_a2 => data_demuxA13, B_a2 => a13_in, Sel_a2 => sel_A13, Data_a2 => data_muxA13);  
	muxA14: mux2to1_3 port map ( A_a3 => data_demuxA14, B_a3 => a14_in, Sel_a3 => sel_A14, Data_a3 => data_muxA14);  
	muxA21: mux2to1_4 port map ( A_a4 => data_demuxA21, B_a4 => a21_in, Sel_a4 => sel_A21, Data_a4 => data_muxA21);  
	muxA22: mux2to1_5 port map ( A_a5 => data_demuxA22, B_a5 => a22_in, Sel_a5 => sel_A22, Data_a5 => data_muxA22);  
	muxA23: mux2to1_6 port map ( A_a6 => data_demuxA23, B_a6 => a23_in, Sel_a6 => sel_A23, Data_a6 => data_muxA23);  
	muxA24: mux2to1_7 port map ( A_a7 => data_demuxA24, B_a7 => a24_in, Sel_a7 => sel_A24, Data_a7 => data_muxA24);  
	muxA31: mux2to1_8 port map ( A_a8 => data_demuxA31, B_a8 => a31_in, Sel_a8 => sel_A31, Data_a8 => data_muxA31);  
	muxA32: mux2to1_9 port map ( A_a9 => data_demuxA32, B_a9 => a32_in, Sel_a9 => sel_A32, Data_a9 => data_muxA32);  
	muxA33: mux2to1_10 port map ( A_a10 => data_demuxA33, B_a10 => a33_in, Sel_a10 => sel_A33, Data_a10 => data_muxA33);  
	muxA34: mux2to1_11 port map ( A_a11 => data_demuxA34, B_a11 => a34_in, Sel_a11 => sel_A34, Data_a11 => data_muxA34);  
	muxA41: mux2to1_12 port map ( A_a12 => data_demuxA41, B_a12 => a41_in, Sel_a12 => sel_A41, Data_a12 => data_muxA41);  
	muxA42: mux2to1_13 port map ( A_a13 => data_demuxA42, B_a13 => a42_in, Sel_a13 => sel_A42, Data_a13 => data_muxA42);  
	muxA43: mux2to1_14 port map ( A_a14 => data_demuxA43, B_a14 => a43_in, Sel_a14 => sel_A43, Data_a14 => data_muxA43);  
	muxA44: mux2to1_15 port map ( A_a15 => data_demuxA44, B_a15 => a44_in, Sel_a15 => sel_A44, Data_a15 => data_muxA44);  
-- komponen register32bit
	regA11: register32bit_0 port map ( B0 => data_muxA11, En_B0 => en_regA11, Res => Res, Clk => Clk, Data_B0 => data_regA11);
	regA12: register32bit_1 port map ( B1 => data_muxA12, En_B1 => en_regA12, Res => Res, Clk => Clk, Data_B1 => data_regA12);
	regA13: register32bit_2 port map ( B2 => data_muxA13, En_B2 => en_regA13, Res => Res, Clk => Clk, Data_B2 => data_regA13);
	regA14: register32bit_3 port map ( B3 => data_muxA14, En_B3 => en_regA14, Res => Res, Clk => Clk, Data_B3 => data_regA14);
	regA21: register32bit_4 port map ( B4 => data_muxA21, En_B4 => en_regA21, Res => Res, Clk => Clk, Data_B4 => data_regA21);
	regA22: register32bit_5 port map ( B5 => data_muxA22, En_B5 => en_regA22, Res => Res, Clk => Clk, Data_B5 => data_regA22);
	regA23: register32bit_6 port map ( B6 => data_muxA23, En_B6 => en_regA23, Res => Res, Clk => Clk, Data_B6 => data_regA23);
	regA24: register32bit_7 port map ( B7 => data_muxA24, En_B7 => en_regA24, Res => Res, Clk => Clk, Data_B7 => data_regA24);
	regA31: register32bit_8 port map ( B8 => data_muxA31, En_B8 => en_regA31, Res => Res, Clk => Clk, Data_B8 => data_regA31);
	regA32: register32bit_9 port map ( B9 => data_muxA32, En_B9 => en_regA32, Res => Res, Clk => Clk, Data_B9 => data_regA32);
	regA33: register32bit_10 port map ( B10 => data_muxA33, En_B10 => en_regA33, Res => Res, Clk => Clk, Data_B10 => data_regA33);
	regA34: register32bit_11 port map ( B11 => data_muxA34, En_B11 => en_regA34, Res => Res, Clk => Clk, Data_B11 => data_regA34);
	regA41: register32bit_12 port map ( B12 => data_muxA41, En_B12 => en_regA41, Res => Res, Clk => Clk, Data_B12 => data_regA41);
	regA42: register32bit_13 port map ( B13 => data_muxA42, En_B13 => en_regA42, Res => Res, Clk => Clk, Data_B13 => data_regA42);
	regA43: register32bit_14 port map ( B14 => data_muxA43, En_B14 => en_regA43, Res => Res, Clk => Clk, Data_B14 => data_regA43);
	regA44: register32bit_15 port map ( B15 => data_muxA44, En_B15 => en_regA44, Res => Res, Clk => Clk, Data_B15 => data_regA44);
-- komponen mux16to4
	Mux16to4_EO : mux16to4 port map
	(
	A0 => data_regA11,
	A1 => data_regA12,
	A2 => data_regA13,
	A3 => data_regA14,
	A4 => data_regA21,
	A5 => data_regA22,
	A6 => data_regA23,
	A7 => data_regA24,
	A8 => data_regA31,
	A9 => data_regA32,
	A10 => data_regA33,
	A11 => data_regA34,
	A12 => data_regA41,
	A13 => data_regA42,
	A14 => data_regA43,
	A15 => data_regA44,    	   
    Sel => sel_mux16to4,      	                       
    Data1 => data_mux1, 
	Data2 => data_mux2, 
	Data3 => data_mux3,
	Data4 => data_mux4
   );

--komponen QuarterRound
	QuarterRound: QuarterRound_ref port map 
	( 
    stop_button => Res,              
    start_button => en_QR,              
    clock => Clk,                   
    A => data_mux1,
	B => data_mux2,
	C => data_mux3,
	D => data_mux4,              
    A_out => QR_out1,
	B_out => QR_out2,
	C_out => QR_out3,
	D_out => QR_out4,
    cu_done_out => out_cu_done
	);

-- komponen demux4to16
	Demux4to16_EO: dmux4to16 port map
	(
	 Data1 => QR_out1, 
	 Data2 => QR_out2,
	 Data3 => QR_out3,
	 Data4 => QR_out4, 
     Sel    => sel_demux4to16,
	 Sel_En => en_demux4to16,                       
     A0     => data_demuxA11,
	 A1     => data_demuxA12,
	 A2     => data_demuxA13,
	 A3     => data_demuxA14,
	 A4     => data_demuxA21,
  	 A5     => data_demuxA22,
 	 A6     => data_demuxA23,
	 A7     => data_demuxA24,
	 A8     => data_demuxA31,
	 A9     => data_demuxA32,
	 A10    => data_demuxA33,
	 A11    => data_demuxA34,
	 A12    => data_demuxA41,
	 A13    => data_demuxA42,
	 A14    => data_demuxA43,
	 A15    => data_demuxA44 
    );

-- komponen FSM even odd round (20 round)
	EvenOddFSM : EvenOddRoundFSM 
	port map
	(
		clock => Clk,
		enable => start_oddeven,
		reset => Res,
		cu_done =>out_cu_done,
		sel_A11 => sel_A11,
		sel_A12 => sel_A12,
		sel_A13 => sel_A13,
		sel_A14 => sel_A14,
		sel_A21 => sel_A21,
		sel_A22 => sel_A22,
		sel_A23 => sel_A23,
		sel_A24 => sel_A24,
		sel_A31 => sel_A31,
		sel_A32 => sel_A32,
		sel_A33 => sel_A33,
		sel_A34 => sel_A34,
		sel_A41 => sel_A41,
		sel_A42 => sel_A42,
		sel_A43 => sel_A43,
		sel_A44 => sel_A44,
		en_regA11 => en_regA11, 
		en_regA12 => en_regA12,
		en_regA13 => en_regA13,
		en_regA14 => en_regA14,
		en_regA21 => en_regA21, 
		en_regA22 => en_regA22,
		en_regA23 => en_regA23,
		en_regA24 => en_regA24,
		en_regA31 => en_regA31, 
		en_regA32 => en_regA32,
		en_regA33 => en_regA33,
		en_regA34 => en_regA34,
		en_regA41 => en_regA41, 
		en_regA42 => en_regA42,
		en_regA43 => en_regA43,
		en_regA44 => en_regA44,
		sel_mux16to4 => sel_mux16to4,
		en_QR => en_QR,
		en_demux4to16 => en_demux4to16,
		sel_demux4to16 => sel_demux4to16,
		flag_evenodd => flag_oddeven_out
	);
	
		-- output assignment
		output_Round(511 downto 480) <= data_regA11;
		output_Round(479 downto 448) <= data_regA12;
		output_Round(447 downto 416) <= data_regA13;
		output_Round(415 downto 384) <= data_regA14;
		output_Round(383 downto 352) <= data_regA21;
		output_Round(351 downto 320) <= data_regA22;
		output_Round(319 downto 288) <= data_regA23;
		output_Round(287 downto 256) <= data_regA24;
		output_Round(255 downto 224) <= data_regA31;
		output_Round(223 downto 192) <= data_regA32;
		output_Round(191 downto 160) <= data_regA33;
		output_Round(159 downto 128) <= data_regA34;
		output_Round(127 downto 96) <= data_regA41;
		output_Round(95 downto 64) <= data_regA42;
		output_Round(63 downto 32) <= data_regA43;
		output_Round(31 downto 0) <= data_regA44;	

        
end architecture;