----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/24/2026 08:11:18 PM
-- Design Name: 
-- Module Name: SEV_SEG_CTRL - Behavioral
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

entity SEV_SEG_CTRL is
   Port (
         CLK : in STD_LOGIC;
         COL : in STD_LOGIC_VECTOR(4 downto 0);
         ROW : in STD_LOGIC_VECTOR(3 downto 0);
         SEG_DISP : out std_logic_vector(7 downto 1);
         AN : out STD_LOGIC_VECTOR(7 downto 0)
   );
end SEV_SEG_CTRL;

architecture Behavioral of SEV_SEG_CTRL is

    component CLK_SEV_SEG port (
         CLK_in : in STD_LOGIC;  -- 100MHz
         CLK_out : out STD_LOGIC -- 1KHz
    );
    end component;
    
    component SEV_SEG_HEX port (
         CLK : in STD_LOGIC;
         ONES : in INTEGER;
         TENS : in INTEGER;
         HUNDREDS : in INTEGER;
         AN : out STD_LOGIC_VECTOR(7 downto 0);
         SEG_DISP : out STD_LOGIC_VECTOR(7 downto 1)
    );
    end component;
    
    component VAL_PARSER port (
        VAL : in INTEGER;
        ONES : out INTEGER;
        TENS : out INTEGER;
        HUNDREDS : out INTEGER
    );    
    end component;    
    
    signal SEV_SEG_CLK : STD_LOGIC := '0';
    signal HUNDS_VAL, TENS_VAL, ONES_VAL : INTEGER range 0 to 9 := 0;
    signal VAL : INTEGER range 0 to 300 := 0;
    
begin

    -- FORMULA: VAL = COL + 20*ROW
    -- COL_VALS = <1,2,3,...,N>    N = 20
    -- ROW_VALS = <0,1,2,...,N-1>  N = 15
    VAL <= (TO_INTEGER(UNSIGNED(COL)) + 1) + 20 * TO_INTEGER(UNSIGNED(ROW));
    
    SEVSEG_CLK : CLK_SEV_SEG port map (
        CLK_in  => CLK,
        CLK_out => SEV_SEG_CLK
    );
    
    PARSER : VAL_PARSER port map (
        VAL => VAL,
        ONES => ONES_VAL,
        TENS => TENS_VAL,
        HUNDREDS => HUNDS_VAL
    );
    
    DISPLAY : SEV_SEG_HEX port map (
        CLK => SEV_SEG_CLK,
        ONES => ONES_VAL,
        TENS => TENS_VAL,
        HUNDREDS => HUNDS_VAL,
        AN => AN,
        SEG_DISP => SEG_DISP
    );

end Behavioral;
