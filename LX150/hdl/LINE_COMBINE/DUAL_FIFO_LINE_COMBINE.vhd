--------------------------------------------------------------------------------
-- AWAIBA Lda
--------------------------------------------------------------------------------
-- MODUL NAME:  DUAL_FIFO_LINE_COMBINE
-- FILENAME:    dual_fifo_line_combine.vhd
-- AUTHOR:      Pedro Santos
--              email: pedro@awaiba.com
--
-- CREATED:     23.07.2013
--------------------------------------------------------------------------------
-- DESCRIPTION: Combine the sensor segments to generate one line.
--
--
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
-- REVISIONS:
-- DATE         VERSION		AUTHOR      	DESCRIPTION
-- 23.07.2013   01     		P. Santos    	Initial version
-- 09.09.2013   02     		P. Santos    	Update to 8 segs for marlin sensor
-- 29.06.2015   03         	R. Sousa        Implemented Dual FIFO architecture (simultaneous data read/write)
-- 19.01.2016   04         	R. Sousa        Number of FIFOs and associated logic is now generated based on the generic value G_NBR_DATA_SEG
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_arith.all;

library UNISIM;
use UNISIM.VComponents.all;

--package LINE_COMBINE_PKG is
--  type T_DATA_SEG is array(natural range <>) of std_logic_vector(15 downto 0);
--end package;

library WORK;
use WORK.LINE_COMBINE_PKG.all;

entity DUAL_FIFO_LINE_COMBINE is
	generic (
		G_NBR_DATA_SEG:   integer := 8);-- Number of data segment fifo pairs
	port (
		RESET:		in  std_logic;	-- Global system reset
		FIFO_ENABLE:	in  std_logic;	-- Enables the fifo control arbitrer
		     --
		WRITE_CLOCK:	in  std_logic;	-- FIFO WRITE Clock - clock used on Sensor side
		DATA_SEG:       in  T_DATA_SEG(0 to G_NBR_DATA_SEG-1);           -- Segment Data
		LVAL_IN:	in  std_logic_vector(G_NBR_DATA_SEG-1 downto 0); -- LVAL signals from all segmants
		     --
		READ_CLOCK:	in  std_logic;  -- FIFO READ Clock - clock used on Camera Link side
		DATA_LINE_OUT:	out std_logic_vector(15 downto 0); -- Output DATA from fifo to Camera Link
		FVAL_OUT:	out std_logic;
		LVAL_OUT:	out std_logic; -- Output LVAL from fifo to Camera Link
		DEBUG_OUT:      out std_logic_vector(1 downto 0) -- Debug output
	);
end entity DUAL_FIFO_LINE_COMBINE;


architecture RTL of DUAL_FIFO_LINE_COMBINE is

	component SEG_FIFO
		port (
			RST:			in  std_logic;
			WR_CLK:			in  std_logic;
			RD_CLK:			in  std_logic;
			DIN:			in  std_logic_vector(15 downto 0);
			WR_EN:			in  std_logic;
			RD_EN:			in  std_logic;
			DOUT:			out std_logic_vector(15 downto 0);
			FULL:			out std_logic;
			ALMOST_FULL:		out std_logic;
			EMPTY:			out std_logic;
			ALMOST_EMPTY:		out std_logic
		);
	end component SEG_FIFO;

	component FIFO_WRITE_SM 
		generic (
			C_NBR_OF_SEG_PIXELS:  integer:=127); -- Number of segment pixels
		port (
			RESET:			in  std_logic; -- Global system reset
			WRITE_CLOCK:		in  std_logic; -- FIFO WRITE Clock - clock used on Sensor side
			--
			FIFO_EMPTY_ACK:		in  std_logic; -- FLAG from the read counter
			WR_ENABLE:		in  std_logic; -- Write enable from the Arbitrer
			READ_ENABLE:		in  std_logic; -- READ enable STATUS from the Arbitrer
			LVAL_IN:		in  std_logic; -- LVAL signals from all segmants
			LVAL_FLAG:		out std_logic; -- Flag to indicate to Arbitrer that LVAL edge was detected
			FIFO_FULL_ACK:		out std_logic;	-- FLAG from the write counter
			ERROR_OUT:		out std_logic);	-- ERROR flag - debug only
	end component FIFO_WRITE_SM;

	component FIFO_READ_SM
		port (
			RESET:			in  std_logic; -- Global system reset
			READ_CLOCK:		in  std_logic; -- FIFO READ Clock - clock used on Sensor side
			--
			FIFO_EMPTY_ACK:		in  std_logic; -- FLAG from the read fifo
			RD_ENABLE:		in  std_logic; -- READ enable from the Arbitrer - used to start read from actual fifo
			FIFO_FULL_ACK:		in  std_logic; -- FLAG from the write State Machine
			START_READ:		in  std_logic; -- FLAG to start read the fifo (contrelled by Arbitrer)
			START_WRITE:		in  std_logic; -- Signal to end the read process from Arbitrer
			FIFO_READ_ENABLE:	out std_logic); -- Signal to enable the fifo read.
	end component FIFO_READ_SM;

	-- STATES to ARBITRER State Machine
	type T_STATES_WR_AR is (IDLE,CHECK_LVAL,WRITE_FIFO_GROUP_1,WRITE_FIFO_GROUP_2,WAIT_FOR_READ_1,WAIT_FOR_READ_2);
	type T_STATES_RD_AR is (IDLE,CHECK_LVAL,GROUP1_READ_FIFO1,GROUP1_READ_FIFO2,GROUP1_READ_FIFO3,GROUP1_READ_FIFO4,GROUP1_READ_FIFO5,GROUP1_READ_FIFO6,GROUP1_READ_FIFO7,GROUP1_READ_FIFO8,
	GROUP2_READ_FIFO1,GROUP2_READ_FIFO2,GROUP2_READ_FIFO3,GROUP2_READ_FIFO4,GROUP2_READ_FIFO5,GROUP2_READ_FIFO6,GROUP2_READ_FIFO7,GROUP2_READ_FIFO8,SWAP_FIFOS_1,SWAP_FIFOS_2);
	signal I_PRESENT_STATE_WR_AR:         T_STATES_WR_AR;
	signal I_PRESENT_STATE_RD_AR:         T_STATES_RD_AR;
