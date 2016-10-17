--------------------------------------------------------------------------------
-- AWAIBA GmbH
--------------------------------------------------------------------------------
-- MODUL NAME:  IMAGE_OUT
-- FILENAME:    image_out.vhd
-- AUTHOR:      
--              
--
-- CREATED:     27.06.2012
--------------------------------------------------------------------------------
-- DESCRIPTION: Receives image data via the image interface and transfers it
--              to a 8-bit wide fifo interface.
--
--              Each frame is preceded by a header, which contains the
--              following information:
--
--              Byte 1:  0xCA
--              Byte 2:  0xFE
--              Byte 3:  0xBE
--              Byte 4:  0x97
--              Byte 5:  Header Length = 0x14
--              Byte 6:  Sensor ID
--              Byte 7:  Frame count
--              Byte 8:  Bits per pixel
--              Byte 9:  Number of columns (ms-byte)
--              Byte 10: Number of columns (ls-byte)
--              Byte 11: Number of rows (ms-byte)
--              Byte 12: Number of rows (ls-byte)
--              Byte 13: Status (ms-byte)
--              Byte 14: Status (ls-byte)
--              Byte 15: HW-ID
--              Byte 16: FPGA FW version
--              Byte 17: Timestamp (Bits 31..24)
--              Byte 18: Timestamp (Bits 24..16)
--              Byte 19: Timestamp (Bits 15..8)
--              Byte 20: Timestamp (Bits 7..0)
--
--              The header is followed by the image data field which is
--              organised as follows:
--
--              Byte 1:   Pixel(0,0) (ms-byte)
--              Byte 2:   Pixel(0,0) (ls-byte)
--              Byte 3:   Pixel(0,1) (ms-byte)
--              Byte 4:   Pixel(0,1) (ls-byte)
--              ...
--              Byte n:   Pixel(Number of rows-1,Number of columns-1) (ms-byte)
--              Byte n+1: Pixel(Number of rows-1,Number of columns-1) (ls-byte)
--
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
-- REVISIONS:
-- DATE         VERSION    AUTHOR      DESCRIPTION
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;


entity IMAGE_OUT is
  generic (
    G_CLK_PERIOD_PS:            integer:=10000;                                 -- clock period in picoseconds
    G_DATA_WIDTH:               integer:=16;                                    -- number of DATA_IN bits
    G_SENSOR_ID:                std_logic_vector(7 downto 0):=x"00";            -- sensor id
    G_HW_ID:                    std_logic_vector(7 downto 0):=x"00";            -- hardware id
    G_FW_VERS:                  std_logic_vector(7 downto 0):=x"00");           -- fpga firmware version
  port (
    -- system signals
    RESET:                      in  std_logic;                                  -- asynchronous reset
    CLOCK:                      in  std_logic;                                  -- system/wb clock
    ENABLE:                     in  std_logic;                                  -- module activation
    -- status inputs
    STATUS_IN:                  in  std_logic_vector(15 downto 0);              -- status information to transmit
    NO_COLS:                    in  std_logic_vector(15 downto 0);              -- number of columns
    NO_ROWS:                    in  std_logic_vector(15 downto 0);              -- number of rows
    -- image data interface
    FVAL_IN:                    in  std_logic;                                  -- frame valid input
    LVAL_IN:                    in  std_logic;                                  -- line valid input
    DATA_IN:                    in  std_logic_vector(G_DATA_WIDTH-1 downto 0);  -- data input
    DATA_IN_EN:                 in  std_logic;                                  -- DATA_IN data valid
    -- fifo write interface
    TX_FIFO_WREN:               out std_logic;                                  -- tx fifo write enable
    TX_FIFO_WRDAT:              out std_logic_vector(31 downto 0);              -- tx fifo write data
    --
    TEST:                       out std_logic);
end entity IMAGE_OUT;


architecture RTL of IMAGE_OUT is

component WORD2BYTE IS
  port (
    RST:                        in  std_logic;
    WR_CLK:                     in  std_logic;
    RD_CLK:                     in  std_logic;
    DIN:                        in  std_logic_vector(15 downto 0);
    WR_EN:                      in  std_logic;
    RD_EN:                      in  std_logic;
    DOUT:                       out std_logic_vector(7 downto 0);
    FULL:                       out std_logic;
    EMPTY:                      out std_logic);
