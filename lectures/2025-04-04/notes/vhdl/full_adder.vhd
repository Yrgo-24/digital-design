--------------------------------------------------------------------------------
-- @brief Design of a full adder.
--
-- @param inputs  Full adder inputs {A,B,Cin} as a vector.
-- @param outputs Full adder outputs {Cout,Sum} as a vector.
--
-- @details The truth table of the full adder is shown below.
--
--       {A,B,Cin} {Cout,Sum}
--          000        00
--          001        01
--          010        01
--          011        10
--          100        01
--          101        10
--          110        10
--          111        11
--
-- @note Cin = Carry in, Cout = Carry out.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
    port(inputs : in std_logic_vector(2 downto 0);
         outputs: out std_logic_vector(1 downto 0));
end entity;

architecture behaviour of full_adder is
begin

    --------------------------------------------------------------------------------
    -- @brief Process triggered at change of the input, i.e. change of A, B, or Cin.
    --
    --        The output is updated in accordance with the truth table.
    --        If something goes wrong, the output is cleared.
    --------------------------------------------------------------------------------
    process (inputs) is
    begin
        case (inputs) is
            when "000"  => outputs <= "00";
            when "001"  => outputs <= "01";
            when "010"  => outputs <= "01";
            when "011"  => outputs <= "10";
            when "100"  => outputs <= "01";
            when "101"  => outputs <= "10";
            when "110"  => outputs <= "10";
            when "111"  => outputs <= "11";
            when others => outputs <= "00";
         end case; 
    end process;

end architecture;