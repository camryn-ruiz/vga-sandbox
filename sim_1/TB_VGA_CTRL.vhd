----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Camryn Ruiz
-- 
-- Create Date: 05/18/2026 08:00:21 PM
-- Design Name: 
-- Module Name: TB_VGA - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Test Bench for VGA output
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

entity TB_VGA is
end TB_VGA;

architecture Behavioral of TB_VGA is

    component top 
        port (
               CLK : in STD_LOGIC;
               LEFT, RIGHT, UP, DOWN : in STD_LOGIC;
               VS, HS : out STD_LOGIC;
               R, G, B : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    signal CLK, VS, HS : STD_LOGIC;
    signal LEFT, RIGHT, UP, DOWN : STD_LOGIC := '0';
    signal R, G, B : STD_LOGIC_VECTOR(3 downto 0);
    
begin

    UUT : top port map (
        CLK => CLK,
        VS => VS,
        HS => HS,
        LEFT => LEFT,
        RIGHT => RIGHT,
        UP => UP,
        DOWN => DOWN,
        R => R,
        G => G,
        B => B
    );
    
    process
    begin
        -- Simulate 100 MHz CLK
        CLK <= '0';
        wait for 5 ns;
        CLK <= '1';
        wait for 5 ns;
    end process;

end Behavioral;
