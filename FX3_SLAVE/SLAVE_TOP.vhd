-- |----------------------------------------------------------------------------|
-- | FX3 SLAVE TOP MODULE                                                       |
-- | -------------------------------------------------------------------------- |
-- | Initial Version P1A, Deyan Levski, deyan.levski@eng.ox.ac.uk, 29.09.2016   |
-- |----------------------------------------------------------------------------|
-- |-+-|



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SLAVE_TOP is

generic
(
	SLIDE_BITS : natural := 3;
	ADDRESS_BITS : natural := 2;
	DATA_BITS : natural := 16;
	PMODE_BITS : natural := 2;
	LCD_BITS : natural := 4
);

port
(
	clock : in std_logic; 			-- input 100 MHz onboard clock
	clock100_out : out std_logic; 		-- output 100 MHz clock to FX3 (PCLK)

	reset_from_slide : in std_logic;	-- RESET button on board
--	reset_from_fx3 : in std_logic; 		-- input reset FIFO from FX3 (INT_N_CTL15)
--	reset_to_fx3 : out std_logic; 		-- reset to fx3
	
	slide_select_mode : in std_logic_vector(SLIDE_BITS-1 downto 0):= "000";		-- select mode (idle, stream, loop)
    	led_buffer_empty_show : out std_logic:= '0'; 					-- show FIFO state - empty or not

	address : out std_logic_vector(ADDRESS_BITS-1 downto 0):="00"; 			-- 2-bit address bus (A)
	data : inout std_logic_vector(DATA_BITS-1 downto 0) :="0000000000000000"; 	-- 16-bit data bus (DQ)
	pktend : out std_logic; 							-- always '1'
	--pmode : out std_logic_vector(PMODE_BITS-1 downto 0) :="11"; 			-- always "11"

	slcs : out std_logic; -- chip select
	slwr : out std_logic; -- write strobe
	slrd : out std_logic; -- read strobe
	sloe : out std_logic; -- output enable

	flaga : in std_logic; -- write to fx3
	flagb : in std_logic -- write to fx3
); 
end SLAVE_TOP;

----------------------------------------------------------------------------------
-- Architecture
----------------------------------------------------------------------------------

architecture Behavioral of SLAVE_TOP is
	
----------------------------------------------------------------------------------
-- FPGA Master-Mode Finished State Machine
----------------------------------------------------------------------------------
type fpga_master_states is 
(
	idle_state, 
	loopback_state, 
	stream_read_from_fx3_state, 
	stream_write_to_fx3_state
);
signal current_state : fpga_master_states:=idle_state;
signal next_state : fpga_master_states:=idle_state;
signal current_mode : std_logic_vector(2 downto 0):="111";
----------------------------------------------------------------------------------
-- Constants
----------------------------------------------------------------------------------
constant MASTER_IDLE : std_logic_vector(2 downto 0):="111";
constant LOOPBACK : std_logic_vector(2 downto 0):="001";
constant STREAM_OUT : std_logic_vector(2 downto 0):="010";
constant STREAM_IN : std_logic_vector(2 downto 0):="100";

constant DATA_BIT : natural := 16;
----------------------------------------------------------------------------------
-- General Signals
----------------------------------------------------------------------------------
signal clock100 : std_logic;
signal reset_fpga : std_logic:='0';
signal address_get : std_logic_vector(1 downto 0);
signal pktend_get : std_logic;
signal slwr_get : std_logic;
signal sloe_get : std_logic;
signal slrd_get : std_logic;
signal slcs_get : std_logic;
signal flaga_get : std_logic;
signal flagb_get : std_logic;
signal data_in_get : std_logic_vector(DATA_BIT-1 downto 0);
signal data_out_get : std_logic_vector(DATA_BIT-1 downto 0);
signal data_out_get2 : std_logic_vector(DATA_BIT-1 downto 0);
----------------------------------------------------------------------------------
-- Stream In Signals
----------------------------------------------------------------------------------
signal stream_in_mode_active: std_logic;
signal data_stream_in : std_logic_vector(DATA_BIT-1 downto 0):="1111000011110000";
signal slwr_stream_in: std_logic;
----------------------------------------------------------------------------------
-- Stream Out Signals
----------------------------------------------------------------------------------
signal stream_out_mode_active: std_logic;
signal data_stream_out : std_logic_vector(DATA_BIT-1 downto 0):="1111000011110000";
signal data_stream_out_to_show : std_logic_vector(DATA_BIT-1 downto 0):="1111000011110000";
signal sloe_stream_out : std_logic;
signal slrd_stream_out : std_logic;
----------------------------------------------------------------------------------
-- Components
----------------------------------------------------------------------------------
component slave_fifo_stream_write_to_fx3 port 
(
	clock100 : in std_logic;
	flaga_get : in std_logic;
	flagb_get : in std_logic;
	reset : in std_logic;
	stream_in_mode_active : in std_logic;
	slwr_stream_in : out std_logic;
	data_stream_in : out std_logic_vector(DATA_BIT-1 downto 0)
); end component;
----------------------------------------------------------------------------------
-- Main code begin
----------------------------------------------------------------------------------	
begin
----------------------------------------------------------------------------------
-- Port Maps
----------------------------------------------------------------------------------
inst_stream_write_to_fx3 : slave_fifo_stream_write_to_fx3 port map
(
	clock100 => clock100,
	flaga_get => flaga_get,
	flagb_get => flagb_get,
	reset => not reset_fpga,
	stream_in_mode_active => stream_in_mode_active,
	slwr_stream_in => slwr_stream_in,
	data_stream_in => data_stream_in
);
----------------------------------------------------------------------------------
-- General Signals
----------------------------------------------------------------------------------
clock100 <= clock;
clock100_out <= clock100;
reset_fpga <= reset_from_slide;

