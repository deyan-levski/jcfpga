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
    	   MEM_FLAG : in STD_LOGIC;
    	   INC_MEM_ADD : in STD_LOGIC;
           MEMCLK : out  STD_LOGIC;
           MEMADDR : out  STD_LOGIC_VECTOR (31 downto 0));
end BLOCKMEM_CTRL;

architecture Behavioral of BLOCKMEM_CTRL is

	signal CLOCK_DIV_REG : std_logic_vector(10 downto 0);
	signal INC_MEM_ADD_PREV : std_logic;

begin

--|-------------------|
--| MEM CLOCK DIVIDER |
--|-------------------|

clockdiv : process (CLOCK, RESET)
variable clk_div_cnt : integer range 0 to 1080 := 0;
variable fst_entry : integer range 0 to 1 := 0;
begin
	if RESET = '1' then
		CLOCK_DIV_REG <= (others => '0');
		clk_div_cnt := 0;
	elsif (CLOCK'event AND CLOCK = '1') then
	if MEM_FLAG = '0' then
		if clk_div_cnt = 1079 then
		CLOCK_DIV_REG <= (others => '0');
		clk_div_cnt := 0;
		else
		CLOCK_DIV_REG <= CLOCK_DIV_REG + 1;
		clk_div_cnt := clk_div_cnt + 1;
		end if;
		fst_entry := 1;
	else
		if fst_entry = 1 then
			CLOCK_DIV_REG <= (others => '0');
			clk_div_cnt := 0;
			fst_entry := 0;
		end if;

		if INC_MEM_ADD = '1' and INC_MEM_ADD_PREV = '0' then
			if clk_div_cnt = 1080 then
			CLOCK_DIV_REG <= (others => '0');
			clk_div_cnt := 0;
			elsif clk_div_cnt = 0 then
			CLOCK_DIV_REG <= (others => '0');
			clk_div_cnt := clk_div_cnt + 1;
			else
			CLOCK_DIV_REG <= CLOCK_DIV_REG + 1;
			clk_div_cnt := clk_div_cnt + 1;
			end if;
		end if;
	end if;
	INC_MEM_ADD_PREV <= INC_MEM_ADD;
	end if;
end process;  

--MEMCLK <= not CLOCK_DIV_REG(0); --f/2
MEMCLK <= not CLOCK;
MEMADDR <= "0000000000000000000" & CLOCK_DIV_REG(10 downto 0) & "00"; -- LSHIFT due to blockmem bug?
--MEMADDR <= CLOCK_DIV_REG(31 downto 0);

end Behavioral;