--------------------------------------------------------------------------------------------------

	-- Internal signals
	constant C_NBR_LVAL_DLY:        integer := 8;  -- number of delays on the LVAL inputs /8
	constant C_NBR_DATA_DLY:        integer := 8;  -- number of delays on the DATA inputs /8

	type T_LVAL_IN_DLY is array (0 to C_NBR_LVAL_DLY-1) of std_logic_vector(G_NBR_DATA_SEG-1 downto 0);
	type T_DATA_SEG_DLY is array (0 to C_NBR_DATA_DLY-1, 0 to G_NBR_DATA_SEG-1) of std_logic_vector(15 downto 0);
	type T_GEN_STD_LOGIC is array (0 to G_NBR_DATA_SEG*2-1) of std_logic;

	signal I_ERROR:			T_GEN_STD_LOGIC;
	signal I_FIFO_GROUP1_FULL_ALL:	std_logic;
	signal I_FIFO_GROUP2_FULL_ALL:	std_logic;
	signal I_WRITE_FIFO_GROUP_1:	std_logic;
	signal I_WRITE_FIFO_GROUP_2:	std_logic;
	signal I_ENA_WRITE_FIFO:	T_GEN_STD_LOGIC;
	signal I_SEG_LVAL_FLAG:		T_GEN_STD_LOGIC;
	signal I_DATA_OUT_SEG:		T_DATA_SEG(0 to G_NBR_DATA_SEG*2-1);
	signal I_FIFO_FULL_SEG:		T_GEN_STD_LOGIC;
	signal I_FIFO_FULL_ACK_SEG:	T_GEN_STD_LOGIC;
	signal I_READ_FROM_SEG:		T_GEN_STD_LOGIC;
	signal I_SEG_FIFO_EMPTY_ACK:	T_GEN_STD_LOGIC;
	signal I_FVAL_OUT:		std_logic;
	signal I_LVAL_OUT:		std_logic;
	signal I_FVAL_CNT_ACK:		std_logic;
	signal I_FVAL_CNT:		std_logic_vector(3 downto 0);
	signal I_LVAL_IN_DLY:		T_LVAL_IN_DLY;
	signal I_DATA_SEG_DLY:          T_DATA_SEG_DLY;
	signal I_DATA_SEG:              T_DATA_SEG(0 to G_NBR_DATA_SEG-1);

begin
	--------------------------------------------------------------------------------
	-- Delay LVAL by "C_NBR_LVAL_DLY" WRITE_CLOCK cycles
	--  Note: I_LVAL_IN_DLY(i) - i: delay value
	--------------------------------------------------------------------------------
	WR_CLK_LVAL_DELAY_PROC: process(RESET,WRITE_CLOCK)
	begin
		if (RESET = '1') then
			I_LVAL_IN_DLY <= (others => (others => '0'));
		elsif (rising_edge(WRITE_CLOCK)) then
			I_LVAL_IN_DLY(0) <= LVAL_IN;
			for i in 0 to C_NBR_LVAL_DLY-2 loop
				I_LVAL_IN_DLY(i+1) <= I_LVAL_IN_DLY(i);                 
			end loop; 
		end if;
	end process WR_CLK_LVAL_DELAY_PROC;

	--------------------------------------------------------------------------------
	-- Delay DATA by "C_NBR_DATA_DLY" READ_CLOCK cycles
	--  Note: I_DATA_SEG_DLY(i,j) - i: delay value; j: segment index
	--------------------------------------------------------------------------------
	RD_CLK_DATA_DELAY_PROC: process(RESET,READ_CLOCK)
	begin
		if (RESET = '1') then
		I_DATA_SEG_DLY	<= (others => (others => (others => '0')));
	elsif (rising_edge(READ_CLOCK)) then
	for i in 0 to G_NBR_DATA_SEG-1 loop
		I_DATA_SEG_DLY(0,i) <= DATA_SEG(i);         			 
	end loop;
	for i in 0 to C_NBR_DATA_DLY-2 loop
		for j in 0 to G_NBR_DATA_SEG-1 loop
			I_DATA_SEG_DLY(i+1,j) <= I_DATA_SEG_DLY(i,j);
		end loop;			 
	end loop;
end if;
end process RD_CLK_DATA_DELAY_PROC;


--------------------------------------------------------------------------------
--WRITE TO FIFO CONTROL STATE MACHINE--		
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Select data segment delay
--  Note: I_DATA_SEG_DLY(i,j) - i: delay value; j: segment index
--------------------------------------------------------------------------------
DATA_SEG_DLY_EVAL: process(RESET,WRITE_CLOCK)
	variable i:  integer := 0;
begin
	if (RESET = '1') then
		i := 0;
		I_DATA_SEG <= (others => (others => '0'));
	elsif (rising_edge(WRITE_CLOCK)) then
	for j in 0 to G_NBR_DATA_SEG-1 loop
		if (j > 1) then
			i := 0;
			I_DATA_SEG(j) <= I_DATA_SEG_DLY(i,j);
		else
			i := 7; --3?
			I_DATA_SEG(j) <= I_DATA_SEG_DLY(i,j);
		end if;
	end loop;
end if;
end process DATA_SEG_DLY_EVAL;

-------------------------------------------
--FIFO Group 1
-------------------------------------------
GROUP1_FIFOS: for i in 0 to G_NBR_DATA_SEG-1 generate

I_FIFO_WRITE_SM: FIFO_WRITE_SM 
generic map (
	C_NBR_OF_SEG_PIXELS => 128)		-- Number of segment pixels
port map (
	 RESET			=> RESET,	-- Global system reset
	WRITE_CLOCK		=> WRITE_CLOCK,	-- Clock used on Sensor side
		 --
	FIFO_EMPTY_ACK		=> I_SEG_FIFO_EMPTY_ACK(i), -- FLAG from the read counter
	WR_ENABLE		=> FIFO_ENABLE,		    -- Write enable from the Arbitrer
	READ_ENABLE         	=> I_READ_FROM_SEG(i),
	LVAL_IN			=> LVAL_IN(i),	-- LVAL signals from all segmants
	LVAL_FLAG		=> I_SEG_LVAL_FLAG(i),	-- Flag to indicate to Arbitrer that LVAL edge was detected
	FIFO_FULL_ACK		=> I_FIFO_FULL_SEG(i),	-- FLAG from the write counter
	ERROR_OUT		=> I_ERROR(i)
);
---------------------------------
I_SEG_FIFO: SEG_FIFO
port map (
	RST			=> RESET,
	WR_CLK			=> WRITE_CLOCK, 
	RD_CLK			=> READ_CLOCK,
	DIN			=> I_DATA_SEG(i),
	WR_EN			=> I_ENA_WRITE_FIFO(i),
	RD_EN			=> I_READ_FROM_SEG(i),
	DOUT			=> I_DATA_OUT_SEG(i),
	FULL			=> open,
	ALMOST_FULL		=> open,
	EMPTY			=> open,
	ALMOST_EMPTY		=> I_SEG_FIFO_EMPTY_ACK(i)
);

end generate GROUP1_FIFOS;


-------------------------------------------
--FIFO Group 2
-------------------------------------------
GROUP2_FIFOS: for i in 0 to G_NBR_DATA_SEG-1 generate

I_FIFO_WRITE_SM: FIFO_WRITE_SM 
generic map (
	C_NBR_OF_SEG_PIXELS => 128)		-- Number of segment pixels
port map (
	RESET			=> RESET,	-- Global system reset
	WRITE_CLOCK		=> WRITE_CLOCK, -- Clock used on Sensor side
		 --
	FIFO_EMPTY_ACK		=> I_SEG_FIFO_EMPTY_ACK(i+G_NBR_DATA_SEG), -- FLAG from the read counter
	WR_ENABLE		=> FIFO_ENABLE, -- Write enable from the Arbitrer
	READ_ENABLE		=> I_READ_FROM_SEG(i+G_NBR_DATA_SEG),
	LVAL_IN			=> LVAL_IN(i),	-- LVAL signals from all segmants
	LVAL_FLAG		=> I_SEG_LVAL_FLAG(i+G_NBR_DATA_SEG), -- Flag to indicate to Arbitrer that LVAL edge was detected
	FIFO_FULL_ACK		=> I_FIFO_FULL_SEG(i+G_NBR_DATA_SEG), -- FLAG from the write counter
	ERROR_OUT		=> I_ERROR(i)
);
---------------------------------
I_SEG_FIFO: SEG_FIFO
port map (
	RST			=> RESET,
	WR_CLK			=> WRITE_CLOCK, 
	RD_CLK			=> READ_CLOCK,
	DIN			=> I_DATA_SEG(i),
	WR_EN			=> I_ENA_WRITE_FIFO(i+G_NBR_DATA_SEG),
	RD_EN			=> I_READ_FROM_SEG(i+G_NBR_DATA_SEG),
	DOUT			=> I_DATA_OUT_SEG(i+G_NBR_DATA_SEG),
	FULL			=> open,
	ALMOST_FULL		=> open,
	EMPTY			=> open,
	ALMOST_EMPTY		=> I_SEG_FIFO_EMPTY_ACK(i+G_NBR_DATA_SEG)
);

