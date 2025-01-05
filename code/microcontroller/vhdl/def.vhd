---------------------------------------------------------------------------------------------------
-- def.vhd: Innehåller ett flertal definitioner i form av konstanter och dylikt via paketet def.
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---------------------------------------------------------------------------------------------------
-- def: Innehållet konstanter för OP-koder, CPU-register, I/O-register med mera. 
---------------------------------------------------------------------------------------------------
package def is

-- Typer:
subtype uint8_t is natural range 0 to 255;                                  -- Osignerat 8-bitars heltal.
type cpu_state_t is (CPU_STATE_FETCH, CPU_STATE_DECODE, CPU_STATE_EXECUTE); -- Tillstånd för CPU:s instruktionscykel.

-- OP-koder: 
constant NOP  : std_logic_vector(7 downto 0) := x"00"; -- Ingen operation. 
constant LDI  : std_logic_vector(7 downto 0) := x"01"; -- Läser innehåll till ett CPU-register. 
constant MOV  : std_logic_vector(7 downto 0) := x"02"; -- Kopierar innehållet från ett CPU-register till ett annat. 
constant OUTD : std_logic_vector(7 downto 0) := x"03"; -- Skriver innehåll från ett CPU-register till ett I/O-register. 
constant IND  : std_logic_vector(7 downto 0) := x"04"; -- Läser innehåll från ett I/O-register till ett CPU-register. 
constant STS  : std_logic_vector(7 downto 0) := x"05"; -- Skriver innehåll från ett CPU-register till RAM-minnet. 
constant LDS  : std_logic_vector(7 downto 0) := x"06"; -- Läser innehåll från RAM-minnet till ett CPU-register. 
constant ORI  : std_logic_vector(7 downto 0) := x"07"; -- Bitvis OR mellan ett CPU-register samt en konstant. 
constant ANDI : std_logic_vector(7 downto 0) := x"08"; -- Bitvis AND mellan ett CPU-register samt en konstant. 
constant XORI : std_logic_vector(7 downto 0) := x"09"; -- Bitvis XOR mellan ett CPU-register samt en konstant. 
constant ORD  : std_logic_vector(7 downto 0) := x"0A"; -- Bitvis OR mellan två CPU-register. 
constant ANDD : std_logic_vector(7 downto 0) := x"0B"; -- Bitvis AND mellan två CPU-register. 
constant XORD : std_logic_vector(7 downto 0) := x"0C"; -- Bitvis XOR med två CPU-register. 
constant CLR  : std_logic_vector(7 downto 0) := x"0D"; -- Nollställer ett CPU-register. 
constant ADDI : std_logic_vector(7 downto 0) := x"0E"; -- Addition mellan ett CPU-register samt en konstant.  
constant SUBI : std_logic_vector(7 downto 0) := x"0F"; -- Subtraktion mellan ett CPU-register samt en konstant. 

