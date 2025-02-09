# 2025-02-28 – Lektion 4

## Dagordning
* Installation av Quartus och ModelSim.
* Introduktion till VHDL – syntes och simulering av en OR-grind.

## Mål med lektionen
* Ha installerat Quartus och syntetiserat en OR-grind på ett FPGA-kort.
* Känna till innebörden av HDL-simulering (`HDL = Hardware Description Language`).
* Känna till vanliga nyckelord i VHDL, exempelvis `entity` samt `architecture`.

## Instruktioner
* **Innan lektionen:** Ladda ned samt extrahera zip-filen [`quartus_installation.zip`](https://drive.google.com/file/d/1uyzGYdMekGuM_wpcnPHFdsq24aYJb-QC/view?usp=classroom_web&authuser=0) från Classroom.
* Installation kommer ske under lektionstid. Vill ni genomföra installationen innan dess finns 
instruktioner [här](../../manuals/Installation%20och%20konfiguration%20av%20Quartus%20Lite%2018.1%20och%20ModelSim.pdf).
* ***OBS!** En del extra säkerhetsmekanismer har lagts till i Windows 11, vilket kan förhindra att flashning till FPGA-kort.
Om du har följt instruktionerna punkt till pricka och du ändå inte kan flasha till FPGA-kortet, stäng av `core isolation`
på din dator.*
* Läs [Bilaga A](#bilaga-a---nyckelord-i-vhdl) nedan för grundläggande information i VHDL.
* Se gärna min tutorial [Syntes och simulering i VHDL](https://www.youtube.com/watch?v=9ibUE7czpc4&authuser=0), som behandlar just
syntes (konstruktion) samt simulering av en 3-ingångars XOR-grind i VHDL.
* Vi kommer använda FPGA-kortet `Terasic DE0`. Kortets manual, som behövs för att ansluta OR-grindens in- och utportar till hårdvara, finns [här](../../manuals/DE0%20User%20ManuaL.pdf).

## Utvärdering
* Vad tar ni med er från dagens lektion?

## Nästa lektion
* Övningar grindnät – konstruktion och simulering för hand samt i VHDL.

## Bilaga A - Nyckelord i VHDL

***Notering**: En modul är ett digitalt byggblock med en utsida (`entity`) samt en insida (`architecture`).*

### `entity`
* `entity` utgör utsidan av en modul (ett digitalt byggblock), där in- och utportar deklareras.  
* `entity` kan liknas vid ett funktionshuvud i C; man ser vad som skickas in i funktionen och vad 
som returneras, men man ser inte vad som sker i funktionen.

#### Exempel
En OR-grind bestående av inportar `a` och `b` samt en utport `x` kan realiseras via en entitet döpt `or_gate`:

```vhdl
entity or_gate is  
    port(a, b: in std_logic;  
         x   : out std_logic);  
end entity;  
```

### `architecture`
* `architecture` utgör insidan av en modul, där modulens beteende/funktionalitet beskrivs.  
* `architecture` kan därmed tänkas utgöra byggblockets implementationsdetaljer, lite som innehållet inuti en C-funktion.
* En modul kan ha fler än en arkitektur, exempelvis om man vill möjliggöra att modulen fungerar olika för olika applikationer.
Det är just därför man har valt att dela upp en modul i `entity` samt `architecture`.
Oftast har en modul dock endast en arkitektur, vilket kommer vara fallet i denna kurs.

#### Exempel
Insidan av entiteten `or_gate` kan definieras för att realisera funktionaliteten av en OR-grind via
en arkitektur döpt `behaviour`:

```vhdl
architecture behaviour of or_gate is  
begin  
    x <= a or b;  
end architecture;  
```

### `std_logic`
* `std_logic` utgör en datatyp för signaler som ska kunna anta logiska värden `0` och `1` samt övriga värden som behövs för att realisera  digitala signaler i praktiken, såsom högohmig/tri-state (`Z`), don't care (`-`) med mera.  
* `std_logic` utgör ett utmärkt val för signaler och variabler som ska tilldelas en eller flera bitar 
(för fler bitar används datatypen  `std_logic_vector`, vilket är en vektor med bitar).  

#### Exempel
I VHDL måste datatypen `std_logic` inkluderas från ett package döpt `std_logic_1164` i biblioteket `IEEE`, 
vilket åstadkommes via följande instruktioner:  

```vhdl
library ieee;  
use ieee.std_logic_1164.all;  
```

### `process`
*  En `process` utgör ett sekventiellt block, vilket innebär att innehållet exekveras sekventiellt (uppifrån och ned),
alltså en instruktion i taget, så som sker vid mjukvaruprogrammering i C, C++, Python eller andra språk. 
* Genom att använda flera processer kan saker ske parallellt för ökad prestanda, likt flertrådade mjukvaruprogram.   

#### Exempel
Funktionaliteten för OR-grinden ovan hade kunnat realiseras via en `process` döpt `OR_PROCESS` såsom visas nedan.  
Processen i fråga exekverar vid förändring av någon av insignaler `a` och `b`, vilket implementeras genom 
att deklarera dessa portar i den så kallade känslighetslistan (innehållet i parentesen efter nyckelordet `or_gate`). 
Via en `if else`-sats sätts utsignal `x` till hög när `a` eller `b` är hög, annars sätts `x` till `0`:  

```vhdl
architecture behaviour of or_gate is
begin
    OR_PROCESS: process(a, b) is
    begin
        if (a = '1' or b = '1') then
            x <= '1';
        else
            x <= '0';
        end if;
    end process;
end architecture;
```

### `signal`
* Nyckelordet `signal` används för interna signaler inom en arkitektur, tänk ledningar mellan logiska grindar. 
* Signaler kan tilldelas ett värde kontinuerligt eller via en `process`.  
* Signalens värde kan läsas i hela arkitekturen, men tilldelning kan bara ske från en källa. 
Signaler kan därmed användas likt filglobala variabler i ett programspråk.  
I detta fall sträcker sig dock synligheten inte till hela filen, utan till den aktuella arkitekturen.  
* Alla signaler deklareras i den deklarativa delen av arkitekturen, alltså direkt ovanför nyckelordet `begin`.   

#### Exempel
Som exempel på användning av en signal i ett system med insignaler `a`, `b`, `c` och `d` och utsignal `x`,
som ska uppfylla den logiska funktionen `x = a + b'cd` kan en signal döpt `y = b'cd` implementeras 
enligt nedan, i detta fall primärt för att göra koden mer läsbar:  

```vhdl
library ieee;
use ieee.std_logic_1164.all;
 
entity signal_example is
    port(a, b, c, d: in std_logic;
         x         : out std_logic);
end entity;
 
architecture behaviour of signal_example is
signal y: std_logic;
begin
    y <= (not b) and c and d;
    x <= a or y;
end architecture;
```

Utan att använda signalen `y` hade koden sett ut såsom visas nedan:  

```vhdl
library ieee;
use ieee.std_logic_1164.all;
 
entity signal_example is
    port(a, b, c, d: in std_logic;
         x         : out std_logic);
end entity;
 
architecture behaviour of signal_example is
begin
       x <= a or ((not b) and c and d);
end architecture;
```
