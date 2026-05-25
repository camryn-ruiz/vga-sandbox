----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Camryn Ruiz
-- 
-- Create Date: 05/18/2026 06:56:23 PM
-- Design Name: 
-- Module Name: VGA_CTRL - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: VGA Controller (Industry Standard (640x480 @ 60Hz)
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--  < FP, HS, BP, LB, PV, RB> = <FRONT PORCH, HOR. SYNC, BACK PORCH, LEFT BORDER, PIXEL VIDEO, RIGHT BORDER>
--  < FP, VS, BP, TB, LV, BB> = <FRONT PORCH, VER. SYNC, BACK PORCH, TOP BORDER, LINES VIDEO, BOTTOM BORDER>
--
-- Vertical Timing:
-- | Visible | Front Porch | Sync Pulse | Back Porch |
-- |   640   |      16      |     96     |     48     |
-- HS : LOW when COUNT >= 656 AND COUNT < 752 else HIGH
--
-- Vertical Timing:
-- | Visible | Front Porch | Sync Pulse | Back Porch |
-- |   480   |      10     |      2     |     33     |
-- VS : LOW when COUNT >= 490 AND COUNT < 492 else HIGH
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VGA_CTRL is
   Port (CLK : in STD_LOGIC;
         VS, HS : out STD_LOGIC;
         DISP_ON : out STD_LOGIC;
         X_COUNT_OUT, Y_COUNT_OUT : out STD_LOGIC_VECTOR(9 downto 0)
   );
end VGA_CTRL;

architecture Behavioral of VGA_CTRL is

    component CLK_DIVIDER 
        port (
               CLK : in STD_LOGIC;
               PIXEL_CLK : out STD_LOGIC
        );
    end component;
    
    signal PIXEL_CLK : STD_LOGIC := '0';
    signal DISPLAY_ON : STD_LOGIC;
    
    -- X Counter           < FP, HS, BP, LB, PV, RB >
    -- X Max Value : 800 = <  8, 96, 40,  8,640,  8 >
    -- Y Counter           < FP, VS, BP, TB, LV, BB >
    -- Y Max Value : 525 = <  2, 2,  25,  8,480,  8 > 
    signal X_COUNT, Y_COUNT : INTEGER := 0;
    signal X_MAX : INTEGER := 799; -- 799
    signal Y_MAX : INTEGER := 524; -- 524
    
    signal X_COUNT_UNSIGNED, Y_COUNT_UNSIGNED : UNSIGNED(9 downto 0) := "0000000000";
    signal X_COUNT_VECT, Y_COUNT_VECT : STD_LOGIC_VECTOR(9 downto 0) := "0000000000";
    
    constant X_PIXELS : INTEGER := 640;
    constant Y_PIXELS : INTEGER := 480;
    
    constant HS_START : INTEGER := 656;
    constant HS_END   : INTEGER := 752;

    constant VS_START : INTEGER := 490;
    constant VS_END   : INTEGER := 492;
    
begin

    PIX_CLK : CLK_DIVIDER port map (
        CLK => CLK,
        PIXEL_CLK => PIXEL_CLK
    );
    
    process (PIXEL_CLK)
    begin
        if (rising_edge(PIXEL_CLK)) then
            -- Check X Count
            if (X_COUNT >= X_MAX) then
                X_COUNT <= 0; -- Reset X Count
                if (Y_COUNT >= Y_MAX) then
                    Y_COUNT <= 0; -- Reset the Y Count
                else 
                    Y_COUNT <= Y_COUNT + 1;  -- Increment Y Count
                end if;
            else
                X_COUNT <= X_COUNT + 1; -- Increment X Count
            end if;
        end if; 
    end process;   

    -- Horizontal Sync Output (Active-Low)
    process(X_COUNT)
    begin
        if (X_COUNT >= HS_START AND X_COUNT <  HS_END) then
            HS <= '0';
        else
            HS <= '1';
        end if;
    end process;
    
    -- Vertical Sync Output (Active-Low)
    process(Y_COUNT)
    begin
        -- Vertical Sync 
        if (Y_COUNT >= VS_START AND Y_COUNT <  VS_END) then
            VS <= '0';
        else
            VS <= '1';
        end if;
    end process;

    process(X_COUNT, Y_COUNT)
    begin
        -- If the Count is within the Resolution
        if (X_COUNT < X_PIXELS AND Y_COUNT < Y_PIXELS) then
            DISPLAY_ON <= '1'; -- Turn ON the Colors Display
        else
            DISPLAY_ON <= '0'; -- Turn OFF the Colors Display
        end if;
    end process;
    
    -- Output Count
    X_COUNT_UNSIGNED <= TO_UNSIGNED(X_COUNT, 10);
    Y_COUNT_UNSIGNED <= TO_UNSIGNED(Y_COUNT, 10);
    
    X_COUNT_VECT <= STD_LOGIC_VECTOR(X_COUNT_UNSIGNED);
    Y_COUNT_VECT <= STD_LOGIC_VECTOR(Y_COUNT_UNSIGNED);
    
    X_COUNT_OUT <= X_COUNT_VECT;
    Y_COUNT_OUT <= Y_COUNT_VECT;
    
    -- Output Display On
    DISP_ON <= DISPLAY_ON;
    
end Behavioral;
