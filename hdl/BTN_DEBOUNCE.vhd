----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Camryn Ruiz
-- 
-- Create Date: 05/23/2026 08:22:21 PM
-- Design Name: 
-- Module Name: BTN_DEBOUNCE - Behavioral
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

entity BTN_DEBOUNCE is
    Generic ( DEBOUNCE_LIMIT : INTEGER := 250000 );
    Port ( CLK : in STD_LOGIC;
           BTN_in : in STD_LOGIC;
           BTN_out : out STD_LOGIC
    );
end BTN_DEBOUNCE;

architecture Behavioral of BTN_DEBOUNCE is

    signal DEBNC_COUNT : INTEGER range 0 to DEBOUNCE_LIMIT := 0;
    signal BTN_STATE : STD_LOGIC := '0';
    
begin

    process (CLK) is
    begin
        if (rising_edge(CLK)) then
            -- Check the button state and if the count is less than the debounce count
            if (BTN_in /= BTN_STATE AND DEBNC_COUNT < DEBOUNCE_LIMIT) then
                DEBNC_COUNT <= DEBNC_COUNT + 1; -- Increment Count
                
            -- End of count reached so the button state is stable, update it
            elsif (BTN_in /= BTN_STATE AND DEBNC_COUNT = DEBOUNCE_LIMIT) then
                BTN_STATE <= BTN_in;
                DEBNC_COUNT <= 0;
            -- Buttons are the same state so reset the count
            else
                DEBNC_COUNT <= 0;
            end if;            
        end if;
    end process;
    
    -- Update Output
    BTN_out <= BTN_STATE; 
    
end Behavioral;
