/***********************************************************************************************
* control_unit.sv: Möjliggör implementering av mikrodatorns styrenhet, med inbyggt RAM-minne,
*                  programminne, I/O-minne, stack samt ALU.
***********************************************************************************************/
`ifndef CONTROL_UNIT_SV_
`define CONTROL_UNIT_SV_

/***********************************************************************************************
* control_unit: Innehåller funktionalitet för implementering av mikrodatorns styrenhet, där
*               klockkällan kan väljas mellan en 50 MHz systemklocka eller via manuell
*               klockpulsgenerering via en tryckknapp. Programminnet (ROM-minnet), RAM-minnet 
*               samt I/O-minnet bäddas in i styrenheten genom att instansieras i denna modul.
***********************************************************************************************/
module control_unit
(
   input logic clock,                /* 50 MHz systemklocka. */
   input logic reset_s2_n,           /* Synkroniserad inverterad reset-signal. */
   input logic key_pressed,          /* Tryckknapp för manuell klockpulsgenerering. */
   input logic manual_clock_enabled, /* Synkroniserad signal från slide-switch för val av klockkälla. */
   inout wire[7:0] io_port_b,        /* 8-bitars I/O-port. */
   inout wire[7:0] io_port_c,        /* 8-bitars I/O-port. */
   inout wire[7:0] io_port_d,        /* 8-bitars I/O-port. */
   output logic[7:0] op_code_out,    /* Aktuell OP-kod. */
   output logic[7:0] r16_out,        /* Innehållet i CPU-register R16. */
   output logic[7:0] pc_out          /* Adressen som programräknaren pekar på. */
);

   /* Inkluderingsdirektiv: */
   import def::*;
   
   /* Signaler för OP-kod samt operander: */
   logic[7:0] op_code;   /* Lagringsregister för aktuell OP-kod. */
   logic[7:0] op1;       /* Lagringsregister för eventuell första operand. */
   logic[7:0] op2;       /* Lagringsregister för eventuell andra operand. */
 
   /* Signaler för diverse register i styrenheten: */
   logic[23:0] ir;       /* Instruktionsregister, lagrar aktuell instruktion som skall exekveras. */
   logic[7:0] pc;        /* Programräknaren, lagrar adressen till nästa instruktion som skall hämtas. */
   logic[3:0] sr;        /* Statusregister, lagrar tillståndsbitar NZVC. */
   logic[7:0] cpu[31:0]; /* CPU-register R0 - R31. */
   stack_t stk;          /* Stacksegment samt stackpekare. */
  
   /* Signaler för tillstånd i CPU:ns instruktionscykel: */
   cpu_state_t state;    /* Aktuellt tillstånd i CPU:ns instruktionscykel. */
   logic run_state;      /* Indikerar ifall aktuellt tillstånd skall utföras. */
  
   /* Signaler för jämförelse-operationer: */
   logic equal;          /* Indikerar ifall operand 1 var lika med operand 2 vid senaste jämförelse. */
   logic greater;        /* Indikerar ifall operand 1 var större än operand 2 vid senaste jämförelse. */
   logic lower;          /* Indikerar ifall operand 1 var mindre än operand 2 vid senaste jämförelse. */
  
   /* Signaler för skrivning/läsning till läs- och skrivbara minnen: */
   rw_memory_t ram1;     /* Signaler för skrivning/läsning till RAM-minnet. */
   rw_memory_t io1;      /* Signaler för skrivning/läsning till I/O-minnet. */ 
   logic[7:0] ram1_out;  /* Tar emot utdata från RAM-minnet. */
   logic[7:0] io1_out;   /* Tar emot utdata från I/O-minnet. */

   /***********************************************************************************************
   * RUN_STATE_PROCESS: Indikerar ifall nästa tillstånd skall utföras, vilket antingen sker via
   *                    nedtryckning av en tryckknapp ifall manuell klockstyrning är aktiverat
   *                    eller vid klockpuls på den 50 MHz systemklockan (ifall manuell
   *                    klockstyrning är inaktiverat).
   ***********************************************************************************************/
   always_ff @ (posedge clock or negedge reset_s2_n)
   begin: RUN_STATE_PROCESS
      if (!reset_s2_n) begin
         run_state <= 1'b0;
      end
      else begin
         if (manual_clock_enabled) begin
            run_state <= key_pressed;
         end
         else begin
            run_state <= 1'b1;
         end
      end
   end
   
   /***********************************************************************************************
   * CPU_STATE_PROCESS: Implementerar CPU:ns instruktionscykel, där en given instruktion hämtas
   *                    från programminnet, delas upp i en OP-kod samt två operander och
   *                    slutligen utförs. Därefter startar instruktionscykeln om och nästa
   *                    instruktion hämtas från programminnet. Adressen som programräknaren
   *                    pekar på avgör vilken instruktion som hämtas från programminnet. 
   *                    Efter att en given instruktion har hämtats så inkrementeras därmed
   *                    programräknaren för att nästa instruktion skall hämtas nästa cykel.
   *                    Vid reset nollställs adressen som programräknaren pekar på för att
   *                    att starta om programmet från början.
   ***********************************************************************************************/
   always_ff @ (posedge clock or negedge reset_s2_n)
   begin: CPU_STATE_PROCESS
      if (!reset_s2_n) begin
         state <= CPU_STATE_FETCH;
         op_code <= 7'b0;
         op1 <= 7'b0;
         op2 <= 7'b0;
         pc  <= 7'b0;
         ram1.write_enable <= 1'b0;
         io1.write_enable <= 1'b0;
         stack_clear(stk);       
         for (logic[7:0] i = R0; i <= R31; ++i) begin
            cpu[i] <= 8'b0;
         end
      end
      else begin
         if (run_state) begin
            case (state)   
            
               CPU_STATE_FETCH: begin
                  ram1.write_enable <= 1'b0;
                  io1.write_enable <= 1'b0;
                  state <= CPU_STATE_DECODE;
               end
               
               CPU_STATE_DECODE: begin
                  op_code <= ir[23:16];
                  op1 <= ir[15:8];
                  op2 <= ir[7:0];
                  pc <= pc + 1'b1;
                  state <= CPU_STATE_EXECUTE;
               end
               
               CPU_STATE_EXECUTE: begin
                  case (op_code)
                     NOP:  ;
                     LDI:  cpu[op1] <= op2;
                     MOV:  cpu[op1] <= cpu[op2];
                     OUT:  rw_memory_write(io1, op1, cpu[op2]);
                     IN:   rw_memory_read(io1, cpu[op1], op2, io1_out);
                     STS:  rw_memory_write(ram1, op1, cpu[op2]); 
                     LDS:  rw_memory_read(ram1, cpu[op1], op2, ram1_out);
                     ORI:  cpu[op1] <= alu(op_code, cpu[op1], op2, sr);
                     ANDI: cpu[op1] <= alu(op_code, cpu[op1], op2, sr);
                     XORI: cpu[op1] <= alu(op_code, cpu[op1], op2, sr);
                     OR:   cpu[op1] <= alu(op_code, cpu[op1], cpu[op2], sr);
                     AND:  cpu[op1] <= alu(op_code, cpu[op1], cpu[op2], sr);
                     XOR:  cpu[op1] <= alu(op_code, cpu[op1], cpu[op2], sr);
                     CLR:  cpu[op1] <= 8'b0;
                     ADDI: cpu[op1] <= alu(op_code, cpu[op1], op2, sr);
                     SUBI: cpu[op1] <= alu(op_code, cpu[op1], op2, sr);
                     ADD:  cpu[op1] <= alu(op_code, cpu[op1], cpu[op2], sr);
                     SUB:  cpu[op1] <= alu(op_code, cpu[op1], cpu[op2], sr);
                     INC:  cpu[op1] <= alu(op_code, cpu[op1], 0, sr);
                     DEC:  cpu[op1] <= alu(op_code, cpu[op1], 0, sr);
                     CPI:  compare(op_code, cpu[op1], op2, sr);
                     CP:   compare(op_code, cpu[op1], cpu[op2], sr);
                     JMP:  pc <= op1;
                     BREQ: if (equal) pc <= op1;
                     BRNE: if (!equal) pc <= op1;
                     BRGE: if (greater | equal) pc <= op1;
                     BRGT: if (greater) pc <= op1;
                     BRLE: if (lower | equal) pc <= op1;
                     BRLT: if (lower) pc <= op1;
                     CALL: begin stack_push(stk, pc); pc <= op1; end
                     RET:  stack_pop(stk, pc);
                     PUSH: stack_push(stk, cpu[op1]);
                     POP:  stack_pop(stk, cpu[op1]);
                     default: ;                    
                  endcase
                  state <= CPU_STATE_FETCH;
               end
               default: state <= CPU_STATE_FETCH;
            endcase
         end
      end
   end
   
   /***********************************************************************************************
   * ram_instance1: Implementerar mikrodatorns RAM-minne och ansluter till signaler i denna modul.
   ***********************************************************************************************/
   ram ram_instance1
   (
      .clock,
      .reset_s2_n,
      .address (ram1.address),
      .data_in (ram1.data_in),
      .write_enable (ram1.write_enable),
      .data_out (ram1_out)
   );
   
   /***********************************************************************************************
   * io_instance1: Implementerar mikrodatorns I/O-minne och ansluter till signaler i denna modul.
   ***********************************************************************************************/
   io io_instance1
   (
      .clock,
      .reset_s2_n,
      .address (io1.address),
      .data_in (io1.data_in),
      .write_enable (io1.write_enable),
      .io_port_b,
      .io_port_c,
      .io_port_d,
      .data_out (io1_out)
   );
   
   /***********************************************************************************************
   * rom_instance1: Implementerar mikrodatorns programminne, där den adress som programräknaren
   *                pekar på kontinuerligt används för att läsa in en instruktion, som hämtas
   *                till instruktionsregistret.
   ***********************************************************************************************/
   rom rom_instance1
   (
      .clock,
      .reset_s2_n,
      .address (pc),
      .data_out (ir)
   );
 
   /* Kontinuerliga tilldelningar: */
   assign pc_out = pc; 
   assign op_code_out = op_code; 
   assign r16_out = cpu[R16]; 
   
   /***********************************************************************************************
   * För equal (op1 == op2) så måste Z-flaggan (sr[2]) vara ettställd.
   * För greater (op1 > op2) så måste både N- och Z-flaggan (sr[3:2]) vara nollställda.
   * För lower (op1 < op2) så måste N-flaggan (sr[3]) vara ettställd.
   ***********************************************************************************************/
   assign equal = sr[2]; 
   assign greater = !sr[3] & !sr[2]; 
   assign lower = sr[3]; 
   
endmodule

`endif /* CONTROL_UNIT_SV_ */