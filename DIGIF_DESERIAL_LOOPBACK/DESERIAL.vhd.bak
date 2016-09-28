--|------------------------------------------------------------------|
--| ADC Testhip Data Deserializer Module                             |
--|------------------------------------------------------------------|
--| Version A, Deyan Levski, deyan.levski@eng.ox.ac.uk, 23.09.2016   |
--|------------------------------------------------------------------|
--|-+-|
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity DESERIAL is
    Port ( CLOCK : in  STD_LOGIC; -- also same as d_digif_sck
           RESET : in  STD_LOGIC; -- also same as d_digif_rst
    	   d_digif_rst	    : in  STD_LOGIC;
           d_digif_msb_data : in  STD_LOGIC;
           d_digif_lsb_data : in  STD_LOGIC;
	   DESERIALIZED_DATA_CLK : inout STD_LOGIC;
           DESERIALIZED_DATA : out  STD_LOGIC_VECTOR (11 downto 0));
end DESERIAL;

architecture Behavioral of DESERIAL is

	signal DESERIALIZED_DATA_INT		: STD_LOGIC_VECTOR (11 downto 0);	-- raw data going out of deserializer buffers
	signal DESERIALIZED_DATA_DEMUX		: STD_LOGIC_VECTOR (11 downto 0);	-- demuxed data from deserializer buffers based on rise/fall edge was first
	signal DESERIALIZED_DATA_DESHIFT	: STD_LOGIC_VECTOR (11 downto 0);	-- muxes DESHIFT_RISE and DESHIFT_FALL based on LOCK signal (LOCK_RISE or LOCK_FALL)
	signal DESERIALIZED_DATA_DESHIFT_RISE	: STD_LOGIC_VECTOR (11 downto 0);	-- rising edge data to be deshifted
	signal DESERIALIZED_DATA_DESHIFT_FALL	: STD_LOGIC_VECTOR (11 downto 0);	-- falling edge data to be deshifted
	signal DESERIALIZED_DATA_DESHIFTED	: STD_LOGIC_VECTOR (11 downto 0);	-- final output deshifted data

	signal PREAMBLE 			: STD_LOGIC_VECTOR (5 downto 0);	-- Decoding preamble (same as DIGIF)

	signal F_EDGE_FLAG : STD_LOGIC;							-- goes high when reset is encountered (high) on falling edge process	
	signal R_EDGE_FLAG : STD_LOGIC;							-- goes high when reset is encountered (high) on rising edge process

	signal DESERIALIZED_DATA_RE		: STD_LOGIC_VECTOR (11 downto 0);	-- strobed deshifted data on riseing edge of (DESERIALIZED_DATA_CLK)
	signal DESERIALIZED_DATA_FE		: STD_LOGIC_VECTOR (11 downto 0);	-- strobed deshifted data on falling edge of (DESERIALIZED_DATA_CLK)

	signal SHIFT				: STD_LOGIC_VECTOR (2 downto 0);	-- shift N-steps left (muxed SHIFT_RISE / SHIFT_FALL depending on LOCK_RISE or LOCK_FALL)
	signal SHIFT_RISE			: STD_LOGIC_VECTOR (2 downto 0);	-- SHIFT_RISE
	signal SHIFT_FALL			: STD_LOGIC_VECTOR (2 downto 0);	-- SHIFT_FALL
	signal LOCK				: STD_LOGIC;				-- final LOCK - implements (LOCK_RISE OR LOCK_FALL) logic function
	signal LOCK_RISE			: STD_LOGIC;				-- LOCK_RISE
	signal LOCK_FALL			: STD_LOGIC;				-- LOCK_FALL
	signal CLOCK_DIV			: STD_LOGIC;				-- toggled signal, then fed directly to DESERIALIZED_DATA_CLK

begin

	PREAMBLE <=  "110100"; --"001011"; -- mirrored check