constant ADD  : std_logic_vector(7 downto 0) := x"10"; -- Addition mellan två CPU-register. 
constant SUBD : std_logic_vector(7 downto 0) := x"11"; -- Subtraktion mellan två CPU-register. 
constant INC  : std_logic_vector(7 downto 0) := x"12"; -- Inkrementerar innehållet i ett CPU-register. 
constant DEC  : std_logic_vector(7 downto 0) := x"13"; -- Dekrementerar innehållet i ett i ett CPU-register. 
constant CPI  : std_logic_vector(7 downto 0) := x"14"; -- Jämför innehållet i ett CPU-register med en konstant. 
constant CP   : std_logic_vector(7 downto 0) := x"15"; -- Jämför innehållet mellan två CPU-register. 
constant JMP  : std_logic_vector(7 downto 0) := x"16"; -- Ovillkorligt programhopp till angiven adress. 
constant BREQ : std_logic_vector(7 downto 0) := x"17"; -- Programhopp om operand 1 är lika med operand 2. 
constant BRNE : std_logic_vector(7 downto 0) := x"18"; -- Programhopp om operand 1 ej är lika med operand 2. 
constant BRGE : std_logic_vector(7 downto 0) := x"19"; -- Programhopp om operand 1 är större eller lika med operand 2. 
constant BRGT : std_logic_vector(7 downto 0) := x"1A"; -- Programhopp om operand 1 är större än operand 2. 
constant BRLE : std_logic_vector(7 downto 0) := x"1B"; -- Programhopp om operand 1 är mindre eller lika med operand 2. 
constant BRLT : std_logic_vector(7 downto 0) := x"1C"; -- Programhopp om operand 1 är mindre än operand 2. 
constant CALL : std_logic_vector(7 downto 0) := x"1D"; -- Programhopp till subrutin och sparar returadressen på stacken. 
constant RET  : std_logic_vector(7 downto 0) := x"1E"; -- Återhopp från subrutin via sparad returadress på stacken. 
constant PUSH : std_logic_vector(7 downto 0) := x"1F"; -- Lägger till data från ett CPU-register till stacken.
constant POP  : std_logic_vector(7 downto 0) := x"20"; -- Tar bort data från stacken och lägger i ett CPU-register.

-- CPU-register (index till array implementerad i styrenheten): 
constant R0 : uint8_t := 0;  -- CPU-register R0.
constant R1 : uint8_t := 1;  -- CPU-register R1. 
constant R2 : uint8_t := 2;  -- CPU-register R2. 
constant R3 : uint8_t := 3;  -- CPU-register R3. 
constant R4 : uint8_t := 4;  -- CPU-register R4. 
constant R5 : uint8_t := 5;  -- CPU-register R5. 
constant R6 : uint8_t := 6;  -- CPU-register R6. 
constant R7 : uint8_t := 7;  -- CPU-register R7. 
constant R8 : uint8_t := 8;  -- CPU-register R8. 
constant R9 : uint8_t := 9;  -- CPU-register R9. 
constant R10: uint8_t := 10; -- CPU-register R10. 
constant R11: uint8_t := 11; -- CPU-register R11. 
constant R12: uint8_t := 12; -- CPU-register R12. 
constant R13: uint8_t := 13; -- CPU-register R13. 
constant R14: uint8_t := 14; -- CPU-register R14. 
constant R15: uint8_t := 15; -- CPU-register R15.

constant R16: uint8_t := 16; -- CPU-register R16. 
constant R17: uint8_t := 17; -- CPU-register R17. 
constant R18: uint8_t := 18; -- CPU-register R18. 
constant R19: uint8_t := 19; -- CPU-register R19. 
constant R20: uint8_t := 20; -- CPU-register R20. 
constant R21: uint8_t := 21; -- CPU-register R21. 
constant R22: uint8_t := 22; -- CPU-register R22. 
constant R23: uint8_t := 23; -- CPU-register R23. 
constant R24: uint8_t := 24; -- CPU-register R24. 
constant R25: uint8_t := 25; -- CPU-register R25. 
constant R26: uint8_t := 26; -- CPU-register R26. 
constant R27: uint8_t := 27; -- CPU-register R27. 
constant R28: uint8_t := 28; -- CPU-register R28. 
constant R29: uint8_t := 29; -- CPU-register R29. 
constant R30: uint8_t := 30; -- CPU-register R30. 
constant R31: uint8_t := 31; -- CPU-register R31. 

-- I/O-register (adresser i I/O-minnet): 
constant PINB : uint8_t := 0; -- Register för läsning av insignaler på I/O-port B. 
constant PORTB: uint8_t := 1; -- Register för skrivning av utsignaler på I/O-port B. 
constant DDRB : uint8_t := 2; -- Datariktningsregister för I/O-port B). 
constant PINC : uint8_t := 3; -- Register för läsning av insignaler på I/O-port C. 
constant PORTC: uint8_t := 4; -- Register för skrivning av utsignaler på I/O-port C. 
constant DDRC : uint8_t := 5; -- Datariktningsregister för I/O-port C). 
constant PIND : uint8_t := 6; -- Register för läsning av insignaler på I/O-port D. 
constant PORTD: uint8_t := 7; -- Register för skrivning av utsignaler på I/O-port C. 
constant DDRD : uint8_t := 8; -- Datariktningsregister för I/O-port D). 