end generate GROUP2_FIFOS;

--------------------------------------------------------------------------------
--DATA ARBITRER STATE MACHINES
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Write Arbitrer FSM
--------------------------------------------------------------------------------
FIFO_WRITE_ARBITRER_FSM: process(RESET,READ_CLOCK)
begin
	if (RESET = '1') then
		I_PRESENT_STATE_WR_AR <= IDLE;
	elsif (rising_edge(READ_CLOCK)) then
		case I_PRESENT_STATE_WR_AR is
	--------------------------------------------------------------------------------
	-- IDLE: default state used to initialise the read/write process
	--------------------------------------------------------------------------------
	when IDLE =>
		if (FIFO_ENABLE = '1') then
			I_PRESENT_STATE_WR_AR <= CHECK_LVAL;
		else
			I_PRESENT_STATE_WR_AR <= I_PRESENT_STATE_WR_AR;
		end if;
	--------------------------------------------------------------------------------
	-- CHECK_LVAL: Check for LVALs to start to write to fifos (mainly the LVAL for 
	--             Segment 1 that is wider)
	--------------------------------------------------------------------------------
	when CHECK_LVAL =>
		if (FIFO_ENABLE = '1') then
			if (LVAL_IN(0) = '1' and I_LVAL_IN_DLY(0)(0) = '0') then
				I_PRESENT_STATE_WR_AR <= WRITE_FIFO_GROUP_1;
			else
				I_PRESENT_STATE_WR_AR <= I_PRESENT_STATE_WR_AR;
			end if;
		else
			I_PRESENT_STATE_WR_AR <= IDLE;
		end if;
	--------------------------------------------------------------------------------
	-- WRITE_FIFO_GROUP_1: write to first group of fifos
	--------------------------------------------------------------------------------
	when WRITE_FIFO_GROUP_1 =>
		if (FIFO_ENABLE = '1') then
			if (I_FIFO_GROUP1_FULL_ALL = '1' or (LVAL_IN(0) = '0' and I_LVAL_IN_DLY(0)(0) = '1')) then
				I_PRESENT_STATE_WR_AR <= WAIT_FOR_READ_1;
			else
				I_PRESENT_STATE_WR_AR <= I_PRESENT_STATE_WR_AR;
			end if;
		else
			I_PRESENT_STATE_WR_AR <= IDLE;
		end if;
	--------------------------------------------------------------------------------
	-- WAIT_FOR_READ_1: wait for fifos to be read
	--------------------------------------------------------------------------------
	when WAIT_FOR_READ_1 =>
		if (FIFO_ENABLE = '1') then
			if (I_PRESENT_STATE_RD_AR = SWAP_FIFOS_1 and (LVAL_IN(0) = '1' and I_LVAL_IN_DLY(0)(0) = '0')) then
				I_PRESENT_STATE_WR_AR <= WRITE_FIFO_GROUP_2;
			else
				I_PRESENT_STATE_WR_AR <= I_PRESENT_STATE_WR_AR;
			end if;
		else
			I_PRESENT_STATE_WR_AR <= IDLE;
		end if;
	--------------------------------------------------------------------------------
	-- WRITE_FIFO_GROUP_2: write to second group of fifos
	--------------------------------------------------------------------------------
	when WRITE_FIFO_GROUP_2 =>
		if (FIFO_ENABLE = '1') then
			if (I_FIFO_GROUP2_FULL_ALL = '1' or (LVAL_IN(0) = '0' and I_LVAL_IN_DLY(0)(0) = '1')) then
				I_PRESENT_STATE_WR_AR <= WAIT_FOR_READ_2;
			else
				I_PRESENT_STATE_WR_AR <= I_PRESENT_STATE_WR_AR;
			end if;
		else
			I_PRESENT_STATE_WR_AR <= IDLE;
		end if;
	--------------------------------------------------------------------------------
	-- WAIT_FOR_READ_2: wait for fifos to be read
	--------------------------------------------------------------------------------
	when WAIT_FOR_READ_2 =>
		if (FIFO_ENABLE = '1') then
			if (I_PRESENT_STATE_RD_AR = SWAP_FIFOS_2) then
				I_PRESENT_STATE_WR_AR <= CHECK_LVAL;
			else
				I_PRESENT_STATE_WR_AR <= I_PRESENT_STATE_WR_AR;
			end if;
		else
			I_PRESENT_STATE_WR_AR <= IDLE;
		end if;
	--------------------------------------------------------------------------------
	-- Others: currently unused states
	--------------------------------------------------------------------------------
	when others =>
		I_PRESENT_STATE_WR_AR <= IDLE;
end case;
	end if;
end process FIFO_WRITE_ARBITRER_FSM;


