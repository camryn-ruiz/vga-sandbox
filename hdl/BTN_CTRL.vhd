----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Camryn Ruiz
-- 
-- Create Date: 05/23/2026 08:22:21 PM
-- Design Name: 
-- Module Name: BTN_CTRL - Behavioral
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

entity BTN_CTRL is
    Port (
        CLK   : in STD_LOGIC;
        LEFT, RIGHT, UP, DOWN : in STD_LOGIC;
        COL   : out STD_LOGIC_VECTOR(4 downto 0);
        ROW   : out STD_LOGIC_VECTOR(3 downto 0)
    );
end BTN_CTRL;

architecture Behavioral of BTN_CTRL is

    component BTN_DEBOUNCE
        port (
            CLK     : in STD_LOGIC;
            BTN_in  : in STD_LOGIC;
            BTN_out : out STD_LOGIC
        );
    end component;

    -- Debounced signals
    signal LEFT_DBNC  : STD_LOGIC := '0';
    signal RIGHT_DBNC : STD_LOGIC := '0';
    signal UP_DBNC    : STD_LOGIC := '0';
    signal DOWN_DBNC  : STD_LOGIC := '0';

    -- Edge detection registers
    signal LEFT_reg  : STD_LOGIC := '0';
    signal RIGHT_reg : STD_LOGIC := '0';
    signal UP_reg    : STD_LOGIC := '0';
    signal DOWN_reg  : STD_LOGIC := '0';

    -- Position
    signal R : UNSIGNED(3 downto 0) := (others => '0');
    signal C : UNSIGNED(4 downto 0) := (others => '0');

    -- Limits
    constant ROW_MIN : UNSIGNED(3 downto 0) := (others => '0');
    constant ROW_MAX : UNSIGNED(3 downto 0) := "1110"; -- 14

    constant COL_MIN : UNSIGNED(4 downto 0) := (others => '0');
    constant COL_MAX : UNSIGNED(4 downto 0) := "10011"; -- 19

begin

    BTN_LEFT : BTN_DEBOUNCE port map (
        CLK => CLK, 
        BTN_in => LEFT, 
        BTN_out => LEFT_DBNC
    );

    BTN_RIGHT : BTN_DEBOUNCE port map (
        CLK => CLK, 
        BTN_in => RIGHT, 
        BTN_out => RIGHT_DBNC
    );

    BTN_UP : BTN_DEBOUNCE port map (
        CLK => CLK, 
        BTN_in => UP, 
        BTN_out => UP_DBNC
    );

    BTN_DOWN : BTN_DEBOUNCE port map (
        CLK => CLK, 
        BTN_in => DOWN, 
        BTN_out => DOWN_DBNC
    );

    ----------------------------------------------------------------------------
    -- Movement + Edge Detection
    ----------------------------------------------------------------------------

    MOVE_PROC : process(CLK)
    begin
        if rising_edge(CLK) then

            -- LEFT
            if LEFT_DBNC = '1' and LEFT_reg = '0' then
                if C = COL_MIN then
                    C <= COL_MAX;
                else
                    C <= C - 1;
                end if;
            end if;

            -- RIGHT
            if RIGHT_DBNC = '1' and RIGHT_reg = '0' then
                if C = COL_MAX then
                    C <= COL_MIN;
                else
                    C <= C + 1;
                end if;
            end if;

            -- UP
            if UP_DBNC = '1' and UP_reg = '0' then
                if R = ROW_MIN then
                    R <= ROW_MAX;
                else
                    R <= R - 1;
                end if;
            end if;

            -- DOWN
            if DOWN_DBNC = '1' and DOWN_reg = '0' then
                if R = ROW_MAX then
                    R <= ROW_MIN;
                else
                    R <= R + 1;
                end if;
            end if;

            -- Update history
            LEFT_reg  <= LEFT_DBNC;
            RIGHT_reg <= RIGHT_DBNC;
            UP_reg    <= UP_DBNC;
            DOWN_reg  <= DOWN_DBNC;

        end if;
    end process;

    ----------------------------------------------------------------------------
    -- Outputs
    ----------------------------------------------------------------------------

    COL <= STD_LOGIC_VECTOR(C);
    ROW <= STD_LOGIC_VECTOR(R);

end Behavioral;