--|-------------------------------------------------------------------------------------------------|
--| Sensor Control Module                                                                           |
--|-------------------------------------------------------------------------------------------------|
--| Version B, Ported to LX150 Version, Author: Deyan Levski, deyan.levski@eng.ox.ac.uk, 09.09.2016 |
--|-------------------------------------------------------------------------------------------------|
--| Version C, Added row/digif/board seq sig, Deyan Levski, 04.11.2016                              |
--|-------------------------------------------------------------------------------------------------|
--|-+-|
--
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity ADC_CTRL is
    Port ( 
	-- UART
	   RX : in  STD_LOGIC;   --	   GPIO5 : out STD_LOGIC;
           TX : out  STD_LOGIC;  --	   GPIO6 : out STD_LOGIC;
	-- CLK/RST
           CLOCK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
	-- CHIP SPI
           SPI_SEN : inout  STD_LOGIC;
	   SPI_SCK : inout  STD_LOGIC;
           SPI_SDA : inout  STD_LOGIC;
    	-- DAC SPI
	   SPI_DAC_SCK : inout STD_LOGIC;
	   SPI_DAC_SDA : inout STD_LOGIC;
	   SPI_DAC_A_SYNC : inout STD_LOGIC;
	   SPI_DAC_B_SYNC : inout STD_LOGIC;
	-- BOARD GPIO
	   GPIO1 : out STD_LOGIC; -- DEBUG_PIN / SREG LOADED
	   GPIO2 : out STD_LOGIC; -- SYNC_CLOCK / Scope Trigger
	   GPIO3 : out STD_LOGIC;
	   GPIO4 : out STD_LOGIC;
	-- GPIO5 : out STD_LOGIC;
	-- GPIO6 : out STD_LOGIC;
    	-- BOARD CTRL
	   SHUTDOWN_VDD : out STD_LOGIC;
	   SHUTDOWN_VDA : out STD_LOGIC;
	   SPI_ADC_CS   : out STD_LOGIC;
	   SPI_ADC_MOSI : out STD_LOGIC;
	   SPI_ADC_CLK  : out STD_LOGIC;
	   SPI_ADC_MISO : in STD_LOGIC;
    	-- LVDS COUNT CLK
    	   COUNT_CLK_P : out STD_LOGIC;
	   COUNT_CLK_N : out STD_LOGIC;
    	-- LVDS DIGIF CLK
	   SRX_P : out STD_LOGIC;
	   SRX_N : out STD_LOGIC;
    	-- CHIP sequencer
		-- row_drv
    	   d_row_addr : inout STD_LOGIC_VECTOR(7 downto 0);
    	   d_row_rs   : inout STD_LOGIC;
    	   d_row_rst  : inout STD_LOGIC;
    	   d_row_tx   : inout STD_LOGIC;
    		-- col_vln
    	   d_col_vln_sh : inout STD_LOGIC;
    		-- sampling
           d_shs : inout  STD_LOGIC;
           d_shr : inout  STD_LOGIC;
           d_ads : inout  STD_LOGIC;
           d_adr : inout  STD_LOGIC;
    		-- col_comp
           d_comp_bias_sh : inout  STD_LOGIC;
           d_comp_dyn_pon : inout  STD_LOGIC;
		-- col_count
	   d_count_en : inout  STD_LOGIC;
	   d_count_rst : inout  STD_LOGIC;
	   d_count_inv_clk : inout  STD_LOGIC;
	   d_count_hold : inout  STD_LOGIC;
	   d_count_updn : inout  STD_LOGIC;
	   d_count_inc_one : inout  STD_LOGIC;
	   d_count_jc_shift_en : inout  STD_LOGIC;
	   d_count_lsb_en : inout  STD_LOGIC;
	   d_count_lsb_clk : inout  STD_LOGIC;
	   d_count_mem_wr : inout  STD_LOGIC;
    		-- ref_vref
           d_ref_vref_ramp_rst : inout  STD_LOGIC;
           d_ref_vref_sh : inout  STD_LOGIC;
           d_ref_vref_clamp_en : inout  STD_LOGIC;
           d_ref_vref_ramp_ota_dyn_pon : inout  STD_LOGIC;
		-- digif
           d_digif_serial_rst : inout  STD_LOGIC;
	   G0LTX_N : in STD_LOGIC;
	   G0LTX_P : in STD_LOGIC;
	   G0HTX_N : in STD_LOGIC;
	   G0HTX_P : in STD_LOGIC;
	   G1LTX_N : in STD_LOGIC;
	   G1LTX_P : in STD_LOGIC;
	   G1HTX_N : in STD_LOGIC;
	   G1HTX_P : in STD_LOGIC;
	   G2LTX_N : in STD_LOGIC;
	   G2LTX_P : in STD_LOGIC;
	   G2HTX_N : in STD_LOGIC;
	   G2HTX_P : in STD_LOGIC;
	   G3LTX_N : in STD_LOGIC;
	   G3LTX_P : in STD_LOGIC;
	   G3HTX_N : in STD_LOGIC;
	   G3HTX_P : in STD_LOGIC;
	   G4LTX_N : in STD_LOGIC;
	   G4LTX_P : in STD_LOGIC;
	   G4HTX_N : in STD_LOGIC;
	   G4HTX_P : in STD_LOGIC;
	   G5LTX_N : in STD_LOGIC;
	   G5LTX_P : in STD_LOGIC;
	   G5HTX_N : in STD_LOGIC;
	   G5HTX_P : in STD_LOGIC;
	   G6LTX_N : in STD_LOGIC;
	   G6LTX_P : in STD_LOGIC;
	   G6HTX_N : in STD_LOGIC;
	   G6HTX_P : in STD_LOGIC;
	   G7LTX_N : in STD_LOGIC;
	   G7LTX_P : in STD_LOGIC;
	   G7HTX_N : in STD_LOGIC;
	   G7HTX_P : in STD_LOGIC;
	-- FX3 GPIFII Interface
	   GPIFII_PCLK			: out   std_logic;			-- fx3 interface clock
	   GPIFII_D			: inout std_logic_vector(31 downto 0);	-- fx3 data bus
	   GPIFII_ADDR			: out   std_logic_vector(4 downto 0);	-- fx3 fifo address
	   GPIFII_SLCS_N		: out   std_logic;			-- fx3 fifo chip select
	   GPIFII_SLRD_N		: out   std_logic;			-- fx3 fifo read enable
	   GPIFII_SLWR_N		: out   std_logic;			-- fx3 fifo write enable
	   GPIFII_SLOE_N		: out   std_logic;			-- fx3 fifo output enable
	   GPIFII_PKTEND_N		: out   std_logic;			-- fx3 fifo packet end flag
	   GPIFII_EPSWITCH		: out   std_logic;			-- fx3 endpoint switch
	   GPIFII_FLAGA			: in    std_logic;			-- fx3 fifo flag
	   GPIFII_FLAGB			: in    std_logic			-- fx3 fifo flag
   );