---------------------------------------------------------------------------------------------------
-- metastability_prevention: Innehåller funktionalitet för att implemenetera synkroniserade
--                           insignaler som fördröjs två klockpulser i syfte att förebygga
--                           metastabilitet. Reset sker dock asynkront och då fördröjs inte
--                           de synkroniserade signalerna.
---------------------------------------------------------------------------------------------------
component metastability_prevention is 
   port
   (
      clock       : in std_logic;  -- 50 MHz systemklocka.
      reset_n     : in std_logic;  -- Inverterad asynkron reset-signal.
      key_n       : in std_logic;  -- Insignal från inverterad tryckknapp.
      switch      : in std_logic;  -- Insignal från slide-switch. 
      reset_s2_n  : out std_logic; -- Synkroniserad inverterad reset-signal.
      key_pressed : out std_logic; -- Indikerar nedtryckning av tryckknappen (fallande flank).
      switch_s2   : out std_logic  -- Synkroniserad signal från slide-switch
   );
end component;

---------------------------------------------------------------------------------------------------
-- display: Innehåller funktionalitet för att skriva ut aktuell OP-kod samt innehållet i
--          CPU-register R16 via fem 7-segmentsdisplayer. hex[5:3] visar aktuell OP-kod medan 
--          hex[1:0] visar innehållet i R16 på hexadecimal form. hex2 används som mellanrum 
--          mellan OP-koden samt innehållet i R16 och har därmed inte definierats.
---------------------------------------------------------------------------------------------------
component display is
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
end component;

---------------------------------------------------------------------------------------------------
-- ram: Innehåller funktionalitet för implementering av ett 8-bitars RAM-minne med utrymme för
--      128 element från adress RAM_MIN - RAM_MAX (8'h00 - 8'h79).
---------------------------------------------------------------------------------------------------
component ram is
   port
   (
      clock        : in std_logic;                    -- 50 MHz systemklocka.
      reset_s2_n   : in std_logic;                    -- Synkroniserad inverterad reset-signal.
      address      : in std_logic_vector(7 downto 0); -- Adress för läsning/skrivning.
      data_in      : in std_logic_vector(7 downto 0); -- Indata för skrivning till RAM-minnet.
      write_enable : in std_logic;                    -- Indikerar ifall skrivning skall genomföras.
      data_out     : out std_logic_vector(7 downto 0) -- Utdata för läsning från RAM-minnet.
   );
end component;


---------------------------------------------------------------------------------------------------
-- io: Innehåller funktionalitet för läsning samt skrivning till mikrodatorns IO-portar, vilket
--     implementeras via ett 8-bitars I/O-minne med utrymme för nio element, vilket utgörs
--     av I/O-register för de tre I/O-portarna, som innehar var sitt datariktningsregister,
--     portregister (för skrivning) samt pinregister (för läsning). 
---------------------------------------------------------------------------------------------------
component io is
   port
   (
      clock        : in std_logic;                       -- 50 MHz systemklocka.
      reset_s2_n   : in std_logic;                       -- Synkroniserad inverterad reset-signal.
      address      : in std_logic_vector(7 downto 0);    -- Adress för läsning/skrivning.
      data_in      : in std_logic_vector(7 downto 0);    -- Indata för skrivning till I/O-minnet.
      write_enable : in std_logic;                       -- Indikerar ifall skrivning skall genomföras.
      io_port_b    : inout std_logic_vector(7 downto 0); -- 8-bitars I/O-port.
      io_port_c    : inout std_logic_vector(7 downto 0); -- 8-bitars I/O-port.
      io_port_d    : inout std_logic_vector(7 downto 0); -- 8-bitars I/O-port.
      data_out     : out std_logic_vector(7 downto 0)    -- Utdata för läsning från I/O-minnet.
   );
