# Bibliotek för ATmega-processorer

## Beskrivning
Bibliotek innehållande diverse drivrutiner och container-klasser för mikrodatorer i ATmega-serien.
Via interfaces kan Implementeringer enkelt göras för vilken ATmega-processor som helst utan stora
förändringar av programmets huvudfunktion. För tillfället är dock drivrutiner enbart implementerade för `ATmega328P`.  
Koden är skriven i C++17 och är anpassad för Microchip Studio.

## Innehåll
Biblioteket består av drivrutiner, container-klasser, smarta pekare samt hjälpfunktioner.

### Drivrutiner

Biblioteket innehåller följande drivrutiner i katalogen [`driver`](./libatmega/driver/):
* `ADC`: Drivrutiner för enkel användning av AD-omvandlare.
* `EEPROM`: Drivrutiner för skrivning och läsning till och från EEPROM-minnet. 
* `GPIO`: Generisk drivrutin för GPIO-enheter.
* `Timer`: Drivrutin för hårdvarutimers.
* `Serial`: Drivrutin för seriell överföring via USART.  
* `Watchdog`: Drivrutin för användning av watchdog timers.

### Container-klasser

Biblioteket innehåller följande generiska container-klasser i katalogen [`container`](./libatmega/container/):
* `Array`: Implementering av statiska arrayer av godtycklig datatyp. 
* `List`: Implementering av dubbellänkade listor av godtycklig datatyp. 
* `Vector`: Implementering av dynamiska vektorer av godtycklig datatyp.

### Smarta pekare

Biblioteket innehåller följande generiska smarta pekare i katalogen [`memory`](./libatmega/memory/):
* `UniquePtr`: Implementering av unika pekare av godtycklig datatyp.
* `SharedPtr`: Implementering of delade pekare av godtycklig datatyp.

### Hjälpfunktioner- och klasser

Biblioteket innehåller följande hjälpklasser:
* `CallbackArray`: Implementering av arrayer innehållande pekare till callbacks (exempelvis för interrupts).  
* `Pair`: Implementering of par innehållande värden av godtycklig datatyp.

Biblioteket innehåller också typmallar för användning av templates samt hjälpfunktioner för diverse lågnivåoperationer.

## Exempelprogram
I katalogen [`target`](./libatmega/target/) finns ett exempelprogram för att demonstrera drivrutinerna:
* En tryckknapp används för att toggla en timer. När timern är aktiverad blinkar den i sin tur en lysdiod var 100:e ms. 
* Ytterligare en timer används för att minska effekterna av kontaktstudsar vid nedtryckning av knappen. 
* En watchdog timer används för att starta om programmet om vi fastnar i en loop eller dylikt.

## Användning
Biblioteket måste öppnas i en Windows-miljö för att bygga och flasha.
Kopiera biblioteket till en Windows-katalog, exempelvis på C:-disken, innan kompilering.