end ADC_CTRL;

architecture Behavioral of ADC_CTRL is

	component PLL_F250 is
		port (
		CLK_IN1           : in     std_logic;
		-- Clock out ports
		CLK_OUT1          : out    std_logic;
		CLK_OUT2          : out    std_logic
		);
	end component;

	component SREG_CONTROL is
		port (
		RX      : in  STD_LOGIC;
           	TX      : out STD_LOGIC;
           	CLOCK   : in  STD_LOGIC;
           	RESET   : in  STD_LOGIC;
           	SPI_SEN : inout  STD_LOGIC;
           	SPI_SCK : inout  STD_LOGIC;
           	SPI_SDA : inout  STD_LOGIC;
		SPI_DAC_SCK : inout STD_LOGIC;
		SPI_DAC_SDA : inout STD_LOGIC;
		SPI_DAC_A_SYNC : inout STD_LOGIC;
		SPI_DAC_B_SYNC : inout STD_LOGIC;
    	   	DEBUG_PIN : out STD_LOGIC
	);
	end component;

	component SEQUENCER is
		port (
		CLOCK			: in  STD_LOGIC;
		RESET			: in  STD_LOGIC;

		FVAL			: inout STD_LOGIC;
		LVAL			: inout STD_LOGIC;

		d_row_addr		: inout STD_LOGIC_VECTOR(7 downto 0);
		d_row_rs		: inout STD_LOGIC;
		d_row_rst		: inout STD_LOGIC;
		d_row_tx		: inout STD_LOGIC;

		d_col_vln_sh		: inout STD_LOGIC;

		d_adc_shr_shs		: inout STD_LOGIC;

		d_shs			: inout STD_LOGIC;
		d_shr			: inout STD_LOGIC;
		d_ads			: inout STD_LOGIC;
		d_adr			: inout STD_LOGIC;
		
		d_comp_bias_sh		: inout STD_LOGIC;
		d_comp_dyn_pon		: inout STD_LOGIC;
		
		d_count_rst		: inout STD_LOGIC;
		d_count_inv_clk		: inout STD_LOGIC;
		d_count_hold		: inout STD_LOGIC;
		d_count_updn		: inout STD_LOGIC;
		d_count_inc_one		: inout STD_LOGIC;
		d_count_jc_shift_en	: inout STD_LOGIC;
		d_count_lsb_en		: inout STD_LOGIC;
		d_count_lsb_clk		: inout STD_LOGIC;
		d_count_mem_wr		: inout STD_LOGIC;
		d_count_en		: inout STD_LOGIC;
		
		d_digif_serial_rst	: inout std_logic;
		
		d_ref_vref_ramp_rst	: inout std_logic;
		d_ref_vref_sh		: inout std_logic;
		d_ref_vref_clamp_en	: inout std_logic;
		d_ref_vref_ramp_ota_dyn_pon: inout std_logic
	);
	end component;

	component FX3_SLAVE is
	port (	CLOCK : in  std_logic;
	        RESET : in  std_logic;
	        LED   : out std_logic;
		FVAL_IN : in std_logic;
		LVAL_IN : in std_logic;
		DATA_IN : in std_logic_vector(15 downto 0);
	        -- FX3 GPIFII Interface
	        GPIFII_PCLK		: out   std_logic;			-- fx3 interface clock
	        GPIFII_D		: inout std_logic_vector(31 downto 0);	-- fx3 data bus
	        GPIFII_ADDR		: out   std_logic_vector(4 downto 0);	-- fx3 fifo address
	        GPIFII_SLCS_N		: out   std_logic;			-- fx3 fifo chip select
	        GPIFII_SLRD_N		: out   std_logic;			-- fx3 fifo read enable
	        GPIFII_SLWR_N		: out   std_logic;			-- fx3 fifo write enable
	        GPIFII_SLOE_N		: out   std_logic;			-- fx3 fifo output enable
	        GPIFII_PKTEND_N		: out   std_logic;			-- fx3 fifo packet end flag
	        GPIFII_EPSWITCH		: out   std_logic;			-- fx3 endpoint switch
	        GPIFII_FLAGA		: in    std_logic;			-- fx3 fifo flag
	        GPIFII_FLAGB		: in    std_logic			-- fx3 fifo flag
       );
	end component;

	signal CLOCK_100 : std_logic;
	signal CLOCK_250 : std_logic;
	signal CLOCK_COUNT_OBUFDS : std_logic;
	signal CLOCK_DIGIF_OBUFDS : std_logic;
	signal FVAL_SEQ  : std_logic;
	signal LVAL_SEQ  : std_logic;
	signal G0LTX	 : std_logic;
	signal G0HTX	 : std_logic;
	signal G1LTX	 : std_logic;
	signal G1HTX	 : std_logic;
	signal G2LTX	 : std_logic;
	signal G2HTX	 : std_logic;
	signal G3LTX	 : std_logic;
	signal G3HTX	 : std_logic;
	signal G4LTX	 : std_logic;
	signal G4HTX	 : std_logic;
	signal G5LTX	 : std_logic;
	signal G5HTX	 : std_logic;
	signal G6LTX	 : std_logic;
	signal G6HTX	 : std_logic;
	signal G7LTX	 : std_logic;
	signal G7HTX	 : std_logic;

