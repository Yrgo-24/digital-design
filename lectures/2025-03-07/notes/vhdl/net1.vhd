--------------------------------------------------------------------------------
-- @brief Design of a small circuit consisting of inputs {a, b, c, d} and 
--        outputs {x, y, z}.
--
--        Equations:
--            * x = a ^ b
--            * y = d
--            * z = cd + b'd'
--
-- @param {a, b, c, d} One-bit inputs.
-- @param {x, y, z}    One-bit outputs.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity net1 is
    port(a, b, c, d: in std_logic; 
         x, y, z: out std_logic);
end entity;

architecture behaviour of net1 is

--------------------------------------------------------------------------------
-- @brief Signals used in the architecture.
--
-- @param b_n The inverse of b, i.e. b'.
-- @param d_n The inverse of d, i.e. d'.
--------------------------------------------------------------------------------
signal b_n, d_n: std_logic;

begin
    b_n <= not b;                    -- Assign b_n = b'
    d_n <= not d;                    -- Assign d_n = d'
    
    x <= a xor b;                    -- Assign x = a ^ b
    y <= d;                          -- Assign y = d
    z <= (c and d) or (b_n and d_n); -- Assign z = cd + b'd'
end architecture;
