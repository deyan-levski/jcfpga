--|--------------------------------------------------------------------------------------------------------|
--| ADC Testchip SREG control module:                                                                      |
--|--------------------------------------------------------------------------------------------------------|
--| Receives register data over UART, converts and retranslates back to ADC Teschip's custom SPI register. |
--| Control word structure: 0xAA - resets the SREG module (start byte) followed by 12 bytes SPI data       |
--| Example:                                                                                               |
--| 0xAA010f037623F15f5a6c7c2e31                                                                           |
--|--------------------------------------------------------------------------------------------------------|
--| Version P1A, Author: Deyan Levski, deyan.levski@eng.ox.ac.uk, 07.09.2016                               |
--|--------------------------------------------------------------------------------------------------------|
--|-+-|
--
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SREG_CONTROL is
    Port ( RX      : in  STD_LOGIC;
           TX      : out STD_LOGIC;
           CLOCK   : in  STD_LOGIC;
           RESET   : in  STD_LOGIC;
           SPI_SEN : inout  STD_LOGIC;
           SPI_SCK : inout  STD_LOGIC;
           SPI_SDA : inout  STD_LOGIC;

    	   DEBUG_PIN : out STD_LOGIC
);
end SREG_CONTROL;

architecture Behavioral of SREG_CONTROL is

	component T_SERIAL is
		port (
		uart_clk: in STD_LOGIC; -- 100 MHz system clock
		uart_rst: in STD_LOGIC;

		data_rx: out STD_LOGIC_VECTOR(7 downto 0);
		uart_rx: in STD_LOGIC;
		uart_tx: out STD_LOGIC;

		ack_flag: out STD_LOGIC -- all is okay
	);
	end component;

	component SREG_CORE is

		port (
		CLOCK 		: in  STD_LOGIC;
		RESET 		: in  STD_LOGIC;
		SPI_SEN 	: inout  STD_LOGIC;
		SPI_DATA 	: in  STD_LOGIC_VECTOR(95 downto 0);
		SPI_DATA_LOAD 	: in STD_LOGIC;
		SPI_SCK 	: inout  STD_LOGIC;
		SPI_SDA 	: inout  STD_LOGIC
	);

	end component;

	signal SPI_DATA_BUFFER : std_logic_vector(95 downto 0);
	signal SPI_FLUSH : STD_LOGIC;
	signal SPI_DATA : STD_LOGIC_VECTOR(95 downto 0);
	signal RX_WORD : STD_LOGIC_VECTOR(7 downto 0);
	signal RX_ACK  : STD_LOGIC;

begin

--|--------------------------------|
--| Instantiating SREG_CORE Driver |
--|--------------------------------|

	SREG_CORE_INST: SREG_CORE
	port map (
		CLOCK => CLOCK,
		RESET => RESET,
		SPI_SEN => SPI_SEN,
		SPI_DATA => SPI_DATA,
		SPI_SCK => SPI_SCK,
		SPI_SDA => SPI_SDA,
		SPI_DATA_LOAD => SPI_FLUSH
	);

--|---------------------------|
--| Instantiating UART Module |
--|---------------------------|

	T_SERIAL_INST: T_SERIAL
	port map (
		uart_clk => CLOCK,
		uart_rst => RESET,
		data_rx  => RX_WORD,
		uart_rx  => RX,
		uart_tx  => TX,
		ack_flag => RX_ACK
	);

--|-----------------------------------|
--| Interface b/w UART and SPI Driver |
--|-----------------------------------|

	flushproecss : process (CLOCK)
	variable WORD_COUNTER : integer range 0 to 15;
	begin
	
	
	if (CLOCK'event and CLOCK = '1') then


		if RESET = '1' then
			SPI_DATA_BUFFER <= (others => '0');
			SPI_FLUSH <= '0';
			WORD_COUNTER := 0;
	
		elsif (RX_ACK'event and RX_ACK = '1') then
	
			SPI_DATA_BUFFER(87 downto 0) <= SPI_DATA_BUFFER(95 downto 8);
			SPI_DATA_BUFFER(95 downto 88) <= RX_WORD(7 downto 0);

			WORD_COUNTER := WORD_COUNTER + 1;
		end if;

		if WORD_COUNTER = 12 then
			SPI_FLUSH <= '1';
		end if;

		if RX_WORD = "10101010" then    -- reset word: 0xAA
		SPI_FLUSH <= '0';
		SPI_DATA_BUFFER <= (others => '0');
		SPI_FLUSH <= '0';
		WORD_COUNTER := 0;
		end if;

	end if;

			SPI_DATA  <= SPI_DATA_BUFFER;

	end process;

DEBUG_PIN <= SPI_FLUSH;

end Behavioral;