end component WORD2BYTE;


constant C_US_CNT_MAX_VAL:      integer:=(1000000 / G_CLK_PERIOD_PS) - 1;
constant C_HEADER_LENGTH:       std_logic_vector(7 downto 0):= x"14";
constant C_ZEROES:              std_logic_vector(15 downto G_DATA_WIDTH):=(others => '0');

subtype T_US_CNT is integer range 0 to C_US_CNT_MAX_VAL;

type T_STATES is (IDLE,SYNC_ID1,SYNC_ID2,HL_SENSOR_ID,FCNT_BPP,COL_NBR,ROW_NBR,STATUS,HW_ID_VERS,
                  TIMESTAMP_MSB,TIMESTAMP_LSB,IMAGE_DATA,WAIT_CYCLE);

signal I_PRESENT_STATE:         T_STATES;
signal I_FRAME_CNT:             std_logic_vector(7 downto 0);
signal I_US_CNT:                T_US_CNT;
signal I_TIMESTAMP_CNT:         std_logic_vector(31 downto 0);
signal I_TIMESTAMP_REG:         std_logic_vector(31 downto 0);
signal I_TX_FIFO_WREN_WORD:     std_logic;
signal I_TX_FIFO_WRDAT_WORD:    std_logic_vector(15 downto 0);
signal I_WORD2BYTE_DOUT:        std_logic_vector(7 downto 0);
signal I_WORD2BYTE_EMPTY:       std_logic;
signal I_WORD2BYTE_RD_EN:       std_logic;
signal I_TX_FIFO_WRDAT:         std_logic_vector(31 downto 0);
signal I_TX_FIFO_WREN:          std_logic;
signal I_TX_FIFO_WREN_1:          std_logic;


begin

--------------------------------------------------------------------------------
-- fsm
--------------------------------------------------------------------------------
FSM: process(RESET,CLOCK)
begin
  if (RESET = '1') then
    I_PRESENT_STATE <= IDLE;
  elsif (rising_edge(CLOCK)) then
    case I_PRESENT_STATE is
--------------------------------------------------------------------------------
-- IDLE: waiting for ENABLE = '1' and FVAL_IN = '1'
--------------------------------------------------------------------------------
      when IDLE =>
        if ((ENABLE = '1') and (FVAL_IN = '1')) then
          I_PRESENT_STATE <= SYNC_ID1;
        else
          I_PRESENT_STATE <= I_PRESENT_STATE;
        end if;
--------------------------------------------------------------------------------
-- SYNC_ID1: transmit SYNC_ID (part 1)
--------------------------------------------------------------------------------
      when SYNC_ID1 =>
        if ((ENABLE = '1') and (FVAL_IN = '1')) then
          I_PRESENT_STATE <= SYNC_ID2;
        else
          I_PRESENT_STATE <= IDLE;
        end if;
--------------------------------------------------------------------------------
-- SYNC_ID2: transmit SYNC_ID2 (part 2)
--------------------------------------------------------------------------------
      when SYNC_ID2 =>
        if ((ENABLE = '1') and (FVAL_IN = '1')) then
          I_PRESENT_STATE <= HL_SENSOR_ID;
        else
          I_PRESENT_STATE <= IDLE;
        end if;
--------------------------------------------------------------------------------
-- HL_SENSOR_ID: transmit header length + sensor ID
--------------------------------------------------------------------------------
      when HL_SENSOR_ID =>
        if ((ENABLE = '1') and (FVAL_IN = '1')) then
          I_PRESENT_STATE <= FCNT_BPP;
        else
          I_PRESENT_STATE <= IDLE;
        end if;
--------------------------------------------------------------------------------
-- FCNT_BPP: transmit frame count and bits per pixel
--------------------------------------------------------------------------------
      when FCNT_BPP =>
        if ((ENABLE = '1') and (FVAL_IN = '1')) then
          I_PRESENT_STATE <= COL_NBR;
        else
          I_PRESENT_STATE <= IDLE;
        end if;
