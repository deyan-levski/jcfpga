--|------------------------------------------------------------------------------------|
--| ADC Testchip SPI Driver                                                            |
--|------------------------------------------------------------------------------------|
--| Version P1A - Initial version, Deyan Levski, deyan.levski@eng.ox.ac.uk, 07.09.2016 |
--|------------------------------------------------------------------------------------|
--
--
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;


entity SREG_CORE is
    Port ( CLOCK : in  STD_LOGIC;
           SPI_SEN : inout  STD_LOGIC;
--           SPI_DATA : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           SPI_SCK : inout  STD_LOGIC;
           SPI_SDA : inout  STD_LOGIC);
end SREG_CORE;

architecture Behavioral of SREG_CORE is

	constant ds_sreg_col_testmux_pon				: std_logic := '0';
	constant ds_sreg_comp_pon					: std_logic := '1';	
	constant ds_sreg_count_mem_bias_pon				: std_logic := '1';
	constant ds_sreg_count_clk_lvds_rx_pon				: std_logic := '1';
	constant ds_sreg_digif_lvds_rx_pon				: std_logic := '1';
	constant ds_sreg_ref_vref_lvds_tx_pon				: std_logic := '1';	
	constant ds_sreg_ref_vref_bias_pon				: std_logic := '1';
	constant ds_sreg_ref_vref_ramp_ota_hi_pow			: std_logic := '1';	
	constant ds_sreg_ref_vref_ramp_pon				: std_logic := '1';
	constant ds_sreg_vln_en						: std_logic := '1';
	constant ds_sreg_photocore_row_pon				: std_logic := '1';
	constant ds_sreg_nc						: std_logic_vector(6 downto 0) := "0000000";		-- vectors are mirrored in SREG you are typing (LSB - MSB) here
	constant d_sreg_col_testmux_en					: std_logic := '0';
	constant d_sreg_comp_bias					: std_logic_vector(3 downto 0) := "1100";		-- vectors are mirrored in SREG
	constant d_sreg_comp_bias_drvr					: std_logic_vector(3 downto 0) := "1111";		-- vectors are mirrored in SREG
	constant d_sreg_count_mem_ctrl_bias				: std_logic_vector(5 downto 0) := "100001";		-- vectors are mirrored in SREG "100001"
	constant d_sreg_count_mem_ctrl_zero_bias			: std_logic_vector(5 downto 0) := "001001";		-- vectors are mirrored in SREG "001001"
	constant d_sreg_force_en					: std_logic := '0';
	constant d_sreg_force_coeff					: std_logic_vector(3 downto 0) := "1100";		-- vectors are mirrored in SREG
	constant d_sreg_count_clk_lvds_rx_dc_on				: std_logic := '0';
	constant d_sreg_count_clk_lvds_rx_bias_adj			: std_logic_vector(3 downto 0) := "1110";		-- vectors are mirrored in SREG
	constant d_sreg_digif_lvds_rx_dc_on				: std_logic := '0';
	constant d_sreg_digif_lvds_rx_bias_adj				: std_logic_vector(3 downto 0) := "1110";		-- vectors are mirrored in SREG
	constant d_sreg_digif_serial_msblsb_mode			: std_logic := '0';
	constant d_sreg_digif_test					: std_logic_vector(2 downto 0) := "000";		-- vectors are mirrored in SREG
	constant d_sreg_ref_vref_lvds_tx_bias_adj			: std_logic_vector(3 downto 0) := "0000";		-- vectors are mirrored in SREG
	constant d_sreg_ref_vref_lvds_tx_vdac_cm_sel			: std_logic_vector(3 downto 0) := "0001";		-- vectors are mirrored in SREG
	constant d_sreg_ref_vref_bias_test_en				: std_logic := '0';
	constant d_sreg_ref_vref_ramp_rst_vdac				: std_logic_vector(3 downto 0) := "1011";		-- vectors are mirrored in SREG
	constant d_sreg_ref_vref_ramp_slew_ctrl				: std_logic_vector(5 downto 0) := "010110";		-- vectors are mirrored in SREG
	constant d_sreg_ref_vref_ramp_test				: std_logic_vector(6 downto 0) := "0000000";		-- vectors are mirrored in SREG
	constant d_sreg_col_adc_ctrl_test				: std_logic_vector(3 downto 0) := "0000";		-- vectors are mirrored in SREG
	constant d_sreg_digif_lvds_tx_core_cmfb_off			: std_logic := '0';
	constant d_sreg_vln_vbpc_bypass					: std_logic := '0';
	constant d_sreg_vln_bias					: std_logic_vector(7 downto 0) := "11110000";		-- vectors are mirrored in SREG
