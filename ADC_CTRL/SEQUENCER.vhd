--|-----------------------------------------------------------------------------------------------------------------------|
--| ADC Testchip Main Sequencer                                                                                           |
--|-----------------------------------------------------------------------------------------------------------------------|
--| Version P1A - Initial version, Deyan Levski, deyan.levski@eng.ox.ac.uk, 07.01.2015                                    |
--|-----------------------------------------------------------------------------------------------------------------------|
--| Version P1A - Deyan Levski, deyan.levski@eng.ox.ac.uk, 17 Jan 2015                                                    |
--|-----------------------------------------------------------------------------------------------------------------------|
--| Version P2A - Improved timing for full code coverage conversion, Deyan Levski, deyan.levski@eng.ox.ac.uk, 05 Feb 2015 |
--|-----------------------------------------------------------------------------------------------------------------------|
--| Version P3A - Added some more signals for coefficient strobing, 22 Feb 2015                                           |
--|-----------------------------------------------------------------------------------------------------------------------|
--| Version P4A - Added memory addressing and readout signalling, 02 Mar 2015                                             |
--|-----------------------------------------------------------------------------------------------------------------------|
--| Version P5A to P9A - Lots of changes in-between, added SREG setting loader, 20 Jan 2016                               |
--|-----------------------------------------------------------------------------------------------------------------------|
--| Version P1B - Removed transport delays, now code synthesizable, DD, 07 Sep 2016                                       |
--|-----------------------------------------------------------------------------------------------------------------------|
--|-+-|
--
--
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
--use IEEE.NUMERIC_STD.ALL;
use work.counters.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SEQUENCER is
    Port (	CLOCK		: in  STD_LOGIC;
		RESET		: in  STD_LOGIC;

	d_adc_shr_shs		: inout STD_LOGIC;

	d_shs			: inout STD_LOGIC;
	d_shr			: inout STD_LOGIC;
	d_ads			: inout STD_LOGIC;
	d_adr			: inout STD_LOGIC;

    	d_comp_bias_sh		: inout STD_LOGIC;
	d_comp_dyn_pon		: inout STD_LOGIC;

	d_count_rst		: inout STD_LOGIC;
	d_count_inv_clk		: inout STD_LOGIC;
	d_count_hold		: inout STD_LOGIC;
	d_count_updn		: inout STD_LOGIC;
	d_count_inc_one		: inout STD_LOGIC;
	d_count_jc_shift_en	: inout STD_LOGIC;
	d_count_lsb_en		: inout STD_LOGIC;
	d_count_lsb_clk		: inout STD_LOGIC;
	d_count_mem_wr		: inout STD_LOGIC;
	d_count_en		: inout STD_LOGIC;

	d_digif_serial_rst	: inout std_logic;

	d_ref_vref_ramp_rst	: inout std_logic;
	d_ref_vref_sh		: inout std_logic;
	d_ref_vref_clamp_en	: inout std_logic;
	d_ref_vref_ramp_ota_dyn_pon: inout std_logic

);
			  
end SEQUENCER;

architecture Behavioral of SEQUENCER is

	constant GLOBALPRESCALER 	: integer range 0 to 16383 := 3;
	constant GLOBALPER 		: integer range 0 to 16383 := 300*GLOBALPRESCALER;  -- 152*GLOBALPRESCALER

