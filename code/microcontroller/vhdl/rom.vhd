---------------------------------------------------------------------------------------------------
-- rom.vhd: Implementering av mikrodatorns programminne, realiserat via ett 24-bitars ROM-minne
--          som rymmer 27 instruktioner. Programkoden sätts samman via konstanter till 24-bitars 
--          instruktioner och lagras på var sin adress i programminnet.
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.def.all;

---------------------------------------------------------------------------------------------------
-- rom: Innehåller funktionalitet för implementering av mikrodatorns programminne, som realiseras
--      i form av en tvådimensionell konstant array. Avläsning sker kontinuerligt från 
--      programminnet förutsatt att angiven adress är giltig, annars sätts utsignalen till noll.
---------------------------------------------------------------------------------------------------
entity rom is
   port
   (
      clock      : in std_logic;                     -- 50 MHz systemklocka.
      reset_s2_n : in std_logic;                     -- Synkroniserad inverterad reset-signal.
      address    : in std_logic_vector(7 downto 0);  -- Adress för läsning/skrivning.
      data_out   : out std_logic_vector(23 downto 0) -- Utdata för läsning från RAM-minnet.
   );
end entity;

architecture behaviour of rom is

---------------------------------------------------------------------------------------------------
-- join: Sätter samman OP-kod samt operander till en 24-bitars instruktion.
---------------------------------------------------------------------------------------------------
function join(op_code: std_logic_vector(7 downto 0); op1, op2: uint8_t) return std_logic_vector is
variable instruction: std_logic_vector(23 downto 0);
begin
   instruction(23 downto 16) := op_code;
   instruction(15 downto 8)  := uint8_vector(op1);
   instruction(7 downto 0)   := uint8_vector(op2);
   return instruction;
end function;

-- Konstanter: 
constant ROM_MIN   : natural := 0;   -- Lägsta adress i programminnet.
constant ROM_MAX   : natural := 127; -- Högsta adress i programminnet.
constant LED       : natural := 1;   -- PIN-nummer för lysdiod ansluten till PORTB1.
constant BUTTON    : natural := 5;   -- PIN-nummer för tryckknapp ansluten till PORTB5.

-- Adresser i programminnet:
constant main           : natural := 0;                  -- Programmets startpunkt.
constant main_loop      : natural := main + 1;           -- Kontinuerlig loop.
constant led_on         : natural := main + 5;           -- Tänder lysdioden.
constant led_off        : natural := led_on + 4;         -- Släcker lysdioden.
constant init_ports     : natural := led_off + 4;        -- Initierar portar som skall användas.
constant button_pressed : natural := init_ports + 5;     -- Indikerar ifall tryckknappen är nedtryckt.
constant return_true    : natural := button_pressed + 5; -- Returnerar 1 via CPU-register R24.
constant return_false   : natural := return_true + 2;    -- Returnerar 0 via CPU-register R24.

---------------------------------------------------------------------------------------------------
-- rom_array_t: Tvådimensionell array för implementering av programminnet, utgörs av 128 adresser
--              med utrymme för 24 bitar per adress. Därmed finns utrymme för 128 instruktioner.
---------------------------------------------------------------------------------------------------
type rom_array_t is array(ROM_MIN to ROM_MAX) of std_logic_vector(23 downto 0);

