# Implementering av en tillståndsmaskin för FPGA samt mikrokontroller

## Beskrivning
Implementering av en tillståndsmaskin för att styra en lysdiod via två tryckknappar.

Tillståndsmaskinen innehar tre tillstånd:
* `STATE_OFF`: Lysdioden är släckt.
* `STATE_BLINK`: Lysdioden blinkar var 100:e millisekund.
* `STATE_ON`: Lysdioden är tänd.

## Tillståndsmaskin för FPGA-kort Terasic DE0
Konstruktionen innehåller följande portar:
* `clock`: 50 MHz systemklocka.
* `reset_n`: Aktivt låg reset-signal från en tryckknapp.
* `button_n`: Aktivt låga tryckknappa, som används för att byta tillstånd framåt och bakåt.
* `led`: Lysdioden som styrs via tillståndsmaskinen.

### Kod
* [fsm.vhd](./fpga/fsm.vhd) innehåller konstruktionens toppmodul `fsm`.
* [meta_prev.vhd](./fpga/meta_prev.vhd) innehåller modulen `meta_prev`, som används för att synkronisera insignalerna med `double flop`-metoden samt att detektera fallande flank på tryckknapparna `button_n`.
* [counter.sv](./fpga/counter.sv) innehåller modulen `counter`, som används som räknare/timer för att blinka lysdioden `led`. 
Denna modul är skriven i SystemVerilog.
* [fsm.qar](./fpga/fsm.qar) utgör en arkiverad projektfil, som kan användas för att direkt öppna projektet, inklusive pins och testbänk, i Quartus.

## Tillståndsmaskin för mikrokontroller ATmega328P
Konstruktionen innehåller följande portar:
* `RESET_BUTTON`: Reset-knapp ansluten till PIN 9 (PORTB1).
* `PREVIOUS_BUTTON`: Tryckknapp för att byta till föregående tillstånd.
* `NEXT_BUTTON`: Tryckknapp för att byta till nästa tillstånd.
* `LED`: Lysdioden som styrs via tillståndsmaskinen.

### Kod
* [main.c](./atmega328p/main.c) används för att initiera och köra systemet.
* [system.h](./atmega328p/system.h) innehåller definitioner av PINs, states samt events för systemet.
* [system.c](./atmega328p/system.c) innehåller implementationsdetaljer för systemet.

### Övriga filer
* [fsm.zip](./atmega328p/fsm.zip) utgör en komprimerad variant av projektet, som kan användas för att köra projektet.\
**Ladda ned samt extrahera denna fil, dubbelklicka sedan på `fsm.cproj` för att öppna projektet i Microchip Studio.**
* [fsm.cproj](./atmega328p/fsm.cproj) utgör en projektfil, som kan användas för att öppna de tidigare nämnda
.c- och .h-filerna som ett projekt döpt `fsm`.
* [fsm.componentinfo.xml](./atmega328p/fsm.componentinfo.xml) innehåller komponentinfo om projektet `fsm`.