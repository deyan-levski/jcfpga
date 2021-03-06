-- file: sampling.vhd
-- (c) Copyright 2009 - 2010 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
------------------------------------------------------------------------------
-- User entered comments
------------------------------------------------------------------------------
-- None
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_misc.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

entity sampling is
generic
 (-- width of the data for the system
  sys_w       : integer := 1;
  -- width of the data for the device
  dev_w       : integer := 4);
port
 (
  DELAY_INC:            in  std_logic;
  DELAY_CE:             in  std_logic;
  DISABLE_PD:           in  std_logic;      -- disable phase detector
  -- From the system into the device
  DATA_IN_FROM_PINS       : in    std_logic_vector(sys_w-1 downto 0);
  DATA_IN_TO_DEVICE       : out   std_logic_vector(dev_w-1 downto 0);

  DEBUG_IN                : in    std_logic_vector (1 downto 0);       -- Input debug data. Tie to "00" if not used
  DEBUG_OUT               : out   std_logic_vector ((3*sys_w)+5 downto 0); -- Ouput debug data. Leave NC if not required
-- Clock and reset signals
  CLK_IN                  : in    std_logic;                    -- Fast clock from PLL/MMCM
  CLK_DIV_IN              : in    std_logic;                    -- Slow clock from PLL/MMCM
  SERDESSTROBE_IN         : in    std_logic;                    -- strobe to ISERDES
  IO_RESET                : in    std_logic);                   -- Reset signal for IO circuit
end sampling;

architecture xilinx of sampling is
  attribute CORE_GENERATION_INFO            : string;
  attribute CORE_GENERATION_INFO of xilinx  : architecture is "sampling,selectio_wiz_v1_5,{component_name=sampling,bus_dir=INPUTS,bus_sig_type=DIFF,bus_io_std=LVDS_25,use_serialization=true,use_phase_detector=false,serialization_factor=4,enable_bitslip=false,enable_train=false,system_data_width=1,bus_in_delay=NONE,bus_out_delay=NONE,clk_sig_type=SINGLE,clk_io_std=LVCMOS33,clk_buf=BUFPLL,active_edge=RISING,clk_delay=NONE,v6_bus_in_delay=NONE,v6_bus_out_delay=NONE,v6_clk_buf=BUFIO,v6_active_edge=NOT_APP,v6_ddr_alignment=SAME_EDGE_PIPELINED,v6_oddr_alignment=SAME_EDGE,ddr_alignment=C0,v6_interface_type=NETWORKING,interface_type=RETIMED,v6_bus_in_tap=0,v6_bus_out_tap=0,v6_clk_io_std=LVCMOS18,v6_clk_sig_type=DIFF}";
  constant clock_enable            : std_logic := '1';
  signal clk_in_int_buf            : std_logic;
  signal clk_div_in_int            : std_logic;


  -- After the buffer
  signal data_in_from_pins_int     : std_logic_vector(sys_w-1 downto 0);
  -- Between the delay and serdes
  signal data_in_from_pins_delay_m   : std_logic_vector(sys_w-1 downto 0);
  signal data_in_from_pins_delay_s   : std_logic_vector(sys_w-1 downto 0);
  constant num_serial_bits         : integer := dev_w/sys_w;
  type serdarr is array (0 to 7) of std_logic_vector(sys_w-1 downto 0);
  -- Array to use intermediately from the serdes to the internal
  --  devices. bus "0" is the leftmost bus
  -- * fills in starting with 0
  signal iserdes_q                 : serdarr := (( others => (others => '0')));
  signal icascade                 : std_logic_vector(sys_w-1 downto 0);

  signal pd_edge                   :    std_logic_vector(sys_w-1 downto 0);
  signal pd_clk                    :    std_logic;
  signal pd_busy                   :    std_logic_vector(sys_w-1 downto 0);
  signal pd_data_inc               :    std_logic_vector(sys_w-1 downto 0);
  signal pd_data_ce                :    std_logic_vector(sys_w-1 downto 0);
  signal pd_cal_master             :    std_logic;
  signal pd_cal_slave              :    std_logic;
  signal pd_cal_rst                :    std_logic;
  signal pd_valid                  :    std_logic_vector(sys_w-1 downto 0);
  signal I_ISERDES_M_VALID         :    std_logic_vector(sys_w-1 downto 0);
  signal pd_inc_dec                :    std_logic_vector(sys_w-1 downto 0);

