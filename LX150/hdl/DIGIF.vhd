--|-------------------------------------------------------------------|
--| ADC Testchip DIGIF interface model                                |
--|-------------------------------------------------------------------|
--| Version A - Deyan Levski, deyan.levski@eng.ox.ac.uk, 23.09.2016   |
--|-------------------------------------------------------------------|
--
--| -+- | Implements a DDR 6:1 serializer |
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

entity DIGIF is
	Port ( d_digif_sck : in  STD_LOGIC;
	       d_digif_rst : in  STD_LOGIC;
	       RESET	   : in  STD_LOGIC;
	       d_digif_msb_data : out  STD_LOGIC;
	       d_digif_lsb_data : out  STD_LOGIC);
end DIGIF;

architecture Behavioral of DIGIF is

	signal PREAMBLE : STD_LOGIC_VECTOR(5 downto 0);

	signal DATA0 	: STD_LOGIC_VECTOR(11 downto 0);
	signal DATA1	: STD_LOGIC_VECTOR(11 downto 0);

	signal MSB_SDA_RISE : STD_LOGIC;		-- MSB serial data output on rising edge process
	signal LSB_SDA_RISE : STD_LOGIC;		-- LSB serial data output on rising edge process
	signal MSB_SDA_FALL : STD_LOGIC;		-- MSB serial data output on falling edge process
	signal LSB_SDA_FALL : STD_LOGIC;		-- LSB serial data output on falling edge process
	signal F_EDGE_FLAG : STD_LOGIC;			-- used for syncing preamble, goes high when reset is encountered (high) on falling edge process
	signal R_EDGE_FLAG : STD_LOGIC;			-- used for syncing preamble, goes high when reset is encountered (high) on rising edge process
	signal F_EDGE_FLAG_DAT : STD_LOGIC;		-- used for syncing data, goes high when reset is encountered (high) on falling edge process	
	signal R_EDGE_FLAG_DAT : STD_LOGIC;		-- used for syncing data, goes high when reset is encountered (high) on rising edge process
	signal mux_sck_rise : STD_LOGIC;
	signal mux_sck_fall : STD_LOGIC;