--------------------------------------------------------------------------------
-- COL_NBR: transmit the number of columns
--------------------------------------------------------------------------------
      when COL_NBR =>
        if ((ENABLE = '1') and (FVAL_IN = '1')) then
          I_PRESENT_STATE <= ROW_NBR;
        else
          I_PRESENT_STATE <= IDLE;
        end if;
--------------------------------------------------------------------------------
-- ROW_NBR: transmit the number of rows
--------------------------------------------------------------------------------
      when ROW_NBR =>
        if ((ENABLE = '1') and (FVAL_IN = '1')) then
          I_PRESENT_STATE <= STATUS;
        else
          I_PRESENT_STATE <= IDLE;
        end if;
--------------------------------------------------------------------------------
-- STATUS: transmit status
--------------------------------------------------------------------------------
      when STATUS =>
        if ((ENABLE = '1') and (FVAL_IN = '1')) then
          I_PRESENT_STATE <= HW_ID_VERS;
        else
          I_PRESENT_STATE <= IDLE;
        end if;
--------------------------------------------------------------------------------
-- HW_ID_VERS: transmit the hw-id and the firmware version
--------------------------------------------------------------------------------
      when HW_ID_VERS =>
        if ((ENABLE = '1') and (FVAL_IN = '1')) then
          I_PRESENT_STATE <= TIMESTAMP_MSB;
        else
          I_PRESENT_STATE <= IDLE;
        end if;
--------------------------------------------------------------------------------
-- TIMESTAMP_MSB: transmit the ms-word of the 32-bit timestamp value
--------------------------------------------------------------------------------
      when TIMESTAMP_MSB =>
        if ((ENABLE = '1') and (FVAL_IN = '1')) then
          I_PRESENT_STATE <= TIMESTAMP_LSB;
        else
          I_PRESENT_STATE <= IDLE;
        end if;
--------------------------------------------------------------------------------
-- TIMESTAMP_LSB: transmit the ls-word of the 32-bit timestamp value
--------------------------------------------------------------------------------
      when TIMESTAMP_LSB =>
        if ((ENABLE = '1') and (FVAL_IN = '1')) then
          I_PRESENT_STATE <= WAIT_CYCLE;
        else
          I_PRESENT_STATE <= IDLE;
        end if;
--------------------------------------------------------------------------------
-- WAIT_CYCLE
--------------------------------------------------------------------------------
      when WAIT_CYCLE =>
        if ((ENABLE = '1') and (FVAL_IN = '1')) then
          I_PRESENT_STATE <= IMAGE_DATA;
        else
          I_PRESENT_STATE <= IDLE;
        end if;
--------------------------------------------------------------------------------
-- IMAGE_DATA: transmit image data
--------------------------------------------------------------------------------
      when IMAGE_DATA =>
        if ((ENABLE = '1') and (FVAL_IN = '1')) then
          I_PRESENT_STATE <= I_PRESENT_STATE;
        else
          I_PRESENT_STATE <= IDLE;
        end if;
    end case;
  end if;
end process FSM;


--------------------------------------------------------------------------------
-- frame counter
--------------------------------------------------------------------------------
FRAME_CNT_EVAL: process(RESET,CLOCK)
begin
  if (RESET = '1') then
    I_FRAME_CNT <= (others => '0');
  elsif (rising_edge(CLOCK)) then
    if (ENABLE = '1') then
      if (I_PRESENT_STATE = HW_ID_VERS) then
        I_FRAME_CNT <= I_FRAME_CNT + "01";
      else
        I_FRAME_CNT <= I_FRAME_CNT;
      end if;
    else
      I_FRAME_CNT <= (others => '0');
    end if;
  end if;
end process FRAME_CNT_EVAL;


--------------------------------------------------------------------------------
-- time stamp prescale counter
--------------------------------------------------------------------------------
US_CNT_EVAL: process(RESET,CLOCK)
begin
  if (RESET = '1') then
    I_US_CNT <= 0;
  elsif (rising_edge(CLOCK)) then
    if (I_US_CNT = C_US_CNT_MAX_VAL) then
      I_US_CNT <= 0;
    else
      I_US_CNT <= I_US_CNT + 1;
    end if;
  end if;