--|----------------------------|
--| ADC SAMPLE AND HOLD TIMING |
--|----------------------------|

	-- SHR or SHS Flag
	constant SHRSHS_L 		: integer range 0 to 16383 := 160*GLOBALPRESCALER;
	constant SHRSHS_H 		: integer := 480*GLOBALPRESCALER;
	constant SHRSHS_G 		: integer := 2*GLOBALPER;

	-- Sample SHR
	constant SHR_L 			: integer range 0 to 16383 := 0*GLOBALPRESCALER;
	constant SHR_H 			: integer range 0 to 16383 := 20*GLOBALPRESCALER;
	constant SHR_G 			: integer range 0 to 16383 := 2*GLOBALPER;
	constant SHR_LP 		: integer range 0 to 16383 := 480*GLOBALPRESCALER;
	constant SHR_HP 		: integer range 0 to 16383 := 600*GLOBALPRESCALER;

	-- Sample SHS
	constant SHS_L 			: integer range 0 to 16383 := 0*GLOBALPRESCALER;
	constant SHS_H 			: integer range 0 to 16383 := 0*GLOBALPRESCALER;
	constant SHS_G 			: integer range 0 to 16383 := 2*GLOBALPER;
	constant SHS_LP 		: integer range 0 to 16383 := 160*GLOBALPRESCALER;
	constant SHS_HP 		: integer range 0 to 16383 := 310*GLOBALPRESCALER;

	-- Switch Convert SHS
	constant ADS_L 			: integer range 0 to 16383 := 0*GLOBALPRESCALER;
	constant ADS_H 			: integer range 0 to 16383 := 0*GLOBALPRESCALER;
	constant ADS_G 			: integer range 0 to 16383 := 2*GLOBALPER;
	constant ADS_LP 		: integer range 0 to 16383 := 170*GLOBALPRESCALER;
	constant ADS_HP 		: integer range 0 to 16383 := 432*GLOBALPRESCALER;

	-- Switch Convert SHR
	constant ADR_L 			: integer range 0 to 16383 := 0*GLOBALPRESCALER;
	constant ADR_H 			: integer range 0 to 16383 := 132*GLOBALPRESCALER;
	constant ADR_G 			: integer range 0 to 16383 := 2*GLOBALPER;
	constant ADR_LP 		: integer range 0 to 16383 := 490*GLOBALPRESCALER;
	constant ADR_HP 		: integer range 0 to 16383 := 600*GLOBALPRESCALER;

--|-------------------|
--| COMPARATOR TIMING |
--|-------------------|

	-- Sample Comparator Bias
	constant COMPBIASSH_L 		: integer range 0 to 16383 := 160*GLOBALPRESCALER;
	constant COMPBIASSH_H 		: integer range 0 to 16383 := 300*GLOBALPRESCALER;
	constant COMPBIASSH_G 		: integer range 0 to 16383 := 2*GLOBALPER;
	constant COMPBIASSH_LP 		: integer range 0 to 16383 := 480*GLOBALPRESCALER;
	constant COMPBIASSH_HP 		: integer range 0 to 16383 := 610*GLOBALPRESCALER;

	-- Comparator Dynamic Power-On
	constant COMPDYNPON_L 		: integer range 0 to 16383 := 131*GLOBALPRESCALER;
	constant COMPDYNPON_H 		: integer range 0 to 16383 := 330*GLOBALPRESCALER;
	constant COMPDYNPON_G 		: integer range 0 to 16383 := 2*GLOBALPER;
	constant COMPDYNPON_LP 		: integer range 0 to 16383 := 431*GLOBALPRESCALER;
	constant COMPDYNPON_HP 		: integer range 0 to 16383 := 728*GLOBALPRESCALER;

