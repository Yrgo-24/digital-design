---------------------------------------------------------------------------------------------------
-- ram.vhd: Möjliggör implementering av mikrodatorns RAM-minne, som kan användas för lagring
--          av data vars minne skall kvarstå ett helt program, exempelvis statiska variabler.
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.def.all;

---------------------------------------------------------------------------------------------------
-- ram: Innehåller funktionalitet för implementering av ett 8-bitars RAM-minne med utrymme för
--      128 element från adress RAM_MIN - RAM_MAX (8'h00 - 8'h79).
---------------------------------------------------------------------------------------------------
entity ram is
   port
   (
      clock        : in std_logic;                    -- 50 MHz systemklocka.
      reset_s2_n   : in std_logic;                    -- Synkroniserad inverterad reset-signal.
      address      : in std_logic_vector(7 downto 0); -- Adress för läsning/skrivning.
      data_in      : in std_logic_vector(7 downto 0); -- Indata för skrivning till RAM-minnet.
      write_enable : in std_logic;                    -- Indikerar ifall skrivning skall genomföras.
      data_out     : out std_logic_vector(7 downto 0) -- Utdata för läsning från RAM-minnet.
   );
end entity;

architecture behaviour of ram is

-- Konstanter: 
constant RAM_MIN : natural := 0;   -- Lägsta adress i RAM-minnet.
constant RAM_MAX : natural := 127; -- Högsta adress i RAM-minnet.

---------------------------------------------------------------------------------------------------
-- ram_array_t: Tvådimensionell array för implementering av RAM-minnet, utgörs av 128 adresser
--              med utrymme för åtta bitar per adress.
---------------------------------------------------------------------------------------------------
type ram_array_t is array(RAM_MIN to RAM_MAX) of std_logic_vector(7 downto 0); 

-- Signaler:
signal data             : ram_array_t; -- 8-bitars RAM-minne med utrymme för 128 element.
signal address_in_range : std_logic;   -- Indikerar ifall angiven adress är korrekt.

begin
   
   ------------------------------------------------------------------------------------------------
   -- RAM_WRITE_PROCESS: Skriver angiven indata till RAM-minnet ifall write-signalen är ettställd
   --                    och angiven adress ligger inom intervallet RAM_MIN - RAM_MAX. Däremot
   --                    vid reset så nollställs hela RAM-minnet.
   ------------------------------------------------------------------------------------------------
   RAM_WRITE_PROCESS: process(clock, reset_s2_n) is
   begin
      if (reset_s2_n = '0') then
         data <= (others => (others => '0'));
      elsif (rising_edge(clock)) then
         if (address_in_range = '1' and write_enable = '1') then
            data(uint8(address)) <= data_in;
         end if;
      end if;
   end process;
  
   -- Kontinuerliga tilldelningar:
   address_in_range <= '1' when (uint8(address) >= RAM_MIN and uint8(address) <= RAM_MIN) else '0';
   data_out <= data(uint8(address)) when address_in_range = '1' else (others => '0');
   
end architecture;