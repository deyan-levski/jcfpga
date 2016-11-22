--------------------------------------------------------------------------------
-- AWAIBA GmbH
--------------------------------------------------------------------------------
-- MODUL NAME:  FIFO_READ_SM
-- FILENAME:    FIFO_READ_SM.vhd
-- AUTHOR:      Pedro Santos
--              email: pedro@awaiba.com
--
-- CREATED:     25.07.2013
--------------------------------------------------------------------------------
-- DESCRIPTION: STATE MACHINE to control the read of the Segment fifo. 
--				Used on STAR project
--
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
-- REVISIONS:
-- DATE         VERSION		AUTHOR      	DESCRIPTION
-- 25.07.2013   01     		P. Santos    	Initial version
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_arith.all;

library UNISIM;
use UNISIM.VComponents.all;


entity FIFO_READ_SM is
	port (
		RESET:			in  std_logic; -- Global system reset
		READ_CLOCK:		in  std_logic; -- FIFO READ Clock - clock used on Sensor side
		--
		FIFO_EMPTY_ACK:		in  std_logic; -- FLAG from the read fifo
		RD_ENABLE:		in  std_logic; -- READ enable from the Arbitrer - used to start read from actual fifo
		FIFO_FULL_ACK:		in  std_logic; -- FLAG from the write State Machine
		START_READ:		in  std_logic; -- FLAG to start read the fifo (contrelled by Arbitrer)
		START_WRITE:		in  std_logic; -- Signal to end the read process from Arbitrer
		FIFO_READ_ENABLE:	out std_logic  -- Signal to enable the fifo read.
		);
end entity FIFO_READ_SM;

architecture RTL of FIFO_READ_SM is

-- STATES to READ State Machine
type T_STATES_RD is (IDLE,READY_TO_READ,READ_FROM_FIFO,FIFO_EMPTY);
signal I_PRESENT_STATE_RD:      T_STATES_RD;
signal I_FIFO_READ_ENABLE:	std_logic;

begin
--------------------------------------------------------------------------------
--READ FROM FIFO CONTROL STATE MACHINE
--------------------------------------------------------------------------------
RD_FIFO_CRTL_SM: process(RESET,READ_CLOCK)
begin
	if (RESET = '1') then
		I_PRESENT_STATE_RD <= IDLE;
		
	elsif (rising_edge (READ_CLOCK)) then
		case I_PRESENT_STATE_RD is
		-- IDLE - default state used to initialise the read process
		when IDLE =>
		  if (RD_ENABLE = '1') then
			if (FIFO_FULL_ACK='1') then	-- Is the fifo full
				I_PRESENT_STATE_RD <= READY_TO_READ;
			else 
				I_PRESENT_STATE_RD <= I_PRESENT_STATE_RD;
			end if;
		  else
			I_PRESENT_STATE_RD <= I_PRESENT_STATE_RD;
		  end if;
		-- READY_TO_READ - fifo is full and the fifo is waiting to start the read process
		when READY_TO_READ =>
		  if (RD_ENABLE = '1') then
			if (START_READ='1') then 	-- is ready to read the fifo?
				I_PRESENT_STATE_RD <= READ_FROM_FIFO;
			else 
				I_PRESENT_STATE_RD <= I_PRESENT_STATE_RD;
			end if;
		  else
			I_PRESENT_STATE_RD <= IDLE;
		  end if;
		-- READ_FROM_FIFO - the data is being read from fifo until fifo is empty
		when READ_FROM_FIFO =>
		  if (RD_ENABLE = '1') then
			if (FIFO_EMPTY_ACK = '1') then	-- Is fifo empty?
				I_PRESENT_STATE_RD <= FIFO_EMPTY;
			else 
				I_PRESENT_STATE_RD <= I_PRESENT_STATE_RD;
			end if;
		  else
			I_PRESENT_STATE_RD <= IDLE;
		  end if;
		-- FIFO_EMPTY - the fifo is empty and available to start to write
		when FIFO_EMPTY =>
		  if (RD_ENABLE = '1') then
			if (START_WRITE='1') then	-- Is FIFO ready to write?
				I_PRESENT_STATE_RD <= IDLE;
			else 
				I_PRESENT_STATE_RD <= I_PRESENT_STATE_RD;
			end if;
		  else
			I_PRESENT_STATE_RD <= IDLE;
		  end if;
		-- others: currently unused states
		when others =>
			null;
		end case;
	end if;
end process RD_FIFO_CRTL_SM;

FIFO_read_Ena_proc: process (RESET,READ_CLOCK)
begin
	if (RESET = '1') then
		I_FIFO_READ_ENABLE <= '0';
	elsif (rising_edge (READ_CLOCK)) then
		if (I_PRESENT_STATE_RD = READ_FROM_FIFO) then	
			I_FIFO_READ_ENABLE <= '1';
		else 
			I_FIFO_READ_ENABLE <= '0';
		end if;
	end if;
end process FIFO_read_Ena_proc;

FIFO_READ_ENABLE <= I_FIFO_READ_ENABLE;

end RTL;