--|---------------------------|
--| COUNTER AND MEMORY TIMING |
--|---------------------------|

	-- Count Enable
	constant COUNTEN_L 		: integer range 0 to 16383 := 27*GLOBALPRESCALER;
	constant COUNTEN_H 		: integer range 0 to 16383 := 131*GLOBALPRESCALER;
	
	-- Count Reset
	constant COUNTRST_L 		: integer range 0 to 16383 := 13*GLOBALPRESCALER;
	constant COUNTRST_H 		: integer range 0 to 16383 := 16*GLOBALPRESCALER;
	constant COUNTRST_G 		: integer range 0 to 16383 := 2*GLOBALPER;

	-- Count Invert Clock
	constant COUNTINVCLK_L 		: integer range 0 to 16383 := 146*GLOBALPRESCALER;
	constant COUNTINVCLK_H 		: integer range 0 to 16383 := 147*GLOBALPRESCALER;
	constant COUNTINVCLK_G 		: integer range 0 to 16383 := 2*GLOBALPER;

	-- Count Hold
	constant COUNTHOLD_L		: integer range 0 to 16383 := 146*GLOBALPRESCALER;
	constant COUNTHOLD_H		: integer range 0 to 16383 := 151*GLOBALPRESCALER;
	constant COUNTHOLD_G		: integer range 0 to 16383 := 2*GLOBALPER;

	-- Count UP/DN	
	constant COUNTUPDN_L 		: integer range 0 to 16383 := 13*GLOBALPRESCALER;
	constant COUNTUPDN_H 		: integer range 0 to 16383 := 16*GLOBALPRESCALER;
	constant COUNTUPDN_G 		: integer range 0 to 16383 := 2*GLOBALPER;
	constant COUNTUPDN_LP		: integer range 0 to 16383 := 150*GLOBALPRESCALER;
	constant COUNTUPDN_HP		: integer range 0 to 16383 := 152*GLOBALPRESCALER;

	-- Count Increment One	
	constant COUNTINCONE_L 		: integer range 0 to 16383 := 13*GLOBALPRESCALER;
	constant COUNTINCONE_H 		: integer range 0 to 16383 := 16*GLOBALPRESCALER;
	constant COUNTINCONE_G 		: integer range 0 to 16383 := 2*GLOBALPER;
	constant COUNTINCONE_LP 	: integer range 0 to 16383 := 148*GLOBALPRESCALER;
	constant COUNTINCONE_HP 	: integer range 0 to 16383 := 149*GLOBALPRESCALER;

	-- Count Johnson Shift Enable
	constant COUNTJCSHIFTEN_L 	: integer range 0 to 16383 := 132*GLOBALPRESCALER;
	constant COUNTJCSHIFTEN_H 	: integer range 0 to 16383 := 141*GLOBALPRESCALER;
	constant COUNTJCSHIFTEN_G 	: integer range 0 to 16383 := GLOBALPER;
	constant COUNTJCSHIFTEN_LP	: integer range 0 to 16383 := 318*GLOBALPRESCALER; -- out of range
	constant COUNTJCSHIFTEN_HP	: integer range 0 to 16383 := 327*GLOBALPRESCALER;

	-- Count LSB Enable
	constant COUNTLSBEN_L 		: integer range 0 to 16383 := 133*GLOBALPRESCALER;
	constant COUNTLSBEN_H 		: integer range 0 to 16383 := 140*GLOBALPRESCALER;
	constant COUNTLSBEN_G 		: integer range 0 to 16383 := GLOBALPER;
	constant COUNTLSBEN_LP		: integer range 0 to 16383 := 320*GLOBALPRESCALER; -- out of range
	constant COUNTLSBEN_HP		: integer range 0 to 16383 := 328*GLOBALPRESCALER;

	-- SRAM Write
	constant COUNTMEMWR_L 		: integer range 0 to 16383 := 0;
	constant COUNTMEMWR_H 		: integer range 0 to 16383 := 148*GLOBALPRESCALER;
	constant COUNTMEMWR_G 		: integer range 0 to 16383 := 2*GLOBALPER;

--|-------------------------|
--| DIGIF SERIALIZER TIMING |
--|-------------------------|

	-- Reset Serializer
	constant DIGIFRST_L : integer := 145*GLOBALPRESCALER;
	constant DIGIFRST_H : integer := 610*GLOBALPRESCALER;
	constant DIGIFRST_G : integer := 2*GLOBALPER;
	constant DIGIFRST_LP: integer := 145*GLOBALPER;
	constant DIGIFRST_HP: integer := 610*GLOBALPER;

--|-----------------------|
--| RAMP GENERATOR TIMING |
--|-----------------------|

	-- Ramp Reset Pulse
	-- d_ref_vref_ramp_rst 	--> NOT version of d_count_en
	
	-- Sample and Hold Vref --// d_ref_vref_sh
	constant VREFSH_L : integer := 131*GLOBALPRESCALER;
	constant VREFSH_H : integer := 180*GLOBALPRESCALER;
	constant VREFSH_G : integer := 1*GLOBALPER;

	-- Clamp enable 	--// d_ref_vref_clamp_en
	constant VREFCLAMPEN_L : integer := 181*GLOBALPRESCALER;
	constant VREFCLAMPEN_H : integer := 189*GLOBALPRESCALER;
	constant VREFCLAMPEN_G : integer := 1*GLOBALPER;

--|-------------------------------------------------------------------------------------------------------------|

--|------------------------|
--| BIT SIGNAL DECLARATION |
--|------------------------|

	signal pre_d_count_en  		: std_logic;
	signal pre_d_count_rst 		: std_logic;
	signal pre_d_count_inv_clk 	: std_logic;
	signal pre_d_count_hold 	: std_logic;
	signal pre_d_count_updn 	: std_logic;
	signal pre_d_count_inc_one 	: std_logic;
	signal pre_d_count_jc_shift_en 	: std_logic;
	signal pre_d_count_lsb_en 	: std_logic;
	signal pre_d_count_mem_wr 	: std_logic;


	signal pre_d_adc_shr_shs	: std_logic;	
	signal pre_d_shs		: std_logic;
	signal pre_d_shr		: std_logic;
	signal pre_d_ads		: std_logic;
	signal pre_d_adr		: std_logic;
	signal pre_d_comp_bias_sh	: std_logic;
	signal pre_d_comp_dyn_pon	: std_logic;

	signal pre_d_digif_serial_rst	: std_logic;

	signal pre_d_ref_vref_sh	: std_logic;
	signal pre_d_ref_vref_clamp_en	: std_logic;
	
	signal CLOCK_DIV_REG 		: std_logic_vector(17 downto 0);
	signal CLOCK_DIV 		: std_logic;
	signal LSB_CLOCK_DIV_REG 	: std_logic_vector(1 downto 0);
	signal LSB_CLOCK 		: std_logic;

