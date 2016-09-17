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

--	signal MSB_SDA_RISE : STD_LOGIC;
--	signal LSB_SDA_RISE : STD_LOGIC;
--	signal MSB_SDA_FALL : STD_LOGIC;
--	signal LSB_SDA_FALL : STD_LOGIC;

-- shared	variable txbuf_m : STD_LOGIC_VECTOR(5 downto 0);
-- shared	variable txbuf_l : STD_LOGIC_VECTOR(5 downto 0);
-- shared  variable sck_counter :integer range 0 to 31 := 0;

begin

--|--------------------------------------------|
--| Alternate transmission with two data words |
--|--------------------------------------------|

	PREAMBLE <= "101011";
	DATA0	 <= "101010101010"; --"010010001011";
	DATA1	 <= "101010101010"; --"111101000110";


	process(d_digif_sck, d_digif_rst)

	variable txbuf_m : STD_LOGIC_VECTOR(5 downto 0);
	variable txbuf_l : STD_LOGIC_VECTOR(5 downto 0);
	variable preamble_counter :integer range 0 to 31 :=0;
	variable preamble_var :std_logic_vector (5 downto 0);
	variable preamble_flag : std_logic;
	variable sck_counter :integer range 0 to 31 := 0;

	begin

		if rising_edge(d_digif_sck) then

		if (d_digif_rst = '1') then

			if preamble_flag = '0' then
			preamble_var := PREAMBLE;
			preamble_flag := '1';
			end if;

			txbuf_m := DATA0(11 downto 6);
			txbuf_l := DATA0(5 downto 0);

			d_digif_msb_data <= preamble_var(5);
			d_digif_lsb_data <= preamble_var(5);

			preamble_var (5 downto 1) := preamble_var (4 downto 0);
			sck_counter := 0;

			preamble_counter := preamble_counter + 1;

			if preamble_counter = 6 then
			preamble_var := PREAMBLE;
			preamble_counter := 0;
			end if;

		else
		
			preamble_flag := '0';

			d_digif_msb_data <= txbuf_m(5);
			d_digif_lsb_data <= txbuf_l(5);

			txbuf_m(5 downto 1) := txbuf_m(4 downto 0);
			txbuf_l(5 downto 1) := txbuf_l(4 downto 0);

			sck_counter := sck_counter + 1;	

			if sck_counter = 6 then
			txbuf_m:= DATA1(11 downto 6);
			txbuf_l:= DATA1(5 downto 0);
			elsif sck_counter = 12 then
			txbuf_m:= DATA0(11 downto 6);
			txbuf_l:= DATA0(5 downto 0);
			sck_counter := 0;
			end if;

		end if;

		elsif falling_edge(d_digif_sck) then

		if (d_digif_rst = '1') then

			if preamble_flag = '0' then
			preamble_var := PREAMBLE;
			preamble_flag := '1';
			end if;

			txbuf_m := DATA0(11 downto 6);
			txbuf_l := DATA0(5 downto 0);

			d_digif_msb_data <= preamble_var(5);
			d_digif_lsb_data <= preamble_var(5);

			preamble_var (5 downto 1) := preamble_var (4 downto 0);
			sck_counter := 0;

			preamble_counter := preamble_counter + 1;

			if preamble_counter = 6 then
			preamble_var := PREAMBLE;
			preamble_counter := 0;
			end if;

		else

			preamble_flag := '0';

			d_digif_msb_data <= txbuf_m(5);
			d_digif_lsb_data <= txbuf_l(5);

			txbuf_m(5 downto 1) := txbuf_m(4 downto 0);
			txbuf_l(5 downto 1) := txbuf_l(4 downto 0);

			sck_counter := sck_counter + 1;	

			if sck_counter = 6 then
			txbuf_m:= DATA1(11 downto 6);
			txbuf_l:= DATA1(5 downto 0);
			elsif sck_counter = 12 then
			txbuf_m:= DATA0(11 downto 6);
			txbuf_l:= DATA0(5 downto 0);
			sck_counter := 0;
			end if;

		end if;

		end if;

	end process;



