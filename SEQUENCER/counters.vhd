--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;

package counters is

   procedure toggle (
    pre_ut    : out std_logic;               
    BOUND_L   : in    integer;  
    BOUND_H   : in    integer;
    BOUND_G   : in    integer;
    cnt       : inout integer);
  
   procedure dualtoggle (
    pre_ut    : out std_logic;               
    BOUND_L   : in    integer;  
    BOUND_H   : in    integer;
    BOUND_G   : in    integer;
    BOUND_LP  : in    integer;
    BOUND_HP  : in    integer;
    cnt       : inout integer);


-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;
--
-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--

end counters;

package body counters is


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


---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;
 
end counters;
