# Digitalt system med flankdetektering

## Beskrivning 
Implementering av ett digitalt system innefattande flankdetektering för toggling av en lysdiod:

Konstruktionen innehållande följande portar:
* `clock`: Systemklocka, satt till 2 Hz i CircuitVerse, 50 MHz på FPGA-kortet.
* `reset_n`: Aktivt låg reset-signal från en tryckknapp.
* `button_n`: Aktivt låg tryckknapp, som används för att toggla lysdioden.
* `led`: Lysdioden som togglas vid nedtryckning av tryckknappen (på fallande flank).

## Kretsschema
Konstruktionens kretsschema visas nedan:

![Kretsschema för konstruktionen](./circuit/led_toggle.png).

Ovanstående krets kan simuleras genom att öppna filen [led_toggle.cv](./circuit/led_toggle.cv) 
i [CircuitVerse](https://circuitverse.org/simulator).

## Syntes samt simulering i VHDL
* [led_toggle.vhd](./vhdl/led_toggle.vhd) innehåller konstruktionens toppmodul `led_toggle`.
* [led_toggle.qar](./vhdl/led_toggle.qar) utgör en arkiverad projektfil, som kan användas 
för att direkt öppna projektet, inklusive pins och testbänk, i Quartus.

## Syntes samt simulering i SystemVerilog
* [led_toggle.sv](./systemverilog/led_toggle.sv) innehåller konstruktionens toppmodul `led_toggle`.
* [led_toggle.qar](./systemverilog/led_toggle.qar) utgör en arkiverad projektfil, som kan användas 
för att direkt öppna projektet, inklusive pins och testbänk, i Quartus.