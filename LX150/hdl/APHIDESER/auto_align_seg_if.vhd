library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.std_logic_arith.all;
use IEEE.NUMERIC_STD.ALL;
use WORK.FUNCTIONS_PKG.all;


library UNISIM;
use UNISIM.VComponents.all;


entity AUTO_ALIGN_SEG_IF is
  generic (
    G_SIMULATION:               boolean:= false;                                -- simulation mode
    G_INVERT_LSB:               boolean:= false;                                -- invert LSB sensor data
    C_TP:                       std_logic_vector:=x"D3D3D3D3");                 -- training pattern
  port (
    -- system signals
    RESET:                      in  std_logic;                                  -- async. reset
    ENABLE:                     in  std_logic;                                  -- module activation
    IO_CLK:                     in  std_logic;                                  -- bit clock
    DIV_CLK:                    in  std_logic;                                  -- bit clock / 4
    BYTE_CLK:                   in  std_logic;                                  -- word clock
    SERDESSTROBE_IN:            in  std_logic;                                  -- strobe to ISERDES
    SEG_DATA:                   in  std_logic;                                  -- serial data for segment LS-Byte (LVDS+)
    -- image data interface
    DATA:                       out std_logic_vector(5 downto 0);              -- data output
    DATA_EN:                    out std_logic;                                  -- DATA_IN data valid
    -- debug
    DEBUG_IN:                   in  std_logic_vector(7 downto 0);
    DEBUG_OUT:                  out std_logic_vector(11 downto 0));
end entity AUTO_ALIGN_SEG_IF;


architecture STRUCTURAL of AUTO_ALIGN_SEG_IF is

component SAMPLING
  generic (
    -- width of the data for the system
    sys_w:                      integer := 1;
    -- width of the data for the device
    dev_w:                      integer := 4);
  port (
    DELAY_INC:                  in  std_logic;
    DELAY_CE:                   in  std_logic;
    DISABLE_PD:                 in  std_logic;                                  -- disable phase detector
    -- From the system into the device
    DATA_IN_FROM_PINS:          in  std_logic_vector(sys_w-1 downto 0);
    DATA_IN_TO_DEVICE:          out std_logic_vector(dev_w-1 downto 0);
    DEBUG_IN:                   in  std_logic_vector (1 downto 0);              -- Input debug data. Tie to "00" if not used
    DEBUG_OUT:                  out std_logic_vector ((3*sys_w)+5 downto 0);    -- Ouput debug data. Leave NC if not required
    -- Clock and reset signals
    CLK_IN:                     in  std_logic;                                  -- Fast clock from PLL/MMCM
    CLK_DIV_IN:                 in  std_logic;                                  -- Slow clock from PLL/MMCM
    SERDESSTROBE_IN:            in  std_logic;                                  -- strobe to ISERDES
    IO_RESET:                   in  std_logic);                                 -- Reset signal for IO circuit
end component SAMPLING;


component DESERIALIZER is
  generic (
    G_N:                        positive:=6);                                   -- output data width
  port (
    RESET:                      in    std_logic;                                -- async. reset
    CLOCK:                      in    std_logic;                                -- system clock
    DIV_CLOCK:                  in    std_logic;                                -- slow clock from sampling
    DATA_IN:                    in    std_logic_vector(3 downto 0);             -- 4-bit data input
    BITSLIP:                    in    std_logic;                                -- enables bitslip operation
    DATA_OUT_EN:                out   std_logic;                                -- '1' = DATA_OUT valid
    DATA_OUT:                   out   std_logic_vector(G_N-1 downto 0));        -- parallel data output
end component DESERIALIZER;

signal I_SEG_LSB:               std_logic;
signal I_SAMPLING_LSB_OUT:      std_logic_vector(3 downto 0);
signal I_DESER_LSB_IN:          std_logic_vector(3 downto 0);
signal I_BITSLIP_LSB_EN:        std_logic:='0';
signal I_DESER_LSB_OUT_EN:      std_logic;
signal I_DESER_LSB_OUT:         std_logic_vector(5 downto 0);

signal I_DEBUG_IN0_1: std_logic;
signal I_DEBUG_IN0_2: std_logic;
signal I_DATA:                  std_logic_vector(5 downto 0);
signal I_DATA_EN:               std_logic;
signal IO_CLK_N:			std_logic;

begin

IO_CLK_N <= not IO_CLK;
	
I_SAMPLING_LSB: SAMPLING
  generic map (
    -- width of the data for the system
    sys_w                       => 1,
    -- width of the data for the device
    dev_w                       => 4)
  port map (
    DELAY_INC                   => '0',
    DELAY_CE                    => '0',
    DISABLE_PD                  => '0',                                         -- disable phase detector
    -- From the system into the device
    DATA_IN_FROM_PINS(0)        => SEG_DATA,
    DATA_IN_TO_DEVICE           => I_SAMPLING_LSB_OUT,
    DEBUG_IN                    => "00",                                        -- Input debug data. Tie to "00" if not used
    DEBUG_OUT                   => open,                                        -- Ouput debug data. Leave NC if not required
    -- Clock and reset signals
    CLK_IN                      => IO_CLK_N, --IO_CLK,                                      -- Fast clock from PLL/MMCM
    CLK_DIV_IN                  => DIV_CLK,                                     -- Slow clock from PLL/MMCM
    SERDESSTROBE_IN             => SERDESSTROBE_IN,                             -- strobe to ISERDES
    IO_RESET                    => RESET);                                      -- Reset signal for IO circuit


I_DESER_LSB_IN <= (not I_SAMPLING_LSB_OUT) when G_INVERT_LSB else I_SAMPLING_LSB_OUT;


I_DESERIALIZER_LSB: DESERIALIZER
  generic map (
    G_N                         => 6)                                           -- output data width
  port map (
    RESET                       => RESET,                                       -- async. reset
    CLOCK                       => BYTE_CLK,                                    -- system clock
    DIV_CLOCK                   => DIV_CLK,                                     -- slow clock from sampling
    DATA_IN                     => I_DESER_LSB_IN,                              -- 5-bit data input
    BITSLIP                     => I_BITSLIP_LSB_EN,                            -- enables bitslip operation
    DATA_OUT_EN                 => I_DESER_LSB_OUT_EN,                          -- '1' = DATA_OUT valid
    DATA_OUT                    => I_DESER_LSB_OUT);                            -- parallel data output

--------------------------------------------------------------------------------
-- output register
--------------------------------------------------------------------------------
OUTREG: process(RESET,BYTE_CLK)
begin
  if (RESET = '1') then
    I_DATA    <= (others => '0');
    I_DEBUG_IN0_1 <= '0';
    I_DEBUG_IN0_2 <= '0';
  elsif (rising_edge(BYTE_CLK)) then
    I_DATA    <= I_DESER_LSB_OUT;
    I_DEBUG_IN0_1 <= DEBUG_IN(0);
    I_DEBUG_IN0_2 <= I_DEBUG_IN0_1;
  end if;
end process OUTREG;

I_BITSLIP_LSB_EN <= I_DEBUG_IN0_1 and not I_DEBUG_IN0_2;

DATA    <= I_DATA;
DATA_EN <= '1';

DEBUG_OUT <= (others => '0');

end STRUCTURAL;