begin

--|----------------------|
--| Instantiate PLL Core |
--|----------------------|

	PLL_250_INST: PLL_F250
	port map (
	CLK_IN1           => CLOCK,
	-- Clock out ports
	CLK_OUT1          => CLOCK_100,
	CLK_OUT2          => CLOCK_250
	);

   -- End of PLL Core instantiation

--|------------------------------------------------|
--| OBUFDS: Differential Output Count Clock Buffer |
--|------------------------------------------------|

   ODDR2_LVDS_CLOC_BUFFER_OUT_INST : ODDR2
   generic map(
      DDR_ALIGNMENT => "NONE", -- Sets output alignment to "NONE", "C0", "C1" 
      INIT => '0', -- Sets initial state of the Q output to '0' or '1'
      SRTYPE => "SYNC") -- Specifies "SYNC" or "ASYNC" set/reset
   port map (
      Q  => CLOCK_COUNT_OBUFDS, -- 1-bit output data
      C0 => CLOCK_250, -- 1-bit clock input
      C1 => not CLOCK_250, -- 1-bit clock input
      CE => '1',   -- 1-bit clock enable input
      D0 => '0',   -- 1-bit data input (associated with C0)
      D1 => '1',   -- 1-bit data input (associated with C1)
      R => RESET,  -- 1-bit reset input
      S => '0'     -- 1-bit set input
   );
   
   OBUFDS_COUNT_CLK : OBUFDS
   generic map (
      IOSTANDARD => "LVDS_33")
   port map (
      O => COUNT_CLK_N,     -- Diff_p output (connect directly to top-level port)
      OB => COUNT_CLK_P,    -- Diff_n output (connect directly to top-level port)
      I => CLOCK_COUNT_OBUFDS -- Buffer input 
   );
  
   -- End of OBUFDS_inst instantiation

