library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;


entity chacha20 is
    port(
        clock            :   in std_logic;
        button_reset_in    :   in std_logic;
        switch	        :   in std_logic;
        button_start_in    :   in std_logic;
        o_TX_comp1		:	out std_logic;		----Output line
		i_RX_comp1		:	in std_logic;		----Input line
        o_TX_comp2		:	out std_logic;		----Output line
		i_RX_comp2		:	in std_logic;		----Input line
        led_out         :   out std_logic;		
		  led_tx          :   out std_logic
        
    );
end entity;

architecture rtl of chacha20 is

--Component mux unutk menentukan arah komunikasi 
component mux2to1_inUART is     
    port (         
        Comp_A              : in    std_logic;    -- data A 
        Comp_B              : in    std_logic;    -- data B
        Sel_switch_mode     : in    std_logic;    -- selector
        Data_UART           : out   std_logic     -- output data
    ); 
end component;  


--Component untuk 512 bit register
component bit_register is 
    port(
        clk             : in    std_logic;                         -- clock signal
        Reset           : in    std_logic;                         -- reset signal
        input_reg       : in    std_logic_vector (511 downto 0);   -- data input
        en_reg_text     : in    std_logic;                         -- enable signal
        output_reg      : out   std_logic_vector (511 downto 0)    -- data output
    );
end component;


--Component untuk Demux
component Demux is 
    port(
        input_Demux : in std_logic_vector(7 downto 0); 
        sel : in std_logic ; 
        output_0, output_1 : out std_logic_vector(7 downto 0)
    );
end component;


--Component untuk memulai counter
component block_counter is 
    port (
        clk      	            : in  std_logic;                         -- sinyal clock
        counter_switch       	: in  std_logic;                         -- sinyal enable
        output_counter    	    : out std_logic_vector (31 downto 0)    -- hasil penghitungan
    );
end component; 

--Component untuk mux_keystream
component mux_keystream is 
    port (
        Input_counter           : in    std_logic_vector(31 downto 0);   --input hasil counter dari block counter
        Input_RNG               : in    std_logic_vector(255 downto 0);  --input yang berasal dari RNG
        Input_keystream_round   : in    std_logic_vector(511 downto 0);  --input hasil odd even round berupa keystream 512 bit
        Input_Nonce             : in    std_logic_vector(95 downto 0);   --input nonce dari nonce generator
        en_mux_keystream        : in    std_logic;                       --selector mux
        Data_out_mux            : out   std_logic_vector(511 downto 0)   --output
    );
end component;

--Component untuk Keystream
component keystream is    
    port(
        Clk                                  : in    std_logic;                         -- clock signal
        Res                                  : in    std_logic;                         -- reset signal
        input_key                            : in    std_logic_vector (511 downto 0);    -- data input
        En_reg_keystream                     : in    std_logic;                         -- enable signal
        out_register_keystream               : out   std_logic_vector (511 downto 0)     -- data output
    );
end component;

--component demux yang menerima input dari register keystream 
component demux_keystream is
    port ( 
        Input_RegKey                     : in  std_logic_vector(511 downto 0);   -- Single 32-bit input
        En_dmux_keystream                : in  std_logic;                        -- 1-bit selector
        out_odd_even                     : out std_logic_vector(511 downto 0);   --output untuk odd even round dalam bentuk key yang belum diacak
        out_keystream                    : out std_logic_vector(511 downto 0)   -- output berupa keystream yang naninya akan di-XOR dengan plain text
    );
end component;

--Component untuk memulai even dan odd round
component EvenOddRound is
	port(
        Clk : in std_logic;
		Res : in std_logic;
		start_oddeven : in std_logic;
        flag_oddeven_out : out std_logic ;
		input_Round : in std_logic_vector(511 downto 0);
        output_Round : out std_logic_vector(511 downto 0)
	);
end component;

--component mux yang menerima inputan berupa key rng dan cipertext untuk dikirim ke uart
component mux2to1_transmitUART is     
    port (         
        Input_dmux_key          : in    std_logic_vector (511 downto 0);    -- input key rng yang sebelumnya disimpan dalam register
        Input_CPRtxt            : in    std_logic_vector (511 downto 0);    -- input cipertext 
        En_mux_transmit         : in    std_logic;                          -- selector
        Data_trasmit            : out   std_logic_vector (511 downto 0)     -- output data
    ); 
end component;  