begin

	--|--------------------------------------------|
	--| Alternate transmission with two data words |
	--|--------------------------------------------|

	PREAMBLE <= "110100";	    --"001011" LSB FIRST LSB--->MSB		-- mirrored word
	DATA0	 <= "000000000101"; --"100000000101"; --"010101010101"; --"101010101010" LSB FIRST LSB--->MSB	-- mirrored word
	DATA1	 <= "000000000101"; --"100000001101"; --"011000101111"; --"111101000110" LSB FIRST LSB--->MSB	-- mirrored word


	rising_edge_process : process(d_digif_sck)

		variable txbuf_m : STD_LOGIC_VECTOR(5 downto 0);	-- tx buffer msb
		variable txbuf_l : STD_LOGIC_VECTOR(5 downto 0);	-- tx buffer lsb
		variable preamble_counter :integer range 0 to 8 :=0;	-- counter for preamble pattern
		variable preamble_var :std_logic_vector (5 downto 0);	-- preamble buffer
		variable sck_counter :integer range 0 to 31 := 0;	-- sck clock counter used for data shifting
		variable sck_toggle : STD_LOGIC;
	begin

		if rising_edge(d_digif_sck) then			-- on rising edge

			if (RESET = '1') then

				sck_toggle := '0';

			elsif (d_digif_rst = '1') then			-- if reset is high

				if F_EDGE_FLAG = '1' then		-- if reset was encountered high on falling edge process 
					R_EDGE_FLAG <= '0';		-- then rising edge encounter flag = '0'

				else					-- else reset was enountered high in this process (rising edge)
					R_EDGE_FLAG <= '1';			-- set rising edge encounter flag to '1'
				end if;

				txbuf_m := DATA0(11 downto 6);		-- load data word to buffers
				txbuf_l := DATA0(5 downto 0);
				sck_counter := 0;			-- prepare clock counter for data shifting

				if (F_EDGE_FLAG = '1') then		-- if reset falling edge encounter then
					MSB_SDA_RISE <= preamble_var(4);	-- we tap from preamble 4 (MSB-1)
					LSB_SDA_RISE <= preamble_var(4);
				end if;
				if (F_EDGE_FLAG = '0') then		-- if not then
					MSB_SDA_RISE <= preamble_var(5);	-- we tap from preamble 5 (MSB)
					LSB_SDA_RISE <= preamble_var(5);
				end if;

				preamble_var (5 downto 2) := preamble_var (3 downto 0);		-- shift left x2 (because there is another shift in falling edge process)

				preamble_counter := preamble_counter + 1;	-- increment preamble counter

				if preamble_counter = 3 then			-- done 3 shift operations?
					preamble_var := PREAMBLE(5 downto 0);		-- load preamble to buffer again
					preamble_counter := 0;				-- reset preamble counter
				end if;

				R_EDGE_FLAG_DAT <= '0';			-- reset data flags
				sck_toggle := not sck_toggle;
				mux_sck_rise <= sck_toggle;
			else
				if F_EDGE_FLAG_DAT = '1' then		-- if reset was encountered low on falling edge process 
					R_EDGE_FLAG_DAT <= '0';		-- then rising edge dat encounter flag = '0'
				else					-- else reset was enountered low in this process (rising edge)
					R_EDGE_FLAG_DAT <= '1';		-- set rising edge dat encounter flag to '1'
				end if;	

				R_EDGE_FLAG <= '0';			-- reset preamble flags
				preamble_var := PREAMBLE;		-- load preamble to buffer
				preamble_counter := 0;			-- reset preamble counter

				if (F_EDGE_FLAG_DAT = '1') then		-- if data falling edge encounter then
					MSB_SDA_RISE <= txbuf_m(4);	-- we tap from data 4 (MSB-1)
					LSB_SDA_RISE <= txbuf_l(4);
				end if;
				if (F_EDGE_FLAG_DAT = '0') then		-- if not then
					MSB_SDA_RISE <= txbuf_m(5);	-- we tap from data 5 (MSB)
					LSB_SDA_RISE <= txbuf_l(5);
				end if;

				txbuf_m(5 downto 2) := txbuf_m(3 downto 0);	-- shift left x2
				txbuf_l(5 downto 2) := txbuf_l(3 downto 0);

				sck_counter := sck_counter + 1;			-- increment data shift counter

				if sck_counter = 3 then				-- if three shifts done, load new word
					txbuf_m:= DATA1(11 downto 6);
					txbuf_l:= DATA1(5 downto 0);
				elsif sck_counter = 6 then			-- if another three shifts done, load another word
					txbuf_m:= DATA0(11 downto 6);
					txbuf_l:= DATA0(5 downto 0);
					sck_counter := 0;				-- reset counter
				end if;

				sck_toggle := not sck_toggle;
				mux_sck_rise <= sck_toggle;

			end if;
		end if;

	end process;


	falling_edge_process : process(d_digif_sck)	-- falling edge process; almost identical to rising edge process

		variable txbuf_m : STD_LOGIC_VECTOR(5 downto 0);
		variable txbuf_l : STD_LOGIC_VECTOR(5 downto 0);
		variable preamble_counter :integer range 0 to 31 :=0;
		variable preamble_var :std_logic_vector (5 downto 0);
		variable sck_counter :integer range 0 to 31 := 0;
		variable sck_toggle : STD_LOGIC;

	begin


		if falling_edge(d_digif_sck) then

			if (RESET = '1') then

				sck_toggle := '0';

			elsif (d_digif_rst = '1') then

				if R_EDGE_FLAG = '1' then
					F_EDGE_FLAG <= '0';
				else	
					F_EDGE_FLAG <= '1';
				end if;

				txbuf_m := DATA0(11 downto 6);
				txbuf_l := DATA0(5 downto 0);

				if (F_EDGE_FLAG = '1') then
					MSB_SDA_FALL <= preamble_var(5);
					LSB_SDA_FALL <= preamble_var(5);
				end if;
				if (F_EDGE_FLAG = '0') then
					MSB_SDA_FALL <= preamble_var(4);
					LSB_SDA_FALL <= preamble_var(4);
				end if;

				preamble_var (5 downto 2) := preamble_var (3 downto 0);
				sck_counter := 0;

				preamble_counter := preamble_counter + 1;

				if preamble_counter = 3 then
					preamble_var := PREAMBLE;
					preamble_counter := 0;
				end if;

				F_EDGE_FLAG_DAT <= '0';			-- reset data flags
				sck_toggle := not sck_toggle;
				mux_sck_fall <= sck_toggle;

			else

				if R_EDGE_FLAG_DAT = '1' then		-- if reset was encountered high on rising edge process 
					F_EDGE_FLAG_DAT <= '0';		-- then falling edge encounter flag = '0'
				else					-- else reset was enountered high in this process (rising edge)
					F_EDGE_FLAG_DAT <= '1';		-- set falling edge encounter flag to '1'
				end if;	

				F_EDGE_FLAG <= '0';			-- reset preampbe flags
				preamble_var := PREAMBLE;
				preamble_counter := 0;

				if (F_EDGE_FLAG_DAT = '1') then		-- if reset falling edge encounter then
					MSB_SDA_FALL <= txbuf_m(5);	-- we tap from data 4 (MSB-1)
					LSB_SDA_FALL <= txbuf_l(5);
				end if;
				if (F_EDGE_FLAG_DAT = '0') then		-- if not then
					MSB_SDA_FALL <= txbuf_m(4);	-- we tap from data 5 (MSB)
					LSB_SDA_FALL <= txbuf_l(4);
				end if;

				txbuf_m(5 downto 2) := txbuf_m(3 downto 0);
				txbuf_l(5 downto 2) := txbuf_l(3 downto 0);

				sck_counter := sck_counter + 1;	

				if sck_counter = 3 then
					txbuf_m:= DATA1(11 downto 6);
					txbuf_l:= DATA1(5 downto 0);
				elsif sck_counter = 6 then
					txbuf_m:= DATA0(11 downto 6);
					txbuf_l:= DATA0(5 downto 0);
					sck_counter := 0;
				end if;
				sck_toggle := not sck_toggle;
				mux_sck_fall <= sck_toggle;

			end if;
		end if;

	end process;

	d_digif_msb_data <= MSB_SDA_FALL when (mux_sck_rise xor mux_sck_fall) = '0' else MSB_SDA_RISE; -- combine outputs from the two processes
	d_digif_lsb_data <= LSB_SDA_FALL when (mux_sck_rise xor mux_sck_fall) = '0' else LSB_SDA_RISE; -- might be glitchy, but should not be an issue because the deserializer clock strobes the data in the middle of the eye opening i.e. plenty of time for glitch to disappear

end Behavioral;

