# 2025-02-28 – Lektion 4

## Dagordning
* Installation av Quartus och ModelSim.
* Introduktion till VHDL – syntes och simulering av en OR-grind.

## Mål med lektionen
* Ha installerat Quartus och syntetiserat en OR-grind på ett FPGA-kort.
* Känna till innebörden av HDL-simulering (`HDL = Hardware Description Language`).
* Känna till vanliga nyckelord i VHDL, exempelvis `entity` samt `architecture`.

## Instruktioner
* **Innan lektionen:** Ladda ned samt extrahera en zip-fil innehållande installationsfiler för Quartus:
    * För er som tänker använda skolans FPGA-kort *(Terasic DE0)*, ladda ned 
    [`quartus_installation_de0.zip`](https://drive.google.com/file/d/1uyzGYdMekGuM_wpcnPHFdsq24aYJb-QC/view?usp=sharing).  
    FPGA-kretsen på kortet heter `5CEBA4F23C7`. Kortets manual finns [här](../../manuals/DE0%20User%20ManuaL.pdf).
    * För er som har införskaffat FPGA-kortet *Terasic DE10-Lite* för privat bruk, ladda ned 
    [`quartus_installation_de10_lite.zip`](https://drive.google.com/file/d/1LVx9B4PeWuvFn8L5QMJclAARbW7NwMW2/view?usp=drive_link).  
    FPGA-kretsen på kortet heter `10M50DAF484C7G`. Kortets manual finns [här](../../manuals/DE10-Lite%20User%20Manual.pdf).

* Läs [Bilaga A](#bilaga-a---grundläggande-koncept-i-vhdl) nedan för information om grundläggande koncept i VHDL.
* Se gärna min tutorial [Syntes och simulering i VHDL](https://www.youtube.com/watch?v=9ibUE7czpc4&authuser=0), som behandlar just
syntes (konstruktion) samt simulering av en 3-ingångars XOR-grind i VHDL.
* Installation av Quartus samt drivrutiner för FPGA-korten kommer ske under lektionstid. Vill ni genomföra installationen innan dess finns 
instruktioner [här](../../manuals/Installation%20och%20konfiguration%20av%20Quartus%20Lite%2018.1%20och%20ModelSim.pdf).
* ***OBS!** En del extra säkerhetsmekanismer har lagts till i Windows 11, vilket kan förhindra att flashning till FPGA-kort fungerar.
Om du har följt instruktionerna punkt till pricka och du ändå inte kan flasha till FPGA-kortet, dirigera till `System settings -> Core isolation` och inaktivera `Memory integrity` på din dator, så som visas nedan:*

![`Memory integrity option`](./images/memory_integrity.png)

## Utvärdering
* Vad tar ni med er från dagens lektion?

## Nästa lektion
* Övningar grindnät – konstruktion och simulering för hand samt i VHDL.

## Bilaga A - Grundläggande koncept i VHDL

### Konceptet modul
* En modul är ett digitalt byggblock med en in- och utsida:
    * På utsidan ser man byggblocket som en svart låda och man tänker bara på byggblockets beteende/funktionalitet. 
    * På insidan ser man vad byggblocket består av.

#### Exempel
Nedan visas en modul döpt `or_gate`, bestående av inportar `a` och `b` samt en utport `x`:

![Modulen `or_gate`](./images/or_gate_module.png)

### `Entity`
* En `entity` utgör utsidan av en modul. 
* På entitetsnivå ses modulen som en svart låda, dvs. man ser endast förhållande mellan in- och utportarna. 
Den interna implementationen, alltså hur lådan fungerar, bortser man från.

#### Exempel

Modulen `or_gate` har följande utseende på entitetsnivå:

![Entiteten `or_gate`](./images/or_gate_entity.png)

I VHDL kan entiteten `or_gate` implementeras såhär:

```vhdl
entity or_gate is  
    port(a, b: in std_logic;  
         x   : out std_logic);  
end entity;  
```

### `Architecture`
* En `architecture` utgör insidan av en modul, där modulens beteende beskrivs.
* Arkitekturen kan därmed tänkas utgöra byggblockets implementationsdetaljer, alltså innehållet i den svarta lådan.
* En modul kan ha fler än en arkitektur, exempelvis om man vill möjliggöra att modulen fungerar olika för olika applikationer.
Det är just därför man har valt att dela upp en modul i `entity` samt `architecture`.
Oftast har en modul dock endast en arkitektur, vilket kommer vara fallet i denna kurs.

#### Exempel

* Allt inom den röda rektangeln i nedanstående bild utgör arkitekturen för modulen `or_gate`:

![Arkitekturen `or_gate`](./images/or_gate_architecture.png)

I VHDL kan arkitekturen för modulen `or_gate` implementeras såhär:

```vhdl
architecture behaviour of or_gate is  
begin  
    x <= a or b;  
end architecture;  
```

***Notering:** Arkitekturens namn kan väljas godtyckligt.*

### Datatypen `std_logic`
* Datatypen `std_logic` används signaler som ska kunna anta logiska värden `0` och `1` samt övriga värden som behövs för att realisera  digitala signaler i praktiken, såsom högohmig/tri-state (`Z`), don't care (`-`) med mera.  
* `std_logic` utgör ett utmärkt val för signaler och variabler som ska tilldelas en eller flera bitar 
(för fler bitar används datatypen  `std_logic_vector`, vilket är en vektor med bitar).  

#### Exempel
I VHDL måste datatypen `std_logic` inkluderas från ett package döpt `std_logic_1164` i biblioteket `IEEE`, 
vilket åstadkommes via följande instruktioner:  

```vhdl
library ieee;  
use ieee.std_logic_1164.all;  
```

### `Process`
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

### `Signal`
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