--------------------------------------------------------------------------------
-- Read Arbitrer FSM
--------------------------------------------------------------------------------
FIFO_READ_ARBITRER_FSM: process(RESET,READ_CLOCK)
begin
	if (RESET = '1') then
		I_PRESENT_STATE_RD_AR <= IDLE;
	elsif (rising_edge(READ_CLOCK)) then
		case I_PRESENT_STATE_RD_AR is
	--------------------------------------------------------------------------------
	-- IDLE: default state used to inicialise the read/write process
	--------------------------------------------------------------------------------
	when IDLE =>
		if (FIFO_ENABLE = '1') then
			I_PRESENT_STATE_RD_AR <= CHECK_LVAL;
		else
			I_PRESENT_STATE_RD_AR <= I_PRESENT_STATE_RD_AR;
		end if;
	--------------------------------------------------------------------------------
	-- CHECK_LVAL: Check for LVALs to start to write to fifos (mainly the LVAL for 
	--             Segment 1 that is wider)
	--------------------------------------------------------------------------------
	when CHECK_LVAL =>
		if (FIFO_ENABLE = '1') then
			if (LVAL_IN(0) = '1' and I_LVAL_IN_DLY(0)(0) = '0') then
				I_PRESENT_STATE_RD_AR <= GROUP2_READ_FIFO1;
			else
				I_PRESENT_STATE_RD_AR <= I_PRESENT_STATE_RD_AR;
			end if;
		else
			I_PRESENT_STATE_RD_AR <= IDLE;
		end if;
	--------------------------------------------------------------------------------
	-- Read from FIFO Group 2 (FSM states should be expanded or reduced to match
	-- G_NBR_DATA_SEG)
	--------------------------------------------------------------------------------
	-- GROUP2_READ_FIFO1: read data from fifo
	--------------------------------------------------------------------------------
	when GROUP2_READ_FIFO1 =>
		if (FIFO_ENABLE = '1') then
			if (I_SEG_FIFO_EMPTY_ACK(G_NBR_DATA_SEG) = '1') then 
				I_PRESENT_STATE_RD_AR <= GROUP2_READ_FIFO2;
			else
				I_PRESENT_STATE_RD_AR <= GROUP2_READ_FIFO1;
			end if;
		else
			I_PRESENT_STATE_RD_AR <= IDLE;
		end if;
	--------------------------------------------------------------------------------
	-- GROUP2_READ_FIFO2: read data from fifo
	--------------------------------------------------------------------------------
	when GROUP2_READ_FIFO2 =>
		if (FIFO_ENABLE = '1') then
			if (I_SEG_FIFO_EMPTY_ACK(G_NBR_DATA_SEG+1) = '1') then 
				I_PRESENT_STATE_RD_AR <= GROUP2_READ_FIFO3;
			else
				I_PRESENT_STATE_RD_AR <= GROUP2_READ_FIFO2;
			end if;
		else
			I_PRESENT_STATE_RD_AR <= IDLE;
		end if;
	--------------------------------------------------------------------------------
	-- GROUP2_READ_FIFO3: read data from fifo
	--------------------------------------------------------------------------------
	when GROUP2_READ_FIFO3 =>
		if (FIFO_ENABLE = '1') then
			if (I_SEG_FIFO_EMPTY_ACK(G_NBR_DATA_SEG+2) = '1') then 
				I_PRESENT_STATE_RD_AR <= GROUP2_READ_FIFO4;
			else
				I_PRESENT_STATE_RD_AR <= GROUP2_READ_FIFO3;
			end if;
		else
			I_PRESENT_STATE_RD_AR <= IDLE;
		end if;
	--------------------------------------------------------------------------------
	-- GROUP2_READ_FIFO4: read data from fifo
	--------------------------------------------------------------------------------		 
	when GROUP2_READ_FIFO4 =>
		if (FIFO_ENABLE = '1') then
			if (I_SEG_FIFO_EMPTY_ACK(G_NBR_DATA_SEG+3) = '1' and I_PRESENT_STATE_WR_AR <= WAIT_FOR_READ_1) then
				I_PRESENT_STATE_RD_AR <= GROUP2_READ_FIFO5; --SWAP_FIFOS_1;
			else
				I_PRESENT_STATE_RD_AR <= GROUP2_READ_FIFO4;
			end if;
		else
			I_PRESENT_STATE_RD_AR <= IDLE;
		end if;

--|---------------------------|
--| Adding 4 more FIFO states |
--|---------------------------|

	--------------------------------------------------------------------------------
	-- GROUP2_READ_FIFO5: read data from fifo
	--------------------------------------------------------------------------------		 
	when GROUP2_READ_FIFO5 =>
		if (FIFO_ENABLE = '1') then
			if (I_SEG_FIFO_EMPTY_ACK(G_NBR_DATA_SEG+4) = '1' and I_PRESENT_STATE_WR_AR <= WAIT_FOR_READ_1) then
				I_PRESENT_STATE_RD_AR <= GROUP2_READ_FIFO6;
			else
				I_PRESENT_STATE_RD_AR <= GROUP2_READ_FIFO5;
			end if;
		else
			I_PRESENT_STATE_RD_AR <= IDLE;
		end if;

	--------------------------------------------------------------------------------
	-- GROUP2_READ_FIFO6: read data from fifo
	--------------------------------------------------------------------------------		 
	when GROUP2_READ_FIFO6 =>
		if (FIFO_ENABLE = '1') then
			if (I_SEG_FIFO_EMPTY_ACK(G_NBR_DATA_SEG+5) = '1' and I_PRESENT_STATE_WR_AR <= WAIT_FOR_READ_1) then
				I_PRESENT_STATE_RD_AR <= GROUP2_READ_FIFO7;
			else
				I_PRESENT_STATE_RD_AR <= GROUP2_READ_FIFO6;
			end if;
		else
			I_PRESENT_STATE_RD_AR <= IDLE;
		end if;
	--------------------------------------------------------------------------------
	-- GROUP2_READ_FIFO7: read data from fifo
	--------------------------------------------------------------------------------		 
	when GROUP2_READ_FIFO7 =>
		if (FIFO_ENABLE = '1') then
			if (I_SEG_FIFO_EMPTY_ACK(G_NBR_DATA_SEG+6) = '1' and I_PRESENT_STATE_WR_AR <= WAIT_FOR_READ_1) then
				I_PRESENT_STATE_RD_AR <= GROUP2_READ_FIFO8;
			else
				I_PRESENT_STATE_RD_AR <= GROUP2_READ_FIFO7;
			end if;
		else
			I_PRESENT_STATE_RD_AR <= IDLE;
		end if;
	--------------------------------------------------------------------------------
	-- GROUP2_READ_FIFO8: read data from fifo
	--------------------------------------------------------------------------------		 
	when GROUP2_READ_FIFO8 =>
		if (FIFO_ENABLE = '1') then
			if (I_SEG_FIFO_EMPTY_ACK(G_NBR_DATA_SEG+7) = '1' and I_PRESENT_STATE_WR_AR <= WAIT_FOR_READ_1) then
				I_PRESENT_STATE_RD_AR <= SWAP_FIFOS_1;
			else
				I_PRESENT_STATE_RD_AR <= GROUP2_READ_FIFO8;
			end if;
		else
			I_PRESENT_STATE_RD_AR <= IDLE;
		end if;

	--------------------------------------------------------------------------------
	-- *****************INSERT ADDITIONAL READ FIFO STATES HERE****************** --
	--------------------------------------------------------------------------------
	-- SWAP_FIFOS_1: swap fifos being written/read
	--------------------------------------------------------------------------------
	when SWAP_FIFOS_1 =>
		if (FIFO_ENABLE = '1') then
			if (I_PRESENT_STATE_WR_AR = WRITE_FIFO_GROUP_2) then 
				I_PRESENT_STATE_RD_AR <= GROUP1_READ_FIFO1;
			else
				I_PRESENT_STATE_RD_AR <= I_PRESENT_STATE_RD_AR;
			end if;
		else
			I_PRESENT_STATE_RD_AR <= IDLE;
		end if;
	--------------------------------------------------------------------------------
	-- Read from FIFO Group 1 (FSM states should be expanded or reduced to match
	-- G_NBR_DATA_SEG)
	--------------------------------------------------------------------------------
	-- GROUP1_READ_FIFO1: read data from fifo
	--------------------------------------------------------------------------------
	when GROUP1_READ_FIFO1 =>
		if (FIFO_ENABLE = '1') then
			if (I_SEG_FIFO_EMPTY_ACK(0) = '1') then 
				I_PRESENT_STATE_RD_AR <= GROUP1_READ_FIFO2;
			else
				I_PRESENT_STATE_RD_AR <= GROUP1_READ_FIFO1;
			end if;
		else
			I_PRESENT_STATE_RD_AR <= IDLE;
		end if;
	--------------------------------------------------------------------------------
	-- GROUP1_READ_FIFO2: read data from fifo
	--------------------------------------------------------------------------------
	when GROUP1_READ_FIFO2 =>
		if (FIFO_ENABLE = '1') then
			if (I_SEG_FIFO_EMPTY_ACK(1) = '1') then 
				I_PRESENT_STATE_RD_AR <= GROUP1_READ_FIFO3;
			else
				I_PRESENT_STATE_RD_AR <= GROUP1_READ_FIFO2;
			end if;
		else
			I_PRESENT_STATE_RD_AR <= IDLE;
		end if;
	--------------------------------------------------------------------------------
	-- GROUP1_READ_FIFO3: read data from fifo
	--------------------------------------------------------------------------------
	when GROUP1_READ_FIFO3 =>
		if (FIFO_ENABLE = '1') then
			if (I_SEG_FIFO_EMPTY_ACK(2) = '1') then 
				I_PRESENT_STATE_RD_AR <= GROUP1_READ_FIFO4;
			else
				I_PRESENT_STATE_RD_AR <= GROUP1_READ_FIFO3;
			end if;
		else
			I_PRESENT_STATE_RD_AR <= IDLE;
		end if;
	--------------------------------------------------------------------------------
	-- GROUP1_READ_FIFO4: read data from fifo
	--------------------------------------------------------------------------------
	when GROUP1_READ_FIFO4 =>
		if (FIFO_ENABLE = '1') then
			if (I_SEG_FIFO_EMPTY_ACK(3) = '1') then
				I_PRESENT_STATE_RD_AR <= GROUP1_READ_FIFO5;
			else
				I_PRESENT_STATE_RD_AR <= GROUP1_READ_FIFO4;
			end if;
		else
			I_PRESENT_STATE_RD_AR <= IDLE;
		end if;

