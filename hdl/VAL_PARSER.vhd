----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/24/2026 08:16:29 PM
-- Design Name: 
-- Module Name: VAL_PARSER - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.NUMERIC_STD.ALL;

entity VAL_PARSER is
   Port ( 
         VAL : in INTEGER;
         ONES : out INTEGER;
         TENS : out INTEGER;
         HUNDREDS : out INTEGER
   );
end VAL_PARSER;

architecture Behavioral of VAL_PARSER is
    
begin

    CONVERSION : process(VAL)
    begin    
        HUNDREDS <= (VAL / 100) mod 10;
        TENS <= (VAL / 10) mod 10;
        ONES <= VAL mod 10;
    end process;

end Behavioral;