--Component untuk Registe switch mode komputer atau memilih komputer pengirim UART RX
component register_switch is
    port (
        Clk                : in    std_logic;                       -- clock signal
        Res                : in    std_logic;                       -- reset signal
        Input_Switch       : in    std_logic;  -- data input
        en_reg_mode        : in    std_logic;                       -- enable signal
        Data_out_Switch  : out   std_logic   -- data output
    );
end component;

--Component dari FSM nya
component chacha20_control_unit is
    port(
        clk                     :   in std_logic;
        button_start            :   in std_logic;
        button_reset            :   in std_logic;
        en_reg_mode             :   out std_logic;
        en_uart_recieve         :   out std_logic;
        uart_recieved_flag      :   in std_logic;
        en_mux_text             :   out std_logic;
        en_reg_text             :   out std_logic;
        cnt_in                  :   out std_logic;
        counter_switch          :   out std_logic;
        enable_i                :   out std_logic;
        enables_shift           :   out std_logic;
        en_mux_keystream        :   out std_logic;
        En_reg_keystream        :   out std_logic;
        En_dmux_keystream       :   out std_logic;
        start_oddeven           :   out std_logic;
        flag_oddeven_out        :   in std_logic;
        En_mux_transmit         :   out std_logic;
        en_uart_transmit        :   out std_logic;
        uart_transmitted_flag   :   in std_logic;
        register_reset          :   out std_logic;
        led_out                 :   out STD_LOGIC;
        rng_done_flag           :   in std_logic;
		  led_tx                  :   out std_logic 
    );
end component;

--component xor  dengan input plantext dan keystream lalu menghasilkan cipertext sebagai output
component BitwiseXOR_512bits is
    port(
        In_plaintext : in std_logic_vector (511 downto 0);
        In_keystream : in std_logic_vector (511 downto 0);
        Out_CPRtxt : out std_logic_vector (511 downto 0)
    );
end component;

--component mux untuk input cipertext dan inputan uart
component mux2to1_512bits is     
    port (         
        in_UART         : in    std_logic_vector (511 downto 0);    -- data input dari UART 
        in_CPRtxt       : in    std_logic_vector (511 downto 0);    -- data cipertext
        en_mux_text     : in    std_logic;                          -- selector
        Data_out        : out   std_logic_vector (511 downto 0)     -- output data
    ); 
end component;  

component nonce96 is
    port (
        clk     : in STD_LOGIC;                         --clock
        in_cnt    : in STD_LOGIC;                       --input fsm sebagai enable counter
        in_reg    : in STD_LOGIC;                       --input register 1 bit untuk menentukan ip address
        out_nonce : out STD_LOGIC_VECTOR (95 downto 0)  --output

    );
end component;

component Demux_outUART is
    port (
        Input_UART              : in  std_logic;  
        Sel_switch_mode         : in  std_logic;                      
        Comp_A                  : out std_logic;  
        Comp_B                  : out std_logic 
    );
end component;

component top_shift is
    port (
        clk                : in std_logic;
        reset              : in std_logic;
        enable             : in std_logic;
		  valid_en           : in std_logic;
        Input_Data_S       : in std_logic_vector (7 downto 0);
        Data_out           : out std_logic_vector(255 downto 0);
        rng_done_flag      : out std_logic
    );
end component;

component neoTRNG is
    port (
      clk_i    : in  std_ulogic; -- module clock
      rstn_i   : in  std_ulogic; -- module reset, low-active, async, optional
      enable_i : in  std_ulogic; -- module enable (high-active)
      valid_o  : out std_ulogic; -- data_o is valid when set (high for one cycle)
      data_o   : out std_ulogic_vector(7 downto 0) -- random data byte output
    );
end component;

component UART_transmit is
    port(
        clk                     :   in  std_logic;
        en_uart_transmit        :   in  std_logic;
        paralel_in              :   in  std_logic_vector(511 downto 0);
        serial_out              :   out std_logic;
        uart_transmitted_flag   :   out std_logic   
    );
end component;

component uart_recieve is
    port(
        clk					:	in 	std_logic;
        serial_in			:	in 	STD_LOGIC;
        en_uart_recieve		:	in	std_logic;
        reg_out				:	out STD_LOGIC_VECTOR (511 downto 0);
        uart_recieved_flag	:	out std_logic
    );
end component;



