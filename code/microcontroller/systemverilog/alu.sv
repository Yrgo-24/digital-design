/**************************************************************************************************
* alu.sv: Innehåller funktionalitet för implementering av mikrodatorns ALU. Denna fil inkluderas 
*         i paketet def och behöver därmed inte inkluderas specifikt i en given modul ifall 
*         detta paket har importerats (vilket görs via direktivet import def::*).
**************************************************************************************************/
`ifndef ALU_SV_
`define ALU_SV_

/**************************************************************************************************
* alu: Implementering av en ALU, där ingående argument a och b utgör operander och resultatet
*      från aktuell aritmetisk eller logisk operation returneras. Statusbitar NZVC i uppdateras 
*      utefter resultatet innan återhoppet. C-flaggan tilldelas carry-biten genom att tilldela 
*      den extra minnessiffra som resulterar från operationen. N-flaggan tilldelas teckenbiten
*      (den mest signifikanta biten MSB från resultatet). Z-flaggan ettställs ifall resultatet 
*      blev noll, annars nollställs denna. V-flaggan ettställs om teckenbiten för båda operander 
*      är samma och resultatets teckenbit är inversen av detta. Exempelvis kan detta ske ifall 
*      addition av två positiva tal (MSB = 0) medför en negativ summa (MSB = 1). V-flaggan 
*      indikerar då att overflow har ägt rum, vilket beror på att fler bitar krävs för att 
*      summan skall bli korrekt.
**************************************************************************************************/
function automatic logic[7:0] alu(input logic[7:0] op_code, a, b, output logic[3:0] nzvc);
   logic[7:0] result;
   
   case (op_code)
      ORI:  { nzvc[0], result } = a | b;
      ANDI: { nzvc[0], result } = a & b;
      XORI: { nzvc[0], result } = a ^ b;
      OR:   { nzvc[0], result } = a | b;
      AND:  { nzvc[0], result } = a & b;
      XOR:  { nzvc[0], result } = a ^ b;
      ADDI: { nzvc[0], result } = a + b;
      SUBI: { nzvc[0], result } = a - b;
      ADD:  { nzvc[0], result } = a + b;
      SUB:  { nzvc[0], result } = a - b;
      INC:  { nzvc[0], result } = a + 1'b1;
      DEC:  { nzvc[0], result } = a - 1'b1;
      CPI:  { nzvc[0], result } = a - b;
      CP:   { nzvc[0], result } = a - b;
   endcase
   
   nzvc[3] = result[7];
   nzvc[2] = result == 8'b0 ? 1'b1 : 1'b0;
   nzvc[1] = (a[7] & b[7] & !result[7]) | (!a[7] & !b[7] & result[7]);
   return result;
endfunction

/**************************************************************************************************
* compare: Jämför operander a och b mot varandra och uppdaterar statusbitar NZVC därefter.
*          ALU:n används för jämförelsen, där returvärdet från ALU:n är irrelevant och förkastas.
**************************************************************************************************/
task automatic compare(input logic[7:0] op_code, a, b, output logic[3:0] nzvc);
   logic[7:0] result = alu(op_code, a, b, nzvc);
   return;
endtask

`endif /* ALU_SV_ */