signal  I_DELAY_INC: std_logic;
signal  I_DELAY_CE_IN1 : std_logic;
signal  I_DELAY_CE_IN2 : std_logic;
signal  I_DELAY_CE_IN3 : std_logic;
signal  I_DELAY_CE : std_logic;


component phase_detector
           generic (
        D                       : integer := 1) ;                            -- Set the number of inputs
           port         (
        use_phase_detector      :  in std_logic ;                               -- Set generation of phase detector logic
        busy                    :  in std_logic_vector(D-1 downto 0) ;          -- BUSY inputs from phase detectors
        valid                   :  in std_logic_vector(D-1 downto 0) ;          -- VALID inputs from phase detectors
        inc_dec                 :  in std_logic_vector(D-1 downto 0) ;          -- INC_DEC inputs from phase detectors
        reset                   :  in std_logic ;                               -- Reset line
        gclk                    :  in std_logic ;                               -- Global clock
        debug_in                :  in std_logic_vector(1 downto 0) ;            -- input debug data
        debug                   : out std_logic_vector((3*D)+5 downto 0) ;      -- Debug bus, 3D+5 = 3 lines per input (from inc, mux and ce) + 6, leave                                                                                 --  nc if debug not required
        cal_master              : out std_logic ;                               -- Output to cal pins on master iodelay2
        cal_slave               : out std_logic ;                               -- Output to cal pins on slave iodelay2
        rst_out                 : out std_logic ;                               -- Output to rst pins on master & slave iodelay2
        ce                      : out std_logic_vector(D-1 downto 0) ;          -- Output to ce pins on iodelay2
        inc                     : out std_logic_vector(D-1 downto 0)) ;         -- Output to inc pins on iodelay2
end component ;


begin




  -- Create the clock logic

   --bufpll_inst : BUFPLL
   -- generic map (
   --   DIVIDE        => 4)
   -- port map (
   --   IOCLK        => clk_in_int_buf,
   --   LOCK         => LOCKED_OUT,
   --   SERDESSTROBE => serdesstrobe,
   --   GCLK         => CLK_DIV_IN,  -- GCLK pin must be driven by BUFG
   --   LOCKED       => LOCKED_IN,
   --   PLLIN        => CLK_IN);


  -- We have multiple bits- step over every bit, instantiating the required elements
  pins: for pin_count in 0 to sys_w-1 generate
  begin
    -- Instantiate the buffers
    ----------------------------------
    -- Instantiate a buffer for every bit of the data bus
     --ibufds_inst : IBUFDS
     --  generic map (
     --    DIFF_TERM  => FALSE,             -- Differential termination
     --    IOSTANDARD => "LVDS_25")
     --  port map (
     --    I          => DATA_IN_FROM_PINS_P  (pin_count),
     --    IB         => DATA_IN_FROM_PINS_N  (pin_count),
     --    O          => data_in_from_pins_int(pin_count));

  data_in_from_pins_int <= DATA_IN_FROM_PINS;

-- DELAY_CE synchronization
process(IO_RESET,CLK_DIV_IN)
begin
  if (IO_RESET = '1') then
    I_DELAY_CE_IN1 <= '0';
    I_DELAY_CE_IN2 <= '0';
    I_DELAY_CE_IN3 <= '0';
  elsif (rising_edge(CLK_DIV_IN)) then
    I_DELAY_CE_IN1 <= DELAY_CE;
    I_DELAY_CE_IN2 <= I_DELAY_CE_IN1;
    I_DELAY_CE_IN3 <= I_DELAY_CE_IN2;
  end if;
end process;

I_DELAY_CE <= I_DELAY_CE_IN2 and not I_DELAY_CE_IN3;


