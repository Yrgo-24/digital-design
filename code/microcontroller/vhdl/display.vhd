---------------------------------------------------------------------------------------------------
-- display.vhd: Möjliggör utskrift av given OP-kod samt innehållet i CPU-register R16 via fem
--              7-segmentsdisplayer med ett mellanrum dem emellan, exempelvis LDI 02 eller ORI 20.
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.def.all;

---------------------------------------------------------------------------------------------------
-- display: Innehåller funktionalitet för att skriva ut aktuell OP-kod samt innehållet i
--          CPU-register R16 via fem 7-segmentsdisplayer. hex[5:3] visar aktuell OP-kod medan 
--          hex[1:0] visar innehållet i R16 på hexadecimal form. hex2 används som mellanrum 
--          mellan OP-koden samt innehållet i R16 och har därmed inte definierats.
---------------------------------------------------------------------------------------------------
entity display is
   port
   (
      clock      : in std_logic;                     -- 50 MHz systemklocka.
      reset_s2_n : in std_logic;                     -- Synkroniserad inverterad reset-signal. 
      enable     : in std_logic;                     -- Enable-signal för aktivering av displayer. 
      op_code    : in std_logic_vector(7 downto 0);  -- Aktuell OP-kod.
      r16        : in std_logic_vector(7 downto 0);  -- Innehållet i register R16.
      hex5       : out std_logic_vector(6 downto 0); -- Display, visar OP-kod.
      hex4       : out std_logic_vector(6 downto 0); -- Display, visar OP-kod.
      hex3       : out std_logic_vector(6 downto 0); -- Display, visar OP-kod.
      hex1       : out std_logic_vector(6 downto 0); -- Display, visar innehållet i CPU-register R16.
      hex0       : out std_logic_vector(6 downto 0)  -- Display, visar innehållet i CPU-register R16.
   );
end entity;

architecture behaviour of display is

-- Konstanter för siffror på hex-displayerna:
constant OFF   : std_logic_vector(6 downto 0) := "1111111"; -- Släcker 7-segmentsdisplay.
constant ZERO  : std_logic_vector(6 downto 0) := "1000000"; -- Binärkod för heltalet 0.
constant ONE   : std_logic_vector(6 downto 0) := "1111001"; -- Binärkod för heltalet 1.
constant TWO   : std_logic_vector(6 downto 0) := "0100100"; -- Binärkod för heltalet 2.
constant THREE : std_logic_vector(6 downto 0) := "0110000"; -- Binärkod för heltalet 3.
constant FOUR  : std_logic_vector(6 downto 0) := "0011001"; -- Binärkod för heltalet 4.
constant FIVE  : std_logic_vector(6 downto 0) := "0010010"; -- Binärkod för heltalet 5.
constant SIX   : std_logic_vector(6 downto 0) := "0000010"; -- Binärkod för heltalet 6.
constant SEVEN : std_logic_vector(6 downto 0) := "1111000"; -- Binärkod för heltalet 7.
constant EIGHT : std_logic_vector(6 downto 0) := "0000000"; -- Binärkod för heltalet 8.
constant NINE  : std_logic_vector(6 downto 0) := "0010000"; -- Binärkod för heltalet 9.
constant A     : std_logic_vector(6 downto 0) := "0001000"; -- Binärkod för bokstaven A.
constant B     : std_logic_vector(6 downto 0) := "0000011"; -- Binärkod för bokstaven B.   
constant C     : std_logic_vector(6 downto 0) := "1000110"; -- Binärkod för bokstaven C.
constant D     : std_logic_vector(6 downto 0) := "0100001"; -- Binärkod för bokstaven D.
constant E     : std_logic_vector(6 downto 0) := "0000110"; -- Binärkod för bokstaven E.
constant F     : std_logic_vector(6 downto 0) := "0001110"; -- Binärkod för bokstaven F.
constant G     : std_logic_vector(6 downto 0) := "0000010"; -- Binärkod för bokstaven G.
constant H     : std_logic_vector(6 downto 0) := "0001001"; -- Binärkod för bokstaven H.
constant I     : std_logic_vector(6 downto 0) := "1111001"; -- Binärkod för bokstaven I.
constant J     : std_logic_vector(6 downto 0) := "1110001"; -- Binärkod för bokstaven J.
constant L     : std_logic_vector(6 downto 0) := "1000111"; -- Binärkod för bokstaven L.
constant M     : std_logic_vector(6 downto 0) := "1101010"; -- Binärkod för bokstaven M.
constant N     : std_logic_vector(6 downto 0) := "1001000"; -- Binärkod för bokstaven N.
constant O     : std_logic_vector(6 downto 0) := "1000000"; -- Binärkod för bokstaven O.
constant P     : std_logic_vector(6 downto 0) := "0001100"; -- Binärkod för bokstaven P.
constant R     : std_logic_vector(6 downto 0) := "0101111"; -- Binärkod för bokstaven R.
constant S     : std_logic_vector(6 downto 0) := "0010010"; -- Binärkod för bokstaven S.
constant T     : std_logic_vector(6 downto 0) := "0000111"; -- Binärkod för bokstaven T.
constant U     : std_logic_vector(6 downto 0) := "1000001"; -- Binärkod för bokstaven U.
constant V     : std_logic_vector(6 downto 0) := "1100011"; -- Binärkod för bokstaven V.

