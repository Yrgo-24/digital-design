/**************************************************************************************************
* rom.sv: Implementering av mikrodatorns programminne, realiserat via ett 24-bitars ROM-minne
*         som rymmer 27 instruktioner. Programkoden sätts samman via konstanter till 24-bitars 
*         instruktioner och lagras på var sin adress i programminnet.
**************************************************************************************************/
`ifndef ROM_SV_
`define ROM_SV_ 

/**************************************************************************************************
* rom: Innehåller funktionalitet för implementering av mikrodatorns programminne, som realiseras
*      i form av en tvådimensionell konstant array. Avläsning sker kontinuerligt från 
*      programminnet förutsatt att angiven adress är giltig, annars sätts utsignalen till noll.
**************************************************************************************************/
module rom
(
   input logic clock,          /* 50 MHz systemklocka. */
   input logic reset_s2_n,     /* Synkroniserad inverterad reset-signal. */
   input logic[7:0] address,   /* Adress för läsning. */
   output logic[23:0] data_out /* Utdata för läsning från ROM-minnet. */
);

   /* Inkluderingsdirektiv: */
   import def::*;
   
   /* Konstanter: */
   localparam ROM_MIN = 8'h00; /* Lägsta adress i programminnet. */
   localparam ROM_MAX = 8'h1A; /* Högsta adress i programminnet. */
   localparam LED = 1;         /* PIN-nummer för lysdiod ansluten till PORTB1. */
   localparam BUTTON = 5;      /* PIN-nummer för tryckknapp ansluten till PORTB5. */
     
   /* Adresser i programminnet: */
   localparam main = 8'h00;                         /* Programmets startpunkt. */
   localparam main_loop = main + 8'h01;             /* Kontinuerlig loop. */
   localparam led_on = main + 8'h05;                /* Tänder lysdioden. */
   localparam led_off = led_on + 8'h04;             /* Släcker lysdioden. */
   localparam init_ports = led_off + 8'h04;         /* Initierar portar som skall användas. */
   localparam button_pressed = init_ports + 8'h05;  /* Indikerar ifall tryckknappen är nedtryckt. */
   localparam return_true = button_pressed + 8'h05; /* Returnerar 1 via CPU-register R24. */
   localparam return_false = return_true + 8'h02;   /* Returnerar 0 via CPU-register R24. */
   
   /***********************************************************************************************
   * data: Programminne implementerad som en tvådimensionell konstant.
   ***********************************************************************************************/
   localparam logic[ROM_MIN:ROM_MAX][23:0] data = 
   {
      /********************************************************************************************
      * main: Initierar I/O-portar. Tänder sedan lysdioden ansluten till PORTB1 vid nedtryckning
      *       av tryckknappen ansluten till PORTB5. Programmet exekverar kontinuerligt så 
      *       länge matningsspänning tillförs.
      ********************************************************************************************/
      assemble(CALL, init_ports),         /* CALL init_ports */
      /* main_loop: */
      assemble(CALL, button_pressed),     /* CALL button_pressed */
      assemble(CPI, R24, 1),              /* CPI R24, 1 */
      assemble(BREQ, led_on),             /* BREQ led_on */
      assemble(JMP, led_off),             /* JMP led_off */
      
      /********************************************************************************************
      * led_on: Tänder lysdioden ansluten till PORTB1.
      ********************************************************************************************/
      assemble(IN, R16, PORTB),           /* IN R16, PORTB */
      assemble(ORI, R16, (1 << LED)),     /* ORI R16, (1 << LED) */
      assemble(OUT, PORTB, R16),          /* OUT PORTB, R16 */
      assemble(JMP, main_loop),           /* JMP main_loop */
      
      /********************************************************************************************
      * led_off: Släcker lysdioden ansluten till PORTB1.
      ********************************************************************************************/
      assemble(IN, R16, PORTB),           /* IN R16, PORTB */
      assemble(ANDI, R16, ~(1 << LED)),   /* ANDI R16, ~(1 << LED) */
      assemble(OUT, PORTB, R16),          /* OUT PORTB, R16 */
      assemble(JMP, main_loop),           /* JMP main_loop */
      
      /********************************************************************************************
      * init_ports: Konfigurerar lysdiodens PIN till utport samt tryckknappens PIN till inport.
      ********************************************************************************************/
      assemble(LDI, R16, (1 << LED)),     /* LDI R16, (1 << LED) */
      assemble(OUT, DDRB, R16),           /* OUT DDRB, R16 */
      assemble(LDI, R16, (1 << BUTTON)),  /* LDI R16, (1 << BUTTON) */
      assemble(OUT, PORTB, R16),          /* OUT PORTB, R16 */
      assemble(RET), /* RET */
      
      /********************************************************************************************
      * button_pressed: Indikerar ifall tryckknappen ansluten till PORTB5 är nedtryckt.
      ********************************************************************************************/
      assemble(IN, R16, PINB),            /* IN R16, PINB */
      assemble(ANDI, R16, (1 << BUTTON)), /* ANDI R16, (1 << BUTTON) */
      assemble(CPI, R16, 0),              /* CPI R16, 1 */
      assemble(BREQ, return_true),        /* BREQ return_true */
      assemble(JMP, return_false),        /* JMP return_false */
      
      /********************************************************************************************
      * return_true: Returnerar heltalet 1 för att indikera att tryckknappen är nedtryckt.
      ********************************************************************************************/
      assemble(LDI, R24, 1),              /* LDI R24, 1 */
      assemble(RET),                      /* RET */
      
      /********************************************************************************************
      * return_false: Returnerar heltalet 0 för att indikera att tryckknappen inte är nedtryckt.
      ********************************************************************************************/
      assemble(LDI, R24, 0),              /* LDI R24, 0 */
      assemble(RET)                       /* RET */   
   };
   
   /* Signaler: */
   logic address_in_range; /* Indikerar ifall angiven adress ligger inom programminnets gränser. */
   
   /***********************************************************************************************
   * ROM_OUTPUT_PROCESS: Läser en instruktion från ROM-minnet ifall angiven adress är korrekt.
   ***********************************************************************************************/
   always_ff @ (posedge clock or negedge reset_s2_n)
   begin: ROM_OUTPUT_PROCESS
      if (!reset_s2_n) begin
         data_out <= 24'b0;
      end
      else begin
         if (address_in_range) begin
            data_out <= data[address];
         end
      end
   end
  
   /***********************************************************************************************
   * assemble: Sätter samman OP-kod samt operander till en 24-bitars instruktion.
   ***********************************************************************************************/
   function automatic logic[23:0] assemble(input logic[7:0] op_code, op1 = 8'b0, op2 = 8'b0);
      return { op_code, op1, op2 };
   endfunction
   
   /* Kontinuerliga tilldelningar: */
   assign address_in_range = (address >= ROM_MIN && address <= ROM_MAX)? 1'b1 : 1'b0; 
   
endmodule

`endif /* ROM_SV_ */