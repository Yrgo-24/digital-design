/**************************************************************************************************
* def.sv: Innehåller ett flertal definitioner i form av konstanter och dylikt via paketet def.
**************************************************************************************************/
`ifndef DEF_SV_
`define DEF_SV_

/**************************************************************************************************
* def: Innehållet konstanter för OP-koder, CPU-register, I/O-register med mera. 
**************************************************************************************************/
package def;

/* Inkluderingsdirektiv: */
`include "alu.sv"
`include "rw_memory.sv"
`include "stack.sv"

/* OP-koder: */
localparam NOP  = 8'h00; /* Ingen operation. */
localparam LDI  = 8'h01; /* Läser innehåll till ett CPU-register. */
localparam MOV  = 8'h02; /* Kopierar innehållet från ett CPU-register till ett annat. */
localparam OUT  = 8'h03; /* Skriver innehåll från ett CPU-register till ett I/O-register. */
localparam IN   = 8'h04; /* Läser innehåll från ett I/O-register till ett CPU-register. */
localparam STS  = 8'h05; /* Skriver innehåll från ett CPU-register till RAM-minnet. */
localparam LDS  = 8'h06; /* Läser innehåll från RAM-minnet till ett CPU-register. */
localparam ORI  = 8'h07; /* Genomför bitvis OR med innehållet i ett CPU-register samt en konstant. */
localparam ANDI = 8'h08; /* Genomför bitvis AND med innehållet i ett CPU-register samt en konstant. */
localparam XORI = 8'h09; /* Genomför bitvis XOR med innehållet i ett CPU-register samt en konstant. */
localparam OR   = 8'h0A; /* Genomför bitvis OR med innehållet i två CPU-register. */
localparam AND  = 8'h0B; /* Genomför bitvis AND med innehållet i två CPU-register. */
localparam XOR  = 8'h0C; /* Genomför bitvis XOR med innehållet i två CPU-register. */
localparam CLR  = 8'h0D; /* Nollställer ett CPU-register. */
localparam ADDI = 8'h0E; /* Addition av innehållet i ett CPU-register med en konstant. */ 
localparam SUBI = 8'h0F; /* Subtraktion av innehållet i ett CPU-register med en konstant. */

localparam ADD  = 8'h10; /* Addition av innehållet i två CPU-register. */
localparam SUB  = 8'h11; /* Subtraktion av innehållet i två CPU-register. */
localparam INC  = 8'h12; /* Inkrementerar värdet lagrat i ett CPU-register. */
localparam DEC  = 8'h13; /* Dekrementerar värdet lagrat i ett CPU-register. */
localparam CPI  = 8'h14; /* Jämför innehållet i ett CPU-register med en konstant. */
localparam CP   = 8'h15; /* Jämför innehållet mellan två CPU-register. */
localparam JMP  = 8'h16; /* Genomför ovillkorligt programhopp till angiven adress. */
localparam BREQ = 8'h17; /* Genomför programhopp om operand 1 är lika med operand 2. */
localparam BRNE = 8'h18; /* Genomför programhopp om operand 1 ej är lika med operand 2. */
localparam BRGE = 8'h19; /* Genomför programhopp om operand 1 är större eller lika med operand 2. */
localparam BRGT = 8'h1A; /* Genomför programhopp om operand 1 är större än operand 2. */
localparam BRLE = 8'h1B; /* Genomför programhopp om operand 1 är mindre eller lika med operand 2. */
localparam BRLT = 8'h1C; /* Genomför programhopp om operand 1 är mindre än operand 2. */
localparam CALL = 8'h1D; /* Genomför programhopp till subrutin och sparar returadressen på stacken. */
localparam RET  = 8'h1E; /* Genomför återhopp från subrutin via sparad returadress på stacken. */
localparam PUSH = 8'h1F; /* Lägger till data från ett CPU-register till stacken. */
localparam POP  = 8'h20; /* Tar bort data från stacken och lägger i ett CPU-register. */

/* CPU-register (index till array implementerad i styrenheten): */
localparam R0  = 8'h00; /* CPU-register R0. */
localparam R1  = 8'h01; /* CPU-register R1. */
localparam R2  = 8'h02; /* CPU-register R2. */
localparam R3  = 8'h03; /* CPU-register R3. */
localparam R4  = 8'h04; /* CPU-register R4. */
localparam R5  = 8'h05; /* CPU-register R5. */
localparam R6  = 8'h06; /* CPU-register R6. */
localparam R7  = 8'h07; /* CPU-register R7. */
localparam R8  = 8'h08; /* CPU-register R8. */
localparam R9  = 8'h09; /* CPU-register R9. */
localparam R10 = 8'h0A; /* CPU-register R10. */
localparam R11 = 8'h0B; /* CPU-register R11. */
localparam R12 = 8'h0C; /* CPU-register R12. */
localparam R13 = 8'h0D; /* CPU-register R13. */
localparam R14 = 8'h0E; /* CPU-register R14. */
localparam R15 = 8'h0F; /* CPU-register R15. */

localparam R16 = 8'h10; /* CPU-register R16. */
localparam R17 = 8'h11; /* CPU-register R17. */
localparam R18 = 8'h12; /* CPU-register R18. */
localparam R19 = 8'h13; /* CPU-register R19. */
localparam R20 = 8'h14; /* CPU-register R20. */
localparam R21 = 8'h15; /* CPU-register R21. */
localparam R22 = 8'h16; /* CPU-register R22. */
localparam R23 = 8'h17; /* CPU-register R23. */
localparam R24 = 8'h18; /* CPU-register R24. */
localparam R25 = 8'h19; /* CPU-register R25. */
localparam R26 = 8'h1A; /* CPU-register R26. */
localparam R27 = 8'h1B; /* CPU-register R27. */
localparam R28 = 8'h1C; /* CPU-register R28. */
localparam R29 = 8'h1D; /* CPU-register R29. */
localparam R30 = 8'h1E; /* CPU-register R30. */
localparam R31 = 8'h1F; /* CPU-register R31. */

/* I/O-register (adresser i I/O-minnet): */
localparam PINB  = 8'h00; /* Register för läsning av insignaler på I/O-port B. */
localparam PORTB = 8'h01; /* Register för skrivning av utsignaler på I/O-port B. */
localparam DDRB  = 8'h02; /* Datariktningsregister för I/O-port B). */
localparam PINC  = 8'h03; /* Register för läsning av insignaler på I/O-port C. */
localparam PORTC = 8'h04; /* Register för skrivning av utsignaler på I/O-port C. */
localparam DDRC  = 8'h05; /* Datariktningsregister för I/O-port C). */
localparam PIND  = 8'h06; /* Register för läsning av insignaler på I/O-port D. */
localparam PORTD = 8'h07; /* Register för skrivning av utsignaler på I/O-port C. */
localparam DDRD  = 8'h08; /* Datariktningsregister för I/O-port D). */

/**************************************************************************************************
* cpu_state_t: Enumeration för implementering av de olika tillstånden i CPU:ns instruktionscykel,
*              där FETCH = hämtar instruktion från programminnet, DECODE = delar upp instruktionen
*              i OP-kod samt operander och EXECUTE = utför instruktionen.
**************************************************************************************************/
typedef enum { CPU_STATE_FETCH, CPU_STATE_DECODE, CPU_STATE_EXECUTE } cpu_state_t;

endpackage

`endif /* DEF_SV_ */