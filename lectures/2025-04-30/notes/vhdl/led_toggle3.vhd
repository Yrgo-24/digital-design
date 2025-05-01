--------------------------------------------------------------------------------
-- @brief Describe a digital system consisting of a clock, a reset button, 
--        three push buttons, and three LEDs. 
-- 
--        Toggle a given LED when the corresponding button is pressed. 
--
--        Turn off all LEDs immediately during a system reset.
--
-- @param clock         50 MHz system clock.
-- @param reset_n       Active-low reset signal for generating system reset.
-- @param button_n[2:0] Active-low push buttons for toggling the LEDs.
-- @param led[2:0]      LEDs that toggle when the corresponding push button 
--                      is pressed.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity led_toggle3 is
    port(clock, reset_n: in std_logic;
         button_n      : in std_logic_vector(2 downto 0);
         led           : out std_logic_vector(2 downto 0));
end entity;

architecture behaviour of led_toggle3 is

--------------------------------------------------------------------------------
-- @brief Define preset values for the push buttons (indicate that the buttons 
--        aren't pressed). Use '1' as the default state for active-low signals.
--------------------------------------------------------------------------------
constant PRESET  : std_logic_vector(2 downto 0) := "111";

--------------------------------------------------------------------------------
-- @brief Define a constant to turn off all LEDs.
--------------------------------------------------------------------------------
constant LEDS_OFF: std_logic_vector(2 downto 0) := "000";

--------------------------------------------------------------------------------
-- @brief Store the values of button_n[2:0] during the previous clock cycle.
--        Keep these values one clock cycle old and update them on the rising 
--        edge of the system clock.
--------------------------------------------------------------------------------
signal button_prev: std_logic_vector(2 downto 0);

--------------------------------------------------------------------------------
-- @brief Detect a falling edge of button_n[2:0]. Set button_edge(i) when the 
--        corresponding button is currently pressed (button_n(i) = '0') but 
--        wasn't pressed during the previous clock cycle (button_prev(i) = '1').
--------------------------------------------------------------------------------
signal button_edge: std_logic_vector(2 downto 0);

--------------------------------------------------------------------------------
-- @brief Use an internal signal to represent the LEDs' state. Use this signal 
--        for toggling the LEDs, as output signals cannot be directly read.
--------------------------------------------------------------------------------
signal led_s: std_logic_vector(2 downto 0);

begin

    --------------------------------------------------------------------------------
    -- @brief Update button_prev during a system reset or on the rising edge of 
    --        the system clock.
    --
    --        Set button_prev to its preset value "111" during a system reset.
    --        Update button_prev with the current value of button_n on the rising 
    --        edge of the system clock.
    --------------------------------------------------------------------------------
    process(clock, reset_n) is
    begin
        if (reset_n = '0') then
            button_prev <= PRESET;
        elsif (rising_edge(clock)) then
            button_prev <= button_n;
        end if;
    end process;
    
    --------------------------------------------------------------------------------
    -- @brief Update led_s during a system reset or on the rising edge of the 
    --        system clock.
    --
    --        Set led_s to its default value of "000" during a system reset.
    --        Toggle led_s(i) on the rising edge of the system clock when a falling 
    --        edge of button_n(i) is detected (i.e., when button_edge(i) = '1').
    --------------------------------------------------------------------------------
    process(clock, reset_n) is
    begin
        if (reset_n = '0') then
            led_s <= LEDS_OFF;
        elsif (rising_edge(clock)) then
            for i in 0 to 2 loop
                if (button_edge(i) = '1') then
                    led_s(i) <= not led_s(i);
                end if;
            end loop;
        end if;
    end process;
    
    --------------------------------------------------------------------------------
    -- @brief Derive button_edge by detecting a falling edge of button_n.
    --        A falling edge is identified when button_n(i) transitions from '1' 
    --        (not pressed) to '0' (pressed), while button_prev(i) still holds '1'.
    --------------------------------------------------------------------------------
    button_edge <= (not button_n) and button_prev;
    
    --------------------------------------------------------------------------------
    -- @brief Continuously assign the value of led_s to the output signal led.
    --------------------------------------------------------------------------------
    led <= led_s;

end architecture;