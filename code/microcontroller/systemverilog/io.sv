/***********************************************************************************************
* io.sv: Möjliggör implementering av mikrodatorns I/O-minne, som används för läsning och
*        skrivning till mikrodatorns I/O-register, såsom datariktningsregister för val av
*        datariktning eller portregister för att sätta utsignaler.
***********************************************************************************************/
`ifndef IO_SV_
`define IO_SV_

/***********************************************************************************************
* io: Innehåller funktionalitet för läsning samt skrivning till mikrodatorns IO-portar, vilket
*     implementeras via ett 8-bitars I/O-minne med utrymme för nio element, vilket utgörs
*     av I/O-register för de tre I/O-portarna, som innehar var sitt datariktningsregister,
*     portregister (för skrivning) samt pinregister (för läsning). 
***********************************************************************************************/
module io
(
   input logic clock,          /* 50 MHz systemklocka. */
   input logic reset_s2_n,     /* Synkroniserad inverterad reset-signal. */
   input logic[7:0] address,   /* Adress för läsning/skrivning. */
   input logic[7:0] data_in,   /* Indata för skrivning till I/O-minnet. */
   input logic write_enable,   /* Indikerar ifall skrivning skall genomföras. */
   inout logic[7:0] io_port_b, /* 8-bitars I/O-port. */
   inout logic[7:0] io_port_c, /* 8-bitars I/O-port. */
   inout logic[7:0] io_port_d, /* 8-bitars I/O-port. */
   output logic[7:0] data_out  /* Utdata för läsning från I/O-minnet. */
);

   /* Inkluderingsdirektiv: */
   import def::*;
   
   /* Konstanter: */
   localparam IO_MIN  = 8'h00;     /* Lägsta adress i I/O-minnet. */
   localparam IO_MAX  = 8'h08;     /* Högsta adress i I/O-minnet. */
   
   /* Signaler: */
   logic[IO_MAX:IO_MIN][7:0] data; /* 8-bitars I/O-minne med utrymme för nio element. */
   logic address_in_range;         /* Indikerar ifall angiven adress är korrekt. */
   
   /***********************************************************************************************
   * IO_UPDATE_PROCESS: Genomför avläsning av indata till I/O-minnets pinregister. Skriver också
   *                    angiven indata till I/O-minnet ifall write-signalen är ettställd samt 
   *                    angiven adress ligger inom intervallet IO_MIN - IO_MAX. Däremot vid
   *                    reset så nollställs hela I/O-minnet.
   ***********************************************************************************************/
   always_ff @ (posedge clock or negedge reset_s2_n)
   begin: IO_UPDATE_PROCESS
      if (!reset_s2_n) begin
         for (logic[7:0] i = IO_MIN; i <= IO_MAX; ++i) begin
            data[i] <= 8'b0;
         end
      end
      else begin
         data[PINB] <= port_read(io_port_b, data[DDRB], data[PORTB]);
         data[PINC] <= port_read(io_port_c, data[DDRC], data[PORTC]);
         data[PIND] <= port_read(io_port_d, data[DDRD], data[PORTD]);
         if (write_enable && address_in_range) begin
            data[address] <= data_in;
         end
      end
   end
   
   /***********************************************************************************************
   * port_read: Läser av insignaler från aktiverade portar, alltså samtliga portar som har satts
   *            till antingen in- eller utportar via ettställning av motsvarande bit i angivet
   *            datariktningsregister eller portregister. Returnerad data skall tilldelas till
   *            motsvarande pinregister. 
   ***********************************************************************************************/
   function automatic logic[7:0] port_read(input logic[7:0] data_in, ddr, port);
      logic[7:0] data_out;
      for (logic[7:0] i = 0; i < 8; ++i) begin
         if (ddr[i] || port[i]) begin
            data_out[i] = data_in[i];
         end
         else begin
            data_out[i] = 1'bZ;
         end
      end
      return data_out;
   endfunction
   
   /***********************************************************************************************
   * port_write: Uppdaterar utsignalen för samtliga utportar genom att dessa tilldelas från
   *             angivet portregister. För att kontrollera vilka bitar som tillhör en utport
   *             så kontrolleras ifall motsvarande bit i angivet datariktningsregister är 
   *             ettställd. Ifall motsvarande bit är nollställd, så tilldelas en högohmig 
   *             utsignal, vilket medför att motsvarande port enbart fungerar som inport.
   *             Returnerad data skall tilldelas till motsvarande I/O-port.
   ***********************************************************************************************/
   function automatic logic[7:0] port_write(input logic[7:0] ddr, port);
      logic[7:0] data_out;
      for (logic[7:0] i = 0; i < 8; ++i) begin
         if (ddr[i]) begin
            data_out[i] = port[i];
         end
         else begin
            data_out[i] = 1'bZ;
         end
      end
      return data_out;
   endfunction

   /* Kontinuerliga tilldelningar: */
   assign address_in_range = (address >= IO_MIN && address <= IO_MAX)? 1'b1 : 1'b0; 
   assign data_out = address_in_range? data[address] : 8'b0; 
   assign io_port_b = port_write(data[DDRB], data[PORTB]); 
   assign io_port_c = port_write(data[DDRC], data[PORTC]); 
   assign io_port_d = port_write(data[DDRD], data[PORTD]); 
   
endmodule

`endif /* IO_SV_ */
