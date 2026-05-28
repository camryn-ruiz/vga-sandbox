----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/24/2026 08:00:46 PM
-- Design Name: 
-- Module Name: CLK_SEV_SEG - Behavioral
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

entity CLK_SEV_SEG is
   -- 100MHz / 1KHz = 100000 | Toggle every half cycle: 100000 / 2 = 50000
   Generic ( COUNTER_LIMIT : INTEGER := 50000 - 1 ); 
   Port (
         CLK_in : in STD_LOGIC;  -- 100MHz
         CLK_out : out STD_LOGIC -- 1KHz
   );
end CLK_SEV_SEG;

architecture Behavioral of CLK_SEV_SEG is
    
    signal COUNTER : INTEGER range 0 to COUNTER_LIMIT := 0;
    signal CLK_DIV : STD_LOGIC := '0';
    
begin
    
    CLK_PROC : process(CLK_in)
    begin
        if (rising_edge(CLK_in)) then
            if (COUNTER = COUNTER_LIMIT) then
                CLK_DIV <= not CLK_DIV;
                COUNTER <= 0;
            else
                COUNTER <= COUNTER + 1;
            end if;    
        end if;
    end process;    
    
    CLK_out <= CLK_DIV;

end Behavioral;
