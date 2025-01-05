/***********************************************************************************************
* metastability_prevention.sv: Synkroniserar mikrokontrollerns insignaler två klockpulser
*                              för att förebygga metastabilitet.
***********************************************************************************************/
`ifndef METASTABILITY_PREVENTION_SV_
`define METASTABILITY_PREVENTION_SV_

/***********************************************************************************************
* metastability_prevention: Innehåller funktionalitet för att implemenetera synkroniserade
*                           insignaler som fördröjs två klockpulser i syfte att förebygga
*                           metastabilitet. Reset sker dock asynkront och då fördröjs inte
*                           de synkroniserade signalerna.
***********************************************************************************************/
module metastability_prevention
(
   input logic clock,        /* 50 MHz systemklocka. */
   input logic reset_n,      /* Inverterad asynkron reset-signal. */
   input logic key_n,        /* Insignal från inverterad tryckknapp. */
   input logic switch,       /* Insignal från slide-switch. */
   output logic reset_s2_n,  /* Synkroniserad inverterad reset-signal. */
   output logic key_pressed, /* Indikerar nedtryckning av tryckknappen (fallande flank). */
   output logic switch_s2    /* Synkroniserad signal från slide-switch. */
);

   /* Synkroniserande signaler: */
   logic reset_s1_n; 
   logic key_s1_n, key_s2_n, key_s3_n; 
   logic switch_s1; 
   
   /***********************************************************************************************
   * RESET_PROCESS: Synkroniserar reset-signalerna, där reset_s2_n i normalfallet tilldelas 
   *                värdet av insignal reset_n två klockcykler tidigare. Däremot vid reset
   *                nollställs samtliga reset-signaler direkt.
   ***********************************************************************************************/
   always_ff @ (posedge clock or negedge reset_n)
   begin: RESET_PROCESS
      if (!reset_n) begin
         reset_s1_n <= 1'b0;
         reset_s2_n <= 1'b0;
      end
      else begin
         reset_s1_n <= reset_n;
         reset_s2_n <= reset_s1_n;
      end
   end
   
   /***********************************************************************************************
   * KEY_PROCESS: Synkroniserar key-signalerna, där key_s3_n i normalfallet tilldelas värdet av
   *              insignal key_n tre klockcykler tidigare. Att tre signaler används
   *              i detta fall beror på att flankdetektering skall genomföras på tryckknappen
   *              som key_n är ansluten till, vilket genomförs via synkroniserade signaler
   *              key_s2_n samt key_s3_n. Däremot vid reset ettställs samtliga signaler direkt.
   ***********************************************************************************************/
   always_ff @ (posedge clock or negedge reset_s2_n)
   begin: KEY_PROCESS
      if (!reset_s2_n) begin
         key_s1_n <= 1'b1;
         key_s2_n <= 1'b1;
         key_s3_n <= 1'b1;
      end
      else begin
         key_s1_n <= key_n;
         key_s2_n <= key_s1_n;
         key_s3_n <= key_s2_n;
      end
   end
   
   /***********************************************************************************************
   * SWITCH_PROCESS: Synkroniserar switch-signalerna, där switch_s2 i normalfallet tilldelas det 
   *                 värde som insignal switch hade två klockcykler tidigare. Däremot vid reset 
   *                 så nollställs samtliga signaler direkt.
   ***********************************************************************************************/
   always_ff @ (posedge clock or negedge reset_s2_n)
   begin: SWITCH_PROCESS
      if (!reset_s2_n) begin
         switch_s1 <= 1'b0;
         switch_s2 <= 1'b0;
      end
      else begin
         switch_s1 <= switch;
         switch_s2 <= switch_s1;
      end
   end
   
   /***********************************************************************************************
   * KEY_EVENT_PROCESS: Indikerar event på fallande flank gällande tryckknappen key_n, vilket 
   *                    sker när tryckknappen övergår från icke nedtryckt till nedtryckt. För
   *                    att detektera eventet så jämförs två synkroniserade signaler key_s2_n
   *                    samt key_s3_n, där key_s3_n är en klockpuls äldre än key_s2_n. Ifall
   *                    key_s3_n är hög och key_s2_n är låg, så var tryckknappen inte nedtryckt
   *                    tre klockcykler sedan, men blev sedan nedtryckt två klockcykler sedan.
   *                    Då har fallande flank på tryckknappens insignal ägt rum, vilket indikeras
   *                    genom att signal key_pressed ettställs, annars hålls denna nollställd.
   ***********************************************************************************************/
   always_ff @ (posedge clock or negedge reset_s2_n)
   begin: KEY_EVENT_PROCESS
      if (!reset_s2_n) begin
         key_pressed <= 1'b0;
      end
      else begin
         if (!key_s2_n & key_s3_n) begin
            key_pressed <= 1'b1;
         end
         else begin
            key_pressed <= 1'b0;
         end
      end
   end

endmodule

`endif /* METASTABILITY_PREVENTION_SV_ */