--|----------------------------------------------------|
--| OBUFDS: Differential Digif Serializer Clock Buffer |
--|----------------------------------------------------|

   ODDR2_LVDS_CLOC_DIGIF_BUFFER_OUT_INST : ODDR2
   generic map(
      DDR_ALIGNMENT => "NONE", -- Sets output alignment to "NONE", "C0", "C1" 
      INIT => '0', -- Sets initial state of the Q output to '0' or '1'
      SRTYPE => "SYNC") -- Specifies "SYNC" or "ASYNC" set/reset
   port map (
      Q  => CLOCK_DIGIF_OBUFDS, -- 1-bit output data
      C0 => CLOCK_100, -- 1-bit clock input
      C1 => not CLOCK_100, -- 1-bit clock input
      CE => '1',   -- 1-bit clock enable input
      D0 => '0',   -- 1-bit data input (associated with C0)
      D1 => '1',   -- 1-bit data input (associated with C1)
      R => RESET,  -- 1-bit reset input
      S => '0'     -- 1-bit set input
   ); 

   OBUFDS_DIGIF_CLK : OBUFDS
   generic map (
      IOSTANDARD => "LVDS_33")
   port map (
      O => SRX_N,     -- Diff_p output (connect directly to top-level port)
      OB => SRX_P,    -- Diff_n output (connect directly to top-level port)
      I => CLOCK_DIGIF_OBUFDS  -- Buffer input
   );
  
   -- End of OBUFDS_inst instantiation

