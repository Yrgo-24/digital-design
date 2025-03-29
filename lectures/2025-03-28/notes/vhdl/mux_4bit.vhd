--------------------------------------------------------------------------------
-- @brief Design of a 4-bit (commonly known as '4-to-1') multiplexer.
--
-- @param abcd Multiplexer inputs connected to SW[3:0].
-- @param sel  Selector bits connected to SW[5:4].
-- @param x    Multiplexer output connected to LEDR[0].
--
-- @note The multiplexer operates as follows:
--            - x = d if sel = 00
--            - x = c if sel = 01
--            - x = b if sel = 10
--            - x = a if sel = 11
--            - x = 0 if something goes wrong.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity mux_4bit is
    port(abcd: in std_logic_vector(3 downto 0);
         sel : in std_logic_vector(1 downto 0);
         x   : out std_logic);
end entity;

architecture behaviour of mux_4bit is
begin

    --------------------------------------------------------------------------------
    -- @brief Update the multiplexer output in accordance with the functional
    --        description above whenever the inputs 'abcd' and/or the selector
    --        signals 'sel' change.
    --------------------------------------------------------------------------------
    process(abcd, sel) is
    begin
        case (sel) is
            when "00"   => x <= abcd(0);
            when "01"   => x <= abcd(1);
            when "10"   => x <= abcd(2);
            when "11"   => x <= abcd(3);
            when others => x <= '0'; 
        end case;
    end process;
    
end architecture;