--	|------------------------------------|
--	| RAW DESERIALIZATION ON RISING EDGE |
--	|------------------------------------|

deserialization_rising_edge : process(CLOCK, RESET)					-- deserialization on rising edge

	variable DESER_MSB_BUF_R		: STD_LOGIC_VECTOR (2 downto 0);	-- 3-bit MSB buffer
	variable DESER_LSB_BUF_R		: STD_LOGIC_VECTOR (2 downto 0);	-- 3-bit LSB buffer
	variable digif_rst_flag 		: STD_LOGIC;				-- used to detect rising edge of d_digif_rst (i.e. old version of d_digif_rst)

	begin
	if rising_edge(CLOCK) then
		
		if RESET = '1' then
			R_EDGE_FLAG <= '0';						-- reset flags			
			DESERIALIZED_DATA_INT(11) <= '0';
			DESERIALIZED_DATA_INT(9)  <= '0';
			DESERIALIZED_DATA_INT(7)  <= '0';
			DESERIALIZED_DATA_INT(5)  <= '0';
			DESERIALIZED_DATA_INT(3)  <= '0';
			DESERIALIZED_DATA_INT(1)  <= '0';
			DESER_MSB_BUF_R := "000";
			DESER_LSB_BUF_R := "000";
			digif_rst_flag := '0';
		else
			if F_EDGE_FLAG = '1' then					-- if reset was encountered high on falling edge process 
				R_EDGE_FLAG <= '0';					-- then rising edge encounter flag = '0'
			else								-- else reset was enountered high in this process (rising edge)
				R_EDGE_FLAG <= '1';					-- set rising edge encounter flag to '1'
			end if;

			DESER_MSB_BUF_R(2 downto 1) := DESER_MSB_BUF_R(1 downto 0);	-- shift
			DESER_MSB_BUF_R(0) := d_digif_msb_data;				-- load value from pin
			DESER_LSB_BUF_R(2 downto 1) := DESER_LSB_BUF_R(1 downto 0);
			DESER_LSB_BUF_R(0) := d_digif_lsb_data;				-- load value from pin
		
			if d_digif_rst = '1' and digif_rst_flag = '0' then		-- if rising edge of d_digif_rst
			DESER_MSB_BUF_R := "000";					-- reset buffers, otherwise preamble comparators toggle too early leading to wrong bit-shift values
			DESER_LSB_BUF_R := "000";
			digif_rst_flag := '1';						-- set flag back high so as to not step in this if-statement till the rest of the d_digif_rst = '1' period
			elsif d_digif_rst = '0' then					-- when d_digif_rst = '0' reset flag back to be ready for next rising edge
			digif_rst_flag := '0';
			end if;

			DESERIALIZED_DATA_INT(11) <= DESER_MSB_BUF_R(2);		-- push buffers to signals												
			DESERIALIZED_DATA_INT(9)  <= DESER_MSB_BUF_R(1);
			DESERIALIZED_DATA_INT(7)  <= DESER_MSB_BUF_R(0);
			DESERIALIZED_DATA_INT(5)  <= DESER_LSB_BUF_R(2);
			DESERIALIZED_DATA_INT(3)  <= DESER_LSB_BUF_R(1);
			DESERIALIZED_DATA_INT(1)  <= DESER_LSB_BUF_R(0);

		end if;

	end if;
	end process;

--	|-------------------------------------|
--	| RAW DESERIALIZATION ON FALLING EDGE |
--	|-------------------------------------|

