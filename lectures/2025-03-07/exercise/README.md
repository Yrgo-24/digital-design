# 2025-03-07 - Konstruktion samt simulering av ett logiskt grindnät (del I)

## Uppgiftsbeskrivning

Realisera grindnätet för en krets bestående av fyra insignaler ABCD samt tre utsignaler XYZ, både för hand samt via VHDL-kod.  

## Sanningstabell

Nedanstående tabell visar sanningstabellen för grindnätet. 

| ABCD | XYZ |   
|------|-----|
| 0000 | 001 |
| 0001 | 010 |
| 0010 | 001 |
| 0011 | 011 |
| 0100 | 100 |
| 0101 | 110 |
| 0110 | 100 |
| 0111 | 111 |
| 1000 | 101 |
| 1001 | 110 |
| 1010 | 101 |
| 1011 | 111 |
| 1100 | 000 |
| 1101 | 010 |
| 1110 | 000 |
| 1111 | 011 |

## Uppgifter 
### 1.1 - Logiska ekvationer 
Finn minimerade logiska ekvationer för utsignaler X, Y och Z via användning av Karnaugh-diagram eller ekvationer. 

### 1.2 - Realisering av grindnätet
Rita grindnätet och verifiera att det fungerar som tänkt via simulering i CircuitVerse.

### 1.3 - Test på FPGA-kort
Realisera projektet via hårdvarubeskrivande kod i VHDL.\
Anslut insignaler ABCD till slide-switchar SWITCH[3:0] och utsignaler XYZ till lysdioder LED[2:0] på FPGA-kortet. 

### Extrauppgifter 
### 2.1 - Simulering med testbänk i VHDL
Skapa en testbänk och genomför simulering av hårdvaran i ModelSim för samtliga binära kombinationer av insignaler ABCD.\
Testkör varje kombination under 10 ns.

## Lösningsförslag
Lösningsförslag finns [här](./../notes/).
