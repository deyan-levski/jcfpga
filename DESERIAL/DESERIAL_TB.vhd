----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:22:33 09/15/2016 
-- Design Name: 
-- Module Name:    DESERIAL_TB - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DESERIAL_TB is
    Port ( CLOCK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
    	   RESET_DIGIF : in STD_LOGIC;
    	   DATA_PAR_CLK : inout STD_LOGIC;
           DATA_PAR : out  STD_LOGIC_VECTOR (11 downto 0));

end DESERIAL_TB;

architecture Behavioral of DESERIAL_TB is

	component DIGIF is

	   port ( 
	   d_digif_sck 		: in  STD_LOGIC;
           d_digif_rst		: in  STD_LOGIC;
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

--	signal d_digif_sck	: STD_LOGIC;
--	signal d_digif_rst	: STD_LOGIC;
	signal d_digif_msb_data : STD_LOGIC;
	signal d_digif_lsb_data : STD_LOGIC;
	signal CLOCK_90		: STD_LOGIC;
	signal RESET_DIGIF_SYNCED : STD_LOGIC;

begin

--|----------------------------------------|
--| Instantiate DIGIF temporarily for test |
--|----------------------------------------|

	DIGIF_INST: DIGIF
	port map (
	   d_digif_sck 		=> CLOCK, -- d_digif_sck,
           d_digif_rst		=> RESET_DIGIF_SYNCED, -- d_digif_rst,
           d_digif_msb_data 	=> d_digif_msb_data,
           d_digif_lsb_data 	=> d_digif_lsb_data
	);

	DESERIAL_INST: DESERIAL
	port map (
	   CLOCK 		=> CLOCK_90, 
           RESET 		=> RESET,
	   d_digif_rst		=> RESET_DIGIF_SYNCED,
           d_digif_msb_data 	=> d_digif_msb_data,
           d_digif_lsb_data 	=> d_digif_lsb_data,
	   DESERIALIZED_DATA_CLK => DATA_PAR_CLK,
           DESERIALIZED_DATA 	=> DATA_PAR
	);

 	rstsync : process (CLOCK)
 	begin
 		if rising_edge(CLOCK) then
 			RESET_DIGIF_SYNCED <= RESET_DIGIF;
 		end if;
 	end process;

	CLOCK_90 <= CLOCK after 1 ns;  -- MANUAL 90deg PHASE SHIFT (Tclk = 4ns)
end Behavioral;

