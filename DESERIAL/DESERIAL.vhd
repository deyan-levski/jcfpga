--|------------------------------------------------------------------|
--| ADC Testhip Data Deserializer Module                             |
--|------------------------------------------------------------------|
--| Version P1A, Deyan Levski, deyan.levski@eng.ox.ac.uk, 14.09.2016 |
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



	signal DESERIALIZED_DATA_INT		: STD_LOGIC_VECTOR (11 downto 0);
	signal DESERIALIZED_DATA_DEMUX		: STD_LOGIC_VECTOR (11 downto 0);
	signal DESERIALIZED_DATA_DESHIFT	: STD_LOGIC_VECTOR (11 downto 0);
	signal DESERIALIZED_DATA_DESHIFT_RISE	: STD_LOGIC_VECTOR (11 downto 0);
	signal DESERIALIZED_DATA_DESHIFT_FALL	: STD_LOGIC_VECTOR (11 downto 0);
	signal DESERIALIZED_DATA_DESHIFTED	: STD_LOGIC_VECTOR (11 downto 0);


	signal DESERIALIZED_DATA_CLOCK_FALL	: STD_LOGIC;
	signal DESERIALIZED_DATA_CLOCK_RISE	: STD_LOGIC;

	signal PREAMBLE 			: STD_LOGIC_VECTOR (5 downto 0);

-- 	signal DESER_MSB_BUF_RISE		: STD_LOGIC_VECTOR (2 downto 0);
-- 	signal DESER_MSB_BUF_FALL		: STD_LOGIC_VECTOR (2 downto 0);
-- 
-- 	signal DESER_LSB_BUF_RISE		: STD_LOGIC_VECTOR (2 downto 0);
-- 	signal DESER_LSB_BUF_FALL		: STD_LOGIC_VECTOR (2 downto 0);
	signal F_EDGE_FLAG : STD_LOGIC;		-- goes high when reset is encountered (high) on falling edge process	
	signal R_EDGE_FLAG : STD_LOGIC;		-- goes high when reset is encountered (high) on rising edge process

	signal DESERIALIZED_DATA_RE		: STD_LOGIC_VECTOR (11 downto 0);
	signal DESERIALIZED_DATA_FE		: STD_LOGIC_VECTOR (11 downto 0);

	signal SHIFT				: STD_LOGIC_VECTOR (2 downto 0);
	signal SHIFT_RISE			: STD_LOGIC_VECTOR (2 downto 0);
	signal SHIFT_FALL			: STD_LOGIC_VECTOR (2 downto 0);
	signal LOCK				: STD_LOGIC;
	signal LOCK_RISE			: STD_LOGIC;
	signal LOCK_FALL			: STD_LOGIC;
	signal CLOCK_DIV			: STD_LOGIC;

begin

	PREAMBLE <=  "110100"; --"001011"; -- mirrored check

deserialization_rising_edge : process(CLOCK, RESET)

	variable DESER_MSB_BUF_R			: STD_LOGIC_VECTOR (2 downto 0);
	variable DESER_LSB_BUF_R			: STD_LOGIC_VECTOR (2 downto 0);
	variable digif_rst_flag 		: STD_LOGIC;

	begin
	if rising_edge(CLOCK) then
		
		if RESET = '1' then
			DESERIALIZED_DATA_CLOCK_RISE <= '0';
			R_EDGE_FLAG <= '0';			-- reset flags			
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
			if F_EDGE_FLAG = '1' then		-- if reset was encountered high on falling edge process 
				R_EDGE_FLAG <= '0';		-- then rising edge encounter flag = '0'
			else					-- else reset was enountered high in this process (rising edge)
			R_EDGE_FLAG <= '1';			-- set rising edge encounter flag to '1'
			end if;

			DESER_MSB_BUF_R(2 downto 1) := DESER_MSB_BUF_R(1 downto 0);
			DESER_MSB_BUF_R(0) := d_digif_msb_data;
			DESER_LSB_BUF_R(2 downto 1) := DESER_LSB_BUF_R(1 downto 0);
			DESER_LSB_BUF_R(0) := d_digif_lsb_data;
		
			if d_digif_rst = '1' and digif_rst_flag = '0' then
			DESER_MSB_BUF_R := "000";
			DESER_LSB_BUF_R := "000";
			digif_rst_flag := '1';
			elsif d_digif_rst = '0' then
			digif_rst_flag := '0';
			end if;

			DESERIALIZED_DATA_INT(11) <= DESER_MSB_BUF_R(2);
			DESERIALIZED_DATA_INT(9)  <= DESER_MSB_BUF_R(1);
			DESERIALIZED_DATA_INT(7)  <= DESER_MSB_BUF_R(0);
			DESERIALIZED_DATA_INT(5)  <= DESER_LSB_BUF_R(2);
			DESERIALIZED_DATA_INT(3)  <= DESER_LSB_BUF_R(1);
			DESERIALIZED_DATA_INT(1)  <= DESER_LSB_BUF_R(0);

		end if;

	end if;
	end process;