--|---------------------------|
--| Adding 4 more FIFO states |
--|---------------------------|

	--------------------------------------------------------------------------------
	-- GROUP1_READ_FIFO5: read data from fifo
	--------------------------------------------------------------------------------
	when GROUP1_READ_FIFO5 =>
		if (FIFO_ENABLE = '1') then
			if (I_SEG_FIFO_EMPTY_ACK(4) = '1') then
				I_PRESENT_STATE_RD_AR <= GROUP1_READ_FIFO6;
			else
				I_PRESENT_STATE_RD_AR <= GROUP1_READ_FIFO5;
			end if;
		else
			I_PRESENT_STATE_RD_AR <= IDLE;
		end if;
	--------------------------------------------------------------------------------
	-- GROUP1_READ_FIFO6: read data from fifo
	--------------------------------------------------------------------------------
	when GROUP1_READ_FIFO6 =>
		if (FIFO_ENABLE = '1') then
			if (I_SEG_FIFO_EMPTY_ACK(5) = '1') then
				I_PRESENT_STATE_RD_AR <= GROUP1_READ_FIFO7;
			else
				I_PRESENT_STATE_RD_AR <= GROUP1_READ_FIFO6;
			end if;
		else
			I_PRESENT_STATE_RD_AR <= IDLE;
		end if;
	--------------------------------------------------------------------------------
	-- GROUP1_READ_FIFO7: read data from fifo
	--------------------------------------------------------------------------------
	when GROUP1_READ_FIFO7 =>
		if (FIFO_ENABLE = '1') then
			if (I_SEG_FIFO_EMPTY_ACK(6) = '1') then
				I_PRESENT_STATE_RD_AR <= GROUP1_READ_FIFO8;
			else
				I_PRESENT_STATE_RD_AR <= GROUP1_READ_FIFO7;
			end if;
		else
			I_PRESENT_STATE_RD_AR <= IDLE;
		end if;
	--------------------------------------------------------------------------------
	-- GROUP1_READ_FIFO8: read data from fifo
	--------------------------------------------------------------------------------
	when GROUP1_READ_FIFO8 =>
		if (FIFO_ENABLE = '1') then
			if (I_SEG_FIFO_EMPTY_ACK(7) = '1') then
				I_PRESENT_STATE_RD_AR <= SWAP_FIFOS_2;
			else
				I_PRESENT_STATE_RD_AR <= GROUP1_READ_FIFO8;
			end if;
		else
			I_PRESENT_STATE_RD_AR <= IDLE;
		end if;
	
	--------------------------------------------------------------------------------
	-- *****************INSERT ADDITIONAL READ FIFO STATES HERE****************** --
	--------------------------------------------------------------------------------
	-- SWAP_FIFOS_2: swap fifos being written/read
	--------------------------------------------------------------------------------
	when SWAP_FIFOS_2 =>
		if (FIFO_ENABLE = '1') then
			if (I_PRESENT_STATE_WR_AR = CHECK_LVAL) then 
				I_PRESENT_STATE_RD_AR <= CHECK_LVAL;
			else
				I_PRESENT_STATE_RD_AR <= I_PRESENT_STATE_RD_AR;
			end if;
		else
			I_PRESENT_STATE_RD_AR <= IDLE;
		end if;
	--------------------------------------------------------------------------------
	-- Others: currently unused states
	--------------------------------------------------------------------------------		
	when others =>
		I_PRESENT_STATE_RD_AR <= IDLE;
end case;
	end if;
end process FIFO_READ_ARBITRER_FSM;
--------------------------------------------------------------------------------
--CONTROL SIGNALS GENERATION--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Other control signals
--------------------------------------------------------------------------------
AUX_CRTL_SIGNAL_PROC: process(RESET,READ_CLOCK,I_PRESENT_STATE_WR_AR)
begin
	if (RESET = '1') then
		I_WRITE_FIFO_GROUP_1 <= '0';
		I_WRITE_FIFO_GROUP_2 <= '0';
	elsif (rising_edge(READ_CLOCK)) then
		if (I_PRESENT_STATE_WR_AR = WRITE_FIFO_GROUP_1) then
			I_WRITE_FIFO_GROUP_1 <= '1';
			I_WRITE_FIFO_GROUP_2 <= '0';
		elsif (I_PRESENT_STATE_WR_AR = WRITE_FIFO_GROUP_2) then
			I_WRITE_FIFO_GROUP_1 <= '0';
			I_WRITE_FIFO_GROUP_2 <= '1';
		else 
			I_WRITE_FIFO_GROUP_1 <= '0';
			I_WRITE_FIFO_GROUP_2 <= '0';
		end if;
	end if;
