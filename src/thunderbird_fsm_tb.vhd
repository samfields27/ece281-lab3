--+----------------------------------------------------------------------------
--| 
--| COPYRIGHT 2017 United States Air Force Academy All rights reserved.
--| 
--| United States Air Force Academy     __  _______ ___    _________ 
--| Dept of Electrical &               / / / / ___//   |  / ____/   |
--| Computer Engineering              / / / /\__ \/ /| | / /_  / /| |
--| 2354 Fairchild Drive Ste 2F6     / /_/ /___/ / ___ |/ __/ / ___ |
--| USAF Academy, CO 80840           \____//____/_/  |_/_/   /_/  |_|
--| 
--| ---------------------------------------------------------------------------
--|
--| FILENAME      : thunderbird_fsm_tb.vhd (TEST BENCH)
--| AUTHOR(S)     : Capt Phillip Warner
--| CREATED       : 03/2017
--| DESCRIPTION   : This file tests the thunderbird_fsm modules.
--|
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std
--|    Files     : thunderbird_fsm_enumerated.vhd, thunderbird_fsm_binary.vhd, 
--|				   or thunderbird_fsm_onehot.vhd
--|
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
  
entity thunderbird_fsm_tb is
end thunderbird_fsm_tb;

architecture test_bench of thunderbird_fsm_tb is 
	
	component thunderbird_fsm is 
    port (
        i_clk, i_reset  : in    std_logic;
        i_left, i_right : in    std_logic;
        o_lights_L      : out   std_logic_vector(2 downto 0);
        o_lights_R      : out   std_logic_vector(2 downto 0)
    );
	end component thunderbird_fsm;

	-- test I/O signals
    signal w_clk : std_logic := '0';
    signal w_reset : std_logic := '0';
    signal w_left : std_logic := '0';
    signal w_right : std_logic := '0';
    
    signal w_lightsL : std_logic_vector(2 downto 0) := "000";
    signal w_lightsR : std_logic_vector(2 downto 0) := "000";
	
	
	signal w_S : STD_LOGIC_vector(2 downto 0) :="000";
	signal w_S_next: std_logic_vector(2 downto 0)  :="000";
	
	-- constants
    constant k_clk_period : time := 10 ns;
    
 
	
begin
	-- PORT MAPS ----------------------------------------
	   uut: thunderbird_fsm port map (
          i_reset => w_reset,
          i_clk => w_clk,
          i_left => w_left,
          i_right => w_right,
          o_Lights_L => w_lightsL,
          o_Lights_R => w_lightsR
         

        );
	
	-----------------------------------------------------
	
	-- PROCESSES ----------------------------------------	
    -- Clock process ------------------------------------
    	clk_proc : process
	begin
		w_clk <= '0';
        wait for k_clk_period/2;
		w_clk <= '1';
		wait for k_clk_period/2;
	end process;
    
    
	-----------------------------------------------------
	
	-- Test Plan Process --------------------------------
		sim_proc : process
    begin
        -- reset
        w_reset <= '1'; 
        wait for k_clk_period*2;
        
        
        assert (w_lightsL = "000") report "lightsL Reset" severity error;
        
        assert (w_lightsR = "000") report "lightsR Reset" severity error;
        
        w_left <= '1'; 
        w_right <= '0'; 
        wait for k_clk_period * 2; 
        
        -- keep variable names same
        assert (w_lightsL = "001")  report "lightsL during first transition" severity error;
        
        assert (w_lightsR = "000")  report "lightsR during first transition" severity error;
        -- New values for test
        
        w_left <= '0'; 
        w_right <= '1'; 
        wait for k_clk_period * 2; 
       
        
        -- 
        
        assert (w_lightsL = "000") report "lightsL during second transition" severity error;
        
        assert (w_lightsR = "001") report "lightsR during second transition" severity error;
 
        wait;
    end process;
	
	
	
	-----------------------------------------------------	
	-- Markdown syntax for including an image in README.md  :
--      ![Waveform from thunderbird_fsm_tb](myimage.png)
end test_bench;
