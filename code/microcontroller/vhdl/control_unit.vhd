---------------------------------------------------------------------------------------------------
-- control_unit.vhd: Möjliggör implementering av mikrodatorns styrenhet, med inbyggt RAM-minne,
--                   programminne, I/O-minne, stack samt ALU.
---------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.def.all;
use work.stack.all;
use work.rw_memory.all;

---------------------------------------------------------------------------------------------------
-- control_unit: Innehåller funktionalitet för implementering av mikrodatorns styrenhet, där
--               klockkällan kan väljas mellan en 50 MHz systemklocka eller via manuell
--               klockpulsgenerering via en tryckknapp. Programminnet (ROM-minnet), RAM-minnet 
--               samt I/O-minnet bäddas in i styrenheten genom att instansieras i denna modul.
---------------------------------------------------------------------------------------------------
entity control_unit is
   port
   (
      clock                : in std_logic;                       -- 50 MHz systemklocka.
      reset_s2_n           : in std_logic;                       -- Synkroniserad inverterad reset-signal.
      key_pressed          : in std_logic;                       -- Tryckknapp för manuell klockpulsgenerering.
      manual_clock_enabled : in std_logic;                       -- Slide-switch för val av klockkälla.
      io_port_b            : inout std_logic_vector(7 downto 0); -- 8-bitars I/O-port.
      io_port_c            : inout std_logic_vector(7 downto 0); -- 8-bitars I/O-port.
      io_port_d            : inout std_logic_vector(7 downto 0); -- 8-bitars I/O-port.
      op_code_out          : out std_logic_vector(7 downto 0);   -- Aktuell OP-kod.
      pc_out               : out std_logic_vector(7 downto 0);   -- Adress som programräknaren pekar på.
      r16_out              : out std_logic_vector(7 downto 0)    -- Innehållet i CPU-register R16.
   );
end entity;

architecture behaviour of control_unit is

---------------------------------------------------------------------------------------------------
-- cpu_reg_t: Array för implementering av CPU-register R0 - R31.
---------------------------------------------------------------------------------------------------
type cpu_reg_t is array(0 to 31) of std_logic_vector(7 downto 0);

-- Signaler för OP-kod samt operander: 
signal op_code   : std_logic_vector(7 downto 0);  -- Lagringsregister för aktuell OP-kod. 
signal op1       : uint8_t;                       -- Lagringsregister för eventuell första operand.
signal op2       : uint8_t;                       -- Lagringsregister för eventuell andra operand.
 
-- Signaler för diverse register i styrenheten: 
signal ir        : std_logic_vector(23 downto 0); -- Instruktionsregister, lagrar aktuell instruktion.
signal pc        : uint8_t;                       -- Programräknare, pekar på adressen till nästa instruktion.
signal sr        : std_logic_vector(3 downto 0);  -- Statusregister, lagrar tillståndsbitar NZVC.
signal cpu       : cpu_reg_t;                     -- CPU-register R0 - R31.
signal stk       : stack_t;                       -- Stacksegment samt stackpekare.

signal state     : cpu_state_t;                   -- CPU:ns aktuella tillstånd i instruktionscykeln.
signal run_state : std_logic;                     -- Indikerar ifall nästa tillstånd skall utföras.

signal comp_res  : std_logic_vector(7 downto 0);  -- Resultat från ALU vid jämförelse (CPI eller CP).
signal equal     : std_logic;                     -- Indikerar op1 == op2 vid senaste jämförelse.
signal greater   : std_logic;                     -- Indikerar op1 > op2 vid senaste jämförelse.
signal lower     : std_logic;                     -- Indikerar op1 < op2 vid senaste jämförelse.

signal ram1      : rw_memory_t;                   -- Signaler för skrivning/läsning till RAM-minnet.
signal io1       : rw_memory_t;                   -- Signaler för skrivning/läsning till I/O-minnet.