begin

--|--------------------|
--| MAIN CLOCK DIVIDER |
--|--------------------|

clockdiv : process (CLOCK, RESET)		-- super aggresive clock prescaler so I can see the LEEDs blinking

	begin
		if RESET = '1' then
			CLOCK_DIV_REG <= (others => '0');
		elsif (CLOCK'event AND CLOCK = '1') then
			CLOCK_DIV_REG <= CLOCK_DIV_REG + 1;
		end if;
	end process;  
	
--	CLOCK_DIV <= CLOCK_DIV_REG(0); -- f/2
	CLOCK_DIV <= CLOCK;	-- bypass clock divider

--|---------------------------------------------------------------|

--|-------------------|
--| LSB CLOCK DIVIDER |
--|-------------------|

lsbclockdiv : process (CLOCK_DIV, RESET)

	begin
		if RESET = '1' then
			LSB_CLOCK_DIV_REG <= (others => '0');
		elsif (CLOCK_DIV'event AND CLOCK_DIV = '0') then
			LSB_CLOCK_DIV_REG <= LSB_CLOCK_DIV_REG + 1;
		end if;
	end process;  
	
	LSB_CLOCK <= LSB_CLOCK_DIV_REG(0); -- f/2

--|---------------------------------------------------------------|

			
   process(CLOCK_DIV, RESET)
	 
	variable d_count_en_cnt  		: integer range 0 to 16383 :=0;		-- counter variables, limit to 14-bit registers
	variable d_count_rst_cnt 		: integer range 0 to 16383 :=0;
	variable d_count_inv_clk_cnt 		: integer range 0 to 16383 :=0;
	variable d_count_hold_cnt		: integer range 0 to 16383 :=0;
	variable d_count_updn_cnt 		: integer range 0 to 16383 :=0;
	variable d_count_inc_one_cnt 		: integer range 0 to 16383 :=0;
	variable d_count_jc_shift_en_cnt 	: integer range 0 to 16383 :=0;
	variable d_count_lsb_en_cnt 		: integer range 0 to 16383 :=0;
	variable d_count_mem_wr_cnt 		: integer range 0 to 16383 :=0;

	variable d_adc_shr_shs_cnt 		: integer range 0 to 16383 :=0;
	variable d_shs_cnt			: integer range 0 to 16383 :=0;
	variable d_shr_cnt			: integer range 0 to 16383 :=0;
	variable d_ads_cnt			: integer range 0 to 16383 :=0;
	variable d_adr_cnt			: integer range 0 to 16383 :=0;

	variable d_comp_bias_sh_cnt		: integer range 0 to 16383 :=0;
	variable d_comp_dyn_pon_cnt		: integer range 0 to 16383 :=0;

	variable d_ref_vref_sh_cnt		: integer range 0 to 16383 :=0;
	variable d_ref_vref_clamp_en_cnt	: integer range 0 to 16383 :=0;

	variable d_digif_serial_rst_cnt		: integer range 0 to 16383 :=0;
	

	variable pre_d_adc_shr_shs_var 		: std_logic;	-- pre signal binary
	variable pre_d_shs_var			: std_logic;
	variable pre_d_shr_var			: std_logic;
	variable pre_d_ads_var			: std_logic;
	variable pre_d_adr_var			: std_logic;

	variable pre_d_comp_bias_sh_var		: std_logic;
	variable pre_d_comp_dyn_pon_var		: std_logic;

	variable pre_d_ref_vref_sh_var		: std_logic;
	variable pre_d_ref_vref_clamp_en_var	: std_logic;

	variable pre_d_digif_serial_rst_var	: std_logic;

	variable pre_d_count_en_var  		: std_logic;
	variable pre_d_count_rst_var 		: std_logic;
	variable pre_d_count_inv_clk_var 	: std_logic;
	variable pre_d_count_hold_var 		: std_logic;
	variable pre_d_count_updn_var 		: std_logic;
	variable pre_d_count_inc_one_var 	: std_logic;
	variable pre_d_count_jc_shift_en_var 	: std_logic;
	variable pre_d_count_lsb_en_var 	: std_logic;
	variable pre_d_count_mem_wr_var 	: std_logic;


	
	begin
	  
   if RESET = '1' then
	
	d_count_en_cnt			:=0;
	d_count_rst_cnt			:=0;
	d_count_inv_clk_cnt		:=0;
	d_count_hold_cnt		:=0;
	d_count_updn_cnt		:=0;
	d_count_inc_one_cnt		:=0;
	d_count_jc_shift_en_cnt		:=0;
	d_count_lsb_en_cnt		:=0;
	d_count_mem_wr_cnt		:=0;
	d_adc_shr_shs_cnt		:=0;
	d_shs_cnt			:=0;
	d_shr_cnt			:=0;
	d_ads_cnt			:=0;
	d_adr_cnt			:=0;
	d_comp_bias_sh_cnt		:=0;
	d_comp_dyn_pon_cnt		:=0;
	d_digif_serial_rst_cnt		:=0;
	d_ref_vref_sh_cnt		:=0;
	d_ref_vref_clamp_en_cnt		:=0;


	elsif (CLOCK_DIV = '1' and CLOCK_DIV'event) then

--|----------------------------|
--| GLOBAL PERIODIC SIGNALLING |
--|----------------------------|

	toggle(pre_d_count_en_var, COUNTEN_L, COUNTEN_H, GLOBALPER, d_count_en_cnt);
	toggle(pre_d_count_rst_var, COUNTRST_L, COUNTRST_H, COUNTRST_G, d_count_rst_cnt);
	toggle(pre_d_count_inv_clk_var, COUNTINVCLK_L, COUNTINVCLK_H, COUNTINVCLK_G, d_count_inv_clk_cnt);
	toggle(pre_d_count_hold_var, COUNTHOLD_L, COUNTHOLD_H, COUNTHOLD_G, d_count_hold_cnt);
	toggle(pre_d_count_mem_wr_var, COUNTMEMWR_L, COUNTMEMWR_H, COUNTMEMWR_G, d_count_mem_wr_cnt);
	toggle(pre_d_adc_shr_shs_var, SHRSHS_L, SHRSHS_H, SHRSHS_G, d_adc_shr_shs_cnt);
	toggle(pre_d_ref_vref_sh_var, VREFSH_L, VREFSH_H, VREFSH_G, d_ref_vref_sh_cnt);
	toggle(pre_d_ref_vref_clamp_en_var, VREFCLAMPEN_L, VREFCLAMPEN_H, VREFCLAMPEN_G, d_ref_vref_clamp_en_cnt);

--|----------------------------------------------------------------------------------------------------------------------------------------------------|

--|-----------------------------|
--| GLOBAL APERIODIC SIGNALLING |
--|-----------------------------|

	dualToggle(pre_d_shs_var, SHS_L, SHS_H, SHS_G, SHS_LP, SHS_HP, d_shs_cnt);
	dualToggle(pre_d_shr_var, SHR_L, SHR_H, SHR_G, SHR_LP, SHR_HP, d_shr_cnt);
	dualToggle(pre_d_ads_var, ADS_L, ADS_H, ADS_G, ADS_LP, ADS_HP, d_ads_cnt);
	dualToggle(pre_d_adr_var, ADR_L, ADR_H, ADR_G, ADR_LP, ADR_HP, d_adr_cnt);

	dualToggle(pre_d_comp_dyn_pon_var, COMPDYNPON_L, COMPDYNPON_H, COMPDYNPON_G, COMPDYNPON_LP, COMPDYNPON_HP, d_comp_dyn_pon_cnt);
	dualToggle(pre_d_comp_bias_sh_var, COMPBIASSH_L, COMPBIASSH_H, COMPBIASSH_G, COMPBIASSH_LP, COMPBIASSH_HP, d_comp_bias_sh_cnt);

	dualToggle(pre_d_count_updn_var, COUNTUPDN_L, COUNTUPDN_H, COUNTUPDN_G, COUNTUPDN_LP, COUNTUPDN_HP, d_count_updn_cnt);
	dualToggle(pre_d_count_inc_one_var, COUNTINCONE_L, COUNTINCONE_H, COUNTINCONE_G, COUNTINCONE_LP, COUNTINCONE_HP, d_count_inc_one_cnt);
	dualToggle(pre_d_count_jc_shift_en_var, COUNTJCSHIFTEN_L, COUNTJCSHIFTEN_H, COUNTJCSHIFTEN_G, COUNTJCSHIFTEN_LP, COUNTJCSHIFTEN_HP, d_count_jc_shift_en_cnt );
	dualToggle(pre_d_count_lsb_en_var, COUNTLSBEN_L, COUNTLSBEN_H, COUNTLSBEN_G, COUNTLSBEN_LP, COUNTLSBEN_HP, d_count_lsb_en_cnt );

	dualToggle(pre_d_digif_serial_rst_var, DIGIFRST_L, DIGIFRST_H, DIGIFRST_G, DIGIFRST_LP, DIGIFRST_HP, d_digif_serial_rst_cnt);

--|----------------------------------------------------------------------------------------------------------------------------------------------------|

	
	end if;

--|------------------------------------|
--| BIT VARIABLE TO SIGNAL ASSIGNMENTS |
--|------------------------------------|

	pre_d_count_en			<=	pre_d_count_en_var;
	pre_d_count_rst			<= 	not pre_d_count_rst_var;
	pre_d_count_inv_clk		<=	pre_d_count_inv_clk_var;
	pre_d_count_hold		<=	pre_d_count_hold_var;
	pre_d_count_updn		<=	not pre_d_count_updn_var;
	pre_d_count_inc_one		<= 	not pre_d_count_inc_one_var;
	pre_d_count_jc_shift_en		<= 	pre_d_count_jc_shift_en_var;
	pre_d_count_lsb_en		<= 	pre_d_count_lsb_en_var;
	pre_d_count_mem_wr		<= 	pre_d_count_mem_wr_var;
	pre_d_adc_shr_shs		<= 	pre_d_adc_shr_shs_var;
	pre_d_shs			<= 	pre_d_shs_var;
	pre_d_shr			<= 	pre_d_shr_var;
	pre_d_ads			<= 	pre_d_ads_var;
	pre_d_adr			<= 	pre_d_adr_var;
	pre_d_comp_bias_sh		<= 	pre_d_comp_bias_sh_var;
	pre_d_comp_dyn_pon		<= 	pre_d_comp_dyn_pon_var;	
	pre_d_digif_serial_rst		<=	pre_d_digif_serial_rst_var;
	pre_d_ref_vref_sh		<=	pre_d_ref_vref_sh_var;
	pre_d_ref_vref_clamp_en		<=	pre_d_ref_vref_clamp_en_var;

	end process;
	
 d_count_en 		<= 	pre_d_count_en;
 d_count_rst 		<= 	pre_d_count_rst;
 d_count_inv_clk 	<= 	pre_d_count_inv_clk;
 d_count_hold 		<= 	pre_d_count_hold;
 d_count_updn 		<= 	pre_d_count_updn;
 d_count_inc_one 	<= 	pre_d_count_inc_one;
 d_count_jc_shift_en 	<= 	pre_d_count_jc_shift_en;
 d_count_lsb_en 	<= 	pre_d_count_lsb_en;
 d_count_lsb_clk 	<= not (LSB_CLOCK and d_count_lsb_en);
 d_count_mem_wr 	<= 	pre_d_count_mem_wr;

 d_digif_serial_rst	<=	pre_d_digif_serial_rst;

 d_adc_shr_shs 		<= 	pre_d_adc_shr_shs;
 d_shs 			<= 	pre_d_shs;
 d_shr 			<= 	pre_d_shr;
 d_ads 			<= 	pre_d_ads;
 d_adr 			<= 	pre_d_adr;
 d_comp_bias_sh 	<= 	pre_d_comp_bias_sh;
 d_comp_dyn_pon 	<= 	'1'; -- pre_d_comp_dyn_pon // stuck high for now
 
 d_ref_vref_ramp_rst	<=  not d_count_en;
 d_ref_vref_sh		<= 	pre_d_ref_vref_sh;
 d_ref_vref_clamp_en	<=	pre_d_ref_vref_clamp_en;
 d_ref_vref_ramp_ota_dyn_pon <= '1'; -- pre_d_ref_vref_ramp_ota_dyn_pon // stuck high for now

end Behavioral;
