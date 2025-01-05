/**************************************************************************************************
* mcu.sv: Innehåller funktionalitet för implementering av en 8-bitars mikrodator med möjlighet
*         att välja mellan att använda en 50 MHz systemklocka eller att generera klockpulser via
*         en tryckknapp. När tryckknappen används som klockkälla visas aktuell OP-kod samt 
*         innehållet i CPU-register R16 på fem 7-segmentsdisplayer.
**************************************************************************************************/
`ifndef MCU_SV_
`define MCU_SV_

/**************************************************************************************************
* mcu: Konstruktionens toppmodul. Övriga moduler, exempelvis för styrenheten samt olika minnen, 
*      implementeras via instansiering från denna modul, antingen direkt eller indirekt via en
*      av de instansierade modulerna. Insignal switch avgör vilken klockkälla som används mellan
*      den 50 MHz systemklockan clock samt manuell klockpulsgenerering via nedtryckning av 
*      tryckknapp key_n, där 0 = clock, 1 = key_n.
**************************************************************************************************/
module mcu
(
   input logic clock,          /* 50 MHz systemklocka. */
   input logic reset_n,        /* Inverterad asynkron reset-signal. */
   input logic key_n,          /* Tryckknapp för generering av klockpulser. */
   input logic switch,         /* Slide-switch för val av klockkälla. */ 
   inout wire[7:0] io_port_b,  /* 8-bitars I/O-port. */
   inout wire[7:0] io_port_c,  /* 8-bitars I/O-port. */
   inout wire[7:0] io_port_d,  /* 8-bitars I/O-port. */
   output logic[6:0] hex5,     /* 7-segmentsdisplay, visar OP-kod. */
   output logic[6:0] hex4,     /* 7-segmentsdisplay, visar OP-kod. */
   output logic[6:0] hex3,     /* 7-segmentsdisplay, visar OP-kod. */
   output logic[6:0] hex1,     /* 7-segmentsdisplay, visar innehållet i CPU-register R16. */
   output logic[6:0] hex0,     /* 7-segmentsdisplay, visar innehållet i CPU-register R16. */
   output logic[7:0] leds      /* Visar programräknarens innehåll vid manuell klockpulsgenerering. */
);

   /* Inkluderingsdirektiv: */
   import def::*;

   /* Signaler: */
   logic reset_s2_n;   /* Synkroniserad inverterad reset-signal. */
   logic switch_s2;    /* Synkroniserad signal från slide-switch för val av klockkälla. */
   logic key_pressed;  /* Indikerar nedtryckning av tryckknapp för ny klockpuls. */
 
   logic[7:0] op_code; /* Lagrar aktuell OP-kod. */
   logic[7:0] r16;     /* Lagrar innehållet i CPU-register R16. */
   logic[7:0] pc;      /* Lagrar den adress som programräknaren pekar på. */
  
   /***********************************************************************************************
   * meta_prev1: Implementering av synkroniserade insignaler i syfte att förebygga metastabilitet.
   ***********************************************************************************************/
   metastability_prevention meta_prev1
   (
      .clock,
      .reset_n,
      .key_n,
      .switch,
      .reset_s2_n,
      .key_pressed,
      .switch_s2
   );
   
   /***********************************************************************************************
   * control_unit1: Implementerar CPU:ns styrenhet, där programminnet, RAM-minnet, I/O-minnet,
   *                ALU:n och stacken implementeras internt. Aktuell OP-kod, innehållet i 
   *                CPU-register R16 samt adressen som programräknaren pekar på passeras för
   *                utskrift via 7-segmentsdisplayer samt lysdioder på FPGA-kortet.
   ***********************************************************************************************/
   control_unit control_unit1
   (
      .clock,
      .reset_s2_n,
      .key_pressed,
      .manual_clock_enabled (switch_s2),
      .io_port_b,
      .io_port_c,
      .io_port_d,
      .op_code_out (op_code),
      .r16_out (r16),
      .pc_out (pc)
   );
   
   /***********************************************************************************************
   * display1: Skriver ut aktuell OP-kod samt innehållet i CPU-register R16 via fem
   *           7-segmentsdisplayer när manuell klockpulsgenerering används.
   ***********************************************************************************************/
   display display1
   (
      .clock,
      .reset_s2_n,
      .enable (switch_s2),
      .op_code,
      .r16,
      .hex5,
      .hex4,
      .hex3,
      .hex1,
      .hex0
   );
   
   /* Kontinuerliga tilldelningar: */
   assign leds = switch_s2? pc : 8'b0;
   
endmodule

`endif /* MCU_SV_ */