---------------------------------------------------------------------------------------------------
-- data: Programminne implementerad som en tvådimensionell konstant.
---------------------------------------------------------------------------------------------------
constant data: rom_array_t :=
   (
      ---------------------------------------------------------------------------------------------
      -- main: Initierar I/O-portar. Tänder sedan lysdioden ansluten till PORTB1 vid nedtryckning
      --       av tryckknappen ansluten till PORTB5. Programmet exekverar kontinuerligt så 
      --       länge matningsspänning tillförs.
      ---------------------------------------------------------------------------------------------
      0      => join(CALL, init_ports, 0),                               -- CALL init_ports 
      -- main_loop:
      1      => join(CALL, button_pressed, 0),                           -- CALL button_pressed
      2      => join(CPI, R24, 1),                                       -- CPI R24, 1
      3      => join(BREQ, led_on, 0),                                   -- BREQ led_on 
      4      => join(JMP, led_off, 0),                                   -- JMP led_off
      
      ---------------------------------------------------------------------------------------------
      -- led_on: Tänder lysdioden ansluten till PORTB1.
      ---------------------------------------------------------------------------------------------
      5      => join(IND, R16, PORTB),                                   -- IN R16, PORTB 
      6      => join(ORI, R16, uint8_shift_left(1, LED)),                -- ORI R16, (1 << LED) 
      7      => join(OUTD, PORTB, R16),                                  -- OUT PORTB, R16 
      8      => join(JMP, main_loop, 0),                                 -- JMP main_loop 
      
      ---------------------------------------------------------------------------------------------
      -- led_off: Släcker lysdioden ansluten till PORTB1.
      ---------------------------------------------------------------------------------------------
      9      => join(IND, R16, PORTB),                                   -- IN R16, PORTB 
      10     => join(ANDI, R16, uint8_invert(uint8_shift_left(1, LED))), -- ANDI R16, ~(1 << LED) 
      11     => join(OUTD, PORTB, R16),                                  -- OUT PORTB, R16 
      12     => join(JMP, main_loop, 0),                                 -- JMP main_loop 
      
      ---------------------------------------------------------------------------------------------
      -- init_ports: Konfigurerar lysdiodens PIN till utport samt tryckknappens PIN till inport.
      ---------------------------------------------------------------------------------------------
      13     => join(LDI, R16, uint8_shift_left(1, LED)),                -- LDI R16, (1 << LED) 
      14     => join(OUTD, DDRB, R16),                                   -- OUT DDRB, R16 
      15     => join(LDI, R16, uint8_shift_left(1, BUTTON)),             -- LDI R16, (1 << BUTTON) 
      16     => join(OUTD, PORTB, R16),                                  -- OUT PORTB, R16 
      17     => join(RET, 0, 0),                                         -- RET 
      
      ---------------------------------------------------------------------------------------------
      -- button_pressed: Indikerar ifall tryckknappen ansluten till PORTB5 är nedtryckt.
      ---------------------------------------------------------------------------------------------
      18     => join(IND, R16, PINB),                                    -- IN R16, PINB 
      19     => join(ANDI, R16, uint8_shift_left(1, BUTTON)),            -- ANDI R16, (1 << BUTTON) 
      20     => join(CPI, R16, 0),                                       -- CPI R16, 1 
      21     => join(BREQ, return_true, 0),                              -- BREQ return_true 
      22     => join(JMP, return_false, 0),                              -- JMP return_false 
      
      ---------------------------------------------------------------------------------------------
      -- return_true: Returnerar heltalet 1 för att indikera att tryckknappen är nedtryckt.
      ---------------------------------------------------------------------------------------------
      23     => join(LDI, R24, 1),                                       -- LDI R24, 1 
      24     => join(RET, 0, 0),                                         -- RET 
      
      ---------------------------------------------------------------------------------------------
      -- return_false: Returnerar heltalet 0 för att indikera att tryckknappen inte är nedtryckt.
      ---------------------------------------------------------------------------------------------
      25     => join(LDI, R24, 0),                                       -- LDI R24, 0 
      26     => join(RET, 0, 0),                                         -- RET    
      others => (others => '0')
   );

-- Signaler:
signal address_in_range : std_logic; -- Indikerar ifall angiven adress är korrekt.

begin

   ------------------------------------------------------------------------------------------------
   -- ROM_OUTPUT_PROCESS: Läser en instruktion från ROM-minnet ifall angiven adress är korrekt.
   ------------------------------------------------------------------------------------------------
   ROM_OUTPUT_PROCESS: process(clock, reset_s2_n) is
   begin
      if (reset_s2_n = '0') then
         data_out <= (others => '0');
      elsif (rising_edge(clock)) then
         if (address_in_range = '1') then
            data_out <= data(uint8(address));
         end if;
      end if;
   end process;
   
   -- Kontinuerliga tilldelningar:
   address_in_range <= '1' when (uint8(address) >= ROM_MIN and uint8(address) <= ROM_MAX) else '0';
   
end architecture;