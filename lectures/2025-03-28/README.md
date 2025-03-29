# 2025-03-28 – Lektion 8

## Dagordning
* Klassisk samt modern konstruktion av multiplexers:
   * **a)** För hand med simulering i CircuitVerse
   * **b)** I VHDL med simulering i ModelSim

## Mål med lektionen
* Känna till multiplexerns konstruktion.
* Få mängdträna klassisk digitalteknik samt syntes och simulering i VHDL.

## Instruktioner
* Läs [Bilaga A](#bilaga-a---logik-för-en-liten-multiplexer) nedan för information om konstruktion av en enkel multiplexer i VHDL.
* Se bifogade [övningsuppgifter](./Övningsuppgifter%202025-03-28.pdf), där konstruktion av multiplexers behandlas. 
Lösningsförslag finns [här](Lösningsförslag%20övningsuppgifter%202025-03-28.pdf).
* Lektionsanteckningar finns i underkatalogen [notes](./notes/README.md).

## Utvärdering
* Vad tar ni med er från dagens lektion?

## Nästa lektion
* Konstruktion av adderare för hand samt i VHDL.
* Om tid finns, påbörjande av system med 7-segmentsdisplayer.

## Bilaga A - Logik för en liten multiplexer

### Case-satsen i VHDL
För att implementera logiken för multiplexern kan vi använda en så kallad case-sats, vilket motsvarar
switch-satsen i C.\
Switch-satsen i C har följande syntax för en multiplexer med insignaler `a` och `b`, selektorsignal `sel`
samt utsignal `x`:

```c
switch (sel)
{
   case 0:
       x = b;
   case 1:
       x = a;
   default:
       x = 0;
}
```

Motsvarande case-sats i VHDL har följande syntax:

```vhdl
case (sel) is
    when '0'    => x <= b;
    when '1'    => x <= a;
    when others => x <= '0';
end case; 
```

***Notering**: Apostrofer används runt enskilda bitar i VHDL, så '0' innebär en bit som är lika med 0.*

Case-satsen måste placeras i ett sekventiellt block, vilket kallas `process` i VHDL. Processer har tidigare
presenterats [här](./../2025-02-28/README.md#process).

Nedan visas case-satsen placerad i en process, som aktiveras för förändring av `a`, `b` och `sel`.\
Om värdet på någon av dessa portar ändras kommer då följande block att exekvera:

```vhdl
process(ab, sel) is
begin
   case (sel) is
      when '0'    => x <= b;
      when '1'    => x <= a;
      when others => x <= '0';
   end case; 
end process;
```

### Konstruktion med case-satsen
Funktionaliteten för en liten 1-bitars multiplexer hade kunnat realiseras via en entity döpt `small_mux` såsom visas nedan:

```vhdl
entity small_mux is
    port(ab: in std_logic_vector(1 downto 0);
         sel: in std_logic;
         x: out std_logic);
end entity;
```

Modulen i fråga har följande portar:
* `ab[1:0]` utgörs av multiplexerns två insignaler `a` och `b` sammansatt till en 2-bitars vektor.
* `sel` utgör en selektorsignal, som avgör vilket av insignalerna som skrivs till utporten `x`.
* `x` utgör mutliplexerns utsignal.

Notera att signalen `ab` är en 2-bitars vektor som motsvarar tidigare signaler `a` samt `b`:
* För att indikerar att detta är en 2-bitars vektor skriver man ofta `ab[1:0]`, där `1:0` utläses som 
`1 down to 0` och indikerar mest respektive minst signifikant bit.
* Den mest signifikanta biten av `ab[1:0]`, vilket är `ab[1]`, utgörs av `a`.
* Den minst signifikanta biten av `ab[1:0]`, vilket är `ab[0]`, utgörs av `b`.

I modulens arkitektur realiserar vi logiken för multiplexern via en case-sats, som placeras i en `process` döpt `MUX_PROCESS`.\
Processen i fråga exekverar vid förändring av någon av insignaler `ab` och `sel`, vilket implementeras genom 
att deklarera dessa portar i den så kallade känslighetslistan\
(innehållet i parentesen efter nyckelordet `process`):

```vhdl
architecture behaviour of small_mux is
begin
    MUX_PROCESS: process(ab, sel) is
    begin
        case (sel) is
            when '0'    => x <= ab(0);
            when '1'    => x <= ab(1);
            when others => x <= '0';
        end case;
    end process;
end architecture;
```

Via case-satsen ovan sätts utsignal `x` till:
   * `ab[0]` när `sel` = 0, 
   * `ab[1]` när `sel` = 1, 
   * 0 för övriga fall (om något går fel exempelvis).  

***Notering**: Det är valfritt att döpa processer, så `MUX_PROCESS:` ovan kan slopas.*