end process AUX_CRTL_SIGNAL_PROC;
--------------------------------------------------------------------------------
-- Read control signals
--------------------------------------------------------------------------------
READ_CRTL_SIGNAL_PROC: process(RESET,READ_CLOCK,I_PRESENT_STATE_RD_AR)
begin
	if (RESET = '1') then
		I_READ_FROM_SEG <= (others => '0');
	elsif (rising_edge(READ_CLOCK)) then
	-- FIFO Group 1
	if (I_PRESENT_STATE_RD_AR = GROUP1_READ_FIFO1) then
		I_READ_FROM_SEG(0) <= '1';
		I_READ_FROM_SEG(1) <= '0';
		I_READ_FROM_SEG(2) <= '0';
		I_READ_FROM_SEG(3) <= '0';
		I_READ_FROM_SEG(4) <= '0';
		I_READ_FROM_SEG(5) <= '0';
		I_READ_FROM_SEG(6) <= '0';
		I_READ_FROM_SEG(7) <= '0';
		--
		I_READ_FROM_SEG(G_NBR_DATA_SEG) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+1) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+2) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+3) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+4) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+5) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+6) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+7) <= '0';

	elsif (I_PRESENT_STATE_RD_AR = GROUP1_READ_FIFO2) then
		I_READ_FROM_SEG(0) <= '0';
		I_READ_FROM_SEG(1) <= '1';
		I_READ_FROM_SEG(2) <= '0';
		I_READ_FROM_SEG(3) <= '0';
		I_READ_FROM_SEG(4) <= '0';
		I_READ_FROM_SEG(5) <= '0';
		I_READ_FROM_SEG(6) <= '0';
		I_READ_FROM_SEG(7) <= '0';
		--
		I_READ_FROM_SEG(G_NBR_DATA_SEG) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+1) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+2) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+3) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+4) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+5) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+6) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+7) <= '0';

	elsif (I_PRESENT_STATE_RD_AR = GROUP1_READ_FIFO3) then
		I_READ_FROM_SEG(0) <= '0';
		I_READ_FROM_SEG(1) <= '0';
		I_READ_FROM_SEG(2) <= '1';
		I_READ_FROM_SEG(3) <= '0';
		I_READ_FROM_SEG(4) <= '0';
		I_READ_FROM_SEG(5) <= '0';
		I_READ_FROM_SEG(6) <= '0';
		I_READ_FROM_SEG(7) <= '0';
		--
		I_READ_FROM_SEG(G_NBR_DATA_SEG) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+1) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+2) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+3) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+4) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+5) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+6) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+7) <= '0';

	elsif (I_PRESENT_STATE_RD_AR = GROUP1_READ_FIFO4) then
		I_READ_FROM_SEG(0) <= '0';
		I_READ_FROM_SEG(1) <= '0';
		I_READ_FROM_SEG(2) <= '0';
		I_READ_FROM_SEG(3) <= '1';
		I_READ_FROM_SEG(4) <= '0';
		I_READ_FROM_SEG(5) <= '0';
		I_READ_FROM_SEG(6) <= '0';
		I_READ_FROM_SEG(7) <= '0';
		--
		I_READ_FROM_SEG(G_NBR_DATA_SEG) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+1) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+2) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+3) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+4) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+5) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+6) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+7) <= '0';

	elsif (I_PRESENT_STATE_RD_AR = GROUP1_READ_FIFO5) then
		I_READ_FROM_SEG(0) <= '0';
		I_READ_FROM_SEG(1) <= '0';
		I_READ_FROM_SEG(2) <= '0';
		I_READ_FROM_SEG(3) <= '0';
		I_READ_FROM_SEG(4) <= '1';
		I_READ_FROM_SEG(5) <= '0';
		I_READ_FROM_SEG(6) <= '0';
		I_READ_FROM_SEG(7) <= '0';
		--
		I_READ_FROM_SEG(G_NBR_DATA_SEG) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+1) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+2) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+3) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+4) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+5) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+6) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+7) <= '0';

	elsif (I_PRESENT_STATE_RD_AR = GROUP1_READ_FIFO6) then
		I_READ_FROM_SEG(0) <= '0';
		I_READ_FROM_SEG(1) <= '0';
		I_READ_FROM_SEG(2) <= '0';
		I_READ_FROM_SEG(3) <= '0';
		I_READ_FROM_SEG(4) <= '0';
		I_READ_FROM_SEG(5) <= '1';
		I_READ_FROM_SEG(6) <= '0';
		I_READ_FROM_SEG(7) <= '0';
		--
		I_READ_FROM_SEG(G_NBR_DATA_SEG) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+1) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+2) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+3) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+4) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+5) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+6) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+7) <= '0';

	elsif (I_PRESENT_STATE_RD_AR = GROUP1_READ_FIFO7) then
		I_READ_FROM_SEG(0) <= '0';
		I_READ_FROM_SEG(1) <= '0';
		I_READ_FROM_SEG(2) <= '0';
		I_READ_FROM_SEG(3) <= '0';
		I_READ_FROM_SEG(4) <= '0';
		I_READ_FROM_SEG(5) <= '0';
		I_READ_FROM_SEG(6) <= '1';
		I_READ_FROM_SEG(7) <= '0';
		--
		I_READ_FROM_SEG(G_NBR_DATA_SEG) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+1) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+2) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+3) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+4) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+5) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+6) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+7) <= '0';

	elsif (I_PRESENT_STATE_RD_AR = GROUP1_READ_FIFO8) then
		I_READ_FROM_SEG(0) <= '0';
		I_READ_FROM_SEG(1) <= '0';
		I_READ_FROM_SEG(2) <= '0';
		I_READ_FROM_SEG(3) <= '0';
		I_READ_FROM_SEG(4) <= '0';
		I_READ_FROM_SEG(5) <= '0';
		I_READ_FROM_SEG(6) <= '0';
		I_READ_FROM_SEG(7) <= '1';
		--
		I_READ_FROM_SEG(G_NBR_DATA_SEG) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+1) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+2) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+3) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+4) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+5) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+6) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+7) <= '0';

	-- FIFO Group 2
	elsif (I_PRESENT_STATE_RD_AR = GROUP2_READ_FIFO1) then
		I_READ_FROM_SEG(0) <= '0';
		I_READ_FROM_SEG(1) <= '0';
		I_READ_FROM_SEG(2) <= '0';
		I_READ_FROM_SEG(3) <= '0';
		I_READ_FROM_SEG(4) <= '0';
		I_READ_FROM_SEG(5) <= '0';
		I_READ_FROM_SEG(6) <= '0';
		I_READ_FROM_SEG(7) <= '0';
		--
		I_READ_FROM_SEG(G_NBR_DATA_SEG) <= '1';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+1) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+2) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+3) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+4) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+5) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+6) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+7) <= '0';

	elsif (I_PRESENT_STATE_RD_AR = GROUP2_READ_FIFO2) then
		I_READ_FROM_SEG(0) <= '0';
		I_READ_FROM_SEG(1) <= '0';
		I_READ_FROM_SEG(2) <= '0';
		I_READ_FROM_SEG(3) <= '0';
		I_READ_FROM_SEG(4) <= '0';
		I_READ_FROM_SEG(5) <= '0';
		I_READ_FROM_SEG(6) <= '0';
		I_READ_FROM_SEG(7) <= '0';
		--
		I_READ_FROM_SEG(G_NBR_DATA_SEG) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+1) <= '1';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+2) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+3) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+4) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+5) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+6) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+7) <= '0';

	elsif (I_PRESENT_STATE_RD_AR = GROUP2_READ_FIFO3) then
		I_READ_FROM_SEG(0) <= '0';
		I_READ_FROM_SEG(1) <= '0';
		I_READ_FROM_SEG(2) <= '0';
		I_READ_FROM_SEG(3) <= '0';
		I_READ_FROM_SEG(4) <= '0';
		I_READ_FROM_SEG(5) <= '0';
		I_READ_FROM_SEG(6) <= '0';
		I_READ_FROM_SEG(7) <= '0';
		--
		I_READ_FROM_SEG(G_NBR_DATA_SEG) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+1) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+2) <= '1';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+3) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+4) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+5) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+6) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+7) <= '0';

	elsif (I_PRESENT_STATE_RD_AR = GROUP2_READ_FIFO4) then
		I_READ_FROM_SEG(0) <= '0';
		I_READ_FROM_SEG(1) <= '0';
		I_READ_FROM_SEG(2) <= '0';
		I_READ_FROM_SEG(3) <= '0';
		I_READ_FROM_SEG(4) <= '0';
		I_READ_FROM_SEG(5) <= '0';
		I_READ_FROM_SEG(6) <= '0';
		I_READ_FROM_SEG(7) <= '0';
		--
		I_READ_FROM_SEG(G_NBR_DATA_SEG) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+1) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+2) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+3) <= '1';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+4) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+5) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+6) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+7) <= '0';

	elsif (I_PRESENT_STATE_RD_AR = GROUP2_READ_FIFO5) then
		I_READ_FROM_SEG(0) <= '0';
		I_READ_FROM_SEG(1) <= '0';
		I_READ_FROM_SEG(2) <= '0';
		I_READ_FROM_SEG(3) <= '0';
		I_READ_FROM_SEG(4) <= '0';
		I_READ_FROM_SEG(5) <= '0';
		I_READ_FROM_SEG(6) <= '0';
		I_READ_FROM_SEG(7) <= '0';
		--
		I_READ_FROM_SEG(G_NBR_DATA_SEG) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+1) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+2) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+3) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+4) <= '1';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+5) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+6) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+7) <= '0';

	elsif (I_PRESENT_STATE_RD_AR = GROUP2_READ_FIFO6) then
		I_READ_FROM_SEG(0) <= '0';
		I_READ_FROM_SEG(1) <= '0';
		I_READ_FROM_SEG(2) <= '0';
		I_READ_FROM_SEG(3) <= '0';
		I_READ_FROM_SEG(4) <= '0';
		I_READ_FROM_SEG(5) <= '0';
		I_READ_FROM_SEG(6) <= '0';
		I_READ_FROM_SEG(7) <= '0';
		--
		I_READ_FROM_SEG(G_NBR_DATA_SEG) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+1) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+2) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+3) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+4) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+5) <= '1';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+6) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+7) <= '0';

	elsif (I_PRESENT_STATE_RD_AR = GROUP2_READ_FIFO7) then
		I_READ_FROM_SEG(0) <= '0';
		I_READ_FROM_SEG(1) <= '0';
		I_READ_FROM_SEG(2) <= '0';
		I_READ_FROM_SEG(3) <= '0';
		I_READ_FROM_SEG(4) <= '0';
		I_READ_FROM_SEG(5) <= '0';
		I_READ_FROM_SEG(6) <= '0';
		I_READ_FROM_SEG(7) <= '0';
		--
		I_READ_FROM_SEG(G_NBR_DATA_SEG) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+1) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+2) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+3) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+4) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+5) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+6) <= '1';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+7) <= '0';

	elsif (I_PRESENT_STATE_RD_AR = GROUP2_READ_FIFO8) then
		I_READ_FROM_SEG(0) <= '0';
		I_READ_FROM_SEG(1) <= '0';
		I_READ_FROM_SEG(2) <= '0';
		I_READ_FROM_SEG(3) <= '0';
		I_READ_FROM_SEG(4) <= '0';
		I_READ_FROM_SEG(5) <= '0';
		I_READ_FROM_SEG(6) <= '0';
		I_READ_FROM_SEG(7) <= '0';
		--
		I_READ_FROM_SEG(G_NBR_DATA_SEG) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+1) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+2) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+3) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+4) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+5) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+6) <= '0';
		I_READ_FROM_SEG(G_NBR_DATA_SEG+7) <= '1';

	end if;
