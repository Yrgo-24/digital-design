---------------------------------------------------------------------------------------------------
-- io.vhd: Möjliggör implementering av mikrodatorns I/O-minne, som används för läsning och
--         skrivning till mikrodatorns I/O-register, såsom datariktningsregister för val av
--         datariktning eller portregister för att sätta utsignaler.
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.def.all;

---------------------------------------------------------------------------------------------------
-- io: Innehåller funktionalitet för läsning samt skrivning till mikrodatorns IO-portar, vilket
--     implementeras via ett 8-bitars I/O-minne med utrymme för nio element, vilket utgörs
--     av I/O-register för de tre I/O-portarna, som innehar var sitt datariktningsregister,
--     portregister (för skrivning) samt pinregister (för läsning). 
---------------------------------------------------------------------------------------------------
entity io is
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
end entity;

architecture behaviour of io is

-- Konstanter:
constant IO_MIN : natural := 0; -- Lägsta adress i I/O-minnet.
constant IO_MAX : natural := 8; -- Högsta adress i I/O-minnet.

---------------------------------------------------------------------------------------------------
-- io_array_t: Tvådimensionell array för implementering av I/O-minnet, utgörs av nio I/O-adresser
--             med utrymme för åtta bitar per adress.
---------------------------------------------------------------------------------------------------
type io_array_t is array(IO_MIN to IO_MAX) of std_logic_vector(7 downto 0); 

-- Signaler:
signal data             : io_array_t;             -- 8-bitars I/O-minne med utrymme för nio element.
signal address_in_range : std_logic;              -- Indikerar ifall angiven adress är korrekt.

---------------------------------------------------------------------------------------------------
-- port_write: Uppdaterar utsignalen för samtliga utportar genom att dessa tilldelas från angivet
--             portregister. För att kontrollera vilka bitar som tillhör en utport så kontrolleras
--             ifall motsvarande bit i angivet datariktningsregister är  ettställd. Ifall denna
--             bit är nollställd, så tilldelas en högohmig utsignal, vilket medför att motsvarande
--             port utgör en inport (som dock måste aktiveras för användning). Returnerad data 
--             skall skrivas till motsvarande I/O-port.
---------------------------------------------------------------------------------------------------
function port_write(ddr, port_reg: std_logic_vector(7 downto 0)) return std_logic_vector is
variable data_out : std_logic_vector(7 downto 0);
begin
   for i in 0 to 7 loop
      if (ddr(i) = '1') then
         data_out(i) := port_reg(i);
      else
         data_out(i) := 'Z';
      end if;
   end loop;
   return data_out;
end function;

begin
   
   ------------------------------------------------------------------------------------------------
   -- IO_UPDATE_PROCESS: Genomför avläsning av indata till I/O-minnets pinregister. Skriver också
   --                    angiven indata till I/O-minnet ifall write-signalen är ettställd samt 
   --                    angiven adress ligger inom intervallet IO_MIN - IO_MAX. Däremot vid
   --                    reset så nollställs hela I/O-minnet.
   ------------------------------------------------------------------------------------------------
   IO_UPDATE_PROCESS: process(clock, reset_s2_n)
   begin
      if (reset_s2_n = '0') then
         data <= (others => (others => '0'));
      elsif (rising_edge(clock)) then
         data(PINB) <= io_port_b;
         data(PINC) <= io_port_c;
         data(PIND) <= io_port_d;
         if (write_enable = '1' and address_in_range = '1') then
            data(uint8(address)) <= data_in;
         end if;
      end if;
   end process;
   
   -- Kontinuerliga tilldelningar:
   address_in_range <= '1' when (uint8(address) >= IO_MIN and uint8(address) <= IO_MAX) else '0';
   data_out <= data(uint8(address)) when address_in_range = '1' else (others => '0');
   io_port_b <= port_write(data(DDRB), data(PORTB));
   io_port_c <= port_write(data(DDRC), data(PORTC));
   io_port_d <= port_write(data(DDRD), data(PORTD));   
   
end architecture;
   