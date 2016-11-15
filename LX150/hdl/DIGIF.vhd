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
	signal txbuf_m  : STD_LOGIC_VECTOR(5 downto 0);
	signal txbuf_l  : STD_LOGIC_VECTOR(5 downto 0);
	signal flag_data : STD_LOGIC;
	signal flag_pream : STD_LOGIC;

begin

	--|--------------------------------------------|
	--| Alternate transmission with two data words |
	--|--------------------------------------------|

	PREAMBLE <= "110100";	    --"001011" LSB FIRST LSB--->MSB		-- mirrored word
	DATA0	 <= "000000000001"; --"100000000101"; --"010101010101"; --"101010101010" LSB FIRST LSB--->MSB	-- mirrored word
	DATA1	 <= "000000000001"; --"100000001101"; --"011000101111"; --"111101000110" LSB FIRST LSB--->MSB	-- mirrored word




	SERIALIZE : process (d_digif_sck, RESET)

	begin

		if (RESET = '1') then

			txbuf_m <= PREAMBLE;
			txbuf_l <= PREAMBLE;
			flag_data <= '0';
			flag_pream <= '0';
			d_digif_msb_data <= '0';
			d_digif_lsb_data <= '0';


		elsif rising_edge(d_digif_sck) then

			if d_digif_rst = '1' then

				if flag_pream = '0' then
					txbuf_m <= PREAMBLE;
					txbuf_l <= PREAMBLE;
					flag_pream <= '1';
				else

				txbuf_m(5 downto 0) <= txbuf_m(4 downto 0) & txbuf_m(5);
				txbuf_l(5 downto 0) <= txbuf_l(4 downto 0) & txbuf_l(5);
				flag_data <= '0';

				end if;
			else

				if flag_data = '0' then
					txbuf_m <= DATA0(11 downto 6);
					txbuf_l <= DATA0(5 downto 0);
					flag_data <= '1';

				else

				txbuf_m(5 downto 0) <= txbuf_m(4 downto 0) & txbuf_m(5);
				txbuf_l(5 downto 0) <= txbuf_l(4 downto 0) & txbuf_l(5);
				flag_pream <= '0';

				end if;
			end if;

			d_digif_msb_data <= txbuf_m(5);
			d_digif_lsb_data <= txbuf_l(5);

		end if;

	end process;

end Behavioral;

