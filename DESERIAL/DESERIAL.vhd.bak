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
           d_digif_msb_data : in  STD_LOGIC;
           d_digif_lsb_data : in  STD_LOGIC;
	   DESERIALIZED_DATA_CLK : inout STD_LOGIC;
           DESERIALIZED_DATA : out  STD_LOGIC_VECTOR (11 downto 0));
end DESERIAL;

architecture Behavioral of DESERIAL is



	signal DESERIALIZED_DATA_INT		: STD_LOGIC_VECTOR (11 downto 0);
	signal DESERIALIZED_DATA_DEMUX		: STD_LOGIC_VECTOR (11 downto 0);

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
begin

	PREAMBLE <=  "001011"; -- mirrored check

deserialization_rising_edge : process(CLOCK, RESET)

	variable sync 				: STD_LOGIC;
	variable cnt 				: integer range 0 to 8 := 0;
	variable DESER_MSB_BUF_R			: STD_LOGIC_VECTOR (2 downto 0);
	variable DESER_LSB_BUF_R			: STD_LOGIC_VECTOR (2 downto 0);
	begin
	if rising_edge(CLOCK) then
		
		if RESET = '1' then
			cnt := 0;			-- one clock cycle gibberish
			sync := '0';
--			DESERIALIZED_DATA_INT(11 downto 0) <= (others => '0');
			DESERIALIZED_DATA_CLOCK_RISE <= '1';

			R_EDGE_FLAG <= '0';			-- reset flags			

		else

			if F_EDGE_FLAG = '1' then		-- if reset was encountered high on falling edge process 
				R_EDGE_FLAG <= '0';		-- then rising edge encounter flag = '0'
			else					-- else reset was enountered high in this process (rising edge)
			R_EDGE_FLAG <= '1';			-- set rising edge encounter flag to '1'
			end if;

			DESER_MSB_BUF_R(0) := d_digif_msb_data;
			DESER_MSB_BUF_R(2 downto 1) := DESER_MSB_BUF_R(1 downto 0);
			DESER_LSB_BUF_R(0) := d_digif_lsb_data;
			DESER_LSB_BUF_R(2 downto 1) := DESER_LSB_BUF_R(1 downto 0);
		
			DESERIALIZED_DATA_INT(11) <= DESER_MSB_BUF_R(2);
			DESERIALIZED_DATA_INT(9)  <= DESER_MSB_BUF_R(1);
			DESERIALIZED_DATA_INT(7)  <= DESER_MSB_BUF_R(0);
			DESERIALIZED_DATA_INT(5)  <= DESER_LSB_BUF_R(2);
			DESERIALIZED_DATA_INT(3)  <= DESER_LSB_BUF_R(1);
			DESERIALIZED_DATA_INT(1)  <= DESER_LSB_BUF_R(0);

			if cnt = 3 then 
				DESERIALIZED_DATA_CLOCK_RISE <= not DESERIALIZED_DATA_CLOCK_RISE; -- toggle (rising edge) in middle of DESERIALIZED_DATA
			cnt := 0;
			end if;

		cnt := cnt + 1;

		end if;

	end if;
	end process;

deserialization_falling_edge : process(CLOCK, RESET)

	variable cnt 				: INTEGER range 0 to 8 := 0;
	variable sync 				: STD_LOGIC;
	variable DESER_MSB_BUF_F		: STD_LOGIC_VECTOR (2 downto 0);
	variable DESER_LSB_BUF_F		: STD_LOGIC_VECTOR (2 downto 0);

	begin
	if falling_edge(CLOCK) then

		if RESET = '1' then
			cnt := 0;			-- one clock cycle gibberish
			sync := '0';
--			DESERIALIZED_DATA_INT(11 downto 0) <= (others => '0');
			DESERIALIZED_DATA_CLOCK_FALL <= '1';

			F_EDGE_FLAG <= '0';			

		else
			if R_EDGE_FLAG = '1' then
			F_EDGE_FLAG <= '0';
			else	
			F_EDGE_FLAG <= '1';
			end if;

			DESER_MSB_BUF_F(0) := d_digif_msb_data;
			DESER_MSB_BUF_F(2 downto 1) := DESER_MSB_BUF_F(1 downto 0);
			DESER_LSB_BUF_F(0) := d_digif_lsb_data;
			DESER_LSB_BUF_F(2 downto 1) := DESER_LSB_BUF_F(1 downto 0);

 			DESERIALIZED_DATA_INT(10) <= DESER_MSB_BUF_F(2);
 			DESERIALIZED_DATA_INT(8)  <= DESER_MSB_BUF_F(1);
 			DESERIALIZED_DATA_INT(6)  <= DESER_MSB_BUF_F(0);
 			DESERIALIZED_DATA_INT(4)  <= DESER_LSB_BUF_F(2);
 			DESERIALIZED_DATA_INT(2)  <= DESER_LSB_BUF_F(1);
 			DESERIALIZED_DATA_INT(0)  <= DESER_LSB_BUF_F(0);

			if cnt = 3 then 
				DESERIALIZED_DATA_CLOCK_FALL <= not DESERIALIZED_DATA_CLOCK_FALL; -- toggle (rising edge) in middle of DESERIALIZED_DATA
			cnt := 0;
			end if;

		cnt := cnt + 1;

		end if;
		
	end if; 
	end process;