--|--------------------|
--| GROUP 0 DATA IBUFF |
--|--------------------|

   IBUFDS_DIGIF_MSB_G0 : IBUFGDS
   generic map (
      DIFF_TERM => TRUE, -- Differential Termination 
      IBUF_LOW_PWR => FALSE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
      IOSTANDARD => "LVDS_33")
   port map (
      O 		=> G0LTX,  -- Buffer output
      I 		=> G0LTX_P,
      IB 		=> G0LTX_N
   );

   IBUFDS_DIGIF_LSB_G0 : IBUFGDS
   generic map (
      DIFF_TERM => TRUE, -- Differential Termination 
      IBUF_LOW_PWR => FALSE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
      IOSTANDARD => "LVDS_33")
   port map (
      O 		=> G0HTX,  -- Buffer output
      I 		=> G0HTX_P,
      IB 		=> G0HTX_N
   );

--|--------------------|
--| GROUP 1 DATA IBUFF |
--|--------------------|

   IBUFDS_DIGIF_MSB_G1 : IBUFGDS
   generic map (
      DIFF_TERM => TRUE, -- Differential Termination 
      IBUF_LOW_PWR => FALSE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
      IOSTANDARD => "LVDS_33")
   port map (
      O 		=> G1LTX,  -- Buffer output
      I 		=> G1LTX_P,
      IB 		=> G1LTX_N
   );

   IBUFDS_DIGIF_LSB_G1 : IBUFGDS
   generic map (
      DIFF_TERM => TRUE, -- Differential Termination 
      IBUF_LOW_PWR => FALSE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
      IOSTANDARD => "LVDS_33")
   port map (
      O 		=> G1HTX,  -- Buffer output
      I 		=> G1HTX_P,
      IB 		=> G1HTX_N
   );

--|--------------------|
--| GROUP 2 DATA IBUFF |
--|--------------------|

   IBUFDS_DIGIF_MSB_G2 : IBUFGDS
   generic map (
      DIFF_TERM => TRUE, -- Differential Termination 
      IBUF_LOW_PWR => FALSE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
      IOSTANDARD => "LVDS_33")
   port map (
      O 		=> G2LTX,  -- Buffer output
      I 		=> G2LTX_P,
      IB 		=> G2LTX_N
   );

   IBUFDS_DIGIF_LSB_G2 : IBUFGDS
   generic map (
      DIFF_TERM => TRUE, -- Differential Termination 
      IBUF_LOW_PWR => FALSE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
      IOSTANDARD => "LVDS_33")
   port map (
      O 		=> G2HTX,  -- Buffer output
      I 		=> G2HTX_P,
      IB 		=> G2HTX_N
   );

--|--------------------|
--| GROUP 3 DATA IBUFF |
--|--------------------|

   IBUFDS_DIGIF_MSB_G3 : IBUFGDS
   generic map (
      DIFF_TERM => TRUE, -- Differential Termination 
      IBUF_LOW_PWR => FALSE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
      IOSTANDARD => "LVDS_33")
   port map (
      O 		=> G3LTX,  -- Buffer output
      I 		=> G3LTX_P,
      IB 		=> G3LTX_N
   );

   IBUFDS_DIGIF_LSB_G3 : IBUFGDS
   generic map (
      DIFF_TERM => TRUE, -- Differential Termination 
      IBUF_LOW_PWR => FALSE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
      IOSTANDARD => "LVDS_33")
   port map (
      O 		=> G3HTX,  -- Buffer output
      I 		=> G3HTX_P,
      IB 		=> G3HTX_N
   );

--|--------------------|
--| GROUP 4 DATA IBUFF |
--|--------------------|

   IBUFDS_DIGIF_MSB_G4 : IBUFGDS
   generic map (
      DIFF_TERM => TRUE, -- Differential Termination 
      IBUF_LOW_PWR => FALSE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
      IOSTANDARD => "LVDS_33")
   port map (
      O 		=> G4LTX,  -- Buffer output
      I 		=> G4LTX_P,
      IB 		=> G4LTX_N
   );

   IBUFDS_DIGIF_LSB_G4 : IBUFGDS
   generic map (
      DIFF_TERM => TRUE, -- Differential Termination 
      IBUF_LOW_PWR => FALSE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
      IOSTANDARD => "LVDS_33")
   port map (
      O 		=> G4HTX,  -- Buffer output
      I 		=> G4HTX_P,
      IB 		=> G4HTX_N
   );

