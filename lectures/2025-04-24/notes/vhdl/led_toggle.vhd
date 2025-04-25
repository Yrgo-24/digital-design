--------------------------------------------------------------------------------
-- @brief Digital system consisting of a clock, a push button, a reset button,
--        and an LED. 
-- 
--        The LED toggles when the button is pressed. 
--
--        The LED is immediately turned off during a system reset.
--
-- @param clock    50 MHz system clock.
-- @param reset_n  Active-low reset signal for generating system reset.
-- @param button_n Active-low push button for toggling the LED.
-- @param led      LED that toggles when the push button is pressed.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity led_toggle is
    port(clock, reset_n, button_n: in std_logic;
         led                     : out std_logic);
end entity;

architecture behaviour of led_toggle is

--------------------------------------------------------------------------------
-- @brief The value of button_n during the previous clock cycle. This value is 
--        one clock cycle old and is updated on rising edge of the system clock.
--
-- @note button_n is active-low, meaning '1' is the default state, and '0' 
--       indicates a button press.
--------------------------------------------------------------------------------
signal button_prev: std_logic;

--------------------------------------------------------------------------------
-- @brief Signal indicating falling edge of button_n. This signal is set when 
--        button_n is currently pressed (button_n = '0') but wasn't pressed 
--        during the previous clock cycle (button_prev = '1').
--------------------------------------------------------------------------------
signal button_edge: std_logic;

--------------------------------------------------------------------------------
-- @brief Internal representation of the LED state. This signal is required 
--        for toggling the LED, as output signals cannot be directly read.
--------------------------------------------------------------------------------
signal led_s: std_logic;

begin

    --------------------------------------------------------------------------------
    -- @brief Update button_prev during system reset or on rising edge of the 
    --        system clock.
    --
    --        During a system reset, button_prev is set to its default value of '1'.
    --        On rising edge of the system clock, button_prev is updated with the
    --        current value of button_n.
    --------------------------------------------------------------------------------
    process (clock, reset_n) is
    begin
        if (reset_n = '0') then
            button_prev <= '1';
        elsif (rising_edge(clock)) then
            button_prev <= button_n;
        end if;
    end process;
    
    --------------------------------------------------------------------------------
    -- @brief Update led_s during system reset or on rising edge of the system clock.
    --
    --        During system reset, led_s is set to its default value of '0'.
    --        On rising edge of the system clock, led_s toggles when a falling edge
    --        of button_n is detected (i.e. when button_edge = '1').
    --------------------------------------------------------------------------------
    process (clock, reset_n) is
    begin
        if (reset_n = '0') then
            led_s <= '0';
        elsif (rising_edge(clock)) then
            if (button_edge = '1') then
                led_s <= not led_s;
            end if;
        end if;
    end process;
    
    --------------------------------------------------------------------------------
    -- @brief Set button_edge when button_n = '0' and button_prev = '1', indicating
    --        that button_n is currently pressed but wasn't pressed during the
    --        previous clock cycle.
    --------------------------------------------------------------------------------
    button_edge <= (not button_n) and button_prev;
    
    --------------------------------------------------------------------------------
    -- @brief Continuously assign the value of led_s to output signal led.
    --------------------------------------------------------------------------------
    led <= led_s;

end architecture;