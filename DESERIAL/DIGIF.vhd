--|-------------------------------------------------------------------|
--| ADC Testchip DIGIF interface model                                |
--|-------------------------------------------------------------------|
--| Version P1A - Deyan Levski, deyan.levski@eng.ox.ac.uk, 14.09.2016 |
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
           d_digif_msb_data : out  STD_LOGIC;
           d_digif_lsb_data : out  STD_LOGIC);
end DIGIF;

architecture Behavioral of DIGIF is

	signal PREAMBLE : STD_LOGIC_VECTOR(5 downto 0);

	signal DATA0 	: STD_LOGIC_VECTOR(11 downto 0);
	signal DATA1	: STD_LOGIC_VECTOR(11 downto 0);

	signal MSB_SDA_RISE : STD_LOGIC;
	signal LSB_SDA_RISE : STD_LOGIC;
	signal MSB_SDA_FALL : STD_LOGIC;
	signal LSB_SDA_FALL : STD_LOGIC;
	signal F_EDGE_FLAG : STD_LOGIC;
	signal R_EDGE_FLAG : STD_LOGIC;

-- shared	variable txbuf_m : STD_LOGIC_VECTOR(5 downto 0);
-- shared	variable txbuf_l : STD_LOGIC_VECTOR(5 downto 0);
-- shared  variable sck_counter :integer range 0 to 31 := 0;

begin

--|--------------------------------------------|
--| Alternate transmission with two data words |
--|--------------------------------------------|

	PREAMBLE <= "110100";	    --"001011" LSB FIRST LSB--->MSB
	DATA0	 <= "010101010101"; --"101010101010" LSB FIRST LSB--->MSB
	DATA1	 <= "011000101111"; --"111101000110" LSB FIRST LSB--->MSB



	rising_edge_process : process(d_digif_sck, d_digif_rst)


	variable txbuf_m : STD_LOGIC_VECTOR(5 downto 0);
	variable txbuf_l : STD_LOGIC_VECTOR(5 downto 0);
	variable preamble_counter :integer range 0 to 31 :=0;
	variable preamble_var :std_logic_vector (5 downto 0);
	variable sck_counter :integer range 0 to 31 := 0;

	begin

	if rising_edge(d_digif_sck) then

		if (d_digif_rst = '1') then

			if F_EDGE_FLAG = '1' then
			R_EDGE_FLAG <= '0';
			else	
			R_EDGE_FLAG <= '1';
			end if;

			txbuf_m := DATA0(11 downto 6);
			txbuf_l := DATA0(5 downto 0);

 			if (F_EDGE_FLAG = '1') then
 			MSB_SDA_RISE <= preamble_var(4);
 			LSB_SDA_RISE <= preamble_var(4);
			end if;
			if (F_EDGE_FLAG = '0') then
 			MSB_SDA_RISE <= preamble_var(5);
 			LSB_SDA_RISE <= preamble_var(5);
 			end if;

			preamble_var (5 downto 2) := preamble_var (3 downto 0);
			sck_counter := 0;

			preamble_counter := preamble_counter + 1;

			if preamble_counter = 3 then
			preamble_var := PREAMBLE(5 downto 0);
			preamble_counter := 0;
			end if;

		 else
		
			R_EDGE_FLAG <= '0';

			preamble_var := PREAMBLE;
			preamble_counter := 0;

			MSB_SDA_RISE <= txbuf_m(4);
			LSB_SDA_RISE <= txbuf_l(4);

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

		end if;


	end if;

	end process;


	falling_edge_process : process(d_digif_sck, d_digif_rst)

	variable txbuf_m : STD_LOGIC_VECTOR(5 downto 0);
	variable txbuf_l : STD_LOGIC_VECTOR(5 downto 0);
	variable preamble_counter :integer range 0 to 31 :=0;
	variable preamble_var :std_logic_vector (5 downto 0);
	variable sck_counter :integer range 0 to 31 := 0;

	begin

	if falling_edge(d_digif_sck) then

		if (d_digif_rst = '1') then

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
			preamble_var := PREAMBLE; --(0) & PREAMBLE(5 downto 1);
			preamble_counter := 0;
			end if;

		else
			F_EDGE_FLAG <= '0';

			preamble_var := PREAMBLE;
			preamble_counter := 0;

			MSB_SDA_FALL <= txbuf_m(5);
			LSB_SDA_FALL <= txbuf_l(5);

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

		end if;

	end if;

	end process;


--	syncprocess:	process(d_digif_sck, d_digif_rst)


-- 	begin
-- 
-- 		if d_digif_rst = '1' and d_digif_sck = '1' then
-- 		d_digif_msb_data <=  MSB_SDA_RISE;
-- 		elsif d_digif_rst = '1' and d_digif_sck = '0' then
-- 		d_digif_msb_data <=  MSB_SDA_FALL;
-- 		end if;
-- 
-- 	end process;


--d_digif_msb_data <= MSB_SDA_FALL when d_digif_sck = '0' else MSB_SDA_RISE when d_digif_sck = '1' else '0';
d_digif_msb_data <= MSB_SDA_FALL when d_digif_sck = '0' else MSB_SDA_RISE; -- when d_digif_sck = '1' else '0';
d_digif_lsb_data <= LSB_SDA_FALL when d_digif_sck = '0' else LSB_SDA_RISE; -- when d_digif_sck = '1' else '0';

--	d_digif_msb_data <= MSB_SDA_RISE xor MSB_SDA_FALL;
--	d_digif_lsb_data <= LSB_SDA_RISE xor LSB_SDA_FALL;

end Behavioral;

