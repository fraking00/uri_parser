

# PROGETTO PARSING DI STRINGHE URI

## PROGETTO LISP

##### SCELTE PROGETTUALE

- `defclass`. Questa è una macro fornita da **common lisp** che ci permette di avere una specie di OOP anche in questo linguaggio. Abbiamo scelto di usare questa macro, dopo numerosi **test** e **ricerche**, confrontando `defclass` con `defstruct` e con una semplice **gestione con liste**. Il determinante è stato il fatto che, con questa macro abbiamo la possibilità di gestire in modo semplice i parametri di default (come in questo caso la porta settata automaticamente ad 80) e per la possibilità di **accedere** e **modificare** in modo semplice questi **componenti**. Dato che le funzioni obbligatorie richiedono l'accesso a questi dati, la scelta finale è ricaduta su `defclass`.

- In questo progetto abbiamo usato gli **errori** per segnalare eventuali problemi dovuti ad un **uri non valido** o a sue **componenti non valide** o mancanti. Per semplicità abbiamo creato due tipi di errori, usando la macro `define-condition`. Questa macro ci permette di creare un oggetto che derivi da **error** e che generi effettivamente un'eccezione con un messaggio passato in input (esempio in basso)

- Per una semplice gestione del codice abbiamo trovato comodo l'uso di diverse let nella parte di parsing. Questo perchè, per come abbiamo strutturato il codice, ci servivano un paio di liste di appoggio, sia per il pezzo analizzato in quel momento che per il resto della stringa ancora da analizzare

- Essendo il linguaggio un funzionale abbiamo strutturato il codice in modo da sfruttare le potenzialità che ci offre il linguaggio, quindi per esempio abbiamo usato parecchio le `mapcar`, la `remove` e ovviamente la ***ricorsione***.

- Essendo **lisp** nato per manipolare bene le liste, abbiamo deciso, dopo una prima versione che in parte usava le **stringhe**, di usare principalmente le liste. Questo ha comportato una maggiore semplicità nella gestione di alcuni passaggi come per esempio passare ad un altra funzione il resto della lista

- Durante la scrittura del codice, ragionando su un modo possibile per capire quando una determinata parte finiva, ci siamo accorti che potevamo usare i simboli che in un eventuale automa (costruito comunque a parte) ci facevano cambiare stato come dei delimitatori. Per questo motivo per comodità abbiamo trasformato la lista lista usando delle funzioni apposite che ogni volta che trovavano quel delimitatore lo sostituivano con un numero negativo. Questo è stato utile soprattutto nella rilettura del codice, in quanto diversi da i semplici caratteri ascii (che già usavamo per il resto). I numeri negativi in questione arrivano fino a -6

- Per strutturare meglio la funzionalità di parsing effettivo abbiamo deciso di creare delle funzioni di parsing per ogni componente della stringa passata in input, che una volta trovata la loro parte e, una volta gestiti gli errori, passano il controllo alle altre funzioni. Questo ci ha semplificato soprattutto la gestione della funzione totale di parsing in quanto le funzioni più grandi sono quella del parsing dello scheme, dato che deve gestire le varie casistiche di quello che viene dopo (anche in funzione allo scheme stesso) e l'authority, dato che c'è la possibilità che contenga anche userinfo. Avendo progettato il codice in questa maniera siamo riusciti a gestirlo meglio

- Per gli **scheme special** abbiamo gestito ogni possibilità con una funzione apposita che richiamavamo dopo il parsing dello scheme. L'unica eccezione è lo **scheme special zos** in quanto può essere richiamato anche da **Authority** dato che zos è una **variazione** del tipo generale di uri in cui l'unica cosa che cambia è il path

- Dato che la funzione che l'utente utilizza deve accettare una stringa come input, abbiamo deciso, dopo una fase iniziale in cui lavoramamo principalmente con le stringhe, di fare una funzione ausiliaria che prende in input la lista della stringa trasformata (usando `transform-word` in quanto deve trasformare i vari delimitatori) e ci restiuisce la struttura dati. Abbiamo fatto questo in quanto in common lisp lavorare sulle liste è nettamente migliore rispetto a lavorare con le stringhe.

##### FUNZIONI PRINCIPALI

- **URI-PARSE**: funzione che prende in input ua stringa e riotrna la struttura dati contenente l'uri parsato
  
  - ```lisp
    (uri-parse "http://disco.unimib.it")
    ```
  
  - L'esempio precedente ci darà come risultato la struttura dati

- **URI-SCHEME**: funzione che prende in input la struttura dati e ritorna la stringa relativa all'attributo scheme
  
  - ```lisp
    (uri-scheme uri-struct)
    ```

- **URI-USERINFO**: funzione che prende in input la struttura dati e ritorna una stringa con l'attributo userinfo della relativa uri-struct
  
  - ```lisp
    (uri-userinfo uri-struct)
    ```

- **URI-HOST**: funzione che prende in input la struttura dati e ritorna una stringa con l'attributo host della uri-struct
  
  - ```lisp
    (uri-host uri-struct)
    ```

- **URI-PORT**: funione che prende in input la struttura dati e ritorna l'integer relativo alla porta dell'uri-struct
  
  - ```lisp
    (uri-port uri-struct)
    ```

- **URI-PATH**: funzione che prende in input la struttura dati e ritorna la stringa relativa alla path della funzione
  
  - ```lisp
    (uri-path uri-struct)
    ```

- **URI-QUERY**: funzione che prende in input la struttura dati e ritorna la stringa relativa alla query della funzione
  
  - ```lisp
    (uri-query uri-struct)
    ```

- **URI-FRAGMENT**: funzione che prende in input la struttura dati e ritorna la stringa relativa al fragment della funzione
  
  - ```lisp
    (uri-fragment uri-struct)
    ```

- **URI-DISPLAY**: funzione che prende in input la **struttura dati** e come **parametro opzionale** uno **stream**, come per esempio un file.la funzione stampa il contenuto della struttura dati nello stream. Quest'ultimo ha come valore di default lo standard output
  
  - ```lisp
    (uri-display uri-struct &optional o-stream)
    ```