--	process(d_digif_sck)
--	
--	variable txbuf_m_rise : STD_LOGIC_VECTOR(5 downto 0);
--	variable txbuf_l_rise : STD_LOGIC_VECTOR(5 downto 0);
--	variable preamble_counter :integer range 0 to 31 :=0;
--	variable preamble_var :std_logic_vector (5 downto 0);
--	variable sck_counter :integer range 0 to 31 := 0;
--	
--	begin
--	
--	
--	if (d_digif_sck'event and d_digif_sck = '1') then	-- DDR
--	
--		if (d_digif_rst = '1') then
--			txbuf_m_rise := DATA0(11 downto 6);
--			txbuf_l_rise := DATA0(5 downto 0);
--	
--			preamble_counter := preamble_counter + 1;
--	
--			MSB_SDA_RISE <= preamble_var(5);
--			LSB_SDA_RISE <= preamble_var(5);
--	
--			preamble_var (5 downto 1) := preamble_var (4 downto 0);
--			sck_counter := 0;
--	
--			if preamble_counter = 3 then
--			preamble_var := PREAMBLE;
--			preamble_counter := 0;
--			end if;
--		else
--			if txbuf_m_rise(5) = '1' then
--			d_digif_msb_data <= '1';
--			else 
--			d_digif_msb_data <= '0';
--			end if;
--			if txbuf_l_rise(5) = '1' then
--			d_digif_lsb_data <= '1';
--			else 
--			d_digif_lsb_data <= '0';
--			end if;
--	
--			MSB_SDA_RISE <= txbuf_m_rise(5);
--			LSB_SDA_RISE <= txbuf_l_rise(5);
--	
--			txbuf_m_rise(5 downto 2) := txbuf_m_rise(3 downto 0);
--			txbuf_l_rise(5 downto 2) := txbuf_l_rise(3 downto 0);
--	
--			sck_counter := sck_counter + 1;	
--	
--			if sck_counter = 3 then
--			txbuf_m_rise:= DATA1(11 downto 6);
--			txbuf_l_rise:= DATA1(5 downto 0);
--			elsif sck_counter = 6 then
--			txbuf_m_rise:= DATA0(11 downto 6);
--			txbuf_l_rise:= DATA0(5 downto 0);
--			sck_counter := 0;
--			end if;
--	
--		end if;
--	
--	end if;
--	
--	end process;
--	
--	process(d_digif_sck)
--	
--	variable txbuf_m_fall : STD_LOGIC_VECTOR(5 downto 0);
--	variable txbuf_l_fall : STD_LOGIC_VECTOR(5 downto 0);
--	variable preamble_counter :integer range 0 to 31 :=0;
--	variable preamble_var :std_logic_vector (5 downto 0);
--	variable sck_counter :integer range 0 to 31 := 0;
--	
--	begin
--	
--	if (d_digif_sck'event and d_digif_sck = '0') then
--	
--		if (d_digif_rst = '1') then
--			txbuf_m_fall:= DATA0(11 downto 6);
--			txbuf_l_fall:= DATA0(5 downto 0);
--	
--			preamble_counter := preamble_counter + 1;
--	
--			MSB_SDA_FALL <= preamble_var(5);
--			LSB_SDA_FALL <= preamble_var(5);
--	
--			preamble_var (5 downto 1) := preamble_var (4 downto 0);
--			sck_counter := 0;
--	
--			if preamble_counter = 3 then
--			preamble_var := PREAMBLE;
--			preamble_counter := 0;
--			end if;
--	
--		else
--			if txbuf_m_fall(5) = '1' then
--			d_digif_msb_data <= '1';
--			else 
--			d_digif_msb_data <= '0';
--			end if;
--			if txbuf_l_fall(5) = '1' then
--			d_digif_lsb_data <= '1';
--			else 
--			d_digif_lsb_data <= '0';
--			end if;
--	
--			MSB_SDA_FALL <= txbuf_m_fall(5);
--			LSB_SDA_FALL <= txbuf_l_fall(5);
--			
--			txbuf_m_fall(5 downto 2) := txbuf_m_fall(3 downto 0);
--			txbuf_l_fall(5 downto 2) := txbuf_l_fall(3 downto 0);
--	
--			sck_counter := sck_counter + 1;	
--	
--			if sck_counter = 3 then
--			txbuf_m_fall:= DATA1(11 downto 6);
--			txbuf_l_fall:= DATA1(5 downto 0);
--			elsif sck_counter = 6 then
--			txbuf_m_fall:= DATA0(11 downto 6);
--			txbuf_l_fall:= DATA0(5 downto 0);
--			sck_counter := 0;
--			end if;
--	
--		end if;
--	
--	end if;
--	
--	end process;

--	d_digif_msb_data <= MSB_SDA_RISE xnor MSB_SDA_FALL;
--	d_digif_lsb_data <= LSB_SDA_RISE xnor LSB_SDA_FALL;

end Behavioral;

