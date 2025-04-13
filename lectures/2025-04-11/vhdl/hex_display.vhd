--------------------------------------------------------------------------------
-- @brief Design of a multi hex display system. Two hex displays are used to
--        display hexadecimal numbers 0 - F. The number displayed on each
--        display is controlled by four slide switches.
--
-- @param switch[7:0]          Inputs from eight slide switches.
-- @param hex1[6:0], hex0[6:0] 7-segment display used for displaying numbers.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity hex_display is
    port(switch    : in std_logic_vector(7 downto 0);
         hex1, hex0: out std_logic_vector(6 downto 0));
end entity;

architecture behaviour of hex_display is
begin
    --------------------------------------------------------------------------------
    -- @brief Add display instance to control hex1 via switch[7:4].
    --------------------------------------------------------------------------------
    display1: entity work.display
        port map(number => switch(7 downto 4), 
                 hex    => hex1);
                 
    --------------------------------------------------------------------------------
    -- @brief Add display instance to control hex0 via switch[3:0].
    --------------------------------------------------------------------------------
    display0: entity work.display
        port map(number => switch(3 downto 0),
                 hex    => hex0);
    
end architecture;
