--------------------------------------------------------------------------------
-- @brief Test bench for the 'net1' module.
--
--        Each combination {0, 0, 0, 0} - {1, 1, 1, 1} of inputs {a, b, c, d}
--        is tested, each combination for 10 ns. Hence the total simulation 
--        time is 160 ns.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all; -- Contains the 'std_logic' type.
use ieee.numeric_std.all;    -- Contains the 'to_unsigned' function.

entity net1_tb is
end entity;

architecture behaviour of net1_tb is

--------------------------------------------------------------------------------
-- @brief Signals used for the simulation. The signals are connected to ports
--        {a, b, c, d} and {x, y, z} of the 'net1' module as described below:
--
--            * abcd(3) is connected to a.
--            * abcd(2) is connected to b.
--            * abcd(1) is connected to c.
--            * abcd(0) is connected to d.
--            * xyz(2) is connected to x.
--            * xyz(1) is connected to y.
--            * xyz(0) is connected to z.
--------------------------------------------------------------------------------
signal abcd: std_logic_vector(3 downto 0); 
signal xyz: std_logic_vector(2 downto 0);  
begin

    --------------------------------------------------------------------------------
    -- @brief Create an instance of the 'or_gate' module for simulation.
    --        The signals abcd and xyz are connected to ports {a, b, c, d} and
    --        {x, y, z} as described above via ordered port mapping. 
    --------------------------------------------------------------------------------
    test: entity work.net1
        port map(abcd(3), abcd(2), abcd(1), abcd(0), 
                 xyz(2), xyz(1), xyz(0));
        
    --------------------------------------------------------------------------------
    -- @brief Try each combination {0, 0, 0, 0} - {1, 1, 1, 1} of inputs {a, b, c, d}, 
    --        each for 10 ns. The simulation is halted once all combinations have 
    --        been tested once.
    --
    --        A for loop is used, where the number 'i' ranges from 0 - 15. 
    --        The value of 'i' is converted to a 4-bite unsigned value, then to a
    --        std_logic_vector, i.e. four bits. This combination is assigned to
    --        signal abcd, which is connected to the ports of the same name in the
    --        'net1' module. After 10 ns, the next combination is tested.
    --------------------------------------------------------------------------------
    sim_process: process is
    begin
        for i in 0 to 15 loop                            -- Try each combination 0 - 15.
            abcd <= std_logic_vector(to_unsigned(i, 4)); -- Assign current combination to {a, b, c, d}.
            wait for 10 ns;                              -- Keep combination for 10 ns.
        end loop;
        wait;                                            -- Wait indefinitely.
    end process;

end architecture;