end component;

---------------------------------------------------------------------------------------------------
-- rom: Innehåller funktionalitet för implementering av mikrodatorns programminne, som realiseras
--      i form av en tvådimensionell konstant array. Avläsning sker kontinuerligt från 
--      programminnet förutsatt att angiven adress är giltig, annars sätts utsignalen till noll.
---------------------------------------------------------------------------------------------------
component rom is
   port
   (
      clock        : in std_logic;                     -- 50 MHz systemklocka.
      reset_s2_n   : in std_logic;                     -- Synkroniserad inverterad reset-signal.
      address      : in std_logic_vector(7 downto 0);  -- Adress för läsning/skrivning.
      data_out     : out std_logic_vector(23 downto 0) -- Utdata för läsning från RAM-minnet.
   );
end component;

---------------------------------------------------------------------------------------------------
-- control_unit: Innehåller funktionalitet för implementering av mikrodatorns styrenhet, där
--               klockkällan kan väljas mellan en 50 MHz systemklocka eller via manuell
--               klockpulsgenerering via en tryckknapp. Programminnet (ROM-minnet), RAM-minnet 
--               samt I/O-minnet bäddas in i styrenheten genom att instansieras i denna modul.
---------------------------------------------------------------------------------------------------
component control_unit is
   port
   (
      clock                : in std_logic;                       -- 50 MHz systemklocka.
      reset_s2_n           : in std_logic;                       -- Synkroniserad inverterad reset-signal.
      key_pressed          : in std_logic;                       -- Tryckknapp för manuell klockpulsgenerering.
      manual_clock_enabled : in std_logic;                       -- Slide-switch för val av klockkälla.
      io_port_b            : inout std_logic_vector(7 downto 0); -- 8-bitars I/O-port.
      io_port_c            : inout std_logic_vector(7 downto 0); -- 8-bitars I/O-port.
      io_port_d            : inout std_logic_vector(7 downto 0); -- 8-bitars I/O-port.
      op_code_out          : out std_logic_vector(7 downto 0);   -- Aktuell OP-kod.
      pc_out               : out std_logic_vector(7 downto 0);   -- Adress som programräknaren pekar på.
      r16_out              : out std_logic_vector(7 downto 0)    -- Innehållet i CPU-register R16.
   );
end component;

-- Funktioner:
function uint8(vector: std_logic_vector(7 downto 0)) return uint8_t;
function uint8_vector(num: uint8_t) return std_logic_vector;
function uint8_shift_left(self: uint8_t; count: natural range 0 to 7) return uint8_t;
function uint8_invert(self: uint8_t) return uint8_t;

-- Procedurer:
procedure alu(constant op_code, a, b : in std_logic_vector(7 downto 0);
              signal result          : out std_logic_vector(7 downto 0);
              signal nzvc            : out std_logic_vector(3 downto 0));
end package;

package body def is

---------------------------------------------------------------------------------------------------
-- uint8: Typomvandlar 8-bitars vektor till motsvarande osignerade heltal.
---------------------------------------------------------------------------------------------------
function uint8(vector: std_logic_vector(7 downto 0)) return uint8_t is
begin
   return to_integer(unsigned(vector));
end function;

---------------------------------------------------------------------------------------------------
-- uint8_vector: Typomvandlar osignerat tal till motsvarande 8-bitars vektor.
---------------------------------------------------------------------------------------------------
function uint8_vector(num: uint8_t) return std_logic_vector is
begin
   return std_logic_vector(to_unsigned(num, 8));
end function;