--reset_to_fx3 <= '1';
--pmode <= "11";
pktend_get <= '1';
----------------------------------------------------------------------------------
-- FPGA Send All Signals
----------------------------------------------------------------------------------
process (reset_fpga, current_state) begin
	if reset_fpga = '1' then
		address <= "11";
    	slwr <= '1';
    	slcs <= '1';
		slrd <= '1';
		sloe <= '1';
		pktend <= '1';
    elsif (rising_edge(clock100)) then
    	address <= address_get;
    	slwr <= slwr_get;
    	slcs <= slcs_get;
		slrd <= slrd_get;
		sloe <= sloe_get;
		pktend <= pktend_get;
    end if;
end process;
----------------------------------------------------------------------------------
-- Get Output Data
----------------------------------------------------------------------------------
process (current_state) begin
	if current_state = stream_write_to_fx3_state then
		data_out_get <= data_stream_in;
	else 
		data_out_get <= (others => '0');
    end if;
end process;
----------------------------------------------------------------------------------
-- Send Output Data 2
----------------------------------------------------------------------------------
process (reset_fpga, clock100) begin
	if reset_fpga = '1' then
		data_out_get2 <= (others => '0');
    elsif (rising_edge(clock100)) then
		data_out_get2 <= data_out_get;
    end if;
end process;
----------------------------------------------------------------------------------
-- Send Output Data 3
----------------------------------------------------------------------------------
process (slwr_get) begin
    if (slwr_get = '0') then
		data <= data_out_get2;
	else 
		data <= (others => 'Z');
    end if;
end process;
----------------------------------------------------------------------------------
-- Get Current Flag Signal
----------------------------------------------------------------------------------
process (reset_fpga, clock100) begin
	if reset_fpga = '1' then
		flaga_get <= '0';
		flagb_get <= '0';
    elsif (rising_edge(clock100)) then
		flaga_get <= flaga;
    	flagb_get <= flagb;
    end if;
end process;
----------------------------------------------------------------------------------
-- Get Loopback, Stream Out, Stream In Mode Active Signals
----------------------------------------------------------------------------------
process (current_state) begin
-- 	if current_state = loopback_state then
-- 		loopback_mode_active <= '1';
-- 	else 
-- 		loopback_mode_active <= '0';
-- 	end if;
-- 	if current_state = stream_read_from_fx3_state then
-- 		stream_out_mode_active <= '1';
-- 	else 
-- 		stream_out_mode_active <= '0';
-- 	end if;
	if current_state = stream_write_to_fx3_state then
		stream_in_mode_active <= '1';
	else 
		stream_in_mode_active <= '0';
	end if;
end process;
----------------------------------------------------------------------------------
-- Get Output/Enable, Read/Write and Write Signals
----------------------------------------------------------------------------------
process (current_state) begin
	if current_state = stream_write_to_fx3_state then
		slcs_get <= '0';
		sloe_get <= '1';
		slrd_get <= '1';
		slwr_get <= slwr_stream_in;
-- 	elsif current_state = stream_read_from_fx3_state then
-- 		slcs_get <= '0';
-- 		sloe_get <= sloe_stream_out;
-- 		slrd_get <= slrd_stream_out;
-- 		slwr_get <= '1';
-- 	elsif current_state = loopback_state then
-- 		slcs_get <= '0';
-- 		sloe_get <= sloe_loopback;
-- 		slrd_get <= slrd_loopback;
-- 		slwr_get <= slwr_loopback;
	else
		slcs_get <= '1';
		sloe_get <= '1';
		slrd_get <= '1';
		slwr_get <= '1';
	end if;
end process;
----------------------------------------------------------------------------------
-- Get Address Signals
----------------------------------------------------------------------------------
-- process (current_state, loopback_address) begin
-- 	if (current_state = stream_read_from_fx3_state) or (loopback_address = '1') then
-- 		address_get <= "11";
-- 	else	
-- 		address_get <= "00";
-- 	end if;
-- end process;
----------------------------------------------------------------------------------
-- FPGA Master-Mode Change State and Select Mode from Slide Switches
----------------------------------------------------------------------------------
process (clock100, reset_fpga) begin
    if (reset_fpga = '1')  then
        current_state <= idle_state;
        current_mode <= MASTER_IDLE;
-- 		lcd_text_line1 <= "FSM FPGA        ";
-- 		lcd_text_line2 <= "MODE: RESET     ";
    elsif (rising_edge(clock100)) then
        current_state <= next_state;
        current_mode <= slide_select_mode;
    end if;
end process;
----------------------------------------------------------------------------------
-- FPGA State Machine
----------------------------------------------------------------------------------
process(current_state, current_mode) begin
   	next_state <= current_state;
    case current_state is
        when idle_state =>
--             if current_mode = LOOPBACK then
--                 next_state <= loopback_state;
            if current_mode = STREAM_OUT then 
                next_state <= stream_read_from_fx3_state;
--             elsif current_mode = STREAM_IN then 
--                 next_state <= stream_write_to_fx3_state;
            else 
                next_state <= idle_state;
            end if;
--         when loopback_state => 
--             if current_mode /= LOOPBACK then
--                 next_state <= idle_state;
--             end if;
--         when stream_read_from_fx3_state => 
--             if current_mode /= STREAM_OUT then
--                 next_state <= idle_state;
--             end if;
        when stream_write_to_fx3_state =>
           if current_mode /= STREAM_IN then
                next_state <= idle_state;
            end if;
        when others => 
            next_state <= idle_state;
    end case;
end process;
----------------------------------------------------------------------------------
-- End Architecture
----------------------------------------------------------------------------------
end Behavioral;

