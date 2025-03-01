# Anteckningar 2025-02-28

Syntes samt simulering av en OR-grind i VHDL:
* [or_gate.vhd](./vhdl/or_gate.vhd) innehåller modulen `or_gate`, som utgör själva implementationen av OR-grinden.
* [or_gate_tb.vhd](./vhdl/or_gate_tb.vhd) utgör en testbänk för modulen `or_gate`. Implementering av
testbänkar kommer behandlas efterföljande lektion.
* [or_gate.qar](./vhdl/or_gate.qar) utgör en arkiverad projektfil, som kan användas 
för att direkt öppna projektet, inklusive pins och testbänk, i Quartus.

Motsvarande hårdvarubeskrivande kod skriven i SystemVerilog finns i underkatalogen [systemverilog](./systemverilog/):
* [or_gate.sv](./systemverilog/or_gate.sv) innehåller modulen `or_gate`, som utgör själva implementationen av OR-grinden.
* [or_gate_tb.sv](./systemverilog/or_gate_tb.sv) utgör en testbänk för modulen `or_gate`.
* [or_gate.qar](./systemverilog/or_gate.qar) utgör en komprimerad projektfil, som kan användas 
för att direkt öppna projektet, inklusive pins och testbänk, i Quartus.
