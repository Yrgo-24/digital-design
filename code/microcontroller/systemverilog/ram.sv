/***********************************************************************************************
* ram.sv: Möjliggör implementering av mikrodatorns RAM-minne, som kan användas för lagring
*         av data vars minne skall kvarstå ett helt program, exempelvis statiska variabler.
***********************************************************************************************/
`ifndef RAM_SV_
`define RAM_SV_

/***********************************************************************************************
* ram: Innehåller funktionalitet för implementering av ett 8-bitars RAM-minne med utrymme för
*      128 element från adress RAM_MIN - RAM_MAX (8'h00 - 8'h79).
***********************************************************************************************/
module ram
(
   input logic clock,         /* 50 MHz systemklocka. */
   input logic reset_s2_n,    /* Synkroniserad inverterad reset-signal. */
   input logic[7:0] address,  /* Adress för läsning/skrivning. */
   input logic[7:0] data_in,  /* Indata för skrivning till RAM-minnet. */
   input logic write_enable,  /* Indikerar ifall skrivning skall genomföras. */
   output logic[7:0] data_out /* Utdata för läsning från RAM-minnet. */
);

   /* Inkluderingsdirektiv: */
   import def::*;

   /* Konstanter: */
   localparam RAM_MIN = 8'h00;       /* Lägsta adress i RAM-minnet. */
   localparam RAM_MAX = 8'h79;       /* Högsta adress i RAM-minnet. */
   
   /* Signaler: */
   logic[RAM_MAX:RAM_MIN][7:0] data; /* 8-bitars RAM-minne med utrymme för 128 element. */
   logic address_in_range;           /* Indikerar ifall angiven adress är korrekt. */
   
   /***********************************************************************************************
   * RAM_WRITE_PROCESS: Skriver angiven indata till RAM-minnet ifall write-signalen är ettställd
   *                    och angiven adress ligger inom intervallet RAM_MIN - RAM_MAX. Däremot vid
   *                    reset så nollställs hela RAM-minnet.
   ***********************************************************************************************/
   always_ff @ (posedge clock or negedge reset_s2_n)
   begin: RAM_WRITE_PROCESS
      if (!reset_s2_n) begin
         for (logic[7:0] i = RAM_MIN; i <= RAM_MAX; ++i) begin
            data[i] <= 8'b0;
         end
      end
      else begin
         if (write_enable & address_in_range) begin
            data[address] <= data_in;
         end
      end
   end
   
   /* Kontinuerliga tilldelningar: */
   assign address_in_range = (address >= RAM_MIN && address <= RAM_MAX)? 1'b1 : 1'b0; 
   assign data_out = address_in_range? data[address] : 8'b0; 

endmodule

`endif /* RAM_SV_ */