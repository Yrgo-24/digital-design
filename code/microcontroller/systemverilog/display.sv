/**************************************************************************************************
* display.sv: Möjliggör utskrift av given OP-kod samt innehållet i CPU-register R16 via fem
*             7-segmentsdisplayer med ett mellanrum dem emellan, exempelvis LDI 02 eller ORI 20.
**************************************************************************************************/
`ifndef DISPLAY_SV
`define DISPLAY_SV

/***********************************************************************************************
* display: Innehåller funktionalitet för att skriva ut aktuell OP-kod samt innehållet i
*          CPU-register R16 via fem 7-segmentsdisplayer. hex[5:3] visar aktuell OP-kod medan 
*          hex[1:0] visar innehållet i R16 på hexadecimal form. hex2 används som mellanrum 
*          mellan OP-koden samt innehållet i R16 och har därmed inte definierats.
***********************************************************************************************/
module display
(
   input logic clock,        /* 50 MHz systemklocka. */
   input logic reset_s2_n,   /* Synkroniserad inverterad reset-signal. */
   input logic enable,       /* Enable-signal, indikerar ifall displayerna är aktiverade. */
   input logic[7:0] op_code, /* Binärkod som indikerar aktuell OP-kod. */
   input logic[7:0] r16,     /* Innehållet i register R16. */
   output logic[6:0] hex5,   /* 7-segmentsdisplay, visar OP-kod. */
   output logic[6:0] hex4,   /* 7-segmentsdisplay, visar OP-kod. */
   output logic[6:0] hex3,   /* 7-segmentsdisplay, visar OP-kod. */
   output logic[6:0] hex1,   /* 7-segmentsdisplay, visar innehållet i CPU-register R16. */
   output logic[6:0] hex0    /* 7-segmentsdisplay, visar innehållet i CPU-register R16. */
); 

   /* Inkluderingsdirektiv: */
   import def::*; 
   
   /* Binärkoder för siffror och bokstäver till 7-segmentsdisplayer: */
   localparam OFF   = 7'b1111111; /* Släcker display. */   
   localparam ZERO  = 7'b1000000; /* Binärkod för heltalet 0. */
   localparam ONE   = 7'b1111001; /* Binärkod för heltalet 1. */
   localparam TWO   = 7'b0100100; /* Binärkod för heltalet 2. */
   localparam THREE = 7'b0110000; /* Binärkod för heltalet 3. */  
   localparam FOUR  = 7'b0011001; /* Binärkod för heltalet 4. */  
   localparam FIVE  = 7'b0010010; /* Binärkod för heltalet 5. */   
   localparam SIX   = 7'b0000010; /* Binärkod för heltalet 6. */ 
   localparam SEVEN = 7'b1111000; /* Binärkod för heltalet 7. */  
   localparam EIGHT = 7'b0000000; /* Binärkod för heltalet 8. */ 
   localparam NINE  = 7'b0010000; /* Binärkod för heltalet 9. */   
   localparam A     = 7'b0001000; /* Binärkod för bokstaven A. */  
   localparam B     = 7'b0000011; /* Binärkod för bokstaven B. */    
   localparam C     = 7'b1000110; /* Binärkod för bokstaven C. */  
   localparam D     = 7'b0100001; /* Binärkod för bokstaven D. */  
   localparam E     = 7'b0000110; /* Binärkod för bokstaven E. */   
   localparam F     = 7'b0001110; /* Binärkod för bokstaven F. */ 
   localparam G     = 7'b0000010; /* Binärkod för bokstaven G. */ 
   localparam H     = 7'b0001001; /* Binärkod för bokstaven H. */
   localparam I     = 7'b1111001; /* Binärkod för bokstaven I. */ 
   localparam J     = 7'b1110001; /* Binärkod för bokstaven J. */ 
   localparam L     = 7'b1000111; /* Binärkod för bokstaven L. */ 
   localparam M     = 7'b1101010; /* Binärkod för bokstaven M. */ 
   localparam N     = 7'b1001000; /* Binärkod för bokstaven N. */ 
   localparam O     = 7'b1000000; /* Binärkod för bokstaven O. */ 
   localparam P     = 7'b0001100; /* Binärkod för bokstaven P. */ 
   localparam R     = 7'b0101111; /* Binärkod för bokstaven R. */ 
   localparam S     = 7'b0010010; /* Binärkod för bokstaven S. */ 
   localparam T     = 7'b0000111; /* Binärkod för bokstaven T. */ 
   localparam U     = 7'b1000001; /* Binärkod för bokstaven U. */ 
   localparam V     = 7'b1100011; /* Binärkod för bokstaven V. */ 
   
   /***********************************************************************************************
   * DISPLAY_OP_CODE: Skriver ut aktuell OP-kod på 7-segmentsdisplayer hex[5:3]. Vid reset
   *                  släcks 7-segmentsdisplayerna.
   ***********************************************************************************************/
   always_ff @ (posedge clock or negedge reset_s2_n)
   begin: DISPLAY_OP_CODE
      
      if (!reset_s2_n) begin
         hex5 <= OFF;
         hex4 <= OFF;
         hex3 <= OFF;
      end
      
      else begin
         if (enable) begin
            case (op_code)          
               NOP: begin
                  hex5 <= N;
                  hex4 <= O;
                  hex3 <= P;
               end
               
               LDI: begin 
                  hex5 <= L; 
                  hex4 <= D; 
                  hex3 <= I; 
               end
               
               MOV: begin
                  hex5 <= M;
                  hex4 <= O;
                  hex3 <= V;
               end
               
               OUT: begin
                  hex5 <= O;
                  hex4 <= U;
                  hex3 <= T;
               end
               
               IN: begin
                  hex5 <= I;
                  hex4 <= N;
                  hex3 <= OFF;
               end
               
               STS: begin
                  hex5 <= S;
                  hex4 <= T;
                  hex3 <= S;
               end
               
               LDS: begin
                  hex5 <= L;
                  hex4 <= D;
                  hex3 <= S;
               end
               
               ORI: begin
                  hex5 <= O;
                  hex4 <= R;
                  hex3 <= I;
               end
               
               ANDI: begin
                  hex5 <= A;
                  hex4 <= N;
                  hex3 <= D;
               end
               
               XORI: begin
                  hex5 <= E;
                  hex4 <= O;
                  hex3 <= R;
               end
               
               OR: begin
                  hex5 <= O;
                  hex4 <= R;
                  hex3 <= OFF;
               end
               
               AND: begin
                  hex5 <= A;
                  hex4 <= N;
                  hex3 <= OFF;
               end
               
               XOR: begin
                  hex5 <= E;
                  hex4 <= O;
                  hex3 <= OFF;
               end
               
               ADDI: begin
                  hex5 <= A;
                  hex4 <= D;
                  hex3 <= D;
               end
               
               SUBI: begin
                  hex5 <= S;
                  hex4 <= U;
                  hex3 <= B;
               end
               
               ADD: begin
                  hex5 <= A;
                  hex4 <= D;
                  hex3 <= D;
               end
               
               SUB: begin
                  hex5 <= S;
                  hex4 <= U;
                  hex3 <= B;
               end
               
               INC: begin
                  hex5 <= I;
                  hex4 <= N;
                  hex3 <= C;
               end
               
               DEC: begin
                  hex5 <= D;
                  hex4 <= E;
                  hex3 <= C;
               end
               
               CLR: begin
                  hex5 <= C;
                  hex4 <= L;
                  hex3 <= R;
               end
               
               CPI: begin
                  hex5 <= C;
                  hex4 <= P;
                  hex3 <= I;
               end
               
               CP: begin
                  hex5 <= C;
                  hex4 <= P;
                  hex3 <= OFF;
               end
               
               JMP: begin
                  hex5 <= J;
                  hex4 <= M;
                  hex3 <= P;
               end
               
               BREQ: begin
                  hex5 <= B;
                  hex4 <= R;
                  hex3 <= E;
               end
               
               BRNE: begin
                  hex5 <= B;
                  hex4 <= N;
                  hex3 <= E;
               end
               
               BRLE: begin
                  hex5 <= B;
                  hex4 <= L;
                  hex3 <= E;
               end
               
               BRLT: begin
                  hex5 <= B;
                  hex4 <= L;
                  hex3 <= T;
               end
               
               BRGE: begin
                  hex5 <= B;
                  hex4 <= G;
                  hex3 <= E;
               end
               
               BRGT: begin
                  hex5 <= B;
                  hex4 <= G;
                  hex3 <= T;
               end
               
               CALL: begin
                  hex5 <= C;
                  hex4 <= A;
                  hex3 <= L;
               end
               
               RET: begin
                  hex5 <= R;
                  hex4 <= E;
                  hex3 <= T;
               end  
               
               PUSH: begin
                  hex5 <= P;
                  hex4 <= S;
                  hex3 <= H;
               end
               
               POP: begin
                  hex5 <= P;
                  hex4 <= O;
                  hex3 <= P;
               end
               
               default: begin    
                  hex5 <= OFF;
                  hex4 <= OFF;
                  hex3 <= OFF;
               end
            endcase
         end
         else begin
            hex5 <= OFF;
            hex4 <= OFF;
            hex3 <= OFF;
         end
      end
   end 
   
   /***********************************************************************************************
   * DISPLAY_R16: Skriver ut innehållet i CPU-register R16 på 7-segmentsdisplayer hex[1:0]. 
   ***********************************************************************************************/
   always_ff @ (posedge clock or negedge reset_s2_n)
   begin: DISPLAY_R16
      if (!reset_s2_n) begin
         hex1 <= OFF;
         hex0 <= OFF;
      end
      else begin
         if (enable) begin
            hex1 <= get_digit(r16[7:4]);
            hex0 <= get_digit(r16[3:0]);
         end
         else begin
            hex1 <= OFF;
            hex0 <= OFF;
         end
      end
   end
   
   /***********************************************************************************************
   * get_digit: Returnerar binärkoden för en hexadecimal siffra 0 - F utefter ingånde argument
   *            number. Returnerad binärkod kan skrivas till en 7-segmentsdisplay för att visa
   *            motsvarande siffra. Vid fel returneras binärkod för att släcka 7-segmentsdisplayen.
   ***********************************************************************************************/
   function automatic logic[6:0] get_digit (input logic[3:0] number);
      case (number)
         4'h00:   return ZERO;
         4'h01:   return ONE;
         4'h02:   return TWO;
         4'h03:   return THREE;
         4'h04:   return FOUR;
         4'h05:   return FIVE;
         4'h06:   return SIX;
         4'h07:   return SEVEN;
         4'h08:   return EIGHT;
         4'h09:   return NINE;
         4'h0A:   return A;
         4'h0B:   return B;
         4'h0C:   return C;
         4'h0D:   return D;
         4'h0E:   return E;
         4'h0F:   return F;
         default: return OFF;
      endcase
   endfunction 

endmodule
   
`endif /* DISPLAY_SV */
	