--	constant d_sreg_nc						: std_logic_vector(8 downto 0) := "000000000";		-- vectors are mirrored in SREG 

	constant SPI_DATA : std_logic_vector(95 downto 0) := ds_sreg_col_testmux_pon & ds_sreg_comp_pon & ds_sreg_count_mem_bias_pon & ds_sreg_count_clk_lvds_rx_pon & ds_sreg_digif_lvds_rx_pon & ds_sreg_ref_vref_lvds_tx_pon & ds_sreg_ref_vref_bias_pon & ds_sreg_ref_vref_ramp_ota_hi_pow & ds_sreg_ref_vref_ramp_pon & ds_sreg_nc & d_sreg_col_testmux_en & d_sreg_comp_bias & d_sreg_comp_bias_drvr & d_sreg_count_mem_ctrl_bias & d_sreg_count_mem_ctrl_zero_bias & d_sreg_force_en & d_sreg_force_coeff & d_sreg_count_clk_lvds_rx_dc_on & d_sreg_count_clk_lvds_rx_bias_adj & d_sreg_digif_lvds_rx_dc_on & d_sreg_digif_lvds_rx_bias_adj & d_sreg_digif_serial_msblsb_mode & d_sreg_digif_test & d_sreg_ref_vref_lvds_tx_bias_adj & d_sreg_ref_vref_lvds_tx_vdac_cm_sel & d_sreg_ref_vref_bias_test_en & d_sreg_ref_vref_ramp_rst_vdac & d_sreg_ref_vref_ramp_slew_ctrl & d_sreg_ref_vref_ramp_test & d_sreg_col_adc_ctrl_test & d_sreg_digif_lvds_tx_core_cmfb_off & d_sreg_vln_vbpc_bypass & d_sreg_vln_bias;


	-- intermediate signals
	signal CLOCK_DIV_REG : std_logic_vector(19 downto 0);
	signal CLOCK_DIV : std_logic;

begin

	clockdiv : process (CLOCK, RESET)		-- spi clock divider from main freerunning clock / 100 MHz
	
	begin
		if RESET = '1' then
			CLOCK_DIV_REG <= (others => '0');
		elsif (CLOCK'event AND CLOCK = '1') then
			CLOCK_DIV_REG <= CLOCK_DIV_REG + 1;
		end if;
	end process;  
	
	CLOCK_DIV <= CLOCK_DIV_REG(19);

	spiclkgen:	process(CLOCK_DIV, RESET)  -- spi clock generator based on the size of the register

	variable sck_counter :integer := 0;

	begin

		if RESET ='1' then

			SPI_SCK <= '0';
			SPI_SEN <= '0';
			sck_counter := 0;	

		elsif(CLOCK_DIV'event AND CLOCK_DIV = '0') then

			sck_counter := sck_counter + 1;

			if (sck_counter < (192 + 2)) then -- +2 because we clock data is delayed with one clock cycle (two edges)

			SPI_SCK <= not SPI_SCK;

			end if;

			if (sck_counter = (192 + 2 + 2)) then -- +2 +2 so that d_spi_sen signal is issues a bit later

			SPI_SEN <= '1';

			end if;

			if (sck_counter = (192 +2 +2 +2)) then -- toggle back d_spi_sen so it has low level again (close gates of latches in SREG)

			SPI_SEN <= '0';

			end if;

     end if;

end process;

	spimaster:	process(SPI_SCK, RESET) -- spi master ; data generator

	variable spi_data_tx :std_logic_vector(95 downto 0); --:= "00000001";

	begin

      if RESET = '1' then

	    SPI_SDA <= '0';
	    spi_data_tx := SPI_DATA;

     elsif(SPI_SCK'event AND SPI_SCK = '0') then

		SPI_SDA <= spi_data_tx(95);

		spi_data_tx(95 downto 1) := spi_data_tx(94 downto 0);

		end if;
		
end process;


end Behavioral;