end process US_CNT_EVAL;


--------------------------------------------------------------------------------
-- time stamp counter (counting period 1 µs)
--------------------------------------------------------------------------------
TS_CNT_EVAL: process(RESET,CLOCK)
begin
  if (RESET = '1') then
    I_TIMESTAMP_CNT <= (others => '0');
  elsif (rising_edge(CLOCK)) then
    if (ENABLE = '1') then
      if (I_US_CNT = C_US_CNT_MAX_VAL) then
        I_TIMESTAMP_CNT <= I_TIMESTAMP_CNT + "01";
      else
        I_TIMESTAMP_CNT <= I_TIMESTAMP_CNT;
      end if;
    else
      I_TIMESTAMP_CNT <= (others => '0');
    end if;
  end if;
end process TS_CNT_EVAL;


--------------------------------------------------------------------------------
-- register for the time stamp counter
--------------------------------------------------------------------------------
TS_CNT_REG_EVAL: process(RESET,CLOCK)
begin
  if (RESET = '1') then
    I_TIMESTAMP_REG <= (others => '0');
  elsif (rising_edge(CLOCK)) then
    if (ENABLE = '1') then
      if (I_PRESENT_STATE = SYNC_ID1) then
        I_TIMESTAMP_REG <= I_TIMESTAMP_CNT;
      else
        I_TIMESTAMP_REG <= I_TIMESTAMP_REG;
      end if;
    else
      I_TIMESTAMP_REG <= (others => '0');
    end if;
  end if;
end process TS_CNT_REG_EVAL;


--------------------------------------------------------------------------------
-- determine fifo write enable
--------------------------------------------------------------------------------
FIFO_WREN_EVAL: process(RESET,CLOCK)
begin
  if (RESET = '1') then
    I_TX_FIFO_WREN_WORD <= '0';
  elsif (rising_edge(CLOCK)) then
    case I_PRESENT_STATE is
      when IDLE           => I_TX_FIFO_WREN_WORD <= '0';
      when SYNC_ID1       => I_TX_FIFO_WREN_WORD <= '1';
      when SYNC_ID2       => I_TX_FIFO_WREN_WORD <= '1';
      when HL_SENSOR_ID   => I_TX_FIFO_WREN_WORD <= '1';
      when FCNT_BPP       => I_TX_FIFO_WREN_WORD <= '1';
      when COL_NBR        => I_TX_FIFO_WREN_WORD <= '1';
      when ROW_NBR        => I_TX_FIFO_WREN_WORD <= '1';
      when STATUS         => I_TX_FIFO_WREN_WORD <= '1';
      when HW_ID_VERS     => I_TX_FIFO_WREN_WORD <= '1';
      when TIMESTAMP_MSB  => I_TX_FIFO_WREN_WORD <= '1';
      when TIMESTAMP_LSB  => I_TX_FIFO_WREN_WORD <= '1';
      when WAIT_CYCLE     => I_TX_FIFO_WREN_WORD <= '0';
      when IMAGE_DATA     => I_TX_FIFO_WREN_WORD <= DATA_IN_EN and LVAL_IN;
    end case;
  end if;
end process FIFO_WREN_EVAL;