--|--------------------|
--| GROUP 5 DATA IBUFF |
--|--------------------|

   IBUFDS_DIGIF_MSB_G5 : IBUFGDS
   generic map (
      DIFF_TERM => TRUE, -- Differential Termination 
      IBUF_LOW_PWR => FALSE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
      IOSTANDARD => "LVDS_33")
   port map (
      O 		=> G5LTX,  -- Buffer output
      I 		=> G5LTX_P,
      IB 		=> G5LTX_N
   );

   IBUFDS_DIGIF_LSB_G5 : IBUFGDS
   generic map (
      DIFF_TERM => TRUE, -- Differential Termination 
      IBUF_LOW_PWR => FALSE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
      IOSTANDARD => "LVDS_33")
   port map (
      O 		=> G5HTX,  -- Buffer output
      I 		=> G5HTX_P,
      IB 		=> G5HTX_N
   );

--|--------------------|
--| GROUP 6 DATA IBUFF |
--|--------------------|

   IBUFDS_DIGIF_MSB_G6 : IBUFGDS
   generic map (
      DIFF_TERM => TRUE, -- Differential Termination 
      IBUF_LOW_PWR => FALSE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
      IOSTANDARD => "LVDS_33")
   port map (
      O 		=> G6LTX,  -- Buffer output
      I 		=> G6LTX_P,
      IB 		=> G6LTX_N
   );

   IBUFDS_DIGIF_LSB_G6 : IBUFGDS
   generic map (
      DIFF_TERM => TRUE, -- Differential Termination 
      IBUF_LOW_PWR => FALSE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
      IOSTANDARD => "LVDS_33")
   port map (
      O 		=> G6HTX,  -- Buffer output
      I 		=> G6HTX_P,
      IB 		=> G6HTX_N
   );

--|--------------------|
--| GROUP 7 DATA IBUFF |
--|--------------------|

   IBUFDS_DIGIF_MSB_G7 : IBUFGDS
   generic map (
      DIFF_TERM => TRUE, -- Differential Termination 
      IBUF_LOW_PWR => FALSE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
      IOSTANDARD => "LVDS_33")
   port map (
      O 		=> G7LTX,  -- Buffer output
      I 		=> G7LTX_P,
      IB 		=> G7LTX_N
   );

   IBUFDS_DIGIF_LSB_G7 : IBUFGDS
   generic map (
      DIFF_TERM => TRUE, -- Differential Termination 
      IBUF_LOW_PWR => FALSE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
      IOSTANDARD => "LVDS_33")
   port map (
      O 		=> G7HTX,  -- Buffer output
      I 		=> G7HTX_P,
      IB 		=> G7HTX_N
   );

--|----------------------------|
--| Instantiating SREG_CONTROL |
--|----------------------------|

	SREG_CONTROL_INST: SREG_CONTROL
	port map (
	RX => RX,
	TX => TX,
	CLOCK => CLOCK_100,
	RESET => RESET,
	SPI_SEN => SPI_SEN,
	SPI_SCK => SPI_SCK,
	SPI_SDA => SPI_SDA,
	SPI_DAC_SCK => SPI_DAC_SCK,
	SPI_DAC_SDA => SPI_DAC_SDA,
	SPI_DAC_A_SYNC => SPI_DAC_A_SYNC,
	SPI_DAC_B_SYNC => SPI_DAC_B_SYNC,
	DEBUG_PIN => GPIO1
	);

   -- End of SREG_CONTROL instantiation