deserialization_falling_edge : process(CLOCK, RESET)					-- deserialization on rising edge
                                                                                                                                                                       
	variable DESER_MSB_BUF_F		: STD_LOGIC_VECTOR (2 downto 0);        -- 3-bit MSB buffer
	variable DESER_LSB_BUF_F		: STD_LOGIC_VECTOR (2 downto 0);        -- 3-bit LSB buffer
	variable digif_rst_flag 		: STD_LOGIC;                            -- used to detect rising edge of d_digif_rst (i.e. old version of d_digif_rst)
	
	begin

	if falling_edge(CLOCK) then

		if RESET = '1' then
			F_EDGE_FLAG <= '0';						-- reset flags
 			DESERIALIZED_DATA_INT(10) <= '0';
 			DESERIALIZED_DATA_INT(8)  <= '0';
 			DESERIALIZED_DATA_INT(6)  <= '0';
 			DESERIALIZED_DATA_INT(4)  <= '0';
 			DESERIALIZED_DATA_INT(2)  <= '0';
 			DESERIALIZED_DATA_INT(0)  <= '0';
			DESER_MSB_BUF_F := "000";
			DESER_LSB_BUF_F := "000";
			digif_rst_flag := '0';
		else
			if R_EDGE_FLAG = '1' then					-- if reset was encountered high on rising edge process 
			F_EDGE_FLAG <= '0';                                             -- then falling edge encounter flag = '0'
			else	                                                        -- else reset was enountered high in this process (rising edge)
			F_EDGE_FLAG <= '1';                                             -- set falling edge encounter flag to '1'
			end if;                                                                                                                                                                                  
                                                                                                                                                                                                                 
			DESER_MSB_BUF_F(2 downto 1) := DESER_MSB_BUF_F(1 downto 0);     -- shift
			DESER_MSB_BUF_F(0) := d_digif_msb_data;                         -- load value from pin
			DESER_LSB_BUF_F(2 downto 1) := DESER_LSB_BUF_F(1 downto 0);                                                                                                                              
			DESER_LSB_BUF_F(0) := d_digif_lsb_data;                         -- load value from pin
                                                                                                                                                                                                                 
			if d_digif_rst = '1' and digif_rst_flag = '0' then              -- if rising edge of d_digif_rst
			DESER_MSB_BUF_F := "000";                                       -- reset buffers, otherwise preamble comparators toggle too early leading to wrong bit-shift values
			DESER_LSB_BUF_F := "000";                                                                                                                                                                
			digif_rst_flag := '1';                                          -- set flag back high so as to not step in this if-statement till the rest of the d_digif_rst = '1' period
			elsif d_digif_rst = '0' then                                    -- when d_digif_rst = '0' reset flag back to be ready for next rising edge
			digif_rst_flag := '0';                                                                                                                                                                   
			end if;                                                                                                                                                                                  
                                                                                                                                                                                                                 
 			DESERIALIZED_DATA_INT(10) <= DESER_MSB_BUF_F(2);                -- push buffers to signals												
 			DESERIALIZED_DATA_INT(8)  <= DESER_MSB_BUF_F(1);
 			DESERIALIZED_DATA_INT(6)  <= DESER_MSB_BUF_F(0);
 			DESERIALIZED_DATA_INT(4)  <= DESER_LSB_BUF_F(2);
 			DESERIALIZED_DATA_INT(2)  <= DESER_LSB_BUF_F(1);
 			DESERIALIZED_DATA_INT(0)  <= DESER_LSB_BUF_F(0);

		end if;
		
	end if; 
	end process;
	
	-- MSB sub-word
	DESERIALIZED_DATA_DEMUX(11) <= DESERIALIZED_DATA_INT(10) when F_EDGE_FLAG = '1' else '0' when RESET = '1' else DESERIALIZED_DATA_INT(11);	-- if falling edge process was first - tap 10 else tap 11
	DESERIALIZED_DATA_DEMUX(10) <= DESERIALIZED_DATA_INT(11) when F_EDGE_FLAG = '1' else '0' when RESET = '1' else DESERIALIZED_DATA_INT(10);
	DESERIALIZED_DATA_DEMUX(9)  <= DESERIALIZED_DATA_INT(8)  when F_EDGE_FLAG = '1' else '0' when RESET = '1' else DESERIALIZED_DATA_INT(9);
	DESERIALIZED_DATA_DEMUX(8)  <= DESERIALIZED_DATA_INT(9)  when F_EDGE_FLAG = '1' else '0' when RESET = '1' else DESERIALIZED_DATA_INT(8);
	DESERIALIZED_DATA_DEMUX(7)  <= DESERIALIZED_DATA_INT(6)  when F_EDGE_FLAG = '1' else '0' when RESET = '1' else DESERIALIZED_DATA_INT(7);
	DESERIALIZED_DATA_DEMUX(6)  <= DESERIALIZED_DATA_INT(7)  when F_EDGE_FLAG = '1' else '0' when RESET = '1' else DESERIALIZED_DATA_INT(6);
	-- LSB sub-word
	DESERIALIZED_DATA_DEMUX(5)  <= DESERIALIZED_DATA_INT(4)  when F_EDGE_FLAG = '1' else '0' when RESET = '1' else DESERIALIZED_DATA_INT(5);
	DESERIALIZED_DATA_DEMUX(4)  <= DESERIALIZED_DATA_INT(5)  when F_EDGE_FLAG = '1' else '0' when RESET = '1' else DESERIALIZED_DATA_INT(4);
	DESERIALIZED_DATA_DEMUX(3)  <= DESERIALIZED_DATA_INT(2)  when F_EDGE_FLAG = '1' else '0' when RESET = '1' else DESERIALIZED_DATA_INT(3);
	DESERIALIZED_DATA_DEMUX(2)  <= DESERIALIZED_DATA_INT(3)  when F_EDGE_FLAG = '1' else '0' when RESET = '1' else DESERIALIZED_DATA_INT(2);
	DESERIALIZED_DATA_DEMUX(1)  <= DESERIALIZED_DATA_INT(0)  when F_EDGE_FLAG = '1' else '0' when RESET = '1' else DESERIALIZED_DATA_INT(1);
	DESERIALIZED_DATA_DEMUX(0)  <= DESERIALIZED_DATA_INT(1)  when F_EDGE_FLAG = '1' else '0' when RESET = '1' else DESERIALIZED_DATA_INT(0);

