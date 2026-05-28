----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Camryn Ruiz
-- 
-- Create Date: 05/23/2026 07:23:03 PM
-- Design Name: 
-- Module Name: top - Behavioral
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

entity top is
    Port (CLK : in STD_LOGIC;
          -- Movement Control Inputs
          LEFT, RIGHT, UP, DOWN : in STD_LOGIC;
          
          -- VGA Outputs
          VS, HS : out STD_LOGIC;
          R, G, B : out STD_LOGIC_VECTOR(3 downto 0);
          
          -- Seven Segment Display Outputs
          SEG_DISP : out std_logic_vector(7 downto 1);
          AN : out STD_LOGIC_VECTOR(7 downto 0)
    );
end top;

architecture Behavioral of top is

    component VGA_CTRL 
        port (
            CLK : in STD_LOGIC;
            VS, HS : out STD_LOGIC;
            DISP_ON : out STD_LOGIC;
            X_COUNT_OUT, Y_COUNT_OUT : out STD_LOGIC_VECTOR(9 downto 0)
        );
    end component;

    component PIXEL_GEN 
        port (
            X_COUNT, Y_COUNT : in STD_LOGIC_VECTOR(9 downto 0);
            ROW : in STD_LOGIC_VECTOR (3 downto 0);
            COL : in STD_LOGIC_VECTOR (4 downto 0);
            DISPLAY_ON : in STD_LOGIC;
            R, G, B : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;
    
    component BTN_CTRL
        port ( 
            CLK : in STD_LOGIC;
            LEFT : in STD_LOGIC;
            RIGHT : in STD_LOGIC;
            UP : in STD_LOGIC;
            DOWN : in STD_LOGIC;
            COL : out STD_LOGIC_VECTOR(4 downto 0);
            ROW : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;
    
    component SEV_SEG_CTRL 
        port (
            CLK : in STD_LOGIC;
            COL : in STD_LOGIC_VECTOR(4 downto 0);
            ROW : in STD_LOGIC_VECTOR(3 downto 0);
            SEG_DISP : out std_logic_vector(7 downto 1);
            AN : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;    
    
    signal DISP_STATUS : STD_LOGIC := '0';
    signal X_COUNTER, Y_COUNTER : STD_LOGIC_VECTOR(9 downto 0) := "0000000000";
    
    signal COL : STD_LOGIC_VECTOR(4 downto 0) := "00000";
    signal ROW : STD_LOGIC_VECTOR(3 downto 0) := "0000";
begin

    VGA_CONTROL : VGA_CTRL port map (
        CLK => CLK,
        VS => VS,
        HS => HS,
        DISP_ON => DISP_STATUS,
        X_COUNT_OUT => X_COUNTER,
        Y_COUNT_OUT => Y_COUNTER
    );

    PATTERN_GEN : PIXEL_GEN port map (
        X_COUNT => X_COUNTER,
        Y_COUNT => Y_COUNTER,
        DISPLAY_ON => DISP_STATUS,
        COL => COL,
        ROW => ROW,
        R => R,
        G => G,
        B => B
    );
    
    BTN_CONTROL : BTN_CTRL port map (
        CLK => CLK,
        LEFT => LEFT,
        RIGHT => RIGHT,
        UP => UP,
        DOWN => DOWN,
        COL => COL,
        ROW => ROW
    );
         
    SEG_CONTROL : SEV_SEG_CTRL port map (
        CLK => CLK,
        COL => COL,
        ROW => ROW,
        SEG_DISP => SEG_DISP,
        AN => AN
    );
    
end Behavioral;
