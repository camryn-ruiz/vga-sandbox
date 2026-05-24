----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Camryn Ruiz
-- 
-- Create Date: 05/18/2026 06:56:23 PM
-- Design Name: 
-- Module Name: CLK_DIVIDER - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Clock Module to get the desired Pixel Clock
--              Desired Pixel Clock for 640x480 @ 60Hz : 25 MHz
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

entity CLK_DIVIDER is
   Port (
      CLK       : in  STD_LOGIC;
      PIXEL_CLK : out STD_LOGIC
   );
end CLK_DIVIDER;

architecture Behavioral of CLK_DIVIDER is

    signal COUNTER : INTEGER := 0;
    constant LIMIT : INTEGER := 1;
    signal CLK_REG : STD_LOGIC := '0';

begin

    process(CLK)
    begin
        if rising_edge(CLK) then

            if COUNTER = LIMIT then
                COUNTER <= 0;
                CLK_REG <= not CLK_REG; -- Waits a CLK cycle to change
            else
                COUNTER <= COUNTER + 1;
            end if;

        end if;
    end process;

    PIXEL_CLK <= CLK_REG;

end Behavioral;