-- 	|--------------------------|
-- 	| SYNC PROCESS RISING EDGE |
-- 	|--------------------------|

	syncprocess_re : process(CLOCK, RESET)
		variable digif_rst_old : std_logic;								-- old variable buffer
	begin

		if RESET = '1' then
		SHIFT_RISE <= "000";
		LOCK_RISE <= '0';

		elsif rising_edge(CLOCK) then

			if (d_digif_rst /= digif_rst_old and d_digif_rst = '1') then		-- if rising edge of d_digif_rst then preamble starts

				LOCK_RISE <= '0';									-- reset LOCK_RISE flag
				digif_rst_old := d_digif_rst;								-- update rst_old

			elsif LOCK = '0' and d_digif_rst = '1' then				-- if rising edge of d_digif_rst and LOCK has been reset then start searching

				if DESERIALIZED_DATA_DEMUX = PREAMBLE & PREAMBLE then					-- if pattern original
	 			SHIFT_RISE <= "000";									-- no need to shift
	 			LOCK_RISE <= '1';									-- lock											
				elsif DESERIALIZED_DATA_DEMUX = PREAMBLE(0) & PREAMBLE(5 downto 0) & PREAMBLE(5 downto 1) then  -- if pattern shifted with one
					SHIFT_RISE <= "001";									-- shift left one bit
					LOCK_RISE <= '1';									-- lock
				elsif DESERIALIZED_DATA_DEMUX = "001101001101" then	-- two search patterns should be enough, keeping here the rest of the possible combinations, just in case
					SHIFT_RISE <= "010";
					LOCK_RISE <= '1';