begin

   ------------------------------------------------------------------------------------------------
   -- RUN_STATE_PROCESS: Indikerar ifall nästa tillstånd skall utföras, vilket antingen sker via
   --                    nedtryckning av en tryckknapp ifall manuell klockstyrning är aktiverat
   --                    eller vid klockpuls på den 50 MHz systemklockan (ifall manuell
   --                    klockstyrning är inaktiverat).
   ------------------------------------------------------------------------------------------------
   RUN_STATE_PROCESS: process(clock, reset_s2_n) is
   begin
      if (reset_s2_n = '0') then
         run_state <= '0';
      elsif (rising_edge(clock)) then
         if (manual_clock_enabled = '1') then
            run_state <= key_pressed;
         else
            run_state <= '1';
         end if;
      end if;
   end process;

   ------------------------------------------------------------------------------------------------
   -- CPU_STATE_PROCESS: Implementerar CPU:ns instruktionscykel, där en given instruktion hämtas
   --                    från programminnet, delas upp i en OP-kod samt två operander och
   --                    slutligen utförs. Därefter startar instruktionscykeln om och nästa
   --                    instruktion hämtas från programminnet. Adressen som programräknaren
   --                    pekar på avgör vilken instruktion som hämtas från programminnet. 
   --                    Efter att en given instruktion har hämtats så inkrementeras därmed
   --                    programräknaren för att nästa instruktion skall hämtas nästa cykel.
   --                    Vid reset nollställs adressen som programräknaren pekar på för att
   --                    att starta om programmet från början.
   ------------------------------------------------------------------------------------------------
   CPU_STATE_PROCESS: process(clock, reset_s2_n) is
   begin
      if (reset_s2_n = '0') then
         pc <= 0;
         sr <= (others => '0');
         for i in R0 to R31 loop
            cpu(i) <= (others => '0');
         end loop;
         stack_clear(stk);
         state <= CPU_STATE_FETCH;
         ram1.write_enable <= '0';
         io1.write_enable <= '0';
      elsif (rising_edge(clock)) then
         if (run_state = '1') then
            case (state) is
               when CPU_STATE_FETCH =>
                  ram1.write_enable <= '0';
                  io1.write_enable <= '0';
                  state <= CPU_STATE_DECODE;
               when CPU_STATE_DECODE =>
                  op_code <= ir(23 downto 16);
                  op1     <= uint8(ir(15 downto 8));
                  op2     <= uint8(ir(7 downto 0));
                  pc <= pc + 1;
                  state <= CPU_STATE_EXECUTE;
               when CPU_STATE_EXECUTE =>
                  case (op_code) is
                     when NOP    => null;
                     when LDI    => cpu(op1) <= uint8_vector(op2);
                     when MOV    => cpu(op1) <= cpu(op2);
                     when OUTD   => rw_memory_write(io1, uint8_vector(op1), cpu(op2));
                     when IND    => rw_memory_read(io1, cpu(op1), uint8_vector(op2));
                     when STS    => rw_memory_write(ram1, uint8_vector(op1), cpu(op2));
                     when LDS    => rw_memory_read(ram1, cpu(op1), uint8_vector(op2));
                     when ORI    => alu(op_code, cpu(op1), uint8_vector(op2), cpu(op1), sr);
                     when ANDI   => alu(op_code, cpu(op1), uint8_vector(op2), cpu(op1), sr);
                     when XORI   => alu(op_code, cpu(op1), uint8_vector(op2), cpu(op1), sr);
                     when ORD    => alu(op_code, cpu(op1), cpu(op2), cpu(op1), sr);
                     when ANDD   => alu(op_code, cpu(op1), cpu(op2), cpu(op1), sr);
                     when XORD   => alu(op_code, cpu(op1), cpu(op2), cpu(op1), sr);
                     when ADDI   => alu(op_code, cpu(op1), uint8_vector(op2), cpu(op1), sr);
                     when SUBI   => alu(op_code, cpu(op1), uint8_vector(op2), cpu(op1), sr);
                     when ADD    => alu(op_code, cpu(op1), cpu(op2), cpu(op1), sr);
                     when SUBD   => alu(op_code, cpu(op1), cpu(op2), cpu(op1), sr);
                     when INC    => alu(op_code, cpu(op1), uint8_vector(1), cpu(op1), sr);
                     when DEC    => alu(op_code, cpu(op1), uint8_vector(1), cpu(op1), sr);
                     when CPI    => alu(op_code, cpu(op1), uint8_vector(op2), comp_res, sr);
                     when CP     => alu(op_code, cpu(op1), cpu(op2), comp_res, sr);
                     when JMP    => pc <= op1;
                     when BREQ   => if (equal = '1') then pc <= op1; end if;
                     when BRNE   => if (equal = '0') then pc <= op1; end if;
                     when BRGE   => if (greater = '1' or equal = '1') then pc <= op1; end if;
                     when BRGT   => if (greater = '1') then pc <= op1; end if;
                     when BRLE   => if (lower = '1' or equal = '1') then pc <= op1; end if;
                     when BRLT   => if (lower = '1') then pc <= op1; end if;
                     when CALL   => stack_push(stk, pc); pc <= op1;
                     when RET    => stack_pop(stk, pc);
                     when PUSH   => stack_push(stk, cpu(op1));
                     when POP    => stack_pop(stk, cpu(op1));                    
                     when others => null;
                  end case;
                  state <= CPU_STATE_FETCH;
               when others => 
                  state <= CPU_STATE_FETCH;
            end case;
         end if;
      end if;
   end process;
   
   ------------------------------------------------------------------------------------------------
   -- ram_instance1: Implementerar mikrodatorns RAM-minne och ansluter till signaler i denna modul.
   ------------------------------------------------------------------------------------------------
   ram_instance1: ram port map
   (
      clock        => clock,
      reset_s2_n   => reset_s2_n,
      address      => ram1.address,
      data_in      => ram1.data_in,
      write_enable => ram1.write_enable, 
      data_out     => ram1.data_out
   );
   
   ------------------------------------------------------------------------------------------------
   -- io_instance1: Implementerar mikrodatorns I/O-minne och ansluter till signaler i denna modul.
   ------------------------------------------------------------------------------------------------
   io_instance1: io port map
   (
      clock        => clock,
      reset_s2_n   => reset_s2_n,
      address      => io1.address,
      data_in      => io1.data_in,
      write_enable => io1.write_enable,
      io_port_b    => io_port_b,
      io_port_c    => io_port_c,
      io_port_d    => io_port_d,
      data_out     => io1.data_out
   );
   
   ------------------------------------------------------------------------------------------------
   -- rom_instance1: Implementerar mikrodatorns programminne, där den adress som programräknaren
   --                pekar på kontinuerligt används för att läsa in en instruktion, som hämtas
   --                till instruktionsregistret.
   ------------------------------------------------------------------------------------------------
   rom_instance1: rom port map
   (
      clock      => clock,
      reset_s2_n => reset_s2_n,
      address    => uint8_vector(pc),
      data_out   => ir
   );

   -- Kontinuerliga tilldelningar:
   op_code_out <= op_code;
   pc_out <= uint8_vector(pc);
   r16_out <= cpu(R16);
   
   ------------------------------------------------------------------------------------------------
   -- För equal (op1 == op2) så måste Z-flaggan sr(2) vara ettställd.
   -- För greater (op1 > op2) så måste både N- och Z-flaggan sr(3 downto 2) vara nollställda.
   -- För lower (op1 < op2) så måste N-flaggan sr(3) vara ettställd.
   ------------------------------------------------------------------------------------------------
   equal <= sr(2);
   greater <= not sr(3) and not sr(2);
   lower <= sr(3);

end architecture;