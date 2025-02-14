# C-program för utskrift av tal

Utskrift av 4- och 8-bitars tal på osignerad, signerad, binär samt hexadecimal form:
* I [`main.c`](./main.c) skrivs talen 6 - 10 ut på 4-bitars form, följt av att talet 126 - 130 skrivs ut på 8-bitars form.
* [`bit_utils.h`](./bit_utils.h) samt [`bit_utils.c`](./bit_utils.c) innehåller hjälpfunktioner för att skriva ut
tal, omvandla dessa till signerad form med mera.

## Kompilering samt körning av programmet med online-kompilator

Öppna [Online C Compiler](https://www.onlinegdb.com/online_c_compiler) och klistra in innehållet
från filerna [`main.c`](./main.c), [`bit_utils.h`](./bit_utils.h) samt [`bit_utils.c`](./bit_utils.c).
Klicka på `Run` för att köra programmet.

## Kompilering samt körning av demonstrationsprogrammet i Linux

Ladda ned nödvändiga paket för att kompilera kod, använda Git med mera:

```bash
sudo apt -y update
sudo apt -y install build-essential make
```

Kompilera och kör programmet via följande kommando:

```bash
make
```

Du kan också enbart bygga programmet utan att köra det efteråt via följande kommando:

```bash
make build
```

Du kan köra programmet utan att kompilera innan via följande kommando:

```bash
make run
```

Du kan också ta bort kompilerade filer via följande kommando:

```bash
make clean
```