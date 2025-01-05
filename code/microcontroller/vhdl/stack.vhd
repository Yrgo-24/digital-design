---------------------------------------------------------------------------------------------------
-- stack.vhd: Implementering av mikrodatorns stack, som möjliggör temporär lagring av data i
--            enlighet med principen LIFO (Last In First Out). Det element som lades till sist
--            tas också ut först. Stacken används exempelvis för lokala variabler samt för lagring
--            av returadressen vid ett funktionsanrop. Vid återhopp hämtas adressen från stacken
--            och tilldelas till programräknaren, så att programmet fortsätter direkt efter den
--            instruktion där funktionsanropet ägde rum. 
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.def.all;

package stack is

-- Konstanter:
constant SP_MIN  : natural := 0;   -- Lägsta adressen på stacken.
constant SP_MAX  : natural := 31;  -- Högsta adressen på stacken.

---------------------------------------------------------------------------------------------------
-- stack_array_t: Tvådimensionell array för implementering av stackens minnesutrymme, utgörs av 
--             32 adresser med utrymme för åtta bitar per adress.
---------------------------------------------------------------------------------------------------
type stack_array_t is array(SP_MIN to SP_MAX) of std_logic_vector(7 downto 0); 

---------------------------------------------------------------------------------------------------
-- stack_t: Implementering av en 8-bitars stack som rymmer 32 element från SP_MIN till SP_MAX.
--          En stackpekare används för att peka på elementet längst upp på stacken, som också tas
--          ut först vid POP-operationer. Vid PUSH-operationer läggs ett nytt element längst upp
--          på stacken och stackpekaren inkrementeras, förutsatt att stacken inte är full.
---------------------------------------------------------------------------------------------------
type stack_t is record
   data : stack_array_t;                  -- Stackens minnesutrymme, 32 x 8 bitar.
   sp   : natural range SP_MIN to SP_MAX; -- Stackpekare, pekar på elementet längst upp på stacken.
end record;

-- Procedurdeklarationer:
procedure stack_push(signal self: inout stack_t; constant data: in std_logic_vector(7 downto 0));
procedure stack_push(signal self: inout stack_t; constant data: in uint8_t);
procedure stack_pop(signal self: inout stack_t; signal dest: out std_logic_vector(7 downto 0));
procedure stack_pop(signal self: inout stack_t; signal dest: out uint8_t);
procedure stack_clear(signal self: out stack_t);

end package;

package body stack is

---------------------------------------------------------------------------------------------------
-- stack_push: Lägger till ett element längst upp på stacken, förutsatt att denna inte är full.
--             Stackpekaren sätts till att peka på elementet längst upp på stacken, vilket
--             innebär inkrementering av stackpekaren varje gång förutom först när stacken är tom,
--             då stackpekaren då pekar längst ned på stacken, där det första elementet placeras.
---------------------------------------------------------------------------------------------------
procedure stack_push(signal self: inout stack_t; constant data: in std_logic_vector(7 downto 0)) is
begin
   if (self.sp >= SP_MAX) then
      self.sp <= SP_MAX;
   else
      if (self.sp = SP_MIN) then
         self.data(SP_MIN) <= data;
      else
         self.data(self.sp + 1) <= data;
         self.sp <= self.sp + 1;
      end if;
   end if;
   return;
end procedure;

---------------------------------------------------------------------------------------------------
-- stack_push: Överlagrad funktion, som lägger ett 8-bitars osignerat heltal på stacken.
---------------------------------------------------------------------------------------------------
procedure stack_push(signal self: inout stack_t; constant data: in uint8_t) is
begin
   stack_push(self, uint8_vector(data));
   return;
end procedure;

---------------------------------------------------------------------------------------------------
-- stack_pop: Tar bort ett element ur stacken och lagrar på angiven destination. Förutsatt att
--            stacken inte är tom så dekrementeras också stackpekaren.
---------------------------------------------------------------------------------------------------
procedure stack_pop(signal self: inout stack_t; signal dest: out std_logic_vector(7 downto 0)) is
begin
   dest <= self.data(self.sp);
   if (self.sp > SP_MIN) then
      self.sp <= self.sp - 1;
   else
      self.sp <= SP_MIN;
   end if;
   return;
end procedure;

---------------------------------------------------------------------------------------------------
-- stack_pop: Överlagrad funktion, som lagrar data som tas ut stacken på angiven destination,
--            som i detta fall passeras som ett 8-bitars osignerat heltal.
---------------------------------------------------------------------------------------------------
procedure stack_pop(signal self: inout stack_t; signal dest: out uint8_t) is
variable data : std_logic_vector(7 downto 0);
begin
   dest <= uint8(self.data(self.sp));
   if (self.sp > SP_MIN) then
      self.sp <= self.sp - 1;
   else
      self.sp <= SP_MIN;
   end if;
   return;
end procedure;

---------------------------------------------------------------------------------------------------
-- stack_clear: Nollställer stacken och sätter stackpekaren till att peka längst ned på stacken,
--              vilket bör genomföras vid reset.
---------------------------------------------------------------------------------------------------
procedure stack_clear(signal self: out stack_t) is
begin
   self.data <= (others => (others => '0'));
   self.sp <= SP_MIN;
   return;
end procedure;

end package body;