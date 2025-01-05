/**************************************************************************************************
* rw_memory_sv: Innehåller funktionalitet för att lagra adress samt data för skrivning till ett
*               läs- och skrivbart minne, även kallat RW-minne (Read/Write), implementerat via
*               strukten rw_memory samt tillhörande tasks. Denna fil inkluderas i paketet def
*               och behöver därmed inte inkluderas specifikt i en given modul ifall detta paket
*               har importerats (vilket görs via direktivet import def::*).
**************************************************************************************************/
`ifndef RW_MEMORY_SV_
`define RW_MEMORY_SV_

/**************************************************************************************************
* rw_memory_t: Adress- och dataregister för lagring av adress samt data vid skrivning/läsning.
*              En enable-signal används för kontrollera när skrivning skall ske. Eftersom struktar
*              enbart fungerar väl när datariktningen för samtliga medlemmar är samma så 
*              deklareras enbart medlemmar som utgör inportar till RW-minnet i fråga. Annars kan 
*              problem uppstå uppstå med att skrivning samt läsning från RW-minnet sker 
*              parallellt till medlemmarna. En signal för att ta emot data från RW-minnet 
*              behöver därmed deklareras separat.
**************************************************************************************************/
typedef struct packed
{
   logic[7:0] address; /* Lagrar adress som läsning/skrivning skall ske till/från. */
   logic[7:0] data_in; /* Lagrar data vid skrivning till RW-minnet. */
   logic write_enable; /* Indikerar ifall skrivning skall ske. */
} rw_memory_t;

/**************************************************************************************************
* rw_memory_write: Genomför skrivning från ett CPU-register till angivet RW-minne.
**************************************************************************************************/
task automatic rw_memory_write(output rw_memory_t self, input logic[7:0] addr, data_in);
   self.address <= addr;
   self.data_in <= data_in;
   self.write_enable <= 1'b1;
   return;
endtask

/**************************************************************************************************
* rw_memory_read: Genomför läsning från angivet RW-minnet till ett CPU-register. Ingående argument
*                 data_out tar emot data avläst från RW-minnet i fråga, vilket sedan tilldelas 
*                 till destinationsadressen.
**************************************************************************************************/
task automatic rw_memory_read(inout rw_memory_t self, output logic[7:0] dest, 
                              input logic[7:0] addr, data_out);
   self.address <= addr;
   self.write_enable <= 1'b0;
   dest <= data_out;
   return;
endtask

`endif /* RW_MEMORY_SV_ */