----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:41:01 11/05/2016 
-- Design Name: 
-- Module Name:    ROMSEQ - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity ROMSEQ is
    Port ( CLOCK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           EN : in  STD_LOGIC;
           DOUT : out  STD_LOGIC_VECTOR (31 downto 0));
end ROMSEQ;

architecture Behavioral of ROMSEQ is
	component blockmem is
	  PORT (
	    clka : IN STD_LOGIC;
	    rsta : IN STD_LOGIC;
	    ena : IN STD_LOGIC;
	    addra : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	    douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	  );
	end component;
	signal MEM_ADDR : std_logic_vector(31 downto 0);
begin

	ROM0 : blockmem
	PORT MAP (
	    clka  => CLOCK,
	    rsta  => RESET,
	    ena   => EN,
	    addra => MEM_ADDR,
	    douta => DOUT
	);

		memaddcnt : process (CLOCK, RESET)

	begin
		if RESET = '1' then
			MEM_ADDR <= (others => '0');
		elsif (CLOCK'event AND CLOCK = '1') then
			MEM_ADDR <= MEM_ADDR + 1;
		end if;
	end process;  

end Behavioral;

