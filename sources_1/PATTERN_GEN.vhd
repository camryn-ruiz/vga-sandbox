----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Camryn Ruiz
-- 
-- Create Date: 05/23/2026 07:21:56 PM
-- Design Name: 
-- Module Name: PATTERN_GEN - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: The Pixel Generator to generate patterns on the display
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
--  Current Pattern: Checkered Display (20 W x 15 H) (300 Total Boxes)
--  
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PIXEL_GEN is
    Port ( X_COUNT, Y_COUNT : in STD_LOGIC_VECTOR(9 downto 0);
           DISPLAY_ON : in STD_LOGIC;
           ROW : in STD_LOGIC_VECTOR (3 downto 0);
           COL : in STD_LOGIC_VECTOR (4 downto 0);
           R, G, B : out STD_LOGIC_VECTOR (3 downto 0)
    );
end PIXEL_GEN;

architecture Behavioral of PIXEL_GEN is

    signal X_COUNT_UNSIGNED, Y_COUNT_UNSIGNED : UNSIGNED(9 downto 0) := "0000000000";
    
    signal TILE_X : UNSIGNED(4 downto 0) := "00000";
    signal TILE_Y : UNSIGNED(3 downto 0) := "0000";
    
    signal R_temp, G_temp, B_temp : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    
begin

    -- Convert to unsigned
    X_COUNT_UNSIGNED <= UNSIGNED(X_COUNT);
    Y_COUNT_UNSIGNED <= UNSIGNED(Y_COUNT);

    -- Divide by 32 using upper bits
    TILE_X <= X_COUNT_UNSIGNED(9 downto 5);
    TILE_Y <= Y_COUNT_UNSIGNED(8 downto 5);
    
    process (X_COUNT_UNSIGNED, Y_COUNT_UNSIGNED, TILE_X, TILE_Y, ROW, COL)
    begin
        -- For Checkered Pattern       
        if ((X_COUNT_UNSIGNED(5) XOR Y_COUNT_UNSIGNED(5)) = '1') then
            -- Output Colors (White)
            R_temp <= "1111";
            G_temp <= "1111";
            B_temp <= "1111";
        else 
            -- Output Colors (Black)
            R_temp <= "0000";
            G_temp <= "0000";
            B_temp <= "0000";
        end if;
        
        if (UNSIGNED(ROW) = TILE_Y AND UNSIGNED(COL) = TILE_X) then
            -- Output Colors (GREEN)
            R_temp <= "0000";
            G_temp <= "1111";
            B_temp <= "0000";  
        end if;  
    end process;

    R <= R_temp when (DISPLAY_ON = '1') else "0000";
    G <= G_temp when (DISPLAY_ON = '1') else "0000";
    B <= B_temp when (DISPLAY_ON = '1') else "0000";
    
end Behavioral;