deserialization_falling_edge : process(CLOCK, RESET)

	variable DESER_MSB_BUF_F		: STD_LOGIC_VECTOR (2 downto 0);
	variable DESER_LSB_BUF_F		: STD_LOGIC_VECTOR (2 downto 0);
	variable digif_rst_flag 		: STD_LOGIC;
	begin
	if falling_edge(CLOCK) then

		if RESET = '1' then
			DESERIALIZED_DATA_CLOCK_FALL <= '0';
			F_EDGE_FLAG <= '0';			
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
			if R_EDGE_FLAG = '1' then
			F_EDGE_FLAG <= '0';
			else	
			F_EDGE_FLAG <= '1';
			end if;

			DESER_MSB_BUF_F(2 downto 1) := DESER_MSB_BUF_F(1 downto 0);
			DESER_MSB_BUF_F(0) := d_digif_msb_data;
			DESER_LSB_BUF_F(2 downto 1) := DESER_LSB_BUF_F(1 downto 0);
			DESER_LSB_BUF_F(0) := d_digif_lsb_data;

			if d_digif_rst = '1' and digif_rst_flag = '0' then
			DESER_MSB_BUF_F := "000";
			DESER_LSB_BUF_F := "000";
			digif_rst_flag := '1';
			elsif d_digif_rst = '0' then
			digif_rst_flag := '0';
			end if;

 			DESERIALIZED_DATA_INT(10) <= DESER_MSB_BUF_F(2);
 			DESERIALIZED_DATA_INT(8)  <= DESER_MSB_BUF_F(1);
 			DESERIALIZED_DATA_INT(6)  <= DESER_MSB_BUF_F(0);
 			DESERIALIZED_DATA_INT(4)  <= DESER_LSB_BUF_F(2);
 			DESERIALIZED_DATA_INT(2)  <= DESER_LSB_BUF_F(1);
 			DESERIALIZED_DATA_INT(0)  <= DESER_LSB_BUF_F(0);

		end if;
		
	end if; 
	end process;

	DESERIALIZED_DATA_DEMUX(11) <= DESERIALIZED_DATA_INT(10) when F_EDGE_FLAG = '1' else '0' when RESET = '1' else DESERIALIZED_DATA_INT(11);
	DESERIALIZED_DATA_DEMUX(10) <= DESERIALIZED_DATA_INT(11) when F_EDGE_FLAG = '1' else '0' when RESET = '1' else DESERIALIZED_DATA_INT(10);
	DESERIALIZED_DATA_DEMUX(9)  <= DESERIALIZED_DATA_INT(8)  when F_EDGE_FLAG = '1' else '0' when RESET = '1' else DESERIALIZED_DATA_INT(9);
	DESERIALIZED_DATA_DEMUX(8)  <= DESERIALIZED_DATA_INT(9)  when F_EDGE_FLAG = '1' else '0' when RESET = '1' else DESERIALIZED_DATA_INT(8);
	DESERIALIZED_DATA_DEMUX(7)  <= DESERIALIZED_DATA_INT(6)  when F_EDGE_FLAG = '1' else '0' when RESET = '1' else DESERIALIZED_DATA_INT(7);
	DESERIALIZED_DATA_DEMUX(6)  <= DESERIALIZED_DATA_INT(7)  when F_EDGE_FLAG = '1' else '0' when RESET = '1' else DESERIALIZED_DATA_INT(6);

	DESERIALIZED_DATA_DEMUX(5)  <= DESERIALIZED_DATA_INT(4)  when F_EDGE_FLAG = '1' else '0' when RESET = '1' else DESERIALIZED_DATA_INT(5);
	DESERIALIZED_DATA_DEMUX(4)  <= DESERIALIZED_DATA_INT(5)  when F_EDGE_FLAG = '1' else '0' when RESET = '1' else DESERIALIZED_DATA_INT(4);
	DESERIALIZED_DATA_DEMUX(3)  <= DESERIALIZED_DATA_INT(2)  when F_EDGE_FLAG = '1' else '0' when RESET = '1' else DESERIALIZED_DATA_INT(3);
	DESERIALIZED_DATA_DEMUX(2)  <= DESERIALIZED_DATA_INT(3)  when F_EDGE_FLAG = '1' else '0' when RESET = '1' else DESERIALIZED_DATA_INT(2);
	DESERIALIZED_DATA_DEMUX(1)  <= DESERIALIZED_DATA_INT(0)  when F_EDGE_FLAG = '1' else '0' when RESET = '1' else DESERIALIZED_DATA_INT(1);
	DESERIALIZED_DATA_DEMUX(0)  <= DESERIALIZED_DATA_INT(1)  when F_EDGE_FLAG = '1' else '0' when RESET = '1' else DESERIALIZED_DATA_INT(0);