--SIGNAL 
  
    signal button_reset  : STD_LOGIC;
    signal button_start : STD_LOGIC;
  --basic control signal 

  --signal untuk mux2to1_inUART
  signal Data_UART_mux : STD_LOGIC;

  --signal untuk register 1 bit
  signal comp_selector : STD_LOGIC;
  signal en_reg_mode : STD_LOGIC;

  --signal untuk mux2to1_512bits
  signal en_mux_text : STD_LOGIC;
  signal data_out_to_512reg : STD_LOGIC_VECTOR (511 downto 0);

  --signal unutk bit_register
  signal en_reg_text : STD_LOGIC;
  signal register_out_text : STD_LOGIC_VECTOR (511 downto 0);

  --signal unutk bitwise xor 
  signal out_512_XOR : STD_LOGIC_VECTOR (511 downto 0);

  --signal untuk block counter
  signal counter_switch : STD_LOGIC;
  signal counter_out_96 : STD_LOGIC_VECTOR (31 downto 0);

  --signal unutk nonce
  signal cnt_in : STD_LOGIC;
  signal nonce_out_96 : STD_LOGIC_VECTOR (95 downto 0);
  
  --signal untuk mux_keystream
  signal en_mux_keystream : STD_LOGIC;
  signal key_out_512 : STD_LOGIC_VECTOR (511 downto 0);

  --signal untuk keystream
  signal En_reg_keystream : STD_LOGIC;
  signal regkey_out_512 : STD_LOGIC_VECTOR (511 downto 0);

  --signal untuk dmux key
  signal En_dmux_keystream : STD_LOGIC;
  signal odd_even_out : STD_LOGIC_VECTOR (511 downto 0);
  signal keystream_out : STD_LOGIC_VECTOR (511 downto 0);
  signal key_out : STD_LOGIC_VECTOR (255 downto 0);

  --signal untuk odd even
  signal start_oddeven : STD_LOGIC;
  signal flag_oddeven_out : STD_LOGIC;
  signal Round_output : STD_LOGIC_VECTOR (511 downto 0);

  --signal untuk mux2to1_transmitUART
  signal En_mux_transmit : STD_LOGIC;
  signal trasmit_data : STD_LOGIC_VECTOR (511 downto 0);

  --signal untuk Demux_outUART
  

  --signal untuk rng
  signal data_o_temp : STD_ULOGIC_VECTOR(7 downto 0);
  signal enable_i : STD_LOGIC;
  signal valid_o  : STD_LOGIC;
  signal o_data : STD_LOGIC_VECTOR (7 downto 0);

  --signal untuk shit reg
  signal enables_shift  : STD_LOGIC;
  signal out_256_shift : STD_LOGIC_VECTOR (255 downto 0); 
  signal flag_rng_done  : STD_LOGIC;
  
  --signal uart recieve 
  signal en_uart_recieve  : STD_LOGIC;
  signal uart_recieved_flag  : STD_LOGIC;
  signal out_reg_rx : STD_LOGIC_VECTOR (511 downto 0);

  --signal untut uart transmit
  signal en_uart_transmit  : STD_LOGIC;
  signal uart_transmitted_flag  : STD_LOGIC;
  signal out_serial_tx  : STD_LOGIC;

  --signal fsm 
  signal out_rst_reg  : STD_LOGIC;
  signal reset_rng  : STD_LOGIC;
  signal out_led  : STD_LOGIC;
  signal tx_led   : std_logic;