I_DELAY_INC <= DELAY_INC and I_DELAY_CE;

  iodelay2_bus_m  : IODELAY2
    generic map (
      DATA_RATE                => "SDR",
      IDELAY_VALUE             => 0,
      IDELAY_TYPE              => "DIFF_PHASE_DETECTOR", --"VARIABLE_FROM_ZERO",
      COUNTER_WRAPAROUND       => "WRAPAROUND",
      DELAY_SRC                => "IDATAIN",
      SERDES_MODE              => "MASTER",
      SIM_TAPDELAY_VALUE       => 49)
  port map (
        IDATAIN  	       => data_in_from_pins_int  (pin_count),
  TOUT     	       => open,
  DOUT     	       => open,
  T        	       => '1',
  ODATAIN  	       => '0',
  DATAOUT  	       => data_in_from_pins_delay_m(pin_count),
  DATAOUT2 	       => open,
        IOCLK0                 => CLK_IN,
        IOCLK1                 => '0',
        CLK                    => CLK_DIV_IN,

  CAL      	       => pd_cal_master,
  INC      	       => pd_data_inc(pin_count),
  CE       	       => pd_data_ce(pin_count),
  RST      	       => pd_cal_rst,
  BUSY      	       => open);

iodelay2_bus_s  : IODELAY2
      generic map (
        DATA_RATE                => "SDR",
        IDELAY_VALUE             => 0,
        IDELAY_TYPE              => "DIFF_PHASE_DETECTOR", --"VARIABLE_FROM_ZERO",
        COUNTER_WRAPAROUND       => "WRAPAROUND",
        DELAY_SRC                => "IDATAIN",
        SERDES_MODE              => "SLAVE",
        SIM_TAPDELAY_VALUE       => 49)
      port map (
        IDATAIN                  => data_in_from_pins_int  (pin_count),
        TOUT                     => open,
        DOUT                     => open,
        T                        => '1',
        ODATAIN                  => '0',
        DATAOUT                  => data_in_from_pins_delay_s(pin_count),
        DATAOUT2                 => open,
        IOCLK0                   => CLK_IN,
        IOCLK1                   => '0',
        CLK                    => CLK_DIV_IN,

        CAL                      => pd_cal_slave,
        INC                      => pd_data_inc(pin_count),
        CE                       => pd_data_ce(pin_count),
        RST                      => pd_cal_rst,
        BUSY                     => pd_busy(pin_count) );


     -- Instantiate the serdes primitive
     ----------------------------------
     -- declare the iserdes
     iserdes2_master : ISERDES2
       generic map (
         BITSLIP_ENABLE => FALSE,
         DATA_RATE      => "SDR",
         DATA_WIDTH     => 4,
         INTERFACE_TYPE => "RETIMED",
         SERDES_MODE    => "MASTER")
       port map (
         Q1         => iserdes_q(3)(pin_count),
         Q2         => iserdes_q(2)(pin_count),
         Q3         => iserdes_q(1)(pin_count),
         Q4         => iserdes_q(0)(pin_count),
        SHIFTOUT    => icascade(pin_count),-- 1-bit Cascade out signal for Master/Slave IO. In Phase Detector mode used to
                                          -- send slave sampled data.
        INCDEC      => pd_inc_dec(pin_count),  -- 1-bit Output of Phase Detector (Dummy in slave)

        VALID       => I_ISERDES_M_VALID(pin_count),   -- 1-bit Output of Phase Detector (Dummy in Slave). If the input data contains no
                                     -- edges (no info for the phase detector to work with) the VALID signal will go
                                     -- LOW to indicate that the fabric should ignore the INCDEC signal.
         BITSLIP    => '0',
         CE0        => clock_enable,   -- 1-bit Clock enable input
         CLK0       => CLK_IN, -- 1-bit IO Clock network input. Optionally Invertible. This is the primary clock
                                       -- input used when the clock doubler circuit is not engaged (see DATA_RATE
                                       -- attribute).
         CLK1       => '0',
         CLKDIV     => CLK_DIV_IN,
         D          => data_in_from_pins_delay_m(pin_count), -- 1-bit Input signal from IOB.
         IOCE       => SERDESSTROBE_IN,                       -- 1-bit Data strobe signal derived from BUFIO CE. Strobes data capture for
                                                          -- NETWORKING and NETWORKING_PIPELINES alignment modes.

         RST        => IO_RESET,        -- 1-bit Asynchronous reset only.
         SHIFTIN    => pd_edge(pin_count),


        -- unused connections
         FABRICOUT  => open,
         CFB0       => open,
         CFB1       => open,
         DFB        => open);



     iserdes2_slave : ISERDES2
       generic map (
         BITSLIP_ENABLE => FALSE,
         DATA_RATE      => "SDR",
         DATA_WIDTH     => 4,
         INTERFACE_TYPE => "RETIMED",
         SERDES_MODE    => "SLAVE")
       port map (
        Q1         => iserdes_q(7)(pin_count),	--(7)
        Q2         => iserdes_q(6)(pin_count),	--(6)
        Q3         => iserdes_q(5)(pin_count),	--(5)
        Q4         => iserdes_q(4)(pin_count),	--(4)
        INCDEC     => open,   -- 1-bit Output of Phase Detector (Dummy in slave)
        SHIFTOUT   => pd_edge(pin_count), -- 1-bit Cascade out signal for Master/Slave IO. In Phase Detector mode used to
                                      -- send slave sampled data.

        VALID      => open,    -- 1-bit Output of Phase Detector (Dummy in Slave). If the input data contains no
                                      -- edges (no info for the phase detector to work with) the VALID signal will go
                                      -- LOW to indicate that the fabric should ignore the INCDEC signal.
        BITSLIP    => '0',
        CE0        => clock_enable,   -- 1-bit Clock enable input
        CLK0       => CLK_IN, -- 1-bit IO Clock network input. Optionally Invertible. This is the primary clock
                                      -- input used when the clock doubler circuit is not engaged (see DATA_RATE
                                      -- attribute).
        CLK1       => '0',
        CLKDIV     => CLK_DIV_IN,
        D          => data_in_from_pins_delay_s(pin_count),            -- 1-bit Input signal from IOB.
        IOCE       => SERDESSTROBE_IN,   -- 1-bit Data strobe signal derived from BUFIO CE. Strobes data capture for
                                      -- NETWORKING and NETWORKING_PIPELINES alignment modes.

        RST        => IO_RESET,       -- 1-bit Asynchronous reset only.
        SHIFTIN    => icascade(pin_count),
        -- unused connections
        FABRICOUT  => open,
        CFB0       => open,
        CFB1       => open,
        DFB        => open);

     -- Concatenate the serdes outputs together. Keep the timesliced
     --   bits together, and placing the earliest bits on the right
     --   ie, if data comes in 0, 1, 2, 3, 4, 5, 6, 7, ...
     --       the output will be 3210, 7654, ...
     -------------------------------------------------------------

     in_slices: for slice_count in 0 to num_serial_bits-1 generate begin
        -- This places the first data in time on the right
        DATA_IN_TO_DEVICE(slice_count) <=
          iserdes_q(slice_count)(0);
        -- To place the first data in time on the left, use the
        --   following code, instead
        -- DATA_IN_TO_DEVICE(slice_count) <=
        --   iserdes_q(slice_count);
     end generate in_slices;


  end generate pins;


pd_valid <= I_ISERDES_M_VALID when (DISABLE_PD = '0') else (others => '0');

pd_inst : phase_detector
generic map (
        D                       => 1)

port map        (
        use_phase_detector      => '1',
        busy                    => pd_busy,
        valid                   => pd_valid,
        inc_dec                 => pd_inc_dec,
        reset                   => IO_RESET,
        gclk                    => CLK_DIV_IN,
        debug_in                => DEBUG_IN,
        debug                   => DEBUG_OUT,
        cal_master              => pd_cal_master,
        cal_slave               => pd_cal_slave,
        rst_out                 => pd_cal_rst,
        ce                      => pd_data_ce,
        inc                     => pd_data_inc);



end xilinx;



