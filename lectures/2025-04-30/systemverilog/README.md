# Digitalt system med flankdetektering i SystemVerilog

## Beskrivning 
Implementering av ett digitalt system döpt `led_toggle` i SystemVerilog.

Toppmodulen `led_toggle` innehållande följande portar:
* `clock`: 50 MHz systemklocka.
* `reset_n`: Inverterande reset-signal från en tryckknapp.
* `button_n`: Inverterande knapp, som används för att toggla lysdioden.
* `led`: Lysdioden som togglas vid nedtryckning av tryckknappen (på fallande flank).

## Kod
Filerna i denna katalog innehåller följande:
* [led_toggle.sv](./led_toggle.sv) innehåller konstruktionens toppmodul `led_toggle`.
* [led_toggle.qar](./led_toggle.qar) utgör en arkiverad projektfil, som kan användas 
för att direkt öppna projektet, inklusive pins och testbänk, i Quartus.