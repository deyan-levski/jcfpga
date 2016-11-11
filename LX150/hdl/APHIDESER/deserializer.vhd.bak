--------------------------------------------------------------------------------
-- AWAIBA GmbH
--------------------------------------------------------------------------------
-- MODUL NAME:  DESERIALIZER
-- FILENAME:    deserializer.vhd
-- AUTHOR:      
--             
--
-- CREATED:     29.04.2010
--------------------------------------------------------------------------------
-- DESCRIPTION: Deserializer (shifts in G_N/4 4-bit packets to form a G_N-bit
--              vector) and bitslip-function
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


entity DESERIALIZER is
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
end entity DESERIALIZER;


architecture RTL of DESERIALIZER is

subtype T_CNT is integer range 0 to G_N-1;

signal I_SREG:                  std_logic_vector(2*G_N-1 downto 0);
signal I_PREG:                  std_logic_vector(2*G_N-1 downto 0);
signal I_PDAT_OUT:              std_logic_vector(G_N-1 downto 0);


begin
--------------------------------------------------------------------------------
-- shift register
--------------------------------------------------------------------------------
SREG_EVAL: process(RESET,DIV_CLOCK)
begin
  if (RESET = '1') then
    I_SREG <= (others => '0');
  elsif (rising_edge(DIV_CLOCK)) then
    I_SREG(3 downto 0)  <= DATA_IN;
    I_SREG(11 downto 4) <= I_SREG(7 downto 0);   --I_SREG(2*G_N-1 downto 5) <= I_SREG(2*G_N-5 downto 0);  
  end if;
end process SREG_EVAL;


--------------------------------------------------------------------------------
-- parallel register
--------------------------------------------------------------------------------
PREG_INT_EVAL: process(RESET,CLOCK)
begin
  if (RESET = '1') then
    I_PREG <= (others => '0');
  elsif (rising_edge(CLOCK)) then
    I_PREG <= I_SREG;
  end if;
end process PREG_INT_EVAL;


--------------------------------------------------------------------------------
-- parallel output register
--------------------------------------------------------------------------------
PDAT_OUT_EVAL: process(RESET,CLOCK)
variable v_pdat_index:  T_CNT;
begin
  if (RESET = '1') then
    I_PDAT_OUT <= (others => '0');
    v_pdat_index := 0;
  elsif (rising_edge(CLOCK)) then
    if (BITSLIP = '1') then
      if (v_pdat_index = G_N-1) then
        v_pdat_index := 0;
      else
        v_pdat_index := v_pdat_index + 1;
      end if;
    end if;
    I_PDAT_OUT <= I_PREG(v_pdat_index+G_N-1 downto v_pdat_index);
  end if;
end process PDAT_OUT_EVAL;


DATA_OUT_EN <= '1';
DATA_OUT    <= I_PDAT_OUT;

end RTL;

