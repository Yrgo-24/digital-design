# Digitalt system med metastabilitetsskydd

## Beskrivning
Implementering av ett digitalt system innefattande flankdetektering för toggling av en lysdiod.
Metastabilitetsskydd har lagts till för att säkerhetsställa att samtliga insignaler är stabila
(0 eller 1) när de används i konstruktionen. När detta genomförs säger man att insignalerna synkroniseras.

Konstruktionen innehållande följande portar:
* `clock`: Systemklocka, satt till 2 Hz i CircuitVerse, 50 MHz på FPGA-kortet.
* `reset_n`: Aktivt låg reset-signal från en tryckknapp.
* `button_n`: Aktivt låg tryckknapp, som används för att toggla lysdioden.
* `led`: Lysdioden som togglas vid nedtryckning av tryckknappen (på fallande flank).

Reset-signalen `reset_n` synkroniseras via två D-vippor. Motsvarande synkroniserad reset-signal `reset_s2_n` används sedan i resten av kretsen. Postfix `s2` innebär att signalen i fråga har synkroniserats med två vippor i enlighet med `double flop`-metoden.

Tryckknappen `button_n` synkroniseras via två D-vippor och ytterligare en vippa används för flankdetektering, där `button_s2_n` utgör "nuvarande" insignal och `button_s3_n` utgör "föregående" insignal. Vid nedtryckning (fallande flank) gäller att `button_s2_n` = 0 och `button_s3_n` = 1. Då ettställs signalen `button_pressed_s2` för att indikera knapptryckning.
När `button_pressed_s2` ettställs togglas lysdioden `led`.

## Kretsschema
Konstruktionen kretsschema visas och kan simuleras genom att öppna filen [led_toggle_meta_prev.cv](./circuit/led_toggle_meta_prev.cv) 
i [CircuitVerse](https://circuitverse.org/simulator).

## Syntes samt simulering i VHDL
* [led_toggle_meta_prev.vhd](./vhdl/led_toggle_meta_prev.vhd) innehåller konstruktionens toppmodul `led_toggle_meta_prev`.
* [meta_prev.vhd](./vhdl/meta_prev.vhd) innehåller modulen `meta_prev`, som används för att synkronisera insignalerna med `double flop`-metoden samt att detektera fallande flank på tryckknappen `button_n`.
* [led_toggle_meta_prev.qar](./vhdl/led_toggle_meta_prev.qar) utgör en arkiverad projektfil, som kan användas för att direkt öppna projektet, inklusive pins och testbänk, i Quartus.

## Syntes samt simulering i Systemverilog
* [led_toggle_meta_prev.sv](./systemverilog/led_toggle_meta_prev.sv) innehåller konstruktionens toppmodul `led_toggle_meta_prev`.
* [meta_prev.sv](./systemverilog/meta_prev.sv) innehåller modulen `meta_prev`, som används för att synkronisera insignalerna
med `double flop`-metoden samt att detektera fallande flank på tryckknappen `button_n`.
* [led_toggle_meta_prev.qar](./systemverilog/led_toggle_meta_prev.qar) utgör en arkiverad projektfil, som kan användas för att direkt öppna projektet, inklusive pins och testbänk, i Quartus.