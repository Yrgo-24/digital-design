--------------------------------------------------------------------------------
-- @brief Synchronize a reset signal and 1-3 push buttons 
--        using the double-flop method. Synchronize each input signal 
--        with two flip-flops.
--
-- @tparam BUTTON_COUNT Set the number of push buttons (1-3).
--
-- @param clock          Provide the 50 MHz system clock.
-- @param reset_n        Provide the active-low reset signal.
-- @param button_n       Provide the active-low push button(s).
-- @param reset_s2_n     Output the synchronized active-low reset signal.
-- @param button_edge_s2 Detect the falling edge of the push button(s).
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity meta_prev is
    generic(BUTTON_COUNT: natural range 1 to 3);
    port(clock, reset_n: in std_logic;
         button_n      : in std_logic_vector(BUTTON_COUNT - 1 downto 0);
         reset_s2_n    : out std_logic;
         button_edge_s2: out std_logic_vector(BUTTON_COUNT - 1 downto 0));
end entity;

architecture behaviour of meta_prev is

--------------------------------------------------------------------------------
-- @brief Declare signals for synchronization and edge detection.
--
-- @param reset_s1_n   Hold the first stage of reset synchronizer.
-- @param reset_s2_n_s Hold the second stage of reset synchronizer 
--                     (internal representation of reset_s2_n).
-- @param button_s1_n  Hold the first stage of button synchronizer.
-- @param button_s2_n  Hold the second stage of button synchronizer.
-- @param button_s3_n  Hold the third stage of button synchronizer (for edge detection).
--------------------------------------------------------------------------------
signal reset_s1_n, reset_s2_n_s             : std_logic;
signal button_s1_n, button_s2_n, button_s3_n: std_logic_vector(BUTTON_COUNT - 1 downto 0);
begin

    --------------------------------------------------------------------------------
    -- @brief Synchronize the reset signals.
    --
    --        On reset (reset_n = 0), set the reset signals to '0' (active reset).
    --        On rising edge of the clock, double-flop synchronize reset_n:
    --            * Assign reset_n to reset_s1_n.
    --            * Assign reset_s1_n to reset_s2_n_s.
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
    -- @brief Synchronize the button signals.
    --
    --        On reset (reset_n = 0), set the button signals to '1' (inactive).
    --        On rising edge of the clock, double-flop synchronize button_n:
    --            * Assign button_n to button_s1_n.
    --            * Assign button_s1_n to button_s2_n.
    --            * Assign button_s2_n to button_s3_n.
    --------------------------------------------------------------------------------
    process (clock, reset_s2_n_s) is
    begin
        if (reset_s2_n_s = '0') then
            button_s1_n <= (others => '1');
            button_s2_n <= (others => '1');
            button_s3_n <= (others => '1');
        elsif (rising_edge(clock)) then
            button_s1_n <= button_n;
            button_s2_n <= button_s1_n;
            button_s3_n <= button_s2_n;
        end if;
    end process;

    --------------------------------------------------------------------------------
    -- @brief Assign the synchronized reset value to reset_s2_n.
    --------------------------------------------------------------------------------
    reset_s2_n <= reset_s2_n_s;
    
    --------------------------------------------------------------------------------
    -- @brief Detect the falling edge of each push button.
    --        Assert button_edge_s2 for one clock cycle on each falling edge.
    --------------------------------------------------------------------------------
    button_edge_s2 <= (not button_s2_n) and button_s3_n;

end architecture;