--------------------------------------------------------------------------------
-- Example: 
-- 		* Connection between segment interface and auto bitslip
--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
-- data sampling, segment 1, LVDS A
--------------------------------------------------------------------------------
I_SEG1_A_SAMPLING: OPTO_SEG_IF
  generic map (
    G_SIMULATION           => false,						         -- simulation mode
    C_TP                   => x"F0F0F0F0")					      -- training pattern
  port map (
	 G_INVERT_MSB           => B_INVERT_MSB_0,				      -- invert MSB sensor data
    G_INVERT_LSB           => B_INVERT_LSB_0,				      -- invert LSB sensor data
    -- system signals
    RESET                  => I_RESET or (not I_N_RST_LOGIC),  -- async. reset
    ENABLE                 => '1',                             -- module activation
    IO_CLK                 => I_IO_CLK,                        -- bit clock
    DIV_CLK                => I_DIV_CLK,                       -- bit clock / 4
    BYTE_CLK               => I_BYTE_CLK,                      -- word clock
    SERDESSTROBE_IN        => I_SERDESSTROBE,                  -- strobe to ISERDES
    -- connect to NanEyeGS image sensor
    SEG_MSB_P              => MSB_A_SEG1_P,                    -- serial data for segment MS-Byte (LVDS+)
    SEG_MSB_N              => MSB_A_SEG1_N,                    -- serial data for segment MS-Byte (LVDS-)
    SEG_LSB_P              => LSB_A_SEG1_P,                    -- serial data for segment LS-Byte (LVDS+)
    SEG_LSB_N              => LSB_A_SEG1_N,                    -- serial data for segment LS-Byte (LVDS+)
    -- image data interface
    DATA                   => I_IMAGE_DATA_SEG1_A,             -- data output
    DATA_EN                => open,                            -- DATA_IN data valid
    -- debug
	 DIV_CLK_CS             => open,
    DEBUG_IN               => (("000000" & I_BIT_SLIP_POS(1 downto 0)) or ("000000" & I_BIT_SLIP_POS_AUTO(1 downto 0))),
    DEBUG_OUT              => I_SAMPLING_DEBUG);
	 
	

--------------------------------------------------------------------------------
-- Automatic Bit Slip Process
--------------------------------------------------------------------------------
BIT_SLIP_SEG1A_PROC: process(I_RESET,I_BYTE_CLK,I_N_RST_LOGIC)
begin
	if ((I_RESET = '1') or (I_N_RST_LOGIC = '0')) then
		I_BIT_SLIP_1A_LSB_FLAG <= '0';
		I_BIT_SLIP_1A_MSB_FLAG <= '0';
		--
		I_BIT_SLIP_POS_AUTO(1 downto 0) <= (others => '0');
	elsif (rising_edge(I_BYTE_CLK)) then
		if (I_BIT_SLIP_AUTO ='1') then
			if ((I_LVAL_1K_SEG1_DLY(9) = '0') and (I_BIT_SLIP_1A_LSB_FLAG = '0')) then
				if (I_IMAGE_DATA_SEG1_A(7 downto 0) = x"AB") then
					I_BIT_SLIP_POS_AUTO(0) <= '0';
				else
					I_BIT_SLIP_POS_AUTO(0) <= '1';
				end if;
				I_BIT_SLIP_1A_LSB_FLAG <= '1';
			else
				I_BIT_SLIP_POS_AUTO(0) <= '0';
			end if;
			if (I_LVAL_1K_SEG1_DLY(9) = '0' and I_BIT_SLIP_1A_MSB_FLAG = '0') then
				if (I_IMAGE_DATA_SEG1_A(15 downto 8) = x"AB") then
					I_BIT_SLIP_POS_AUTO(1) <= '0';
				else
					I_BIT_SLIP_POS_AUTO(1) <= '1';
				end if;
				I_BIT_SLIP_1A_MSB_FLAG <= '1';
			else
				I_BIT_SLIP_POS_AUTO(1) <= '0';
			end if;
		else
			I_BIT_SLIP_POS_AUTO(1 downto 0) <= (others => '0');
			I_BIT_SLIP_1A_LSB_FLAG <= '0';
			I_BIT_SLIP_1A_MSB_FLAG <= '0';
		end if;
		if (LVAL_1K_SEG1 = '1') then
			I_BIT_SLIP_POS_AUTO(1 downto 0) <= (others => '0');
			I_BIT_SLIP_1A_LSB_FLAG <= '0';
			I_BIT_SLIP_1A_MSB_FLAG <= '0';
		end if;
	end if;
end process BIT_SLIP_SEG1A_PROC;