end if;
end process READ_CRTL_SIGNAL_PROC;
--------------------------------------------------------------------------------
-- Write control signals
--------------------------------------------------------------------------------
WRITE_CRTL_SIGNAL_PROC: process(RESET,READ_CLOCK)
begin
	if (RESET = '1') then
		I_ENA_WRITE_FIFO <= (others => '0');
		I_FIFO_FULL_ACK_SEG <= (others => '0');
	elsif (rising_edge(READ_CLOCK)) then
	-- FIFO Group 1		
	if (I_WRITE_FIFO_GROUP_1 = '1') then
for i in 0 to G_NBR_DATA_SEG*2-1 loop
		if (i < 2) then 
		I_ENA_WRITE_FIFO(i) <= '1' and (I_LVAL_IN_DLY(0)(i) or I_LVAL_IN_DLY(1)(i));
		elsif ((i > 1) and (i < G_NBR_DATA_SEG)) then
		I_ENA_WRITE_FIFO(i) <= '1' and I_LVAL_IN_DLY(0)(i);
	else
		I_ENA_WRITE_FIFO(i) <= '0';
	end if;
end loop;
	-- FIFO Group 2
	elsif (I_WRITE_FIFO_GROUP_2 = '1') then
for i in 0 to G_NBR_DATA_SEG*2-1 loop
		if (i < G_NBR_DATA_SEG) then 
		I_ENA_WRITE_FIFO(i) <= '0';
		elsif ((i > G_NBR_DATA_SEG-1) and (i < G_NBR_DATA_SEG+2)) then
		I_ENA_WRITE_FIFO(i) <= '1' and (I_LVAL_IN_DLY(0)(i-G_NBR_DATA_SEG) or I_LVAL_IN_DLY(1)(i-G_NBR_DATA_SEG));
	else
		I_ENA_WRITE_FIFO(i) <= '1' and I_LVAL_IN_DLY(0)(i-G_NBR_DATA_SEG);
	end if;
end loop;
-- FIFO Group 1
elsif (I_WRITE_FIFO_GROUP_1 = '1') then
for i in 0 to G_NBR_DATA_SEG-1 loop
	if (I_FIFO_FULL_SEG(i) = '1') then 
		I_ENA_WRITE_FIFO(i) <= '0';
		I_FIFO_FULL_ACK_SEG(i) <= '1';
	end if;
end loop;
if (I_FIFO_GROUP1_FULL_ALL = '1') then
for i in 0 to G_NBR_DATA_SEG-1 loop
	I_FIFO_FULL_ACK_SEG(i) <= '0';
end loop;
			end if;
		-- FIFO Group 2
		elsif (I_WRITE_FIFO_GROUP_2 = '1') then
		for i in G_NBR_DATA_SEG to G_NBR_DATA_SEG*2-1 loop
			if (I_FIFO_FULL_SEG(i) = '1') then 
				I_ENA_WRITE_FIFO(i) <= '0';
				I_FIFO_FULL_ACK_SEG(i) <= '1';
			end if;
		end loop;
		if (I_FIFO_GROUP2_FULL_ALL = '1') then
		for i in G_NBR_DATA_SEG to G_NBR_DATA_SEG*2-1 loop
			I_FIFO_FULL_ACK_SEG(i) <= '0';
		end loop;
	end if;
else
	I_ENA_WRITE_FIFO <= (others => '0');
	I_FIFO_FULL_ACK_SEG <= (others => '0');
end if;
	end if;
end process WRITE_CRTL_SIGNAL_PROC;

--------------------------------------------------------------------------------
--FVAL COUNTER
--------------------------------------------------------------------------------
FVAL_COUNT_PROC: process(RESET,READ_CLOCK)
begin
	if (RESET = '1') then
		I_FVAL_CNT_ACK <= '0';
		I_FVAL_CNT <= (others => '0');
	elsif (rising_edge (READ_CLOCK)) then
		if (I_PRESENT_STATE_WR_AR = CHECK_LVAL) then
			if (I_FVAL_CNT = "1111") then --0111
				I_FVAL_CNT_ACK <= '1';
				I_FVAL_CNT <= (others => '0');
			else
				I_FVAL_CNT_ACK <= '0';
				I_FVAL_CNT <= I_FVAL_CNT + "01";
			end if;
		else
			I_FVAL_CNT_ACK <= '0';
			I_FVAL_CNT <= (others => '0');
		end if;
	end if;
