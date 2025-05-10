--------------------------------------------------------------------------------
-- @brief Implement a digital system with a push button, system clock, reset,
--        and an LED. Toggle the LED on the falling edge of the push button.
--
--        Synchronize input signals using the double-flop method to prevent
--        metastability.
--
-- @param clock    50 MHz system clock.
-- @param reset_n  Active-low reset signal (0 = system reset).
-- @param button_n Active-low push button for toggling the LED.
-- @param led      LED output, toggled on falling edge of the push button.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity led_toggle_meta_prev is
    port(clock, reset_n, button_n: in std_logic;
         led                     : out std_logic);
end entity;

architecture behaviour of led_toggle_meta_prev is

--------------------------------------------------------------------------------
-- @brief Declare internal signals.
--
-- @param reset_s2_n     Synchronized active-low reset signal (double-flop).
-- @param button_edge_s2 Indicate falling edge of the push button (double-flop).
-- @param led_s          Store internal LED state.
--------------------------------------------------------------------------------
signal reset_s2_n, button_edge_s2, led_s: std_logic;

begin

    --------------------------------------------------------------------------------
    -- @brief Instantiate meta_prev to synchronize inputs and detect button edge.
    --        Connect signals with matching names.
    --------------------------------------------------------------------------------
    meta_prev1: entity work.meta_prev
        port map(clock, reset_n, button_n, reset_s2_n, button_edge_s2);
        
    --------------------------------------------------------------------------------
    -- @brief Toggle the LED on button falling edge.
    --
    --        On reset (reset_s2_n = 0), turn off the LED (led_s = 0).
    --        On rising edge of the clock, toggle led_s if button_edge_s2 = 1.
    --------------------------------------------------------------------------------
    process (clock, reset_s2_n) is
    begin
        if (reset_s2_n = '0') then
            led_s <= '0';
        elsif (rising_edge(clock)) then
            if (button_edge_s2 = '1') then
                led_s <= not led_s;
            end if;
        end if;
    end process;
    
    -- Drive the LED output with the internal LED state.
    led <= led_s;
    
end architecture;
