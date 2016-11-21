--|----------------------------------------------------|
--| BLOCKMEM Addressing module                         |
--|----------------------------------------------------|
--| Version A, Deyan Levski, deyan.levski@eng.ox.ac.uk |
--|----------------------------------------------------|
--|-+-|
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BLOCKMEM_CTRL is
    Port ( CLOCK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           MEMCLK : out  STD_LOGIC;
           MEMADDR : out  STD_LOGIC_VECTOR (31 downto 0));
end BLOCKMEM_CTRL;

architecture Behavioral of BLOCKMEM_CTRL is

	signal CLOCK_DIV_REG : std_logic_vector(9 downto 0);

begin

--|-------------------|
--| MEM CLOCK DIVIDER |
--|-------------------|

clockdiv : process (CLOCK, RESET)
variable clk_div_cnt : integer range 0 to 1280 := 0;
begin
	if RESET = '1' then
		CLOCK_DIV_REG <= (others => '0');
		clk_div_cnt := 0;
	elsif (CLOCK'event AND CLOCK = '1') then
		if clk_div_cnt = 1080 then
		CLOCK_DIV_REG <= (others => '0');
		clk_div_cnt := 0;
		else
		CLOCK_DIV_REG <= CLOCK_DIV_REG + 1;
		clk_div_cnt := clk_div_cnt + 1;
		end if;
	end if;
end process;  

--MEMCLK <= not CLOCK_DIV_REG(0); --f/2
MEMCLK <= not CLOCK;
MEMADDR <= "00000000000000000000" & CLOCK_DIV_REG(9 downto 0) & "00"; -- LSHIFT due to blockmem bug?
--MEMADDR <= CLOCK_DIV_REG(31 downto 0);

end Behavioral;

