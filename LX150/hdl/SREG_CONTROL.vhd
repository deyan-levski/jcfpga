-- |--------------------------------------------------------------------------------------------------------|
-- | ADC Testchip SREG control module. Includes VDAC SPI master                                             |
-- |--------------------------------------------------------------------------------------------------------|
-- | Receives register data over UART, converts and retranslates back to ADC Teschip's custom SPI register. |
-- | Control word structure: 0xAA - resets the SREG module (start byte) followed by 12 bytes SPI data       |
-- | Example:                                                                                               |
-- | 0xAA010f037623F15f5a6c7c2e31                                                                           |
-- |--------------------------------------------------------------------------------------------------------|
-- | Version P1A, Author: Deyan Levski, deyan.levski@eng.ox.ac.uk, 07.09.2016                               |
-- |--------------------------------------------------------------------------------------------------------|
-- | Version A, Added VDAC SPI master, dl, 07.10.2016                                                       |
-- |--------------------------------------------------------------------------------------------------------|
-- |-+-|
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
	   SPI_DAC_SCK : inout STD_LOGIC;
	   SPI_DAC_SDA : inout STD_LOGIC;
	   SPI_DAC_A_SYNC : inout STD_LOGIC;
	   SPI_DAC_B_SYNC : inout STD_LOGIC;
	   
    	   MEM_FLAG : inout STD_LOGIC;
    	   MEM_DATA : inout STD_LOGIC_VECTOR(31 downto 0);
    	   INC_MEM_ADD : inout STD_LOGIC;

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

	component SPI_CORE is
		port ( 
		CLOCK 		: in  STD_LOGIC;
		RESET 		: in  STD_LOGIC;
		SPI_DATA 	: in  STD_LOGIC_VECTOR(31 downto 0);		-- SPI data
		CSEL_I 		: in  STD_LOGIC;				-- low load DAC_A; high DAC_B
		SPI_DATA_LOAD 	: in STD_LOGIC;					-- Load SPI data
		SPI_SCK 	: inout  STD_LOGIC;				-- SPI clock
		SPI_SDA 	: inout  STD_LOGIC;				-- SPI data
		SYNC_DAC_A 	: out  STD_LOGIC;				-- controlled by CSEL_I
		SYNC_DAC_B 	: out  STD_LOGIC);				-- controlled by CSEL_I
	end component;

	signal SPI_DATA_BUFFER : std_logic_vector(135 downto 0);
	signal SPI_FLUSH : STD_LOGIC;
	signal SPI_DAC_FLUSH : STD_LOGIC;
	signal SPI_DATA : STD_LOGIC_VECTOR(95 downto 0);
	signal SPI_DAC_DATA : STD_LOGIC_VECTOR(31 downto 0);
	signal CSEL_I : STD_LOGIC;
	signal INT_CONTROL_WORD : STD_LOGIC_VECTOR(7 downto 0);
	signal RX_WORD : STD_LOGIC_VECTOR(7 downto 0);
	signal RX_ACK  : STD_LOGIC;
	signal RX_ACK_OLD : STD_LOGIC;

	signal MEM_DATA_BUFFER : STD_LOGIC_VECTOR(31 downto 0);

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

--|-----------------------------------|
--| Instantiating SPI_CORE DAC Driver |
--|-----------------------------------|

	SPI_CORE_INST: SPI_CORE
	port map (
		CLOCK => CLOCK,
		RESET => RESET,
		SPI_DATA => SPI_DAC_DATA,	-- SPI data
		CSEL_I => CSEL_I,		-- low load DAC_A; high DAC_B
		SPI_DATA_LOAD => SPI_DAC_FLUSH,	-- Load SPI data
		SPI_SCK    => SPI_DAC_SCK,	-- SPI clock
		SPI_SDA    => SPI_DAC_SDA,	-- SPI data
		SYNC_DAC_A => SPI_DAC_A_SYNC,	-- ship select DAC A
		SYNC_DAC_B => SPI_DAC_B_SYNC	-- chip select DAC B
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

--|------------------------------------|
--| Interface b/w UART and SPI Drivers |
--|------------------------------------|

	flushproecss : process (CLOCK)
	variable WORD_COUNTER : integer :=0;
	begin
	
	
	if (CLOCK'event and CLOCK = '1') then


		if RESET = '1' then
			SPI_DATA_BUFFER <= (others => '0');
			SPI_FLUSH <= '0';
			SPI_DAC_FLUSH <= '0';
			WORD_COUNTER := 0;

			MEM_DATA_BUFFER <= (others => '0');
			MEM_DATA <= (others => '0');
			MEM_FLAG <= '0';
			INC_MEM_ADD <= '0';
	
		elsif RX_ACK = '1' and RX_ACK_OLD = '0' then -- elsif (RX_ACK'event and RX_ACK = '1') then
	
			SPI_DATA_BUFFER(127 downto 0) <= SPI_DATA_BUFFER(135 downto 8);
			SPI_DATA_BUFFER(135 downto 128) <= RX_WORD(7 downto 0);
			
			MEM_DATA_BUFFER(23 downto 0) <= MEM_DATA_BUFFER(31 downto 8);
			MEM_DATA_BUFFER(31 downto 24) <= RX_WORD(7 downto 0);

			WORD_COUNTER := WORD_COUNTER + 1;
			INC_MEM_ADD <= '0';
		end if;

		RX_ACK_OLD <= RX_ACK;

		if (WORD_COUNTER = 17 and MEM_FLAG = '0') then
			SPI_FLUSH <= '1';
			SPI_DAC_FLUSH <= '1';
		end if;

		if (WORD_COUNTER = 5 and MEM_FLAG = '1') then
			MEM_DATA <= MEM_DATA_BUFFER;
			INC_MEM_ADD <= '1';
			WORD_COUNTER := 0;
		end if;

		if RX_WORD = "10101010" then    -- reset word: 0xAA
			SPI_DATA_BUFFER <= (others => '0');
			SPI_FLUSH <= '0';
			SPI_DAC_FLUSH <= '0';
			WORD_COUNTER := 0;

			MEM_FLAG <= '0';
			INC_MEM_ADD <= '0';
		end if;

		if RX_WORD = "10101110" then	-- reset word: 0xAE
			SPI_DATA_BUFFER <= (others => '0');
			SPI_FLUSH <= '0';
			SPI_DAC_FLUSH <= '0';

			MEM_DATA_BUFFER <= (others => '0');
			MEM_FLAG <= '1';
			INC_MEM_ADD <= '0';
			WORD_COUNTER := 0;

		end if;

		if RX_WORD = "10101111" then	-- stop word: 0xAF
			SPI_DATA_BUFFER <= (others => '0');
			SPI_FLUSH <= '0';
			SPI_DAC_FLUSH <= '0';

			MEM_DATA_BUFFER <= (others => '0');
			MEM_FLAG <= '0';
			INC_MEM_ADD <= '0';
			WORD_COUNTER := 0;
		end if;

	end if;

	end process;
		SPI_DATA  	 <= SPI_DATA_BUFFER(95 downto 0);
		SPI_DAC_DATA 	 <= SPI_DATA_BUFFER(127 downto 96);
		INT_CONTROL_WORD <= SPI_DATA_BUFFER(135 downto 128);

		CSEL_I <= INT_CONTROL_WORD(0); -- dac chip select tap


DEBUG_PIN <= SPI_FLUSH;

end Behavioral;
