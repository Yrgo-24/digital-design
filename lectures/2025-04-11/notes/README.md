# Digitalt system med 7-segmentsdisplayer

## Beskrivning 
Implementering av ett digitalt system döpt `hex_display`. Systemets blockschema visas nedan:

![Blockschema över projektet `hex_display`](./images/hex_display.png).

Toppmodulen `hex_display` innehållande följande portar:
* `input[7:0]`: Utgörs av insignaler från slide-switchar. 
* `hex1[6:0]` samt `hex0[6:0]`: Utgörs av utsignaler till var sin 7-segmentsdisplay.

Hårdvaran har implementerats enligt nedan:
* Det 4-bitars binära tal som matas in via slide-switchar `input[7:3]` skrivs ut hexadecimalt på `hex1`.
* Det 4-bitars binära tal som matas in via slide-switchar `input[3:0]` skrivs ut hexadecimalt på `hex0`.

## Syntes samt simulering i VHDL
* [hex_display.vhd](./vhdl/hex_display.vhd) innehåller konstruktionens toppmodul `hex_display`.
* [display.vhd](./vhdl/display.vhd) innehåller modulen `display`, som möjliggör att man enkelt kan 
erhålla binärkoden för en hexadecimal siffra 0 - F genom att mata in ett 4-bitars binärt tal `0b0000` - `0b1111`.\
Två instanser av denna modul används i toppmodulen, en för varje 7-segmentsdisplay. 
* [display_tb.vhd](./vhdl/display_tb.vhd) innehåller en testbänk för modulen `display`. I denna testbänk verifieras att 
binärkoden för en given 7-segmentsdisplay är korrekt för samtliga 4-bitars kombinationer `0b0000` - `0b1111`.
* [hex_display.qar](./vhdl/hex_display.qar) utgör en arkiverad projektfil, som kan användas 
för att direkt öppna projektet, inklusive pins och testbänk, i Quartus.

## Syntes samt simulering i SystemVerilog
* [hex_display.sv](./systemverilog/hex_display.sv) innehåller konstruktionens toppmodul `hex_display`.
* [display.sv](./systemverilog/display.sv) innehåller modulen `display`, som möjliggör att man enkelt kan 
erhålla binärkoden för en hexadecimal siffra 0 - F genom att mata in ett 4-bitars binärt tal `0b0000` - `0b1111`.\
Två instanser av denna modul används i toppmodulen, en för varje 7-segmentsdisplay.
* [display_tb.sv](./systemverilog/display_tb.sv) innehåller en testbänk för modulen `display`. I denna testbänk verifieras 
att binärkoden för en given 7-segmentsdisplay är korrekt för samtliga 4-bitars kombinationer `0b0000` - `0b1111`.
* [hex_display.qar](./systemverilog/hex_display.qar) utgör en arkiverad projektfil, som kan användas 
för att direkt öppna projektet, inklusive pins och testbänk, i Quartus.