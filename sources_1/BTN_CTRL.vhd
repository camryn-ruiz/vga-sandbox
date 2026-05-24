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
        LEFT, RIGHT, UP, DOWN  : in STD_LOGIC;
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

    -- Debounced Buttons
    signal LEFT_DBNC  : STD_LOGIC := '0';
    signal RIGHT_DBNC : STD_LOGIC := '0';
    signal UP_DBNC    : STD_LOGIC := '0';
    signal DOWN_DBNC  : STD_LOGIC := '0';

    -- ROW/COL Location on Screen
    signal R : unsigned(3 downto 0) := (others => '0');
    signal C : unsigned(4 downto 0) := (others => '0');

    -- Constants for Min/Max
    constant ROW_MIN : unsigned(3 downto 0) := (others => '0');
    constant ROW_MAX : unsigned(3 downto 0) := "1111";

    constant COL_MIN : unsigned(4 downto 0) := (others => '0');
    constant COL_MAX : unsigned(4 downto 0) := "10100";

begin

    BTN_LEFT : BTN_DEBOUNCE
        port map (
            CLK     => CLK,
            BTN_in  => LEFT,
            BTN_out => LEFT_DBNC
        );

    BTN_RIGHT : BTN_DEBOUNCE
        port map (
            CLK     => CLK,
            BTN_in  => RIGHT,
            BTN_out => RIGHT_DBNC
        );

    BTN_UP : BTN_DEBOUNCE
        port map (
            CLK     => CLK,
            BTN_in  => UP,
            BTN_out => UP_DBNC
        );

    BTN_DOWN : BTN_DEBOUNCE
        port map (
            CLK     => CLK,
            BTN_in  => DOWN,
            BTN_out => DOWN_DBNC
        );

    --------------------------------------------------------------------------
    -- Row Selector (UP/DOWN)
    --------------------------------------------------------------------------
    ROW_SEL : process(CLK)
    begin
        if rising_edge(CLK) then
            if (UP_DBNC = '1') then
                if (R = ROW_MIN) then
                    R <= ROW_MAX;
                else
                    R <= R - 1;
                end if;

            elsif (DOWN_DBNC = '1') then
                if (R = ROW_MAX) then
                    R <= ROW_MIN;
                else
                    R <= R + 1;
                end if;
            end if;
        end if;
    end process ROW_SEL;

    --------------------------------------------------------------------------
    -- Column Selector (LEFT/RIGHT)
    --------------------------------------------------------------------------
    COL_SEL : process(CLK)
    begin
        if rising_edge(CLK) then

            if (RIGHT_DBNC = '1') then
                if (C = COL_MAX) then
                    C <= COL_MIN;
                else
                    C <= C + 1;
                end if;

            elsif (LEFT_DBNC = '1') then
                if (C = COL_MIN) then
                    C <= COL_MAX;
                else
                    C <= C - 1;
                end if;
            end if;
        end if;
    end process COL_SEL;

    --------------------------------------------------------------------------
    -- Output Row/Column
    --------------------------------------------------------------------------
    COL <= STD_LOGIC_VECTOR(C);
    ROW <= STD_LOGIC_VECTOR(R);

end Behavioral;