end process FVAL_COUNT_PROC;

--------------------------------------------------------------------------------
--DATA OUT AND LVAL GENERATION
--------------------------------------------------------------------------------
DATA_LVAL_GEN_PROC: process(RESET,READ_CLOCK)
begin
	if (RESET = '1') then
		I_LVAL_OUT <= '0';
		I_FVAL_OUT <= '0';
		DATA_LINE_OUT <= x"0000";
	elsif (rising_edge (READ_CLOCK)) then
		if (I_PRESENT_STATE_RD_AR = SWAP_FIFOS_1 or I_PRESENT_STATE_RD_AR = SWAP_FIFOS_2) then
			I_LVAL_OUT <= '0';
			I_FVAL_OUT <= '0';
			DATA_LINE_OUT <= x"CECE";
		-- FIFO Group 1
		elsif (I_PRESENT_STATE_RD_AR = GROUP1_READ_FIFO1) then
			I_LVAL_OUT <= '1';
			I_FVAL_OUT <= '1';
			DATA_LINE_OUT <= I_DATA_OUT_SEG(0); 
		elsif (I_PRESENT_STATE_RD_AR = GROUP1_READ_FIFO2) then
			I_LVAL_OUT <= '1';
			I_FVAL_OUT <= '1';
			DATA_LINE_OUT <= I_DATA_OUT_SEG(1);
		elsif (I_PRESENT_STATE_RD_AR = GROUP1_READ_FIFO3) then
			I_LVAL_OUT <= '1';
			I_FVAL_OUT <= '1';
			DATA_LINE_OUT <= I_DATA_OUT_SEG(2);
		elsif (I_PRESENT_STATE_RD_AR = GROUP1_READ_FIFO4) then
			I_LVAL_OUT <= '1';
			I_FVAL_OUT <= '1';
			DATA_LINE_OUT <= I_DATA_OUT_SEG(3);
		elsif (I_PRESENT_STATE_RD_AR = GROUP1_READ_FIFO5) then
			I_LVAL_OUT <= '1';
			I_FVAL_OUT <= '1';
			DATA_LINE_OUT <= I_DATA_OUT_SEG(4);
		elsif (I_PRESENT_STATE_RD_AR = GROUP1_READ_FIFO6) then
			I_LVAL_OUT <= '1';
			I_FVAL_OUT <= '1';
			DATA_LINE_OUT <= I_DATA_OUT_SEG(5);
		elsif (I_PRESENT_STATE_RD_AR = GROUP1_READ_FIFO7) then
			I_LVAL_OUT <= '1';
			I_FVAL_OUT <= '1';
			DATA_LINE_OUT <= I_DATA_OUT_SEG(6);
		elsif (I_PRESENT_STATE_RD_AR = GROUP1_READ_FIFO8) then
			I_LVAL_OUT <= '1';
			I_FVAL_OUT <= '1';
			DATA_LINE_OUT <= I_DATA_OUT_SEG(7);

		-- FIFO Group 2
		elsif (I_PRESENT_STATE_RD_AR = GROUP2_READ_FIFO1) then
			I_LVAL_OUT <= '1';
			I_FVAL_OUT <= '1';
			DATA_LINE_OUT <= I_DATA_OUT_SEG(G_NBR_DATA_SEG);
		elsif (I_PRESENT_STATE_RD_AR = GROUP2_READ_FIFO2) then
			I_LVAL_OUT <= '1';
			I_FVAL_OUT <= '1';
			DATA_LINE_OUT <= I_DATA_OUT_SEG(G_NBR_DATA_SEG+1);
		elsif (I_PRESENT_STATE_RD_AR = GROUP2_READ_FIFO3) then
			I_LVAL_OUT <= '1';
			I_FVAL_OUT <= '1';
			DATA_LINE_OUT <= I_DATA_OUT_SEG(G_NBR_DATA_SEG+2);
		elsif (I_PRESENT_STATE_RD_AR = GROUP2_READ_FIFO4) then
			I_LVAL_OUT <= '1';
			I_FVAL_OUT <= '1';
			DATA_LINE_OUT <= I_DATA_OUT_SEG(G_NBR_DATA_SEG+3);
		elsif (I_PRESENT_STATE_RD_AR = GROUP2_READ_FIFO5) then
			I_LVAL_OUT <= '1';
			I_FVAL_OUT <= '1';
			DATA_LINE_OUT <= I_DATA_OUT_SEG(G_NBR_DATA_SEG+4);
		elsif (I_PRESENT_STATE_RD_AR = GROUP2_READ_FIFO6) then
			I_LVAL_OUT <= '1';
			I_FVAL_OUT <= '1';
			DATA_LINE_OUT <= I_DATA_OUT_SEG(G_NBR_DATA_SEG+5);
		elsif (I_PRESENT_STATE_RD_AR = GROUP2_READ_FIFO7) then
			I_LVAL_OUT <= '1';
			I_FVAL_OUT <= '1';
			DATA_LINE_OUT <= I_DATA_OUT_SEG(G_NBR_DATA_SEG+6);
		elsif (I_PRESENT_STATE_RD_AR = GROUP2_READ_FIFO8) then
			I_LVAL_OUT <= '1';
			I_FVAL_OUT <= '1';
			DATA_LINE_OUT <= I_DATA_OUT_SEG(G_NBR_DATA_SEG+7);
		--
		else
			I_LVAL_OUT <= '0';
			I_FVAL_OUT <= '0';
			DATA_LINE_OUT <= x"CECE";
		end if;
	end if;
end process DATA_LVAL_GEN_PROC;

LVAL_OUT <= I_LVAL_OUT;
FVAL_OUT <= I_FVAL_OUT;
----------------------------------------------------------------------------------

I_FIFO_GROUP1_FULL_ALL <= I_FIFO_FULL_ACK_SEG(0) and I_FIFO_FULL_ACK_SEG(1) and I_FIFO_FULL_ACK_SEG(2) and I_FIFO_FULL_ACK_SEG(3);  -- only when all fifos are full (fifo is full when the respective LVAL falls or counter ends)
I_FIFO_GROUP2_FULL_ALL <= I_FIFO_FULL_ACK_SEG(G_NBR_DATA_SEG) and I_FIFO_FULL_ACK_SEG(G_NBR_DATA_SEG+1) and I_FIFO_FULL_ACK_SEG(G_NBR_DATA_SEG+2) and I_FIFO_FULL_ACK_SEG(G_NBR_DATA_SEG+3) and I_FIFO_FULL_ACK_SEG(G_NBR_DATA_SEG+4) and I_FIFO_FULL_ACK_SEG(G_NBR_DATA_SEG+5) and I_FIFO_FULL_ACK_SEG(G_NBR_DATA_SEG+6) and I_FIFO_FULL_ACK_SEG(G_NBR_DATA_SEG+7);  -- only when all fifos are full (fifo is full when the respective LVAL falls or counter ends)



DEBUG_OUT(0) <= I_ENA_WRITE_FIFO(0);
DEBUG_OUT(1) <= I_ENA_WRITE_FIFO(2);

end RTL;