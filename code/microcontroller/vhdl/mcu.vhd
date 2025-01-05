---------------------------------------------------------------------------------------------------
-- mcu.vhd: Innehåller funktionalitet för implementering av en 8-bitars mikrodator med möjlighet
--          att välja mellan att använda en 50 MHz systemklocka eller att generera klockpulser
--          via en tryckknapp. När tryckknappen används som klockkälla visas aktuell OP-kod samt 
--          innehållet i CPU-register R16 på fem 7-segmentsdisplayer.
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.def.all;

---------------------------------------------------------------------------------------------------
-- mcu: Konstruktionens toppmodul. Övriga moduler, exempelvis för styrenheten samt olika minnen, 
--      implementeras via instansiering från denna modul, antingen direkt eller indirekt via en
--      av de instansierade modulerna. Insignal switch avgör vilken klockkälla som används mellan
--      den 50 MHz systemklockan clock samt manuell klockpulsgenerering via nedtryckning av 
--      tryckknapp key_n, där 0 = clock, 1 = key_n.
---------------------------------------------------------------------------------------------------
entity mcu is
   port
   (
      clock     : in std_logic;                       -- 50 MHz systemklocka.
      reset_n   : in std_logic;                       -- Inverterad asynkron reset-signal.
      key_n     : in std_logic;                       -- Tryckknapp för manuell klockpulsgenerering.
      switch    : in std_logic;                       -- Slide-switch för val av klockkälla.
      io_port_b : inout std_logic_vector(7 downto 0); -- 8-bitars I/O-port.
      io_port_c : inout std_logic_vector(7 downto 0); -- 8-bitars I/O-port.
      io_port_d : inout std_logic_vector(7 downto 0); -- 8-bitars I/O-port.
      hex5      : out std_logic_vector(6 downto 0);   -- Display, visar OP-kod.
      hex4      : out std_logic_vector(6 downto 0);   -- Display, visar OP-kod.
      hex3      : out std_logic_vector(6 downto 0);   -- Display, visar OP-kod.
      hex1      : out std_logic_vector(6 downto 0);   -- Display, visar innehållet i CPU-register R16.
      hex0      : out std_logic_vector(6 downto 0);   -- Display, visar innehållet i CPU-register R16.
      leds      : out std_logic_vector(7 downto 0)    -- Visar programräknarens innehåll.
      
   );
end entity;

architecture behaviour of mcu is

-- Signaler:
signal reset_s2_n  : std_logic; -- Synkronierad inverterad reset-signal.
signal key_pressed : std_logic; -- Indikerar nedtryckning av tryckknapp för ny klockpuls.
signal switch_s2   : std_logic; -- Synkroniserad signal från slide-switch för val av klockkälla.

signal op_code     : std_logic_vector(7 downto 0); -- Lagrar aktuell OP-kod.
signal r16         : std_logic_vector(7 downto 0); -- Lagrar innehållet i CPU-register R16.
signal pc          : std_logic_vector(7 downto 0); -- Lagrar adressen programräknaren pekar på.

begin

   ------------------------------------------------------------------------------------------------
   -- meta_prev1: Implementering av synkroniserade insignaler i syfte att förebygga metastabilitet.
   ------------------------------------------------------------------------------------------------
   meta_prev1: metastability_prevention port map
   (
      clock       => clock,
      reset_n     => reset_n,
      key_n       => key_n,
      switch      => switch,
      reset_s2_n  => reset_s2_n,
      switch_s2   => switch_s2,
      key_pressed => key_pressed  
   );
   
   ------------------------------------------------------------------------------------------------
   -- control_unit1: Implementerar CPU:ns styrenhet, där programminnet, RAM-minnet, I/O-minnet,
   --                ALU:n och stacken implementeras internt. Aktuell OP-kod, innehållet i 
   --                CPU-register R16 samt adressen som programräknaren pekar på passeras för
   --                utskrift via 7-segmentsdisplayer samt lysdioder på FPGA-kortet.
   ------------------------------------------------------------------------------------------------
   control_unit1: control_unit port map
   (
      clock                => clock,
      reset_s2_n           => reset_s2_n,
      key_pressed          => key_pressed,
      manual_clock_enabled => switch_s2,
      io_port_b            => io_port_b,
      io_port_c            => io_port_c,
      io_port_d            => io_port_d,
      op_code_out          => op_code,
      pc_out               => pc,
      r16_out              => r16
   );
   
   ------------------------------------------------------------------------------------------------
   -- display1: Skriver ut aktuell OP-kod samt innehållet i CPU-register R16 via fem
   --           7-segmentsdisplayer när manuell klockpulsgenerering används.
   ------------------------------------------------------------------------------------------------
   display1: display port map
   (
      clock      => clock,
      reset_s2_n => reset_s2_n,
      enable     => switch_s2,
      op_code    => op_code,
      r16        => r16,
      hex5       => hex5,
      hex4       => hex4,
      hex3       => hex3,
      hex1       => hex1,
      hex0       => hex0
   );
   
   -- Kontinuerliga tilldelningar:
   leds <= pc when switch_s2 = '1' else (others => '0');

end architecture;