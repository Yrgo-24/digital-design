# Mikrodator i VHDL
* 8-bitars mikrodator för FPGA, skriven i VHDL. Mikrodatorn är baserad på ATmega328P.

* Ett litet program för att blinka en lysdiod vid nedtryckning av en tryckknapp är implementerat i maskinkod.

* Det finns två klockkällor tillgängliga:
    * En 50 MHz systemklocka för normal användning.
    * En manuell klocka, som pulserar via nedtryckning av en tryckknapp. Aktuell OP-kod samt innehållet
      i CPU-register R16 visas via fem 7-segmentsdisplayer när denna klocka används. Adressen som programräknaren
      pekar på visas också på binär form via åtta lysdioder på FPGA-kortet.

* Koden skrevs mellan 2022-07-15 - 2022-07-17 via `Intel Quartus Prime 18.1`.

* PINs är tilldelade för FPGA-kort Terasic DE0.

* Kommentarerna är skrivna på svenska.

* Öppna filen [`mcu.qar`](./mcu.qar) för att öppna hela projektet i Quartus.