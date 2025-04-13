--------------------------------------------------------------------------------
-- @brief Test bench for the display module. Each combination 0000 - 1111 of
--        the number to display is tested during 10 ns, hence the simulation
--        time is 160 ns.
--
--        The correlation between the input number and the binary code
--        displayed on the corrected hex display is shown below:
--
--        -------------------
--        | input |  code   |
--        |-----------------|
--        | 0000  | 1000000 |
--        | 0001  | 1111001 |
--        | 0010  | 0100100 |
--        | 0011  | 0110000 |
--        | 0100  | 0011001 |
--        | 0101  | 0010010 |
--        | 0110  | 0000010 |
--        | 0111  | 1111000 |
--        | 1000  | 0000000 |
--        | 1001  | 0010000 |
--        | 1010  | 0001000 |
--        | 1011  | 0000011 |
--        | 1100  | 1000110 |
--        | 1101  | 0100001 |
--        | 1110  | 0000110 |
--        | 1111  | 0001110 |
--        | other | 0000000 |
--        -------------------
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_tb is
end entity;

architecture behaviour of display_tb is

--------------------------------------------------------------------------------
-- @brief Signals used to test the display module.
--------------------------------------------------------------------------------
signal number: std_logic_vector(3 downto 0);
signal hex   : std_logic_vector(6 downto 0);

begin

    --------------------------------------------------------------------------------
    -- @brief Create an instance of the display module and connect signals with
    --        the same name as the corresponding ports for simulation.
    --------------------------------------------------------------------------------
    display1: entity work.display
        port map(number, hex);
        
    --------------------------------------------------------------------------------
    -- @brief Test each combination of the inputs during 10 ns each.  
    --------------------------------------------------------------------------------
    simulation: process is
    begin
        for i in 0 to 16 loop                              -- Try each combination one by one.
            number <= std_logic_vector(to_unsigned(i, 4)); -- Assign new combination to 'number'.
            wait for 10 ns;                                -- Hold current state for 10 ns.
        end loop;
        wait;                                              -- Halt process to stop the simulation.
    end process;

end architecture;