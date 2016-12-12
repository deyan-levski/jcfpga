--|------------------------------------------------------------------------------------|
--| ADC Testchip SPI Driver                                                            |
--|------------------------------------------------------------------------------------|
--| Version P1A - Initial version, Deyan Levski, deyan.levski@eng.ox.ac.uk, 07.09.2016 |
--|------------------------------------------------------------------------------------|
--
--
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity SREG_CORE is

    Port ( CLOCK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           SPI_SEN : inout  STD_LOGIC;
           SPI_DATA : in STD_LOGIC_VECTOR(95 downto 0);
    	   SPI_DATA_LOAD : in STD_LOGIC;
           SPI_SCK : inout  STD_LOGIC;
           SPI_SDA : inout  STD_LOGIC);
end SREG_CORE;

architecture Behavioral of SREG_CORE is

	-- intermediate signals
	signal CLOCK_DIV_REG : std_logic_vector(19 downto 0);
	signal CLOCK_DIV : std_logic;

	signal SPI_DATA_TX :std_logic_vector(96 downto 0); --:= "00000001";
	signal SPI_MASTER_RESET :std_logic;

	signal SPI_SCK_IN : std_logic;
	signal SPI_MASTER_RESET_IN : std_logic;

begin

--|-------------------|
--| SPI CLOCK DIVIDER |
--|-------------------|

	clockdiv : process (CLOCK, RESET)		-- spi clock divider from main freerunning clock / 100 MHz
	
	begin
		if RESET = '1' then
			CLOCK_DIV_REG <= (others => '0');
		elsif (CLOCK'event AND CLOCK = '1') then
			CLOCK_DIV_REG <= CLOCK_DIV_REG + 1;
		end if;
	end process;  
	
	CLOCK_DIV <= CLOCK_DIV_REG(16);	-- set clock prescaler here

--|-------------------------|
--| SPI_SCK CLOCK GENERATOR |
--|-------------------------|

	spiclkgen:	process(CLOCK_DIV)  -- spi clock generator based on the size of the register

	variable sck_counter :integer range 0 to 255 := 0; -- 8-bit register
	variable stop_overflow_flag :integer range 0 to 1 := 0;

	begin

	if (CLOCK_DIV'event AND CLOCK_DIV = '0') then

		if RESET ='1' then

			SPI_SCK <= '0';
			SPI_SEN <= '0';
			sck_counter := 0;
			stop_overflow_flag := 0;
		
		elsif SPI_DATA_LOAD = '0' then

			SPI_SCK <= '0';
			SPI_SEN <= '0';
			sck_counter := 0;
			stop_overflow_flag := 0;

		elsif SPI_DATA_LOAD = '1' and stop_overflow_flag = 0 then

			sck_counter := sck_counter + 1;

			if (sck_counter < (192 + 2)) then -- +2 because we clock data is delayed with one clock cycle (two edges)

			SPI_SCK <= not SPI_SCK;

			end if;

			if (sck_counter = (192 + 2 + 2)) then -- +2 +2 so that d_spi_sen signal is issues a bit later

			SPI_SEN <= '1';

			end if;

			if (sck_counter = (192 +2 +2 +2)) then -- toggle back d_spi_sen so it has low level again (close gates of latches in SREG)

			SPI_SEN <= '0';
			stop_overflow_flag := 1;

			end if;

		end if;

     	end if;

end process;

--|-----------------------------|
--| SPI_SDA MASTER TRANSMISSION |
--|-----------------------------|

	SPI_MASTER_RESET <= RESET or (not SPI_DATA_LOAD);
--	
--	   BUFG_MASTER_RESET : BUFG
--	   port map (
--	      O => SPI_MASTER_RESET_IN, -- 1-bit output: Clock buffer output
--	      I => SPI_MASTER_RESET  -- 1-bit input: Clock buffer input
--	   );
--	
--	
	   BUFG_SPI_SCK : BUFG
	   port map (
	      O => SPI_SCK_IN, -- 1-bit output: Clock buffer output
	      I => SPI_SCK  -- 1-bit input: Clock buffer input
	   );


	spimaster:	process(SPI_SCK_IN, SPI_MASTER_RESET) -- spi master ; data generator
	
	--variable SPI_DATA_TX :std_logic_vector(95 downto 0); --:= "00000001";
	
	begin
	
	
	if SPI_MASTER_RESET = '1' then
	
		SPI_DATA_TX(96 downto 0) <= '0' & SPI_DATA;
	
	elsif(SPI_SCK_IN'event AND SPI_SCK_IN = '0') then
	
		SPI_DATA_TX(96 downto 1) <= SPI_DATA_TX(95 downto 0);
	
	end if;
end process;

--	spimaster:	process(CLOCK, SPI_MASTER_RESET) -- spi master ; data generator
--	
--	--variable SPI_DATA_TX :std_logic_vector(95 downto 0); --:= "00000001";
--	
--	begin
--	
--		if SPI_MASTER_RESET = '1' then
--	
--			SPI_DATA_TX(96 downto 0) <= '0' & SPI_DATA;
--	
--		elsif rising_edge(CLOCK) then	
--	
--			if(SPI_SCK = '1' AND SPI_SCK_OLD = '0') then
--		
--				SPI_DATA_TX(96 downto 1) <= SPI_DATA_TX(95 downto 0);
--		
--			end if;
--	
--		SPI_SCK_OLD <= SPI_SCK;
--	
--		end if;

--	end process;

SPI_SDA <= SPI_DATA_TX(96);

end Behavioral;
