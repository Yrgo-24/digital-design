# 2025-05-23 – Lektion 16

## Dagordning
* Skapande av tillståndsgrafer.
* Konstruktion av tillståndsmaskiner i VHDL.

## Mål med lektionen
* Kunna rita tillståndsgrafer för enklare tillståndsmaskiner för hand.
* Kunna konstruera tillståndsmaskiner i VHDL.

## Instruktioner
* Läs [Bilaga A – Introduktion till tillståndsmaskiner i VHDL](#bilaga-a---introduktion-till-tillståndsmaskiner-i-vhdl) nedan för
grundläggande information om tillståndsmaskiner i VHDL.
* Ladda ned, öppna och kompilera bifogad .qar-fil [fsm.qar](fsm.qar). Denna fil innehåller skelettkod
för ett projekt döpt `fsm` (`Finite State Machine`).\
En tillståndsmaskin ska läggas till i detta projekt under lektionens gång.
* Se bifogade [övningsuppgifter](./Övningsuppgifter%202025-05-23.pdf). Lösningsförslag finns [här](./notes/README.md).

## Utvärdering
* Några synpunkter om dagens föreläsning?

## Nästa lektion
* Arbete med Inlämningsuppgift VI – Konstruktion av timerkretsar eller en digital klocka.

## Bilaga A - Introduktion till tillståndsmaskiner i VHDL

En tillståndsmaskin, ofta förkortat `FSM` *(Finite State Machine)* är en algoritm som används för att implementera logik
innefattande multipla tillstånd. Som exempel, en tillståndsmaskin hade kunnat användas för att styra en lysdiod via tre tillstånd:
* `STATE_OFF`: Lysdioden är släckt.
* `STATE_BLINK`: Lysdioden blinkar var med en viss frekvens.
* `STATE_ON`: Lysdioden är tänd.

För att modellera tillståndsmaskinens olika tillstånd används ofta en enumererad typ i VHDL. Som exempel, ovanstående
tillstånd kan realiseras via en egenskapad typ döpt `state_t` så som visas nedan:

```vhdl
type state_t is (STATE_OFF, STATE_BLINK, STATE_ON);
```

Därefter används en signal av denna typ för att hålla aktuellt tillstånd. En sådan signal kan döpas till
exempelvis `state` eller `current_state`. Nedan implementeras en signal av typen `state_t` döpt state:

```vhdl
signal state: state_t;
```

Denna signal kan därefter tilldelas ett tillstånd, exempelvis `STATE_ON`, via en tilldelning:

```vhdl
state <= STATE_ON;
```

Oftast implementeras tillståndsmaskinens beteende via en case-sats, såsom visas i exemplet nedan.
Signaler `to_next_state` samt `to_prev_state` kan antas ha implementerats på så sätt att
de signaler när vi ska byta till nästa respektive föregående tillstånd:

```vhdl
process(clock, reset_s2_n) is
begin
    if (reset_s2_n = '0') then
        state <= STATE_OFF; -- Vid reset, sätt state till STATE_OFF.
    elsif (rising_edge(clock)) then
        case (state) is
            when STATE_OFF =>
                if (to_next_state = '1') then
                    state <= STATE_BLINK;
                elsif (to_prev_state = '1') then
                    state <= STATE_ON;
                end if;
            --- Här implementerar vi cases för STATE_BLINK samt STATE_ON.
            when others =>
                state <= STATE_OFF; -- Om något går fel, återställ state till STATE_OFF.
        end case;
    end if;
end process;
```