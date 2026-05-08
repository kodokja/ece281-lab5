--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity top_basys3 is
    port(
        -- inputs
        clk     :   in std_logic; -- native 100MHz FPGA clock
        sw      :   in std_logic_vector(7 downto 0); -- operands and opcode
        btnU    :   in std_logic; -- reset
        btnC    :   in std_logic; -- fsm cycle
        
        -- outputs
        led :   out std_logic_vector(15 downto 0);
        -- 7-segment display segments (active-low cathodes)
        seg :   out std_logic_vector(6 downto 0);
        -- 7-segment display active-low enables (anodes)
        an  :   out std_logic_vector(3 downto 0)
    );
end top_basys3;

architecture top_basys3_arch of top_basys3 is 
  
	-- declare components and signals
	signal w_button : std_logic;
	
    signal w_clk : std_logic;
    signal w_cycle : std_logic_vector(3 downto 0);
    
    signal w_data: std_logic_vector(3 downto 0);
    signal w_seg : std_logic_vector(6 downto 0);
    signal w_sel : std_logic_vector(3 downto 0);
    
    signal w_result : std_logic_vector(7 downto 0);
    signal w_flags : std_logic_vector(3 downto 0);
    signal w_A_reg : std_logic_vector(7 downto 0);
    signal w_B_reg : std_logic_vector(7 downto 0);
    signal w_mux_data : std_logic_vector(7 downto 0);
    
    signal w_sign : std_logic_vector(3 downto 0) := "0000";
    signal w_hund : std_logic_vector(3 downto 0) := "0000";
    signal w_tens : std_logic_vector(3 downto 0) := "0000";
    signal w_ones : std_logic_vector(3 downto 0) := "0000";
    
    component clock_divider is
        generic (constant k_DIV : natural := 2);
        
        port(   i_clk : in STD_LOGIC;
                i_reset : in STD_LOGIC;
                o_clk : out STD_LOGIC
        ); 
    end component clock_divider;
    
    component controller_fsm is
        port(   i_reset : in STD_LOGIC;
                i_adv : in STD_LOGIC;
                o_cycle : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component controller_fsm;
    
    component button_debounce is
        port(   clk : in STD_LOGIC;
                reset : in STD_LOGIC;
                button : in STD_LOGIC;
                action : out STD_LOGIC
        );
    end component button_debounce;
    
    component ALU is
        port(   i_op : in STD_LOGIC_VECTOR(2 downto 0);
                i_A : in STD_LOGIC_VECTOR(7 downto 0);
                i_B : in STD_LOGIC_VECTOR(7 downto 0);
                o_result : out STD_LOGIC_VECTOR(7 downto 0);
                o_flags : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component ALU;
    
    component twos_comp is
        port(   i_bin : in STD_LOGIC_VECTOR(7 downto 0);
                o_sign : out STD_LOGIC;
                o_hund : out STD_LOGIC_VECTOR(3 downto 0);
                o_tens : out STD_LOGIC_VECTOR(3 downto 0);
                o_ones: out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component twos_comp;
    
    component TDM4 is
        generic (constant k_WIDTH : natural  := 4);
        port(   i_clk : in STD_LOGIC;
                i_reset : in STD_LOGIC;
                i_D3 : in STD_LOGIC_VECTOR(3 downto 0);
                i_D2 : in STD_LOGIC_VECTOR(3 downto 0);
                i_D1 : in STD_LOGIC_VECTOR(3 downto 0);
                i_D0 : in STD_LOGIC_VECTOR(3 downto 0);
                o_data : out STD_LOGIC_VECTOR(3 downto 0);
                o_sel : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component TDM4;
    
    component sevenseg_decoder is
        port(   i_hex : in STD_LOGIC_VECTOR(3 downto 0);
                o_seg_n : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component sevenseg_decoder;
    
begin
	-- PORT MAPS ----------------------------------------
    
    clock_divider1 : clock_divider
        generic map(k_DIV => 5000)
        port map(
            i_clk => clk,
            o_clk => w_clk,
            i_reset => '0'
        );
    
    button_debounce1 : button_debounce
        port map(
            clk => clk,
            reset => btnU,
            button => btnC,
            action => w_button
        );
    
    controller_fsm1 : controller_fsm
        port map(
            i_reset => btnU,
            i_adv => w_button,
            o_cycle => w_cycle
        );
        
    ALU1 : ALU
        port map(
            i_op => sw(2 downto 0),
            i_A => w_A_reg,
            i_B => w_B_reg,
            o_result => w_result,
            o_flags =>  w_flags
        
        );
        
    twos_comp1 : twos_comp
        port map(
            i_bin => w_mux_data,
            o_sign => w_sign(0),
            o_hund => w_hund,
            o_tens => w_tens,
            o_ones => w_ones
        
        );
        
    TDM4_1 : TDM4
        port map(
            i_clk => w_clk,
            i_reset => '0',
            i_D3 => w_sign,
            i_D2 => w_hund,
            i_D1 => w_tens,
            i_D0 => w_ones,
            o_data => w_data,
            o_sel => w_sel
        );
    
    sevenseg_decoder1 : sevenseg_decoder
        port map(
            i_hex => w_data,
            o_seg_n => w_seg
        );
	-- CONCURRENT STATEMENTS ----------------------------
	
	process(clk)
	begin
	   if(w_cycle = "0010" and rising_edge(clk)) then
	       w_A_reg <= sw(7 downto 0);
	   end if;
	end process;
	
	process(clk)
	begin
	   if(w_cycle = "0100" and rising_edge(clk)) then
	       w_B_reg <= sw(7 downto 0);
	   end if;
	end process;
	
	w_mux_data <= w_A_reg when (w_cycle = "0010") else
	              w_B_reg when (w_cycle = "0100") else
	              w_result when (w_cycle = "1000") else
	              "00000000";
	              
	seg <= "0000001" when (w_data = "0001") else
	       w_seg;
	
	an <= w_sel;
	led(3) <= w_cycle(3);
	led(2) <= w_cycle(2);
	led(1) <= w_cycle(1);
	led(0) <= w_cycle(0);
	led(15) <= w_flags(3);
	led(14) <= w_flags(2);
	led(13) <= w_flags(1);
	led(12) <= w_flags(0);
end top_basys3_arch;