--				elsif DESERIALIZED_DATA_DEMUX = "100110100110" then
--					SHIFT_RISE <= "011";
--					LOCK_RISE <= '1';
--				elsif DESERIALIZED_DATA_DEMUX = "010011010011" then
--					SHIFT_RISE <= "100";
--					LOCK_RISE <= '1';
--				elsif DESERIALIZED_DATA_DEMUX = "101001101001" then
--					SHIFT_RISE <= "101";
--					LOCK_RISE <= '1';
				else											-- else no pattern is found
					SHIFT_RISE <= "000";
					LOCK_RISE <= '0';								-- so lock zero, and continue searching on next clock cycle
				end if;

			else
			DESERIALIZED_DATA_DESHIFT_RISE <= DESERIALIZED_DATA_DEMUX;				-- load DEMUX to DESHIFT //rise
			digif_rst_old := d_digif_rst;								-- update rst_old
			end if;
		end if;
	end process;


-- 	|---------------------------|
-- 	| SYNC PROCESS FALLING EDGE |
-- 	|---------------------------|

	syncprocess_fe : process(CLOCK, RESET)									
		variable digif_rst_old : std_logic;								-- old variable buffer
	begin

		if RESET = '1' then
		SHIFT_FALL <= "000";
		LOCK_FALL <= '0';

		elsif falling_edge(CLOCK) then
		
			if (d_digif_rst /= digif_rst_old and d_digif_rst = '1') then		-- if falling edge of d_digif_rst then preamble starts
			
			LOCK_FALL <= '0';									-- reset LOCK_RISE flag
			digif_rst_old := d_digif_rst;								-- update rst_old

			elsif LOCK = '0' and d_digif_rst = '1' then				-- if falling edge of d_digif_rst and LOCK has been reset then start searching

				if DESERIALIZED_DATA_DEMUX = PREAMBLE & PREAMBLE then					
					SHIFT_FALL <= "000";
					LOCK_FALL  <= '1';
				elsif DESERIALIZED_DATA_DEMUX = PREAMBLE(0) & PREAMBLE(5 downto 0) & PREAMBLE(5 downto 1) then -- i.e. def. "011010011010"
					SHIFT_FALL <= "001";
					LOCK_FALL  <= '1';
				elsif DESERIALIZED_DATA_DEMUX = "001101001101" then
					SHIFT_FALL <= "010";
					LOCK_FALL  <= '1';
--				elsif DESERIALIZED_DATA_DEMUX = "100110100110" then
--					SHIFT_FALL <= "011";
--					LOCK_FALL  <= '1';
--				elsif DESERIALIZED_DATA_DEMUX = "010011010011" then
--					SHIFT_FALL <= "100";
--					LOCK_FALL  <= '1';
--				elsif DESERIALIZED_DATA_DEMUX = "101001101001" then
--					SHIFT_FALL <= "101";
--					LOCK_FALL  <= '1';
				else
					SHIFT_FALL <= "000";
					LOCK_FALL  <= '0';
				end if;

			else
			DESERIALIZED_DATA_DESHIFT_FALL <= DESERIALIZED_DATA_DEMUX; 				-- load DEMUX to DESHIFT //rise
			digif_rst_old := d_digif_rst;								-- update rst_old
			end if;
		end if;
	end process;

	LOCK <= LOCK_RISE or LOCK_FALL;											-- combine locks from rise and fall processes
	SHIFT <= SHIFT_RISE when LOCK_RISE = '1' else SHIFT_FALL when LOCK_FALL = '1' else "000" when LOCK = '0';	-- mux SHIFT rise or fall based on the ussued lock from fall or rise

	DESERIALIZED_DATA_DESHIFT <= DESERIALIZED_DATA_DESHIFT_RISE when LOCK_RISE = '1' else DESERIALIZED_DATA_DESHIFT_FALL when LOCK_FALL = '1';	-- used for aligning data with one 1/2 clock period 

	DESERIALIZED_DATA_DESHIFTED <=
				DESERIALIZED_DATA_DESHIFT when SHIFT = "000" else									-- execute deshifting
				DESERIALIZED_DATA_DESHIFT(10 downto 0) & DESERIALIZED_DATA_DESHIFT(11) when SHIFT = "001" else
				DESERIALIZED_DATA_DESHIFT(9 downto 0)  & DESERIALIZED_DATA_DESHIFT(11 downto 10) when SHIFT = "010" else		-- keeping all possible combinations, just in case
			--	DESERIALIZED_DATA_DESHIFT(8 downto 0)  & DESERIALIZED_DATA_DESHIFT(11 downto 9 ) when SHIFT = "011" else
			--	DESERIALIZED_DATA_DESHIFT(7 downto 0)  & DESERIALIZED_DATA_DESHIFT(11 downto 8 ) when SHIFT = "100" else
			--	DESERIALIZED_DATA_DESHIFT(6 downto 0)  & DESERIALIZED_DATA_DESHIFT(11 downto 7 ) when SHIFT = "101" else
				DESERIALIZED_DATA_DESHIFT;

