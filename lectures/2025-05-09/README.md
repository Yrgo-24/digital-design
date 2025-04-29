# 2025-05-09 – Lektion 14

## Dagordning
* Förebyggande av metastabilitet med D-vippor (*double flop*-metoden), både för hand samt i VHDL.

## Mål med lektionen
* Känna till vad som menas med metastabilitet samt hur D-vippor kan användas för att förebygga detta.

## Instruktioner
* Se min [video tutorial](https://www.youtube.com/watch?reload=9&v=KrssJRgF13I&feature=youtu.be) för information om metastabilitet.
* En kortfattad introduktion till metastabilitet finns i [Bilaga A](#bilaga-a---kortfattad-information-gällande-metastabilitet) nedan.
* Se bifogade [övningsuppgifter](./Övningsuppgifter%202025-05-09.pdf). Lösningsförslag läggs upp efter lektionen.
* Motsvarande kod skriven i SystemVerilog finns [här](./systemverilog/README.md).

## Utvärdering
* Några synpunkter om dagens föreläsning?

## Nästa lektion
* Konstruktion av timerkretsar för hand.

## Bilaga A - Kortfattad introduktion till metastabilitet

Metastabilitet är ett tillstånd där utsignalen ur en vippa varken är 0 eller 1, vilket kan uppstå när en insignal ändrar värde för nära en klockpuls. Då hinner signalen inte stabilisera sig på 0 eller 1 och vippans utsignal kan då sväva någonstans mellan 0 - 1 en viss tid. Oftast stabiliserar sig sedan vippans utsignal till 0 eller 1, annars kan systemfel uppstå, då vissa efterföljande grindar kan tolka vippans utsignal som 0, andra som 1, vilket kan få märkliga effekter.

För att förebygga metastabilitet används ofta den så kallade *double flop*-metoden, som innebär att samtliga insignaler förutom
systemklockan synkronis[text](file:///c%3A/Users/SEGOTER/Downloads/led_toggle_meta_prev.qar)eras via två vippor var. Utsignalen ur den andra vippan (ofta märkt med postfix s2 för att indikera synkronisering med två vippor) kommer vara stabil, dvs. 1 eller 0.

Ytterligare information om metastabilitet finns [här](https://nandland.com/lesson-13-metastability/) 
och [här](https://vhdlwhiz.com/terminology/metastability/).