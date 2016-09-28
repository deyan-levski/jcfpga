--|-------------------------------------------|
--| DIGIF - DESERIALIZER LOOPBACK TEST MODULE |
--|-------------------------------------------|
--
--


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity DIGIF_DESERIAL_LOOPBACK is
    Port ( 
	   CLOCK_IN        : in  STD_LOGIC;
           RESET           : in  STD_LOGIC;
    	   RESET_DIGIF     : in STD_LOGIC;
    	   DATA_PAR_CLK    : inout STD_LOGIC;
           DATA_PAR 	   : out  STD_LOGIC_VECTOR (11 downto 0);
	   DEBUG_PIN	   : out STD_LOGIC;
    	   DEBUG_PIN_2	   : out STD_LOGIC;
    --	   DEBUG_PIN_3     : out STD_LOGIC;
    	   d_digif_rst_o   : inout STD_LOGIC;
    	   d_digif_rst_i   : in STD_LOGIC;
	   d_digif_sck_o_p : out STD_LOGIC;
	   d_digif_sck_o_n : out STD_LOGIC;
	   d_digif_sck_i_p : in STD_LOGIC;
    	   d_digif_sck_i_n : in STD_LOGIC;
      d_digif_msb_data_o_p : out STD_LOGIC;
      d_digif_msb_data_o_n : out STD_LOGIC;
      d_digif_lsb_data_o_p : out STD_LOGIC;
      d_digif_lsb_data_o_n : out STD_LOGIC;
      d_digif_msb_data_i_p : in STD_LOGIC;
      d_digif_msb_data_i_n : in STD_LOGIC;
      d_digif_lsb_data_i_p : in STD_LOGIC;
      d_digif_lsb_data_i_n : in STD_LOGIC

);
end DIGIF_DESERIAL_LOOPBACK;

architecture Behavioral of DIGIF_DESERIAL_LOOPBACK is

	component DIGIF is

	   port ( 
	   d_digif_sck 		: in  STD_LOGIC;
           d_digif_rst		: in  STD_LOGIC;
	   RESET		: in  STD_LOGIC;
           d_digif_msb_data 	: out  STD_LOGIC;
           d_digif_lsb_data 	: out  STD_LOGIC
   	   );

	end component;

	component DESERIAL is

	   port ( 
	   CLOCK 		: in  STD_LOGIC;
           RESET		: in  STD_LOGIC;
	   d_digif_rst		: in  STD_LOGIC;
           d_digif_msb_data 	: in  STD_LOGIC;
           d_digif_lsb_data	: in  STD_LOGIC;
	   DESERIALIZED_DATA_CLK: inout STD_LOGIC;
           DESERIALIZED_DATA 	: out  STD_LOGIC_VECTOR (11 downto 0)
   	   );

	end component;

	signal d_digif_msb_data_i : STD_LOGIC;
	signal d_digif_lsb_data_i : STD_LOGIC;
	signal d_digif_msb_data_o : STD_LOGIC;
	signal d_digif_lsb_data_o : STD_LOGIC;

	signal RESET_DIGIF_SYNCED : STD_LOGIC;
       	signal RESET_DIGIF_SYNCED_DESER : STD_LOGIC;

	component PLL_50_100_150_200_250 is
		port
		 (-- Clock in ports
		  CLK_IN1           : in     std_logic;
		  -- Clock out ports
		  CLK_OUT0          : out    std_logic;
		  CLK_OUT1          : out    std_logic;
		  CLK_OUT2          : out    std_logic;
		  CLK_OUT3          : out    std_logic;
		  CLK_OUT4          : out    std_logic;
		  CLK_OUT5          : out    std_logic
		 );
	end component;

	signal CLOCK : STD_LOGIC;
	signal CLOCK_90 : STD_LOGIC;
	signal CLOCK_OBUFDS : STD_LOGIC;
  	signal d_digif_sck_i : STD_LOGIC;
  
  begin

	PLL_MODULE: PLL_50_100_150_200_250
		port map
		 (-- Clock in ports
		  CLK_IN1           => CLOCK_IN,
		  -- Clock out ports
		  CLK_OUT0         => open,-- 50 Mega 0 deg
		  CLK_OUT1         => open,-- 50 Mega 90 deg
		  CLK_OUT2         => CLOCK, --open, 	-- 100 Mega 0 deg
		  CLK_OUT3         => CLOCK_90, --open,     -- 100 Mega 90 deg
		  CLK_OUT4         => open,     -- 250 Mega 0 deg
		  CLK_OUT5	   => open	-- 250 Mega 90 deg
		 );

--	|--------------------|
--	| DIGIF Sensor Model |
--	|--------------------|

	DIGIF_INST: DIGIF
	port map (
	   d_digif_sck 		=> d_digif_sck_i, -- d_digif_sck,
           d_digif_rst		=> d_digif_rst_i, -- d_digif_rst,
	   RESET		=> RESET,
           d_digif_msb_data 	=> d_digif_msb_data_o,
           d_digif_lsb_data 	=> d_digif_lsb_data_o
	);

