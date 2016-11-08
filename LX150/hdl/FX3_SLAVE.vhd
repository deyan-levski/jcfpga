library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity FX3_SLAVE is
	Port (	CLOCK : in  STD_LOGIC;
	       RESET : in  STD_LOGIC;
	       LED   : out STD_LOGIC;
	       FVAL_IN : in STD_LOGIC;
	       LVAL_IN : in STD_LOGIC;
	       DATA_IN : in STD_LOGIC_VECTOR(15 downto 0);
	       -- FX3 GPIFII Interface
	       GPIFII_PCLK	:		out   std_logic;			-- fx3 interface clock
	       GPIFII_D		:		inout std_logic_vector(31 downto 0);	-- fx3 data bus
	       GPIFII_ADDR	:		out   std_logic_vector(4 downto 0);	-- fx3 fifo address
	       GPIFII_SLCS_N	:		out   std_logic;			-- fx3 fifo chip select
	       GPIFII_SLRD_N	:		out   std_logic;			-- fx3 fifo read enable
	       GPIFII_SLWR_N	:		out   std_logic;			-- fx3 fifo write enable
	       GPIFII_SLOE_N	:		out   std_logic;			-- fx3 fifo output enable
	       GPIFII_PKTEND_N	:		out   std_logic;			-- fx3 fifo packet end flag
	       GPIFII_EPSWITCH	:		out   std_logic;			-- fx3 endpoint switch
	       GPIFII_FLAGA	:		in    std_logic;			-- fx3 fifo flag
	       GPIFII_FLAGB	:		in    std_logic				-- fx3 fifo flag
       );
end FX3_SLAVE;

architecture Behavioral of FX3_SLAVE is

	component FX3_SLAVE_IF is
		generic (
			     G_WRDAT_W:		    positive:= 16);		-- FIFO WRDAT width
		port ( 
			     -- system signals
			     RESET:			 in    std_logic;
			     FX3_CLK:			 in    std_logic;
			     CLOCK:			 in    std_logic;
			     FIFO_ENABLE:		 in    std_logic_vector(7 downto 0);
			     --fifo interfaces
			     FIFO_WR_CLK:		 in    std_logic;
			     FIFO0_WRDAT_I:		 in    std_logic_vector(G_WRDAT_W-1 downto 0);
			     FIFO0_WREN_I:		 in    std_logic;
			     FIFO0_FULL_O:		 out   std_logic;
			     FIFO_RD_CLK:		 in    std_logic;
			     FIFO_RDEN_I:		 in    std_logic;
			     FIFO_EMPTY_O:		 out   std_logic;
			     FIFO_RDDAT_O:		 out   std_logic_vector(7 downto 0);
			     -- GPIFII interface
			     GPIFII_PCLK:		 out   std_logic;
			     GPIFII_D:			 inout std_logic_vector(31 downto 0);
			     GPIFII_ADDR:		 out   std_logic_vector(4 downto 0);
			     GPIFII_SLCS_N:		 out   std_logic;
			     GPIFII_SLRD_N:		 out   std_logic;
			     GPIFII_SLWR_N:		 out   std_logic;
			     GPIFII_SLOE_N:		 out   std_logic;
			     GPIFII_PKTEND_N:		 out   std_logic;
			     GPIFII_EPSWITCH:		 out   std_logic;
			     GPIFII_FLAGA:		 in    std_logic;				 -- Current thread DMA ready
			     GPIFII_FLAGB:		 in    std_logic);				 -- Current thread DMA watermark
	end component FX3_SLAVE_IF;

	component IMAGE_OUT is
		generic (
			     G_CLK_PERIOD_PS:	    integer:=10000;				 -- clock period in picoseconds
			     G_DATA_WIDTH:		    integer:=16;				 -- number of DATA_IN bits
			     G_SENSOR_ID:		    std_logic_vector(7 downto 0):=x"00";	 -- sensor id
			     G_HW_ID:		    std_logic_vector(7 downto 0):=x"00";	 -- hardware id
			     G_FW_VERS:		    std_logic_vector(7 downto 0):=x"00");	 -- fpga firmware version
		port (
			     -- system signals
			     RESET:			 in  std_logic;					 -- asynchronous reset
			     CLOCK:			 in  std_logic;					 -- system/wb clock
			     ENABLE:			 in  std_logic;					 -- module activation
							    -- status inputs
			     STATUS_IN:			 in  std_logic_vector(15 downto 0);		 -- status information to transmit
			     NO_COLS:			 in  std_logic_vector(15 downto 0);		 -- number of columns
			     NO_ROWS:			 in  std_logic_vector(15 downto 0);		 -- number of rows
									      -- image data interface
			     FVAL_IN:			 in  std_logic;					 -- frame valid input
			     LVAL_IN:			 in  std_logic;					 -- line valid input
			     DATA_IN:			 in  std_logic_vector(G_DATA_WIDTH-1 downto 0);  -- data input
			     DATA_IN_EN:		 in  std_logic;					 -- DATA_IN data valid
							       -- fifo write interface
			     TX_FIFO_WREN:		 out std_logic;					 -- tx fifo write enable
			     TX_FIFO_WRDAT:		 out std_logic_vector(31 downto 0);		 -- tx fifo write data
			     --
			     TEST:			 out std_logic);
	end component IMAGE_OUT;

	signal		     TX_FIFO_WREN_O:		 std_logic;					 -- tx fifo write enable
	signal		     TX_FIFO_WRDAT_O:		 std_logic_vector(31 downto 0);			 -- tx fifo write data