--	|---------------------------------------|
--	| PROCESS USSUING DATA OUT STROBE CLOCK |
--	|---------------------------------------|
	
        clockdiv : process (CLOCK, LOCK)
	variable old_rst : STD_LOGIC;
	variable lock_old : STD_LOGIC;
	variable cnt : integer range 0 to 7 := 0;
        begin
		if LOCK = '0' then				-- if preamble hasn't been clocked, strobe clock is '0'
                        CLOCK_DIV <= '0';
			cnt := 0;				-- reset counters
			lock_old := '0';

		elsif (CLOCK'event AND CLOCK = '0') and LOCK = '1' then		-- when lock is '1' and on falling edge of clock

			if d_digif_rst /= old_rst and d_digif_rst = '0' then	-- check if d_digif_rst is falling down
			CLOCK_DIV <= not CLOCK_DIV;				-- toggle clock
			cnt := 2;						---- controls bit slipping, when incremented / decremented extra we catch-up or lag next clock toggling, def 2,
			old_rst := d_digif_rst;			-- update old_rst
			end if;							-- should be used in combination with rising/falling edge rstsync: process

			if lock_old = '0' then			-- toggle CLOCK_DIV at the moment of locking
			CLOCK_DIV <= not CLOCK_DIV;		-- executed only once per LOCK
			lock_old := '1';			-- lock_old set to 1 means that, LOCK needs to become '0' to unblock this if-statement for future execution
			end if;

			cnt := cnt + 1;				-- increment clock period divide counter

			if cnt = 4 then				-- toggle clock, 1 cycle per 6 cycles
			CLOCK_DIV <= not CLOCK_DIV;
			cnt := 1;
			end if;

			old_rst := d_digif_rst;			-- update old_rst

                end if;
        end process;  

        DESERIALIZED_DATA_CLK <= CLOCK_DIV;			-- tap out

--  	|-------------------------------|
--  	| FINAL DATA STROBE RISING EDGE |
--  	|-------------------------------|

	strobeprocess_re : process(DESERIALIZED_DATA_CLK)

	begin 
		if rising_edge(DESERIALIZED_DATA_CLK) then 

		DESERIALIZED_DATA_RE <= DESERIALIZED_DATA_DESHIFTED;

		end if;

	end process;

-- 	|--------------------------------|
-- 	| FINAL DATA STROBE FALLING EDGE |
-- 	|--------------------------------|

	strobeprocess_fe : process(DESERIALIZED_DATA_CLK)

	begin 
		if falling_edge(DESERIALIZED_DATA_CLK) then 

		DESERIALIZED_DATA_FE <= DESERIALIZED_DATA_DESHIFTED;

		end if;

	end process;

	DESERIALIZED_DATA <= DESERIALIZED_DATA_RE when DESERIALIZED_DATA_CLK = '1' else DESERIALIZED_DATA_FE when DESERIALIZED_DATA_CLK = '0';	-- combine data from the final data strobe processes

end Behavioral;