---------------------------------------------------------------------------------------------------
-- get_digit: Returnerar binärkoden för en hexadecimal siffra 0 - F utefter ingånde argument
--            number. Returnerad binärkod kan skrivas till en 7-segmentsdisplay för att visa
--            motsvarande siffra. Vid fel returneras binärkod för att släcka 7-segmentsdisplayen.
---------------------------------------------------------------------------------------------------
function get_digit(number: natural range 0 to 9) return std_logic_vector is
begin
   case (number) is
      when 0      => return ZERO;
      when 1      => return ONE;
      when 2      => return TWO;
      when 3      => return THREE;
      when 4      => return FOUR;
      when 5      => return FIVE;
      when 6      => return SIX;
      when 7      => return SEVEN;
      when 8      => return EIGHT;
      when 9      => return NINE;
      when others => return OFF;
   end case;
end function;

begin

   ------------------------------------------------------------------------------------------------
   -- DISPLAY_OP_CODE: Skriver ut aktuell OP-kod på 7-segmentsdisplayer hex[5:3].
   ------------------------------------------------------------------------------------------------
   DISPLAY_OP_CODE: process(clock, reset_s2_n) is
   begin
      if (reset_s2_n = '0') then
         hex5 <= OFF;
         hex4 <= OFF;
         hex3 <= OFF;
      elsif (rising_edge(clock)) then
         if (enable = '1') then
            case (op_code) is          
               when NOP => 
                  hex5 <= N;
                  hex4 <= O;
                  hex3 <= P;
                  
                when LDI => 
                  hex5 <= L; 
                  hex4 <= D; 
                  hex3 <= I; 
               
               when MOV =>
                  hex5 <= M;
                  hex4 <= O;
                  hex3 <= V;
               
               when OUTD =>
                  hex5 <= O;
                  hex4 <= U;
                  hex3 <= T;
               
               when IND =>
                  hex5 <= I;
                  hex4 <= N;
                  hex3 <= OFF;
               
               when STS =>
                  hex5 <= S;
                  hex4 <= T;
                  hex3 <= S;
               
               when LDS =>
                  hex5 <= L;
                  hex4 <= D;
                  hex3 <= S;
               
               when ORI =>
                  hex5 <= O;
                  hex4 <= R;
                  hex3 <= I;
               
               when ANDI =>
                  hex5 <= A;
                  hex4 <= N;
                  hex3 <= D;
               
               when XORI =>
                  hex5 <= E;
                  hex4 <= O;
                  hex3 <= R;
               
               when ORD =>
                  hex5 <= O;
                  hex4 <= R;
                  hex3 <= OFF;
               
               when ANDD =>
                  hex5 <= A;
                  hex4 <= N;
                  hex3 <= OFF;
               
               when XORD =>
                  hex5 <= E;
                  hex4 <= O;
                  hex3 <= OFF;
               
               when ADDI =>
                  hex5 <= A;
                  hex4 <= D;
                  hex3 <= D;
               
               when SUBI =>
                  hex5 <= S;
                  hex4 <= U;
                  hex3 <= B;
               
               when ADD =>
                  hex5 <= A;
                  hex4 <= D;
                  hex3 <= D;

               when SUBD =>
                  hex5 <= S;
                  hex4 <= U;
                  hex3 <= B;
               
               when INC =>
                  hex5 <= I;
                  hex4 <= N;
                  hex3 <= C;
               
               when DEC =>
                  hex5 <= D;
                  hex4 <= E;
                  hex3 <= C;
               
              when  CLR =>
                  hex5 <= C;
                  hex4 <= L;
                  hex3 <= R;
               
               when CPI =>
                  hex5 <= C;
                  hex4 <= P;
                  hex3 <= I;
               
               when CP =>
                  hex5 <= C;
                  hex4 <= P;
                  hex3 <= OFF;
               
               when JMP =>
                  hex5 <= J;
                  hex4 <= M;
                  hex3 <= P;
               
               when BREQ =>
                  hex5 <= B;
                  hex4 <= R;
                  hex3 <= E;
               
               when BRNE =>
                  hex5 <= B;
                  hex4 <= N;
                  hex3 <= E;
               
               when BRLE =>
                  hex5 <= B;
                  hex4 <= L;
                  hex3 <= E;
               
               when BRLT =>
                  hex5 <= B;
                  hex4 <= L;
                  hex3 <= T;
               
               when BRGE =>
                  hex5 <= B;
                  hex4 <= G;
                  hex3 <= E;
               
               when BRGT =>
                  hex5 <= B;
                  hex4 <= G;
                  hex3 <= T;
               
               when CALL =>
                  hex5 <= C;
                  hex4 <= A;
                  hex3 <= L;
               
               when RET =>
                  hex5 <= R;
                  hex4 <= E;
                  hex3 <= T;  
                 
               when PUSH =>
                  hex5 <= P;
                  hex4 <= S;
                  hex3 <= H;
               
               when POP => 
                  hex5 <= P;
                  hex4 <= O;
                  hex3 <= P;  
                 
                when others =>
                  hex5 <= OFF;
                  hex4 <= OFF; 
                  hex3 <= OFF;
            end case;
         else
            hex5 <= OFF;
            hex4 <= OFF;
            hex3 <= OFF;
         end if;
      end if;
   end process;
   
   ------------------------------------------------------------------------------------------------
   -- DISPLAY_R16: Skriver ut innehållet i CPU-register R16 på 7-segmentsdisplayer hex[1:0]. 
   ------------------------------------------------------------------------------------------------
   DISPLAY_R16: process (clock, reset_s2_n)
   begin
      if (reset_s2_n = '0') then
         hex1 <= OFF;
         hex0 <= OFF;
      elsif (rising_edge(clock)) then
         if (enable = '1') then
            hex1 <= get_digit(to_integer(unsigned(r16(7 downto 4))));
            hex0 <= get_digit(to_integer(unsigned(r16(3 downto 0))));
         else
            hex1 <= OFF;
            hex0 <= OFF;
         end if;
      end if;
   end process;

end architecture;