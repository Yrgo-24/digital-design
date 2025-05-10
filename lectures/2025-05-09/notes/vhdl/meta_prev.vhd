--------------------------------------------------------------------------------
-- @brief Module used for synchronizing a reset signal and a push button with
--        the double flop method, i.e. each input signal is synchronized with
--        two flip flops. 
--
-- @param clock          50 MHz system clock.
-- @param reset_n        Active-low reset signal.
-- @param button_n       Active low push button for toggling the LED.
-- @param reset_s2_n     Synchronized active-low reset signal.
-- @param button_edge_s2 Indicates falling edge of the push button.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity meta_prev is
    port(clock, reset_n, button_n  : in std_logic;
         reset_s2_n, button_edge_s2: out std_logic);
end entity;

architecture behaviour of meta_prev is

--------------------------------------------------------------------------------
-- @brief Signals used for synchronization and edge detection.
--
-- @param reset_s1_n   First stage of reset synchronizer.
-- @param reset_s2_n_s Second stage of reset synchronizer 
--                     (internal representation of reset_s2_n).
-- @param button_s1_n  First stage of button synchronizer.
-- @param button_s2_n  Second stage of button synchronizer.
-- @param button_s3_n  Third stage of button synchronizer 
--                     (used for edge detection).
--------------------------------------------------------------------------------
signal reset_s1_n, reset_s2_n_s             : std_logic;
signal button_s1_n, button_s2_n, button_s3_n: std_logic;
begin

    --------------------------------------------------------------------------------
    -- @brief Synchronize the reset signals with a synchronized process.
    --
    --        On reset (reset_n = 0), set the reset signals to '0' (active reset).
    --        On rising edge of the clock, double-flop synchronize reset_n:
    --            * reset_s1_n is assigned the value of reset_n.
    --            * reset_s2_n_s is assigned the value of reset_s1_n.
    --------------------------------------------------------------------------------
    process (clock, reset_n) is
    begin
        if (reset_n = '0') then
            reset_s1_n   <= '0';
            reset_s2_n_s <= '0';
        elsif (rising_edge(clock)) then
            reset_s1_n   <= reset_n;
            reset_s2_n_s <= reset_s1_n;
        end if;
    end process;
    
    --------------------------------------------------------------------------------
    -- @brief Synchronize the button signals with a synchronized process.
    --
    --        On reset (reset_n = 0), set the button signals to '1' (inactive).
    --        On rising edge of the clock, double-flop synchronize button_n:
    --            * button_s1_n is assigned the value of button_n.
    --            * button_s2_n is assigned the value of button_s1_n.
    --            * button_s3_n is assigned the value of button_s2_n.
    --------------------------------------------------------------------------------
    process (clock, reset_s2_n_s) is
    begin
        if (reset_s2_n_s = '0') then
            button_s1_n <= '1';
            button_s2_n <= '1';
            button_s3_n <= '1';
        elsif (rising_edge(clock)) then
            button_s1_n <= button_n;
            button_s2_n <= button_s1_n;
            button_s3_n <= button_s2_n;
        end if;
    end process;

    -- Continuously assign the synchronized reset value to reset_s2_n.
    reset_s2_n <= reset_s2_n_s;
    
    -- button_edge_s2 = 1 when button_s2_n = 0 and button_s3_n = 1, i.e.
    -- when the button is currently pressed, but wasn't pressed a moment ago.
    button_edge_s2 <= (not button_s2_n) and button_s3_n;

end architecture;