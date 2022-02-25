done by https://github.com/AndreaD148

## PROGETTO URI-PARSE

### funzioni uri_parse

La funzione **uri_parse** è così definita:

```prolog
uri_parse(UriString, URI)
```

Il **primo parametro** è la stringa contenente **l'uri** da voler **parsare**.

Il **secondo parametro** è la struttura dati che verrà ritornata.

La struttura è così definita:

```prolog
URI = uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)
```

la funzione uri_parse analizza lo scheme. Se lo scheme è tra quelli speciali (gli scheme sono case insensitive, quindi possiamo avere per esempio MaILtO) viene eseguita una funzione apposita per quello scheme specifico. 

Se lo scheme non è tra gli scheme speciali viene passato all'altra serie di uri con le varie casistiche. 

Questi uri sono una serie di dcg che prendono in input la lista contenente la UriString convertita in caratteri ascii.

All'interno della dcg viene fatto l'effettivo parse, richiamando le dcg ausiliarie che abbiamo creato per riconoscere le varie parti.

**uri_display/1** è così definita:

```prolog
uri_display(String)

uri_display(uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment))
```

il **primo** scrive a schermo l'analisi del uri_parse della stringa.

il **secondo** trascrive a schermo i valori del oggetto uri senza controlli.

per il secondo uri_display però i componenti dell'oggetto devono esere scritti come stringhe come nell'esempio.

esempio:    

```prolog
uri("http", [], "disco.unimib.it", "80", [], [], [])
```

**uri _display/2** è così definita:

```prolog
uri_display(String,FilePath)

uri_display(uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment),FilePath)
```

il **primo** scrive su file l'analisi del uri_parse della stringa.

il **secondo** trascrive su file i valori del oggetto uri senza controlli.

per il secondo uri_display però i componenti dell'oggetto devono essere scritti come stringhe come nell'esempio precedente.

il FilePath è scitto sotto forma di stringa e nel percorso file per divisore usa / al posto di \ come nell'esempio:

```prolog
uri_display("http://disco.unimib.it","C:/user/Francesco/desktop/università/parsed.txt")
```

### **test velocità di computazione**

- Dopo molteplici test del codice è sorto che il programma computi velocemente tutte le casistiche valide, cioè quelle che restituiscono l'effettiva struttura dati **URI**,  anche se con una stringa molto complessa e con moltplici sotto casitiche dell'**URI 1** abbiamo costatato che fatica a dare la risposta ma computa comunque in un tempo valido (da 1 a 5 sec con gli esempi svolti).

- Nel codice, però abbiamo constatato che in caso di risposta **false** la computazione impieghi più tempo a restituire la risposta stessa, poichè avendo usato molteplici predicati **DCG** per scomporre ed analizzare la **uri_string**, prima di un **false** il codice stesso "parserà" tutte le casistiche valide di **URI 1** o **URI 2** (come **prolog** impone) e poi negherà la tesi impiegando così un tempo maggiore rispetto le casistiche di cui al punto precedente.
