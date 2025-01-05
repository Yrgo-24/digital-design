---------------------------------------------------------------------------------------------------
-- metastability_prevention.vhd: Synkroniserar mikrokontrollerns insignaler två klockpulser
--                               för att förebygga metastabilitet.
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

---------------------------------------------------------------------------------------------------
-- metastability_prevention: Innehåller funktionalitet för att implemenetera synkroniserade
--                           insignaler som fördröjs två klockpulser i syfte att förebygga
--                           metastabilitet. Reset sker dock asynkront och då fördröjs inte
--                           de synkroniserade signalerna.
---------------------------------------------------------------------------------------------------
entity metastability_prevention is
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
end entity;

architecture behaviour of metastability_prevention is

-- Synkroniserade signaler:
signal reset_s1_n_s, reset_s2_n_s         : std_logic;
signal key_s1_n_s, key_s2_n_s, key_s3_n_s : std_logic;
signal switch_s1_s, switch_s2_s           : std_logic;

begin

   ------------------------------------------------------------------------------------------------
   -- RESET_PROCESS: Synkroniserar reset-signalerna, där reset_s2_n_s i normalfallet tilldelas 
   --                värdet av insignal reset_n två klockcykler tidigare. Däremot vid reset
   --                nollställs samtliga reset-signaler direkt.
   ------------------------------------------------------------------------------------------------
   RESET_PROCESS: process(clock, reset_n) is
   begin
      if (reset_n = '0') then
         reset_s1_n_s <= '0';
         reset_s2_n_s <= '0';
         reset_s2_n_s <= '0';
      elsif (rising_edge(clock)) then
         reset_s1_n_s <= reset_n;
         reset_s2_n_s <= reset_s1_n_s;
      end if;
   end process;
   
   ------------------------------------------------------------------------------------------------
   -- KEY_PROCESS: Synkroniserar key-signalerna, där key_s3_n_s i normalfallet tilldelas värdet
   --              av insignal key_n tre klockcykler tidigare. Att tre signaler används i detta
   --              fall beror på att flankdetektering skall genomföras på tryckknappen som key_n
   --              är ansluten till, vilket genomförs via synkroniserade signaler key_s2_n_s samt
   --              key_s3_n_s. Däremot vid reset ettställs samtliga signaler direkt.
   ------------------------------------------------------------------------------------------------
   KEY_PROCESS: process (clock, reset_s2_n_s) is
   begin
      if (reset_s2_n_s = '0') then
         key_s1_n_s <= '1';
         key_s2_n_s <= '1';
         key_s3_n_s <= '1';
      elsif (rising_edge(clock)) then
         key_s1_n_s <= key_n;
         key_s2_n_s <= key_s1_n_s;
         key_s3_n_s <= key_s2_n_s;
      end if;
   end process;
   
   ------------------------------------------------------------------------------------------------
   -- SWITCH_PROCESS: Synkroniserar switch-signalerna, där switch_s2_s i normalfallet tilldelas 
   --                 det värde som insignal switch hade två klockcykler tidigare. Däremot vid 
   --                 reset så nollställs samtliga signaler direkt.
   ------------------------------------------------------------------------------------------------
   SWITCH_PROCESS: process(clock, reset_s2_n_s) is
   begin
      if (reset_s2_n_s = '0') then
         switch_s1_s <= '0';
         switch_s2_s <= '0';
      elsif (rising_edge(clock)) then
         switch_s1_s <= switch;
         switch_s2_s <= switch_s1_s;
      end if;
   end process;
   
   ------------------------------------------------------------------------------------------------
   -- KEY_EVENT_PROCESS: Indikerar event på fallande flank gällande tryckknappen key_n, vilket 
   --                    sker när tryckknappen övergår från icke nedtryckt till nedtryckt. För
   --                    att detektera eventet så jämförs två synkroniserade signaler key_s2_n_s
   --                    samt key_s3_n_s, där key_s3_n_s är en klockpuls äldre än key_s2_n_s.
   --                    Ifall key_s3_n_s är hög och key_s2_n_s är låg, så var tryckknappen inte
   --                    nedtryckt tre klockcykler sedan, men blev sedan nedtryckt två klockcykler.
   --                    sedan. Då har fallande flank på tryckknappens insignal ägt rum, vilket
   --                    indikeras via ettställning av key_pressed, annars hålls denna nollställd.
   ------------------------------------------------------------------------------------------------
   KEY_EVENT_PROCESS: process(clock, reset_s2_n_s) is
   begin
      if (reset_s2_n_s = '0') then
         key_pressed <= '0';
      elsif (rising_edge(clock)) then
         if (key_s2_n_s = '0' and key_s3_n_s = '1') then
            key_pressed <= '1';
         else
            key_pressed <= '0';
         end if;
      end if;
   end process;
   
   -- Kontinuerliga tilldelningar:
   reset_s2_n <= reset_s2_n_s;
   switch_s2  <= switch_s2_s;
   
end architecture;