--	|--------------|
--	| DESERIALIZER |
--	|--------------|

	DESERIAL_INST: DESERIAL
	port map (
	   CLOCK 		=> CLOCK_90, 
           RESET 		=> RESET,
	   d_digif_rst		=> RESET_DIGIF_SYNCED_DESER,
           d_digif_msb_data 	=> d_digif_msb_data_i,
           d_digif_lsb_data 	=> d_digif_lsb_data_i,
	   DESERIALIZED_DATA_CLK => DATA_PAR_CLK,
           DESERIALIZED_DATA 	=> DATA_PAR
	);

 	rstsync : process (CLOCK)				-- reset sync
 	begin
		if falling_edge(CLOCK) then			--- change to rising edge for x1 bitslip, for rest of bitslips, use cnt variable in DESERIAL instance, def falling
 			RESET_DIGIF_SYNCED <= RESET_DIGIF;
 		end if;
 	end process;

	d_digif_rst_o <= RESET_DIGIF_SYNCED;
	RESET_DIGIF_SYNCED_DESER <= RESET_DIGIF_SYNCED;

--	|----------------------------------------|
--	| DIGIF SERIALIZER LVDS CLOCK BUFFER OUT |
--	|----------------------------------------|

	ODDR2_LVDS_CLOC_BUFFER_OUT_inst : ODDR2
	generic map(
	   DDR_ALIGNMENT => "NONE", -- Sets output alignment to "NONE", "C0", "C1" 
	   INIT => '0', -- Sets initial state of the Q output to '0' or '1'
	   SRTYPE => "SYNC") -- Specifies "SYNC" or "ASYNC" set/reset
	port map (
	   Q => CLOCK_OBUFDS, -- 1-bit output data
	   C0 => CLOCK, -- 1-bit clock input
	   C1 => not CLOCK, -- 1-bit clock input
	   CE => '1',   -- 1-bit clock enable input
	   D0 => '0',   -- 1-bit data input (associated with C0)
	   D1 => '1',   -- 1-bit data input (associated with C1)
	   R => RESET,-- 1-bit reset input
	   S => '0'     -- 1-bit set input
	);

	OBUFDS_DIGIF_SCK : OBUFDS
	generic map (
		IOSTANDARD => "LVDS_33")
	port map (
		O 	=> d_digif_sck_o_p,     -- Diff_p output (connect directly to top-level port)
		OB 	=> d_digif_sck_o_n,     -- Diff_n output (connect directly to top-level port)
		I 	=> CLOCK_OBUFDS		-- Buffer input 
	);

--	|--------------------------------------|
--	| DIGIF SERIALIZER MSB DATA BUFFER OUT |
--	|--------------------------------------|

	OBUFDS_DIGIF_MSB_DATA : OBUFDS
	generic map (
		IOSTANDARD => "LVDS_33")
	port map (
		O 	=> d_digif_msb_data_o_p, 
		OB 	=> d_digif_msb_data_o_n, 
		I 	=> d_digif_msb_data_o 
	);

--	|--------------------------------------|
--	| DIGIF SERIALIZER LSB DATA BUFFER OUT |
--	|--------------------------------------|

	OBUFDS_DIGIF_LSB_DATA : OBUFDS
	generic map (
		IOSTANDARD => "LVDS_33")
	port map (
		O 	=> d_digif_lsb_data_o_p, 
		OB 	=> d_digif_lsb_data_o_n, 
		I 	=> d_digif_lsb_data_o
	);

--	|----------------------------------|
--	| DESERIALIZER MSB DATA BUFFER IN  |
--	|----------------------------------|

 	IBUFDS_DIGIF_MSB_DATA : IBUFGDS
 	generic map (
 	   DIFF_TERM => TRUE, -- Differential Termination 
 	   IBUF_LOW_PWR => FALSE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
 	   IOSTANDARD => "LVDS_33")
 	port map (
 	   O 		=> d_digif_msb_data_i,  -- Buffer output
 	   I 		=> d_digif_msb_data_i_p,  -- Diff_p buffer input (connect directly to top-level port)
 	   IB 		=> d_digif_msb_data_i_n -- Diff_n buffer input (connect directly to top-level port)
 	);

--	|----------------------------------|
--	| DESERIALIZER LSB DATA BUFFER OUT |
--	|----------------------------------|

 	IBUFDS_DIGIF_LSB_DATA : IBUFGDS
 	generic map (
 	   DIFF_TERM => TRUE, -- Differential Termination 
 	   IBUF_LOW_PWR => FALSE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
 	   IOSTANDARD => "LVDS_33")
 	port map (
 	   O 		=> d_digif_lsb_data_i,  -- Buffer output
 	   I 		=> d_digif_lsb_data_i_p,  -- Diff_p buffer input (connect directly to top-level port)
 	   IB 		=> d_digif_lsb_data_i_n -- Diff_n buffer input (connect directly to top-level port)
 	);

--	|---------------------------|
--	| DIGIF LVDS CLOCK RECEIVER |
--	|---------------------------|

 	IBUFDS_DIGIF_SCK : IBUFGDS
 	generic map (
 	   DIFF_TERM => TRUE, -- Differential Termination 
 	   IBUF_LOW_PWR => FALSE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
 	   IOSTANDARD => "LVDS_33")
 	port map (
 	   O 		=> d_digif_sck_i,  -- Buffer output
 	   I 		=> d_digif_sck_i_p,  -- Diff_p buffer input (connect directly to top-level port)
 	   IB 		=> d_digif_sck_i_n -- Diff_n buffer input (connect directly to top-level port)
 	);


DEBUG_PIN   <= d_digif_lsb_data_i;
DEBUG_PIN_2 <= d_digif_msb_data_i; --CLOCK;
--DEBUG_PIN_3 <= '0'; --CLOCK_90;

end Behavioral;

