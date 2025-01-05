---------------------------------------------------------------------------------------------------
-- rw_memory_vhd: Innehåller funktionalitet för att lagra adress samt data för skrivning till ett
--                läs- och skrivbart minne, även kallat RW-minne (Read/Write), implementerat via
--                strukten rw_memory samt tillhörande tasks. 
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

---------------------------------------------------------------------------------------------------
-- rw_memory: Innehåller typen rw_memory samt tillhörande funktioner för enkel skrivning till
--            och från olika RW-minnen, såsom RAM-minnet samt I/O-minnet.
---------------------------------------------------------------------------------------------------
package rw_memory is

---------------------------------------------------------------------------------------------------
-- rw_memory_t: Adress- och dataregister för lagring av adress samt data vid skrivning/läsning.
--              En enable-signal används för kontrollera när skrivning skall ske. 
---------------------------------------------------------------------------------------------------
type rw_memory_t is record
 address      : std_logic_vector(7 downto 0); -- Lagrar adress för läsning/skrivning.
 data_in      : std_logic_vector(7 downto 0); -- Lagrar data vid skrivning till RW-minnet.
 data_out     : std_logic_vector(7 downto 0); -- Lagrar data vid läsning från RW-minnet.
 write_enable : std_logic;                    -- Indikerar ifall skrivning skall ske.
end record;

-- Procedurer:
procedure rw_memory_write(signal self      : inout rw_memory_t; 
                          constant address : in std_logic_vector(7 downto 0);
                          constant data_in : in std_logic_vector(7 downto 0));       
procedure rw_memory_read(signal self        : inout rw_memory_t;
                         signal destination : out std_logic_vector(7 downto 0);
                         constant address   : in std_logic_vector(7 downto 0));
                         
end package;

package body rw_memory is

---------------------------------------------------------------------------------------------------
-- rw_memory_write: Genomför skrivning från ett CPU-register till angivet RW-minne.
---------------------------------------------------------------------------------------------------
procedure rw_memory_write(signal self      : inout rw_memory_t; 
                          constant address : in std_logic_vector(7 downto 0);
                          constant data_in : in std_logic_vector(7 downto 0)) is
begin
   self.address <= address;
   self.data_in <= data_in;
   self.write_enable <= '1';
   return;
end procedure; 
                     
---------------------------------------------------------------------------------------------------
-- rw_memory_read: Genomför läsning från angivet RW-minnet till ett CPU-register och skriver
--                 till destinationsadressen.
---------------------------------------------------------------------------------------------------    
procedure rw_memory_read(signal self        : inout rw_memory_t;
                         signal destination : out std_logic_vector(7 downto 0);
                         constant address   : in std_logic_vector(7 downto 0)) is
begin
   self.address <= address;
   self.write_enable <= '0';
   destination <= self.data_out;
   return;
end procedure; 

end package body;