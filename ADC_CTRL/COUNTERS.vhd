--|------------------------------------------------------------------------------------|
--| Sequencer togglling counter functions                                              |
--|------------------------------------------------------------------------------------|
--| Version P1A - Initial version, Deyan Levski, deyan.levski@eng.ox.ac.uk, 09.09.2016 |
--|------------------------------------------------------------------------------------|
--|-+-|
--
--


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;

package COUNTERS is

   procedure toggle (
    pre_ut    : out std_logic;               
    BOUND_L   : in    integer;  
    BOUND_H   : in    integer;
    BOUND_G   : in    integer;
    cnt       : inout integer
    );
  
   procedure dualtoggle (
    pre_ut    : out std_logic;               
    BOUND_L   : in    integer;  
    BOUND_H   : in    integer;
    BOUND_G   : in    integer;
    BOUND_LP  : in    integer;
    BOUND_HP  : in    integer;
    cnt       : inout integer
    );

end COUNTERS;

package body COUNTERS is

--|------------------------|
--| Single Periodic Toggle |
--|------------------------|

  procedure toggle (pre_ut      : out   std_logic;
                     BOUND_L    : in    integer;
                     BOUND_H    : in    integer;
                     BOUND_G    : in    integer;
                     cnt        : inout integer) is
                     
  begin  -- toggle

        if cnt >= BOUND_L and cnt <= BOUND_H then
           pre_ut := '1';
         else 
           pre_ut := '0';
        end if;
        
        if cnt = BOUND_G then
          cnt := 0;
        end if;
       
        cnt := cnt + 1;
       
  end procedure toggle;
  
--|------------------------|
--| Dual Aperiodic Toggles |
--|------------------------|
  
  procedure dualToggle (pre_ut      : out   std_logic;
                     BOUND_L    : in    integer;
                     BOUND_H    : in    integer;
                     BOUND_G    : in    integer;
                     BOUND_LP   : in    integer;
                     BOUND_HP   : in    integer;
                     cnt        : inout integer) is
  begin  -- dualToggle
    
        if (cnt >= BOUND_L and cnt <= BOUND_H) or (cnt >= BOUND_LP and cnt <= BOUND_HP) then
           pre_ut := '1';
         else 
           pre_ut := '0';
        end if;
        
        if cnt = BOUND_G then
          cnt := 0;
        end if;
       
        cnt := cnt + 1;
    
  end procedure dualToggle;

end COUNTERS;