--------------------------------------------------------------------------------
-- determine fifo write data
--------------------------------------------------------------------------------
FIFO_WRDAT_EVAL: process(RESET,CLOCK)
begin
  if (RESET = '1') then
    I_TX_FIFO_WRDAT_WORD <= (others => '0');
  elsif (rising_edge(CLOCK)) then
    case I_PRESENT_STATE is
      when IDLE           => I_TX_FIFO_WRDAT_WORD <= (others => '0');
      when SYNC_ID1       => I_TX_FIFO_WRDAT_WORD <= x"CAFE";
      when SYNC_ID2       => I_TX_FIFO_WRDAT_WORD <= x"BE97";
      when HL_SENSOR_ID   => I_TX_FIFO_WRDAT_WORD <= C_HEADER_LENGTH & G_SENSOR_ID;
      when FCNT_BPP       => I_TX_FIFO_WRDAT_WORD <= I_FRAME_CNT & conv_std_logic_vector(G_DATA_WIDTH,8);
      when COL_NBR        => I_TX_FIFO_WRDAT_WORD <= NO_COLS;
      when ROW_NBR        => I_TX_FIFO_WRDAT_WORD <= NO_ROWS;
      when STATUS         => I_TX_FIFO_WRDAT_WORD <= STATUS_IN;
      when HW_ID_VERS     => I_TX_FIFO_WRDAT_WORD <= G_HW_ID & G_FW_VERS;
      when TIMESTAMP_MSB  => I_TX_FIFO_WRDAT_WORD <= I_TIMESTAMP_REG(31 downto 16);
      when TIMESTAMP_LSB  => I_TX_FIFO_WRDAT_WORD <= I_TIMESTAMP_REG(15 downto 0);
      when WAIT_CYCLE     => I_TX_FIFO_WRDAT_WORD <= I_TX_FIFO_WRDAT_WORD;
      when IMAGE_DATA     => I_TX_FIFO_WRDAT_WORD <= C_ZEROES & DATA_IN;
    end case;
  end if;
end process FIFO_WRDAT_EVAL;


--------------------------------------------------------------------------------
-- word to byte conversion
--------------------------------------------------------------------------------
I_WORD2BYTE: WORD2BYTE
  port map (
    RST                         => RESET,
    WR_CLK                      => CLOCK,
    RD_CLK                      => CLOCK,
    DIN                         => I_TX_FIFO_WRDAT_WORD,
    WR_EN                       => I_TX_FIFO_WREN_WORD,
    RD_EN                       => I_WORD2BYTE_RD_EN,
    DOUT                        => I_WORD2BYTE_DOUT,
    FULL                        => TEST,
    EMPTY                       => I_WORD2BYTE_EMPTY);

I_WORD2BYTE_RD_EN <= not I_WORD2BYTE_EMPTY;

TX_FIFO_WRDAT_GEN: process(RESET,CLOCK)
begin
  if (RESET = '1') then
    I_TX_FIFO_WRDAT <= (others => '0');
  elsif (rising_edge(CLOCK)) then
    if (I_PRESENT_STATE = IMAGE_DATA) then
      if ((DATA_IN_EN and LVAL_IN) = '1') then
        I_TX_FIFO_WRDAT(31 downto 16) <= I_TX_FIFO_WRDAT(15 downto 0);
        I_TX_FIFO_WRDAT(15 downto 0)  <= DATA_IN;
      end if;
    else
      if (I_TX_FIFO_WREN_WORD = '1') then
        I_TX_FIFO_WRDAT(31 downto 16) <= I_TX_FIFO_WRDAT(15 downto 0);
        I_TX_FIFO_WRDAT(15 downto 0)  <= I_TX_FIFO_WRDAT_WORD;
      end if;
    end if;
  end if;
end process TX_FIFO_WRDAT_GEN;


TX_FIFO_WREN_GEN: process(RESET,CLOCK)
begin
  if (RESET = '1') then
    I_TX_FIFO_WREN <= '0';
    I_TX_FIFO_WREN_1 <= '0';
  elsif (rising_edge(CLOCK)) then
    I_TX_FIFO_WREN_1 <= I_TX_FIFO_WREN;
    if (I_PRESENT_STATE = IMAGE_DATA) then
      if (LVAL_IN = '0') then
        I_TX_FIFO_WREN <= '0';
      elsif (DATA_IN_EN = '1') then
        I_TX_FIFO_WREN <= not I_TX_FIFO_WREN;
      end if;
    else
      if (FVAL_IN = '0') then
        I_TX_FIFO_WREN <= '0';
      elsif (I_TX_FIFO_WREN_WORD = '1') then
        I_TX_FIFO_WREN <= not I_TX_FIFO_WREN;
      end if;
    end if;
  end if;
end process TX_FIFO_WREN_GEN;


TX_FIFO_WREN  <= I_TX_FIFO_WREN_1;  --not I_WORD2BYTE_EMPTY;
TX_FIFO_WRDAT <= I_TX_FIFO_WRDAT; --I_TX_FIFO_WRDAT_WORD; --I_WORD2BYTE_DOUT;

end RTL;

