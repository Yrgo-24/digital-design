--------------------------------------------------------------------------------
-- @brief Finite State Machine (FSM) to control an LED using two push buttons.
--
-- @param clock    50 MHz system clock.
-- @param reset_n  Active-low reset signal.
-- @param button_n Active-low push buttons for controlling the LED state.
-- @param led      LED controlled by the FSM.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------------------
-- @brief Entity declaration for module 'fsm'.
--------------------------------------------------------------------------------
entity fsm is
    port(clock, reset_n: in std_logic;
         button_n      : in std_logic_vector(1 downto 0);
         led           : out std_logic);
end entity;

--------------------------------------------------------------------------------
-- @brief Architecture declaration for module 'fsm'.
--------------------------------------------------------------------------------
architecture behaviour of fsm is

--------------------------------------------------------------------------------
-- @brief Component declaration for the SystemVerilog module 'counter'.
--        Allows instantiation of the SystemVerilog counter in VHDL.
--
-- @tparam MAX_COUNT The max count value of the counter.
--
-- @param clock      50 MHz system clock.
-- @param reset_s2_n Asynchronous active-low reset signal.
-- @param enable     Enable signal for the counter (1 = enabled).
-- @param elapsed    Indicates that the timer has elapsed.
--------------------------------------------------------------------------------
component counter is
    generic(MAX_COUNT: natural);
    port(clock, reset_s2_n, enable: in std_logic;
         elapsed                  : out std_logic);
end component;

--------------------------------------------------------------------------------
-- @brief Enumeration type representing the FSM states.
--
-- @value STATE_OFF   The LED is off.
-- @value STATE_BLINK The LED blinks every 100 ms.
-- @value STATE_ON    The LED is on.
--------------------------------------------------------------------------------
type state_t is (STATE_OFF, STATE_BLINK, STATE_ON);

--------------------------------------------------------------------------------
-- @brief Signal holding the current state of the FSM.
--------------------------------------------------------------------------------
signal state: state_t;

--------------------------------------------------------------------------------
-- @brief Detect falling edge on each push button (active-low).
--------------------------------------------------------------------------------
signal button_edge_s2: std_logic_vector(1 downto 0);

--------------------------------------------------------------------------------
-- @brief Trigger state machine update:
--        - to_next_state: Go to next state on falling edge of button_n(0).
--        - to_prev_state: Go to previous state on falling edge of button_n(1).
--------------------------------------------------------------------------------
signal to_next_state, to_prev_state: std_logic;

--------------------------------------------------------------------------------
-- @brief Indicate whether the timer is enabled ('1' = true).
--------------------------------------------------------------------------------
signal timer_enabled: std_logic;

--------------------------------------------------------------------------------
-- @brief Indicate that the timer has elapsed ('1' = true).
--------------------------------------------------------------------------------
signal timer_elapsed: std_logic;

--------------------------------------------------------------------------------
-- @brief Synchronized active low reset signal ('0' = reset).
--------------------------------------------------------------------------------
signal reset_s2_n: std_logic;

--------------------------------------------------------------------------------
-- @brief Internal representation of the LED value ('1' = enabled).
--------------------------------------------------------------------------------
signal led_s: std_logic;

begin

    --------------------------------------------------------------------------------
    -- @brief Create a process to update the state of the state machine at system
    --        reset (reset_s2_n = '0') or rising edge of the clock.
    --------------------------------------------------------------------------------
    process (clock, reset_s2_n) is
    begin
         -- If reset_s2_n = '0', set state to STATE_OFF.
         if (reset_s2_n = '0') then
             state <= STATE_OFF;
         -- Else on rising edge of the clock, update in accordance with the state diagram.
         elsif (rising_edge(clock)) then
             -- Check the value of the state signal via a case statement.
             -- STATE_OFF -> STATE_BLINK -> STATE_ON -> STATE_OFF...
             case (state) is
                 when STATE_OFF =>
                     if (to_next_state = '1') then
                         state <= STATE_BLINK;
                     elsif (to_prev_state = '1') then
                         state <= STATE_ON;
                     end if;
                 when STATE_BLINK =>
                      if (to_next_state = '1') then
                         state <= STATE_ON;
                     elsif (to_prev_state = '1') then
                         state <= STATE_OFF;
                     end if;
                 when STATE_ON =>
                     if (to_next_state = '1') then
                         state <= STATE_OFF;
                     elsif (to_prev_state = '1') then
                         state <= STATE_BLINK;
                     end if;
                 -- Reset the state machine on error.
                 when others =>
                    state <= STATE_OFF;
             end case;
         end if;
    end process;
    
    --------------------------------------------------------------------------------
    -- @brief Create a process to update the LED value.
    --------------------------------------------------------------------------------
    process (clock, reset_s2_n) is
    begin
        -- If reset_s2_n = '0', disable the LED (led_s = '0').
        if (reset_s2_n = '0') then
            led_s <= '0';
        -- Else on rising edge of the clock, update the LED value
        -- in accordance with current state.
        elsif (rising_edge(clock)) then
            case (state) is
                when STATE_OFF =>
                    led_s <= '0';
                when STATE_BLINK =>
                    -- If timer_elapsed = '1', toggle the LED (led_s = !led_s).
                    if (timer_elapsed = '1') then
                        led_s <= not led_s;
                    end if;
                when STATE_ON =>
                    led_s <= '1';
                -- Disable the LED (led_s = '0') on error.
                when others =>
                    led_s <= '0';
            end case;
        end if;
    end process;

    --------------------------------------------------------------------------------
    -- @brief Create a counter used as a 10 Hz timer.
    --
    -- @note The max count value is set to 5 000 000, since the clock frequency
    --       is 50 MHz.
    --------------------------------------------------------------------------------
    counter1 : counter
    generic map(MAX_COUNT => 5000000)
    port map(clock      => clock,
             reset_s2_n => reset_s2_n,
             enable     => timer_enabled,
             elapsed    => timer_elapsed);
             
    --------------------------------------------------------------------------------
    -- @brief Create a metastability prevention instance. 
    -- 
    -- @note Two push buttons are used in this case, hence BUTTON_COUNT = 2.
    --------------------------------------------------------------------------------
    meta_prev1 : entity work.meta_prev
    generic map(BUTTON_COUNT => 2)
    port map(clock          => clock,
             reset_n        => reset_n,
             button_n       => button_n,
             reset_s2_n     => reset_s2_n,
             button_edge_s2 => button_edge_s2);
    
    --------------------------------------------------------------------------------
    -- @brief Request to go to next state on falling edge of button_n(0) only.
    --------------------------------------------------------------------------------
    to_next_state <= (not button_edge_s2(1)) and button_edge_s2(0);

    --------------------------------------------------------------------------------
    -- @brief Request to go to previous state on falling edge of button_n(1) only.
    --------------------------------------------------------------------------------
    to_prev_state <= button_edge_s2(1) and (not button_edge_s2(0));
    
    --------------------------------------------------------------------------------
    -- @brief Enable the timer only when the current state is STATE_BLINK.
    --------------------------------------------------------------------------------
    timer_enabled <= '1' when state = STATE_BLINK else '0';
    
    --------------------------------------------------------------------------------
    -- @brief Continuously assign the value of led_s to the LED.
    --------------------------------------------------------------------------------
    led <= led_s;

end architecture;