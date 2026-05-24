----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/18/2026 08:00:21 PM
-- Design Name: 
-- Module Name: TB_VGA_CTRL - Behavioral
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

entity TB_VGA_CTRL is
end TB_VGA_CTRL;

architecture Behavioral of TB_VGA_CTRL is

    component VGA_CTRL 
        port (
               CLK : in STD_LOGIC;
               R, G, B: out STD_LOGIC_VECTOR(3 downto 0);
               VS, HS : out STD_LOGIC  
        );
    end component;

    signal CLK, VS, HS : STD_LOGIC;
    signal R, G, B : STD_LOGIC_VECTOR(3 downto 0);
    
begin

    UUT : VGA_CTRL port map (
        CLK => CLK,
        VS => VS,
        HS => HS,
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
