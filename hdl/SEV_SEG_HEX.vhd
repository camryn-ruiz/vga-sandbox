----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Camryn Ruiz
-- 
-- Create Date: 05/15/2026 06:57:41 PM
-- Design Name: 
-- Module Name: SEV_SEG_HEX - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Seven Segment Dispaly to Hex Converter
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

entity SEV_SEG_HEX is
   Generic ( MAX_COUNT : INTEGER := 3 - 1 );
   Port (
         CLK : in STD_LOGIC;
         ONES, TENS, HUNDREDS : in INTEGER range 0 to 9;
         AN : out STD_LOGIC_VECTOR(7 downto 0);
         SEG_DISP : out STD_LOGIC_VECTOR(7 downto 1)
   );
end SEV_SEG_HEX;

architecture Behavioral of SEV_SEG_HEX is

    signal COUNTER : INTEGER range 0 to MAX_COUNT := 0;
    signal VAL : INTEGER range 0 to 9 := 0;
    signal AN_reg : STD_LOGIC_VECTOR(7 downto 0) := "11111110";
    
begin
    
    CLK_PROC : process (CLK)
        variable NEXT_COUNT : INTEGER range 0 to MAX_COUNT;
    begin
        if (rising_edge(CLK)) then
            if (COUNTER = MAX_COUNT) then
                NEXT_COUNT := 0;
            else 
                NEXT_COUNT := COUNTER + 1;
            end if;  
            
            COUNTER <= NEXT_COUNT;
            
            case NEXT_COUNT is
                when 0 => VAL <= ONES;
                when 1 => VAL <= TENS;
                when 2 => VAL <= HUNDREDS;
                when others => VAL <= 0;
            end case;
        end if;
    end process;
    
    SEG_SEL : process(COUNTER)
    begin
        case COUNTER is
            when 0 => AN_reg <= "11111110";
            when 1 => AN_reg <= "11111101";
            when 2 => AN_reg <= "11111011";
            when others => AN_reg <= "11111111";
        end case;
    end process;
    
    VAL_SEL : process(VAL)
    begin
        case (VAL) is
            --                     GFEDCBA
            when 0 => SEG_DISP <= "1000000"; -- 0 (0x40)
            when 1 => SEG_DISP <= "1111001"; -- 1 (0x79)
            when 2 => SEG_DISP <= "0100100"; -- 2 (0x24)
            when 3 => SEG_DISP <= "0110000"; -- 3 (0x30)
            when 4 => SEG_DISP <= "0011001"; -- 4 (0x19)
            when 5 => SEG_DISP <= "0010010"; -- 5 (0x12)
            when 6 => SEG_DISP <= "0000010"; -- 6 (0x02)
            when 7 => SEG_DISP <= "1111000"; -- 7 (0x78)
            when 8 => SEG_DISP <= "0000000"; -- 8 (0x00)
            when 9 => SEG_DISP <= "0010000"; -- 9 (0x10)
            when others => SEG_DISP <= "1000000"; -- Default to 0 (Only need 0-9 here)
        end case;
    end process;
    
    AN <= AN_reg;

end Behavioral;
