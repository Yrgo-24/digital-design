--------------------------------------------------------------------------------
-- @brief Test bench for the 'full_adder' module.
--
--        Each combination {0,0,0} - {1,1,1} of inputs {A,B,Cin} is tested, 
--        each for 10 ns. Hence the total simulation time is 80 ns. 
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity full_adder_tb is
end entity;

architecture behaviour of full_adder_tb is

--------------------------------------------------------------------------------
-- @brief Signals used for the simulation. These signals represent the ports
--        of the 'full_adder' module and will be displayed in ModelSim.
--------------------------------------------------------------------------------
signal inputs : std_logic_vector(2 downto 0);
signal outputs: std_logic_vector(1 downto 0);
begin

    --------------------------------------------------------------------------------
    -- @brief Create a full adder named 'full_adder1'. The signals above are 
    --        connected to the associated ports via port mapping.
    --------------------------------------------------------------------------------
    full_adder1: entity work.full_adder
        port map(inputs, outputs);
        
    --------------------------------------------------------------------------------
    -- @brief Run each combination {0,0,0} - {1,1,1} of inputs {A,B,Cin} via a loop.
    --        Each combination is tested for 10 ns. The process is halted once
    --        the simulation is finished.
    --------------------------------------------------------------------------------
    process is
    begin
      for i in 0 to 7 loop
            -- Convert i to a 3-bit vector, assign to signal 'inputs'.
            inputs <= std_logic_vector(to_unsigned(i, 3));
            -- Keep this combination for 10 ns.
            wait for 10 ns;
        end loop;
        -- Halt process, otherwise the simulation will start over.
        wait;
    end process;

end architecture;