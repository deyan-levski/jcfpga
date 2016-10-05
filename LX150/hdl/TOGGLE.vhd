----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:18:38 09/06/2016 
-- Design Name: 
-- Module Name:    toggle - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity toggle is
    Port ( BOUND_L : in  STD_LOGIC;
           BOUND_H : in  STD_LOGIC;
           BOUND_G : in  STD_LOGIC;
           cnt : in  STD_LOGIC;
           out : in  STD_LOGIC);
end toggle;

architecture Behavioral of toggle is

begin


end Behavioral;

