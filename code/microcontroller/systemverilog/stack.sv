/**************************************************************************************************
* stack.sv: Implementering av mikrodatorns stack, som möjliggör temporär lagring av data i
*           enlighet med principen LIFO (Last In First Out). Det element som lades till sist
*           tas också ut först. Stacken används exempelvis för lokala variabler samt för lagring
*           av returadressen vid ett funktionsanrop. Vid återhopp hämtas adressen från stacken
*           och tilldelas till programräknaren, så att programmet fortsätter direkt efter den
*           instruktion där funktionsanropet ägde rum. Denna fil inkluderas i paketet def och
*           behöver därmed inte inkluderas specifikt i en given modul ifall detta paket har
*           importerats (vilket görs via direktivet import def::*).
**************************************************************************************************/
`ifndef STACK_SV_
`define STACK_SV_

/* Konstanter: */
localparam SP_MIN  = 8'h00;        /* Lägsta adressen på stacken. */
localparam SP_MAX  = 8'h1F;        /* Högsta adress på stacken. */

/**************************************************************************************************
* stack_t: Implementering av en 8-bitars stack som rymmer 32 element från SP_MIN - SP_MAX.
*          En stackpekare används för att peka på elementet längst upp på stacken, som också tas
*          ut först vid POP-operationer. Vid PUSH-operationer läggs ett nytt element längst upp på
*          stacken och stackpekaren inkrementeras, förutsatt att stacken inte är full.
**************************************************************************************************/
typedef struct packed
{
   logic[SP_MIN:SP_MAX][7:0] data; /* Stackens minnesutrymme, 32 x 8 bitar. */
   logic[7:0] sp;                  /* Stackpekare, pekar på elementet längst upp på stacken. */
} stack_t;

/**************************************************************************************************
* stack_push: Lägger till ett element längst upp på stacken, förutsatt att denna inte är full.
*             Stackpekaren sätts till att peka på elementet längst upp på stacken, vilket innebär
*             inkrementering av stackpekaren varje gång förutom först när stacken är tom, då
*             stackpekaren då pekar längst ned på stacken, där det första elementet placeras.
**************************************************************************************************/
task automatic stack_push(inout stack_t self, input logic[7:0] data);
   if (self.sp >= SP_MAX) begin
      self.sp <= SP_MAX;
   end
   else begin
      if (self.sp <= SP_MIN) begin
         self.data[SP_MIN] <= data;
         self.sp <= SP_MIN;
      end
      else begin
         self.data[self.sp + 1'b1] <= data;
         self.sp <= self.sp + 1'b1;
      end
   end
   return;
endtask

/**************************************************************************************************
* stack_pop: Tar bort ett element ur stacken och lagrar på angiven destination. Förutsatt att
*            stacken inte är tom så dekrementeras också stackpekaren.
**************************************************************************************************/
task automatic stack_pop(inout stack_t self, output logic[7:0] dest);
   dest <= self.data[self.sp];
   if (self.sp > SP_MIN) begin
      self.sp <= self.sp - 1'b1;
   end
   else begin
      self.sp <= SP_MIN;
   end
   return;
endtask

/**************************************************************************************************
* stack_clear: Nollställer stacken och sätter stackpekaren till att peka längst ned på stacken,
*              vilket bör genomföras vid reset.
**************************************************************************************************/
task automatic stack_clear(output stack_t self);
   for (logic[7:0] i = SP_MIN; i <= SP_MAX; ++i) begin
      self.data[i] = 8'b0;
   end
   self.sp = SP_MIN;
   return;
endtask

`endif /* STACK_SV_ */