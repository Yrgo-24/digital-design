--------------------------------------------------------------------------------
-- @brief Module for writing a hexadecimal number 0 - F to a hex display.
--
-- @param number[3:0] The number to print in 4-bit binary form.
-- @param hex[6:0]    The hex display for which to write.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity display is
    port(number: in std_logic_vector(3 downto 0);
         hex   : out std_logic_vector(6 downto 0));
end entity;

architecture behaviour of display is

--------------------------------------------------------------------------------
-- @brief Binary codes for hexadecimal digits 0 - F.
--------------------------------------------------------------------------------
constant DISPLAY_0  : std_logic_vector(6 downto 0) := "1000000";
constant DISPLAY_1  : std_logic_vector(6 downto 0) := "1111001";
constant DISPLAY_2  : std_logic_vector(6 downto 0) := "0100100";
constant DISPLAY_3  : std_logic_vector(6 downto 0) := "0110000";
constant DISPLAY_4  : std_logic_vector(6 downto 0) := "0011001";
constant DISPLAY_5  : std_logic_vector(6 downto 0) := "0010010";
constant DISPLAY_6  : std_logic_vector(6 downto 0) := "0000010";
constant DISPLAY_7  : std_logic_vector(6 downto 0) := "1111000";
constant DISPLAY_8  : std_logic_vector(6 downto 0) := "0000000";
constant DISPLAY_9  : std_logic_vector(6 downto 0) := "0010000";
constant DISPLAY_A  : std_logic_vector(6 downto 0) := "0001000";
constant DISPLAY_B  : std_logic_vector(6 downto 0) := "0000011";
constant DISPLAY_C  : std_logic_vector(6 downto 0) := "1000110";
constant DISPLAY_D  : std_logic_vector(6 downto 0) := "0100001";
constant DISPLAY_E  : std_logic_vector(6 downto 0) := "0000110";
constant DISPLAY_F  : std_logic_vector(6 downto 0) := "0001110";
constant DISPLAY_OFF: std_logic_vector(6 downto 0) := "1111111";

begin

    --------------------------------------------------------------------------------
    -- @brief Update the digit written to the hex display every time the number
    --        changes.
    --------------------------------------------------------------------------------
    process (number) is
    begin
        case (number) is
            when "0000" => hex <= DISPLAY_0;
            when "0001" => hex <= DISPLAY_1;
            when "0010" => hex <= DISPLAY_2;
            when "0011" => hex <= DISPLAY_3;
            when "0100" => hex <= DISPLAY_4;
            when "0101" => hex <= DISPLAY_5;
            when "0110" => hex <= DISPLAY_6;
            when "0111" => hex <= DISPLAY_7;
            when "1000" => hex <= DISPLAY_8;
            when "1001" => hex <= DISPLAY_9;
            when "1010" => hex <= DISPLAY_A;
            when "1011" => hex <= DISPLAY_B;
            when "1100" => hex <= DISPLAY_C;
            when "1101" => hex <= DISPLAY_D;
            when "1110" => hex <= DISPLAY_E;
            when "1111" => hex <= DISPLAY_F;
            when others => hex <= DISPLAY_OFF;
        end case;
    end process;

end architecture;