--|-------------------------|
--| Instantiating SEQUENCER |
--|-------------------------|

	SEQUENCER_INST: SEQUENCER
	port map (
		CLOCK			=>	  CLOCK_250, -- should use CLOCK_250, using CLOCK_100 for scope
		RESET			=>	  RESET,
		FVAL			=>	  FVAL_SEQ,
		LVAL			=>	  LVAL_SEQ,

		d_row_addr		=>	  d_row_addr,
		d_row_rs		=>	  d_row_rs,
		d_row_rst		=>	  d_row_rst,
		d_row_tx		=>	  d_row_tx,
		d_col_vln_sh		=> 	  d_col_vln_sh,

		d_adc_shr_shs		=>	  open,
									  
		d_shs			=>	  d_shs,
		d_shr			=>	  d_shr,
		d_ads			=>	  d_ads,
		d_adr			=>	  d_adr,
						  
		d_comp_bias_sh		=>	  d_comp_bias_sh,
		d_comp_dyn_pon		=>	  d_comp_dyn_pon,
						  
		d_count_rst		=>	  d_count_rst,
		d_count_inv_clk		=>	  d_count_inv_clk,
		d_count_hold		=>	  d_count_hold,
		d_count_updn		=>	  d_count_updn,
		d_count_inc_one		=>	  d_count_inc_one,
		d_count_jc_shift_en	=>	  d_count_jc_shift_en,
		d_count_lsb_en		=>	  d_count_lsb_en,
		d_count_lsb_clk		=>	  d_count_lsb_clk,
		d_count_mem_wr		=>	  d_count_mem_wr,
		d_count_en		=>	  d_count_en,
						  
		d_digif_serial_rst	=>	  d_digif_serial_rst,
						  
		d_ref_vref_ramp_rst	=>	  d_ref_vref_ramp_rst,
		d_ref_vref_sh		=>	  d_ref_vref_sh,
		d_ref_vref_clamp_en	=>	  d_ref_vref_clamp_en,
		d_ref_vref_ramp_ota_dyn_pon =>	  d_ref_vref_ramp_ota_dyn_pon
		 );

   -- End of SEQUENCER instantiation

-- |----------------------------------------|
-- | Instantiating IMAGE_OUT and FX3 DRIVER |
-- |----------------------------------------|

	FX3_SLAVE_INST : FX3_SLAVE 
	port map (	
		CLOCK 			=> CLOCK_100,
	        RESET 			=> RESET,
	        LED   			=> open,
		FVAL_IN 		=> FVAL_SEQ,
		LVAL_IN			=> LVAL_SEQ,
		DATA_IN			=> "0101010101010101",
	        -- FX3 GPIFII Interface
	        GPIFII_PCLK		=> GPIFII_PCLK,		-- fx3 interface clock
	        GPIFII_D		=> GPIFII_D,		-- fx3 data bus
	        GPIFII_ADDR		=> GPIFII_ADDR,		-- fx3 fifo address
	        GPIFII_SLCS_N		=> GPIFII_SLCS_N,	-- fx3 fifo chip select
	        GPIFII_SLRD_N		=> GPIFII_SLRD_N,	-- fx3 fifo read enable
	        GPIFII_SLWR_N		=> GPIFII_SLWR_N,	-- fx3 fifo write enable
	        GPIFII_SLOE_N		=> GPIFII_SLOE_N,	-- fx3 fifo output enable
	        GPIFII_PKTEND_N		=> GPIFII_PKTEND_N,	-- fx3 fifo packet end flag
	        GPIFII_EPSWITCH		=> GPIFII_EPSWITCH,	-- fx3 endpoint switch
	        GPIFII_FLAGA		=> GPIFII_FLAGA,	-- fx3 fifo flag
	        GPIFII_FLAGB		=> GPIFII_FLAGB		-- fx3 fifo flag
       );

GPIO2 <= not CLOCK_100; -- scope triggering clock
GPIO3 <= '0';
GPIO4 <= '0';
SHUTDOWN_VDD <= '0';
SHUTDOWN_VDA <= '0';
SPI_ADC_CS   <= '0';
SPI_ADC_MOSI <= '0';
SPI_ADC_CLK  <= '0';
--SPI_ADC_MISO <= '0';

end Behavioral;
