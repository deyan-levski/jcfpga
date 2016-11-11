--------------------------------------------------------------------------------
-- AWAIBA GmbH
--------------------------------------------------------------------------------
-- MODUL NAME:  FUNCTIONS_PKG
-- FILENAME:    functions_pkg.vhd
-- AUTHOR:      Michael Heil - Ing. Büro für FPGA-Logic-Design
--              email:  michael.heil@fpga-logic-design.de
--
-- CREATED:     12.11.2009
--------------------------------------------------------------------------------
-- DESCRIPTION: Package for definition of functions
--
--
--------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------
-- REVISIONS:
-- DATE         VERSION    AUTHOR      DESCRIPTION
-- 09.06.2011   01         M. Heil     Initial version
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


package FUNCTIONS_PKG is

function log2(X: integer) return integer;
function max(a,b: integer) return integer;
function and_vector_bits(X: std_logic_vector) return std_logic;

end package;


package body FUNCTIONS_PKG is

function log2(X: integer) return integer is
variable N: integer:= 1;
variable R: integer:= 0;
begin
    while (N < X) loop
      N := N * 2;
      R := R + 1;
    end loop;
    if (X <= 1) then
      return 0;
    else
      return R;
    end if;
end function log2;

function max(a,b: integer) return integer is
begin
  if (a > b) then
    return a;
  else
    return b;
  end if;
end function max;

function and_vector_bits(X: std_logic_vector) return std_logic is
variable temp: std_logic:='1';
begin
  for i in X'range loop
    temp := temp and X(i);
  end loop;
  return temp;
end function and_vector_bits;


end package body FUNCTIONS_PKG;