begin
    -- Instantiation of components

    reset_rng <= (button_reset_in);
    led_out <= out_led;
	led_tx  <= tx_led;
    button_reset <= not(button_reset_in);
    button_start <= not(button_start_in);

    register_1bit : register_switch
     port map(
        Clk => clock,
        Res => button_reset,
        Input_Switch => switch,
        en_reg_mode => en_reg_mode,
        Data_out_Switch => comp_selector
    );

    mux_uart : mux2to1_inUART
     port map(
        Comp_A => i_RX_comp1,
        Comp_B => i_RX_comp2,
        Sel_switch_mode => comp_selector,
        Data_UART => Data_UART_mux  
    );

    uart_rx : uart_recieve
     port map(
        clk => clock,
        serial_in => Data_UART_mux,
        en_uart_recieve => en_uart_recieve,
        reg_out => out_reg_rx,
        uart_recieved_flag => uart_recieved_flag
    );

    mux_512bit_cipertext : mux2to1_512bits
     port map(
        in_UART => out_reg_rx, 
        in_CPRtxt => out_512_XOR,
        en_mux_text => en_mux_text,
        Data_out => data_out_to_512reg
    );

    reg_512bit_text : bit_register
     port map(
        clk => clock,
        Reset => out_rst_reg,
        input_reg => data_out_to_512reg,
        en_reg_text => en_reg_text,
        output_reg => register_out_text
    );

    xor_512 : BitwiseXOR_512bits
     port map(
        In_plaintext => register_out_text,
        In_keystream => keystream_out,
        Out_CPRtxt => out_512_XOR
    );

    counter : block_counter
     port map(
        clk => clock,
        counter_switch => counter_switch,
        output_counter => counter_out_96
    );

    nonce : nonce96
     port map(
        clk => clock,
        in_cnt => cnt_in,
        in_reg => comp_selector,
        out_nonce => nonce_out_96
    );

    neo_trng : neoTRNG
     port map(
        clk_i => clock,
        rstn_i => reset_rng, 
        enable_i => enable_i,
        valid_o => valid_o,
        data_o   => data_o_temp
    );

    o_data <= STD_LOGIC_VECTOR(data_o_temp);
    --konversi sinyal std_ulogic menjadi std_logic
    
    shift_reg : top_shift
     port map(
        clk => clock,
        reset => out_rst_reg,
        enable => enables_shift,
        Input_Data_S => o_data,
        Data_out => out_256_shift,
		valid_en => valid_o,
        rng_done_flag => flag_rng_done
    );


    mux_key : mux_keystream
     port map(
        Input_counter => counter_out_96,
        Input_RNG => out_256_shift,
        Input_keystream_round => Round_output,
        Input_Nonce => nonce_out_96,
        en_mux_keystream => en_mux_keystream,
        Data_out_mux => key_out_512
    );

    reg_key : keystream
     port map(
        Clk => clock,
        Res => out_rst_reg,
        input_key => key_out_512,
        En_reg_keystream => En_reg_keystream,
        out_register_keystream => regkey_out_512
    );

    dmux_key : demux_keystream
     port map(
        Input_RegKey => regkey_out_512,
        En_dmux_keystream => En_dmux_keystream,
        out_odd_even => odd_even_out,
        out_keystream => keystream_out
    );

    oddeven : EvenOddRound
     port map(
        Clk => clock,
        Res => button_reset,
        start_oddeven => start_oddeven,
        flag_oddeven_out => flag_oddeven_out,
        input_Round => odd_even_out,
        output_Round => Round_output
    );

    mux_transmit : mux2to1_transmitUART
     port map(
        Input_dmux_key => odd_even_out,
        Input_CPRtxt => register_out_text,
        En_mux_transmit => En_mux_transmit,
        Data_trasmit => trasmit_data
    );

    uart_tx : UART_transmit
     port map(
        clk => clock,
        en_uart_transmit => en_uart_transmit,
        paralel_in => trasmit_data,
        serial_out => out_serial_tx,
        uart_transmitted_flag => uart_transmitted_flag
    );

    demux_out : Demux_outUART
     port map(
        Input_UART => out_serial_tx, 
        Sel_switch_mode => comp_selector,
        Comp_A => o_TX_comp1,
        Comp_B => o_TX_comp2
    );

    control_unit : chacha20_control_unit
     port map(
        clk => clock,
        button_start => button_start,
        button_reset => button_reset,
        en_reg_mode => en_reg_mode,
        en_uart_recieve => en_uart_recieve,
        uart_recieved_flag => uart_recieved_flag,
        en_mux_text => en_mux_text,
        en_reg_text => en_reg_text,
        cnt_in => cnt_in,
        counter_switch => counter_switch,
        enable_i => enable_i,
        enables_shift => enables_shift,
        en_mux_keystream => en_mux_keystream,
        En_reg_keystream => En_reg_keystream,
        En_dmux_keystream => En_dmux_keystream,
        start_oddeven => start_oddeven,
        flag_oddeven_out => flag_oddeven_out,
        En_mux_transmit => En_mux_transmit,
        en_uart_transmit => en_uart_transmit,
        uart_transmitted_flag => uart_transmitted_flag,
        register_reset   => out_rst_reg,
        led_out => out_led,
        rng_done_flag => flag_rng_done,
		  led_tx  => tx_led
    );

end architecture;
