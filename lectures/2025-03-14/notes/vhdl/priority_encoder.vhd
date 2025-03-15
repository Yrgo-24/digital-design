--------------------------------------------------------------------------------
-- @brief Design of a 2-bit priority encoder.
--
-- @param {a,b,c,d} 1-bit inputs.
-- @param {x,y}     1-bit outputs.
--
-- @note The encoder operates like this:
--           - a = 1               => {x,y} = {1,1}
--           - a = 0, b = 1        => {x,y} = {1,0}
--           - a = 0, b = 0, c = 1 => {x,y} = {0,1}
--           - a = 0, b = 0, c = 0 => {x,y} = {0,0}
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity priority_encoder is
    port(a, b, c, d: in std_logic;
         x, y      : out std_logic);
end entity;

architecture behaviour of priority_encoder is
signal b_n: std_logic; -- Signal representation of b'.
begin
    b_n <= not b;          -- Assign b' = !b.
    x <= a or b;           -- Assign x = a + b.
    y <= a or (b_n and c); -- Assign y = a + b'c.
end architecture;