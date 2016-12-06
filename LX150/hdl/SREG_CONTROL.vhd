--|------------------------------------------------------------------------------------------------|
--| ADC Testchip SREG + RAM control module. Includes VDAC SPI master                               |
--|------------------------------------------------------------------------------------------------|
--| Receives register data over UART, retranslates back to ADC Teschip's custom SPI register.      |
--| Control word structure: 0xAA - resets the SREG module (start byte) followed by 17byts SPI data |
--| Example:                                                                                       |
--| 0xaa00104988020a04204c0444460000010301                                                         |
--| --                                                                                             |
--| RAM load structure example:                                                                    |
--| RAM start bytes: 0xAE 0xAE (two bytes required) before loading RAM data                        |
--| RAM data: (byte0 byte1 byte2 byte3) = 32 bits = word 1                                         |
--| (byte4 byte5 byte6 byte7) = 32 bits = word 2                                                   |
--| Current RAM size is 1080 x 32, hence a total of 4320 words required to be sent                 |
--| After full RAM content transfer, end transmission with 0xAF                                    |
--| Obviously, make sure word content of RAM doesn't match 0xAA, 0xAE or 0xAF                      |
--| Else: transmission will end prematurely                                                        |
--|------------------------------------------------------------------------------------------------|
--| Future TODO:                                                                                   |
--| 1) Use dual/triple start/stop words to ensure robust RAM transfer                              |
--| 2) Or, implement lock state blacking out start/stop words, once transmission is running        |
--| 3) Make module generic                                                                         |
--|------------------------------------------------------------------------------------------------|
--|------------------------------------------------------------------------------------------------|
--| Version P1A, Author: Deyan Levski, deyan.levski@eng.ox.ac.uk, 07.09.2016                       |
--|------------------------------------------------------------------------------------------------|
--| Version A, Added VDAC SPI master, dl, 07.10.2016                                               |
--|------------------------------------------------------------------------------------------------|
--| Version B, Added RAM load functionality, dl, 30.11.2016                                        |
--|------------------------------------------------------------------------------------------------|
--|-+-|
----
----

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

    	   DEBUG_PIN : out STD_LOGIC;
	   DEBUG_PIN2: out STD_LOGIC
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

		ack_flag: out STD_LOGIC -- all is okay (transmission/reception done)
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
		SPI_DATA 	: in  STD_LOGIC_VECTOR(31 downto 0);	-- SPI data
		CSEL_I 		: in  STD_LOGIC;		    	-- low load DAC_A; high DAC_B
		SPI_DATA_LOAD 	: in STD_LOGIC;			    	-- Load SPI data
		SPI_SCK 	: inout  STD_LOGIC;		    	-- SPI clock
		SPI_SDA 	: inout  STD_LOGIC;		    	-- SPI data
		SYNC_DAC_A 	: out  STD_LOGIC;		    	-- controlled by CSEL_I
		SYNC_DAC_B 	: out  STD_LOGIC);		    	-- controlled by CSEL_I
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
	
--		elsif RX_ACK = '1' and RX_ACK_OLD = '0' then
		elsif (RX_ACK'event and RX_ACK = '1') then
			if MEM_FLAG = '0' then
			SPI_DATA_BUFFER(127 downto 0) <= SPI_DATA_BUFFER(135 downto 8);
			SPI_DATA_BUFFER(135 downto 128) <= RX_WORD(7 downto 0);
			else
			MEM_DATA_BUFFER(23 downto 0) <= MEM_DATA_BUFFER(31 downto 8);
			MEM_DATA_BUFFER(31 downto 24) <= RX_WORD(7 downto 0);
			end if;
			WORD_COUNTER := WORD_COUNTER + 1;
			INC_MEM_ADD <= '0';
		end if;

		RX_ACK_OLD <= RX_ACK;

		if (WORD_COUNTER = 5) then

			if MEM_FLAG = '1' then
			-- swapping correct data bit order
			MEM_DATA(31) <= MEM_DATA_BUFFER(7);
			MEM_DATA(30) <= MEM_DATA_BUFFER(6);
			MEM_DATA(29) <= MEM_DATA_BUFFER(5);
			MEM_DATA(28) <= MEM_DATA_BUFFER(4);
			MEM_DATA(27) <= MEM_DATA_BUFFER(3);
			MEM_DATA(26) <= MEM_DATA_BUFFER(2);
			MEM_DATA(25) <= MEM_DATA_BUFFER(1);
			MEM_DATA(24) <= MEM_DATA_BUFFER(0);
			MEM_DATA(23) <= MEM_DATA_BUFFER(15);
			MEM_DATA(22) <= MEM_DATA_BUFFER(14);
			MEM_DATA(21) <= MEM_DATA_BUFFER(13);
			MEM_DATA(20) <= MEM_DATA_BUFFER(12);
			MEM_DATA(19) <= MEM_DATA_BUFFER(11);
			MEM_DATA(18) <= MEM_DATA_BUFFER(10);
			MEM_DATA(17) <= MEM_DATA_BUFFER(9);
			MEM_DATA(16) <= MEM_DATA_BUFFER(8);
			MEM_DATA(15) <= MEM_DATA_BUFFER(23);
			MEM_DATA(14) <= MEM_DATA_BUFFER(22);
			MEM_DATA(13) <= MEM_DATA_BUFFER(21);
			MEM_DATA(12) <= MEM_DATA_BUFFER(20);
			MEM_DATA(11) <= MEM_DATA_BUFFER(19);
			MEM_DATA(10) <= MEM_DATA_BUFFER(18);
			MEM_DATA(9) <= MEM_DATA_BUFFER(17);
			MEM_DATA(8) <= MEM_DATA_BUFFER(16);
			MEM_DATA(7) <= MEM_DATA_BUFFER(31);
			MEM_DATA(6) <= MEM_DATA_BUFFER(30);
			MEM_DATA(5) <= MEM_DATA_BUFFER(29);
			MEM_DATA(4) <= MEM_DATA_BUFFER(28);
			MEM_DATA(3) <= MEM_DATA_BUFFER(27);
			MEM_DATA(2) <= MEM_DATA_BUFFER(26);
			MEM_DATA(1) <= MEM_DATA_BUFFER(25);
			MEM_DATA(0) <= MEM_DATA_BUFFER(24);
			INC_MEM_ADD <= '1';
			WORD_COUNTER := 1;
			end if;

		elsif (WORD_COUNTER = 17) then	-- (SREG load stops on the 17th word)

			if MEM_FLAG = '0' then
			SPI_FLUSH <= '1';	-- flush SREG flags
			SPI_DAC_FLUSH <= '1';
			end if;

		end if;

		if RX_WORD = "10101010" then    -- reset word: 0xAA (for SREG load)
						-- note: two reset word sending needed for
						-- correct address 0 RAM write

			SPI_DATA_BUFFER <= (others => '0');
			SPI_FLUSH <= '0';
			SPI_DAC_FLUSH <= '0';
			WORD_COUNTER := 0;

			MEM_FLAG <= '0';
			INC_MEM_ADD <= '0';

		elsif RX_WORD = "10101110" then	-- reset word: 0xAE (for RAM load)

			MEM_DATA_BUFFER <= (others => '0');
			MEM_FLAG <= '1';
			INC_MEM_ADD <= '0';
			WORD_COUNTER := 0;

		elsif RX_WORD = "10101111" then	-- stop word: 0xAF (for RAM load)

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

DEBUG_PIN <= INC_MEM_ADD; --RX_ACK;--SPI_FLUSH;
DEBUG_PIN2 <= CSEL_I; --MEM_FLAG;

end Behavioral;
