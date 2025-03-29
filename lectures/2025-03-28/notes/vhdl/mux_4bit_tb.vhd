--------------------------------------------------------------------------------
-- @brief Test bench for the 'mux_4bit' module.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_4bit_tb is
end entity;

architecture behaviour of mux_4bit_tb is

--------------------------------------------------------------------------------
-- @brief Signals used to connect to the ports of the 'mux_4bit' module.
--------------------------------------------------------------------------------
signal abcd: std_logic_vector(3 downto 0);
signal sel : std_logic_vector(1 downto 0);
signal x   : std_logic;

begin

    --------------------------------------------------------------------------------
    -- @brief Create instance of the 'mux_4bit' module for simulation. The signals
    --        declared above are connected to the corresponding ports.
    --------------------------------------------------------------------------------
    mux_4bit1: entity work.mux_4bit
        port map(abcd, sel, x);
      
    --------------------------------------------------------------------------------
    -- @brief Try each combination {00}-{11} of selector signals 'sel' for each
    --        combination {0000}-{1111} of inputs 'abcd', each for 10 ns.
    --
    -- @note Nested for loops are utilized for this test:
    --           - The outer loop is used to assign each combination of 'sel'. 
    --           - The inner loop is used to assign each combination of 'abcd' while 
    --             using the current 'sel' combination (assigned in the outer loop).
    --------------------------------------------------------------------------------
    simulation: process is
    begin
        for i in 0 to 3 loop
            sel <= std_logic_vector(to_unsigned(i, 2));
            for j in 0 to 15 loop
                abcd <= std_logic_vector(to_unsigned(j, 4)); 
                wait for 10 ns;
            end loop;
        end loop;
        wait;
    end process;

end architecture;