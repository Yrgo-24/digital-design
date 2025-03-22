--------------------------------------------------------------------------------
-- @brief Design of a 4-bit comparator.
--
-- @param {a,b,c,d} 1-bit inputs.
-- @param {x,y,z}     1-bit outputs.
--
-- @note The comparator operates like this:
--           - {a,b} > {c,d} => {x,y,z} = {1,0,0}
--           - {a,b} = {c,d} => {x,y,z} = {0,1,0}
--           - {a,b} < {c,d} => {x,y,z} = {0,0,1}
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity comparator_4bit is
    port(a, b, c, d: in std_logic;
         x, y, z   : out std_logic);
end entity;

architecture behaviour of comparator_4bit is

-- Signal representations of {a',b',c',d'}.
signal a_n, b_n, c_n, d_n: std_logic;

begin
    -- Assign a', b', c' and d' to the corresponding signals.
    a_n <= not a; b_n <= not b; c_n <= not c; d_n <= not d;
    
    -- Assign x = ac' + bc'd' + abd'.
    x <= (a and c_n) or (b and c_n and d_n) or (a and b and d_n);
    
    -- Assign y = (a ^ c)' * (b ^ d)'.
    y <= (a xnor c) and (b xnor d);
    
    -- Assign z = a'c + a'b'd + b'cd.
    z <= (a_n and c) or (a_n and b_n and d) or (b_n and c and d);

end architecture;