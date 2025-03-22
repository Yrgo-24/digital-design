--------------------------------------------------------------------------------
-- @brief Test bench for the `comparator_4bit´ module.
--
--        Each combination of inputs {a,b,c,d} is tested one at a time, each 
--        combination for 10 ns. For this reason, the total simulation time 
--        is 160 ns.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator_4bit_tb is
end entity;

architecture behaviour of comparator_4bit_tb is
signal abcd: std_logic_vector(3 downto 0); -- Signal representation of {a,b,c,d}.
signal xyz : std_logic_vector(2 downto 0); -- Signal representation of {x,y,z}.
begin

    --------------------------------------------------------------------------------
    -- @brief Create instance of the `comparator_4bit´ module for testing.
    --        Ports {a,b,c,d} and {x,y,z} are connected to signals abcd and xyz
    --        in the test bench.
    --
    -- @note Regarding the port map:
    --           - abcd(3) is connected to a.
    --           - abcd(2) is connected to b.
    --           - abcd(1) is connected to c.
    --           - abcd(0) is connected to d.
    --           - xyz(2) is connected to x.
    --           - xyz(1) is connected to y.
    --           - xyz(0) is connected to z. 
    --------------------------------------------------------------------------------
    comparator_4bit: entity work.comparator_4bit
        port map(abcd(3), abcd(2), abcd(1), abcd(0), xyz(2), xyz(1), xyz(0));
        
    --------------------------------------------------------------------------------
    -- @brief Try each combination {0,0,0,0} - {1,1,1,1} of inputs {a,b,c,d}
    --        via the connected signal abcd. Each combination is tested during 10 ns.
    --        The outputs {x,y,z} will be displayed via connected signal xyz.
    --------------------------------------------------------------------------------
    sim_process: process is
    begin
        for i in 0 to 15 loop                            -- Try each combination 0 - 15.
            abcd <= std_logic_vector(to_unsigned(i, 4)); -- Assign current combination to abcd.
            wait for 10 ns;                              -- Keep combination for 10 ns.
        end loop;
        wait;                                            -- Wait indefinitely.
    end process;

end architecture;