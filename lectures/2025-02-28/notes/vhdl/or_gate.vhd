--------------------------------------------------------------------------------
-- @brief Implementation of an OR gate consisting of inputs {a, b} and output x.
--
-- @param a, b Inputs.
-- @param x    Output.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all; -- Contains the std_logic data type.

entity or_gate is
    port(a, b: in std_logic;
         x: out std_logic);
end entity;

architecture behaviour of or_gate is
begin 
    x <= a or b; -- Assign x = a + b.
end architecture;