-- 	|--------------------------|
-- 	| Sync process rising edge |
-- 	|--------------------------|

	syncprocess_re : process(CLOCK, RESET)
		variable digif_rst_old : std_logic;
	begin

		if RESET = '1' then
		SHIFT_RISE <= "000";
		LOCK_RISE <= '0';
		elsif rising_edge(CLOCK) and (d_digif_rst /= digif_rst_old and d_digif_rst = '1') then
			LOCK_RISE <= '0';
			digif_rst_old := d_digif_rst;
		elsif rising_edge(CLOCK) and LOCK = '0' and d_digif_rst = '1' then

 		if DESERIALIZED_DATA_DEMUX = PREAMBLE & PREAMBLE then
 			SHIFT_RISE <= "000";
 			LOCK_RISE <= '1';
		elsif DESERIALIZED_DATA_DEMUX = PREAMBLE(0) & PREAMBLE(5 downto 0) & PREAMBLE(5 downto 1) then -- i.e. def. "011010011010"
  			SHIFT_RISE <= "001";
  			LOCK_RISE <= '1';
-- 		elsif DESERIALIZED_DATA_DEMUX = "001101001101" then
-- 			SHIFT_RISE <= "010";
-- 			LOCK_RISE <= '1';
-- 		elsif DESERIALIZED_DATA_DEMUX = "100110100110" then
-- 			SHIFT_RISE <= "011";
-- 			LOCK_RISE <= '1';
-- 		elsif DESERIALIZED_DATA_DEMUX = "010011010011" then
-- 			SHIFT_RISE <= "100";
-- 			LOCK_RISE <= '1';
-- 		elsif DESERIALIZED_DATA_DEMUX = "101001101001" then
-- 			SHIFT_RISE <= "101";
-- 			LOCK_RISE <= '1';
		else
			SHIFT_RISE <= "000";
			LOCK_RISE <= '0';
		end if;
		elsif rising_edge(CLOCK) then
			DESERIALIZED_DATA_DESHIFT_RISE <= DESERIALIZED_DATA_DEMUX;
			digif_rst_old := d_digif_rst;
	end if;
	end process;


-- 	|---------------------------|
-- 	| Sync process falling edge |
-- 	|---------------------------|

	syncprocess_fe : process(CLOCK, RESET)
		variable digif_rst_old : std_logic;
	begin

		if RESET = '1' then
		SHIFT_FALL <= "000";
		LOCK_FALL <= '0';

		elsif falling_edge(CLOCK) and (d_digif_rst /= digif_rst_old and d_digif_rst = '1') then
			LOCK_FALL <= '0';
			digif_rst_old := d_digif_rst;

		elsif falling_edge(CLOCK) and LOCK = '0' and d_digif_rst = '1' then

		if DESERIALIZED_DATA_DEMUX = PREAMBLE & PREAMBLE then
			SHIFT_FALL <= "000";
			LOCK_FALL  <= '1';
		elsif DESERIALIZED_DATA_DEMUX = PREAMBLE(0) & PREAMBLE(5 downto 0) & PREAMBLE(5 downto 1) then -- i.e. def. "011010011010"
 			SHIFT_FALL <= "001";
 			LOCK_FALL  <= '1';