---------------------------------------------------------------------------------------------------
-- uint8_shift_left: Vänsterskiftar osignerat 8-bitars tal angivet antal gånger.
---------------------------------------------------------------------------------------------------
function uint8_shift_left(self: uint8_t; count: natural range 0 to 7) return uint8_t is
variable num: std_logic_vector(7 downto 0);
begin
   if (count = 0) then
      return self;
   else
      num := std_logic_vector(to_unsigned(self, 8));
      for i in 1 to count loop
         num(7 downto 1) := num(6 downto 0);
         num(0) := '0';
      end loop;
      return to_integer(unsigned(num));
   end if;
end function;

---------------------------------------------------------------------------------------------------
-- uint8_invert: Inverterar osignerat 8-bitars tal bitvis.
---------------------------------------------------------------------------------------------------
function uint8_invert(self: uint8_t) return uint8_t is
variable bits: std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(self, 8));
begin
   bits := not bits;
   return to_integer(unsigned(bits));
end function;

---------------------------------------------------------------------------------------------------
-- alu: Implementering av en ALU, där ingående argument a och b utgör operander och resultatet
--      från aktuell aritmetisk eller logisk operation returneras. Statusbitar NZVC i uppdateras 
--      utefter resultatet innan återhoppet. C-flaggan tilldelas carry-biten genom att tilldela 
--      den extra minnessiffra som resulterar från operationen. N-flaggan tilldelas teckenbiten
--      (den mest signifikanta biten MSB från resultatet). Z-flaggan ettställs ifall resultatet 
--      blev noll, annars nollställs denna. V-flaggan ettställs då teckenbiten för båda operander 
--      är samma och resultatets teckenbit är inversen av detta. Exempelvis kan detta ske ifall 
--      addition av två positiva tal (MSB = 0) medför en negativ summa (MSB = 1). V-flaggan 
--      indikerar då att overflow har ägt rum, vilket beror på att fler bitar krävs för att 
--      summan skall bli korrekt.
---------------------------------------------------------------------------------------------------
procedure alu(constant op_code, a, b : in std_logic_vector(7 downto 0);
              signal result          : out std_logic_vector(7 downto 0);
              signal nzvc            : out std_logic_vector(3 downto 0)) is
              
variable a_uint : unsigned(8 downto 0) := (others => '0'); -- Operand a med minnesbit.
variable b_uint : unsigned(8 downto 0) := (others => '0'); -- Operand b med minnesbit.
variable num    : unsigned(8 downto 0) := (others => '0'); -- Resultat med minnesbit.
begin

   a_uint(7 downto 0) := unsigned(a);
   b_uint(7 downto 0) := unsigned(b);
   
   case (op_code) is
      when ORI    => num := a_uint or b_uint;
      when ANDI   => num := a_uint and b_uint;
      when XORI   => num := a_uint xor b_uint;
      when ORD    => num := a_uint or b_uint;
      when ANDD   => num := a_uint and b_uint;
      when XORD   => num := a_uint xor b_uint;
      when ADDI   => num := a_uint + b_uint;
      when SUBI   => num := a_uint - b_uint;
      when ADD    => num := a_uint + b_uint;
      when SUBD   => num := a_uint - b_uint;
      when INC    => num := a_uint + 1;
      when DEC    => num := a_uint - 1;
      when CPI    => num := a_uint - b_uint;
      when CP     => num := a_uint - b_uint;
      when others => null;
   end case;
   
   nzvc(3) <= num(7);
   
   if (num(7 downto 0) = x"00") then
      nzvc(2) <= '1';
   else
      nzvc(2) <= '0';
   end if;
   
   if ((a(7) = '1' and b(7) = '1' and num(7) = '0') or (a(7) = '0' and b(7) = '0' and num(7) = '1')) then
      nzvc(1) <= '1';
   else
      nzvc(1) <= '0';
   end if;
   
   nzvc(0) <= num(8);
   result <= std_logic_vector(num(7 downto 0));
   return;
end procedure;

end package body;