begin

	FX3_SLAVE_INST: FX3_SLAVE_IF
	generic map (
			 G_WRDAT_W	=> 32)								 -- FIFO WRDAT width
	port map (
			 -- system signals
			 RESET			=> RESET,
			 FX3_CLK		=> '0',
			 CLOCK			=> CLOCK,
			 FIFO_ENABLE		=> (others => '1'),
			 --fifo interfaces
			 FIFO_WR_CLK		=> CLOCK,
			 FIFO0_WRDAT_I		=> TX_FIFO_WRDAT_O, --"10101011110011011110111100000001",
			 FIFO0_WREN_I		=> TX_FIFO_WREN_O,
			 FIFO0_FULL_O		=> open,
			 FIFO_RD_CLK		=> CLOCK,
			 FIFO_RDEN_I		=> '0',
			 FIFO_EMPTY_O		=> open,
			 FIFO_RDDAT_O		=> open,
			 -- GPIFII interface
			 GPIFII_PCLK		=> open,
			 GPIFII_D		=> GPIFII_D,
			 GPIFII_ADDR		=> GPIFII_ADDR,
			 GPIFII_SLCS_N		=> GPIFII_SLCS_N,
			 GPIFII_SLRD_N		=> GPIFII_SLRD_N,
			 GPIFII_SLWR_N		=> GPIFII_SLWR_N,
			 GPIFII_SLOE_N		=> GPIFII_SLOE_N,
			 GPIFII_PKTEND_N	=> GPIFII_PKTEND_N,
			 GPIFII_EPSWITCH	=> GPIFII_EPSWITCH,
			 GPIFII_FLAGA		=> GPIFII_FLAGA,					-- Current thread DMA ready
			 GPIFII_FLAGB		=> GPIFII_FLAGB);

	IMAGE_OUT_INST : IMAGE_OUT
	generic map (
			    G_CLK_PERIOD_PS	=> 10000,
			    G_DATA_WIDTH	=> 16,
			    G_SENSOR_ID		=> x"00",
			    G_HW_ID		=> x"00",
			    G_FW_VERS		=> x"00")
	port map (
			 -- system signals
			 RESET			  => RESET,
			 CLOCK			  => CLOCK,
			 ENABLE			  => '1',
			 -- status inputs
			 STATUS_IN		  => "0101010101010101",
			 NO_COLS		  => "0000010000000000",
			 NO_ROWS		  => "0000000010000000",
			 -- image data interface
			 FVAL_IN		  => FVAL_IN, 
			 LVAL_IN		  => LVAL_IN,
			 DATA_IN		  => "0101010101010101",
			 DATA_IN_EN		  => '1',
			 -- fifo write interface
			 TX_FIFO_WREN		  => TX_FIFO_WREN_O,
			 TX_FIFO_WRDAT		  => TX_FIFO_WRDAT_O,
			 TEST			  => open);

        LED <= '0';
end Behavioral;