-- 		elsif DESERIALIZED_DATA_DEMUX = "001101001101" then
-- 			SHIFT_FALL <= "010";
-- 			LOCK_FALL  <= '1';
-- 		elsif DESERIALIZED_DATA_DEMUX = "100110100110" then
-- 			SHIFT_FALL <= "011";
-- 			LOCK_FALL  <= '1';
-- 		elsif DESERIALIZED_DATA_DEMUX = "010011010011" then
-- 			SHIFT_FALL <= "100";
-- 			LOCK_FALL  <= '1';
-- 		elsif DESERIALIZED_DATA_DEMUX = "101001101001" then
-- 			SHIFT_FALL <= "101";
-- 			LOCK_FALL  <= '1';
		else
			SHIFT_FALL <= "000";
			LOCK_FALL  <= '0';
		end if;

		elsif falling_edge(CLOCK) then
			DESERIALIZED_DATA_DESHIFT_FALL <= DESERIALIZED_DATA_DEMUX;
	end if;
	end process;

	LOCK <= LOCK_RISE or LOCK_FALL;
	SHIFT <= SHIFT_RISE when LOCK_RISE = '1' else SHIFT_FALL when LOCK_FALL = '1' else "000" when LOCK = '0';

	DESERIALIZED_DATA_DESHIFT <= DESERIALIZED_DATA_DESHIFT_RISE when LOCK_RISE = '1' else DESERIALIZED_DATA_DESHIFT_FALL when LOCK_FALL = '1';

	DESERIALIZED_DATA_DESHIFTED <=
					DESERIALIZED_DATA_DESHIFT when SHIFT = "000" else
					DESERIALIZED_DATA_DESHIFT(10 downto 0) & DESERIALIZED_DATA_DESHIFT(11) when SHIFT = "001" else
					DESERIALIZED_DATA_DESHIFT(9 downto 0)  & DESERIALIZED_DATA_DESHIFT(11 downto 10) when SHIFT = "010" else
					DESERIALIZED_DATA_DESHIFT(8 downto 0)  & DESERIALIZED_DATA_DESHIFT(11 downto 9 ) when SHIFT = "011" else
					DESERIALIZED_DATA_DESHIFT(7 downto 0)  & DESERIALIZED_DATA_DESHIFT(11 downto 8 ) when SHIFT = "100" else
					DESERIALIZED_DATA_DESHIFT(6 downto 0)  & DESERIALIZED_DATA_DESHIFT(11 downto 7 ) when SHIFT = "101" else
					DESERIALIZED_DATA_DESHIFT;

	
        clockdiv : process (CLOCK, LOCK)
	variable old_rst : STD_LOGIC;
	variable lock_old : STD_LOGIC;
	variable cnt : integer range 0 to 7 := 0;
        begin
                if LOCK = '0' then
                        CLOCK_DIV <= '0';
			cnt := 0;
			lock_old := '0';

                elsif (CLOCK'event AND CLOCK = '0') and LOCK = '1' then

			if d_digif_rst /= old_rst and d_digif_rst = '0' then
			CLOCK_DIV <= not CLOCK_DIV;
			cnt := 2;
			end if;

			if lock_old = '0' then
			CLOCK_DIV <= not CLOCK_DIV;
			lock_old := '1';
			end if;

			cnt := cnt + 1;

			if cnt = 4 then
			CLOCK_DIV <= not CLOCK_DIV;
			cnt := 1;
			end if;

			old_rst := d_digif_rst;

                end if;
        end process;  

-- 	rstsync : process (CLOCK)
-- 	begin
-- 		if rising_edge(CLOCK) then
-- 			d_digif_rst <= d_digif_rst_in;
-- 		end if;
-- 	end process;

        DESERIALIZED_DATA_CLK <= CLOCK_DIV;

-- 	|----------------------------|
-- 	| Strobe process rising edge |
-- 	|----------------------------|

	strobeprocess_re : process(DESERIALIZED_DATA_CLK)

	begin 
		if rising_edge(DESERIALIZED_DATA_CLK) then 

		DESERIALIZED_DATA_RE <= DESERIALIZED_DATA_DESHIFTED;

		end if;

	end process;

--	|-----------------------------|
--	| Strobe process falling edge |
--	|-----------------------------|

	strobeprocess_fe : process(DESERIALIZED_DATA_CLK)

	begin 
		if falling_edge(DESERIALIZED_DATA_CLK) then 

		DESERIALIZED_DATA_FE <= DESERIALIZED_DATA_DESHIFTED;

		end if;

	end process;

	DESERIALIZED_DATA <= DESERIALIZED_DATA_RE when DESERIALIZED_DATA_CLK = '1' else DESERIALIZED_DATA_FE when DESERIALIZED_DATA_CLK = '0';

--	DESERIALIZED_DATA_CLK <= DESERIALIZED_DATA_CLOCK_RISE or DESERIALIZED_DATA_CLOCK_FALL; -- when R_EDGE_FLAG = '0' else DESERIALIZED_DATA_CLOCK_FALL; --when F_EDGE_FLAG = '1' else '0';

end Behavioral;