--  	syncprocess : process(CLOCK)
--  
--  	begin
--  
--  		if DESERIALIZED_DATA_INT = "100101100101" then
--  		DESERIALIZED_DATA <= DESERIALIZED_DATA_INT(10 downto 0) & DESERIALIZED_DATA_INT(11);
--  		sync_sll_1 <= '1';
--  		elsif DESERIALIZED_DATA_INT = "110010110010" then
--   		DESERIALIZED_DATA <= DESERIALIZED_DATA_INT(9 downto 0) & DESERIALIZED_DATA_INT(11 downto 10);
--  		sync_sll_2 <= '1';
-- 
-- 
--  		end if;
--  
--  	end process;

	strobeprocess : process(DESERIALIZED_DATA_CLK)

	begin 
		if falling_edge(DESERIALIZED_DATA_CLK) then 
--		DESERIALIZED_DATA <= DESERIALIZED_DATA_INT;


 -- 		if DESERIALIZED_DATA_INT = "100101100101" then
 -- 		DESERIALIZED_DATA <= DESERIALIZED_DATA_INT(10 downto 0) & DESERIALIZED_DATA_INT(11);
 -- 		sync_sll_1 <= '1';
 -- 		elsif DESERIALIZED_DATA_INT = "110010110010" then
 --  		DESERIALIZED_DATA <= DESERIALIZED_DATA_INT(9 downto 0) & DESERIALIZED_DATA_INT(11 downto 10);
--		elsif DESERIALIZED_DATA_INT = "011010011010" then

  --		sync_sll_2 <= '1';
--		else
		DESERIALIZED_DATA <= DESERIALIZED_DATA_DEMUX;
--		end if;

		end if;
	end process;

DESERIALIZED_DATA_DEMUX(11) <= DESERIALIZED_DATA_INT(10) when F_EDGE_FLAG = '1' else DESERIALIZED_DATA_INT(11);
DESERIALIZED_DATA_DEMUX(10) <= DESERIALIZED_DATA_INT(11) when F_EDGE_FLAG = '1' else DESERIALIZED_DATA_INT(10);
DESERIALIZED_DATA_DEMUX(9)  <= DESERIALIZED_DATA_INT(8)  when F_EDGE_FLAG = '1' else DESERIALIZED_DATA_INT(9);
DESERIALIZED_DATA_DEMUX(8)  <= DESERIALIZED_DATA_INT(9)  when F_EDGE_FLAG = '1' else DESERIALIZED_DATA_INT(8);
DESERIALIZED_DATA_DEMUX(7)  <= DESERIALIZED_DATA_INT(6)  when F_EDGE_FLAG = '1' else DESERIALIZED_DATA_INT(7);
DESERIALIZED_DATA_DEMUX(6)  <= DESERIALIZED_DATA_INT(7)  when F_EDGE_FLAG = '1' else DESERIALIZED_DATA_INT(6);
DESERIALIZED_DATA_DEMUX(5)  <= DESERIALIZED_DATA_INT(4)  when F_EDGE_FLAG = '1' else DESERIALIZED_DATA_INT(5);
DESERIALIZED_DATA_DEMUX(4)  <= DESERIALIZED_DATA_INT(5)  when F_EDGE_FLAG = '1' else DESERIALIZED_DATA_INT(4);
DESERIALIZED_DATA_DEMUX(3)  <= DESERIALIZED_DATA_INT(2)  when F_EDGE_FLAG = '1' else DESERIALIZED_DATA_INT(3);
DESERIALIZED_DATA_DEMUX(2)  <= DESERIALIZED_DATA_INT(3)  when F_EDGE_FLAG = '1' else DESERIALIZED_DATA_INT(2);
DESERIALIZED_DATA_DEMUX(1)  <= DESERIALIZED_DATA_INT(0)  when F_EDGE_FLAG = '1' else DESERIALIZED_DATA_INT(1);
DESERIALIZED_DATA_DEMUX(0)  <= DESERIALIZED_DATA_INT(1)  when F_EDGE_FLAG = '1' else DESERIALIZED_DATA_INT(0);



	DESERIALIZED_DATA_CLK <= DESERIALIZED_DATA_CLOCK_RISE when R_EDGE_FLAG = '1' else DESERIALIZED_DATA_CLOCK_FALL when F_EDGE_FLAG = '1' else '0';

end Behavioral;

