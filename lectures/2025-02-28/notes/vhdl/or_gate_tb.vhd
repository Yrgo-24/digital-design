--------------------------------------------------------------------------------
-- @brief Test bench for the 'or_gate' module.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all; -- Contains the std_logic data type.
use ieee.numeric_std.all;    -- Contains the to_unsigned function.

entity or_gate_tb is
end entity;

architecture behaviour of or_gate_tb is
signal a, b, x: std_logic := '0'; -- Signals used for simulation.
begin

    --------------------------------------------------------------------------------
    -- @brief Create an instance of the 'or_gate' module for simulation.
    --        Signals a, b, and x are connected to the ports of the same name.
    --------------------------------------------------------------------------------
    or_gate1: entity work.or_gate
        port map(a, b, x);

    --------------------------------------------------------------------------------
    -- @brief Try each combination {00 - 11} of inputs {a, b}, each for 10 ns.
    --        The simulation is halted once all combinations have been tested.
    --------------------------------------------------------------------------------
    simulation: process is
    begin
        for i in 0 to 3 loop                               -- Try each combination 0 - 3 = {00 - 11}.
            (a, b) <= std_logic_vector(to_unsigned(i, 2)); -- Assign current combination to {a, b}.
            wait for 10 ns;                                -- Keep current combination for 10 ns.
        end loop;
        wait;                                              -- Wait indefinitely.
    end process;
end architecture;