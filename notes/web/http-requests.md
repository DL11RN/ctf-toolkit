# WEB — HTTP con `requests` (fondamenti: verbi, header, cookie, body)

> Sfide "protocollo HTTP" (tipiche intro OliCyber/CINI): **non c'è una vuln da sfruttare**,
> devi solo costruire la richiesta GIUSTA con `requests` e sapere **DOVE** guardare la flag.
> Gira in venv: `source .venv/bin/activate` (`requests` è in `tools/requirements.txt`).
>
> Per le classi di attacco vere (SQLi, XSS, SSTI, JWT...) vedi `00-triage.md`.

## Regola d'oro: la flag può stare in posti diversi — guardali TUTTI
Molte di queste sfide falliscono solo perché si guarda `r.text` quando la flag è altrove.

| Dove può stare | Come leggerla | Tipico quando |
|---|---|---|
| Corpo della risposta | `r.text` · `r.json()` | GET/POST "normali" |
| Header di risposta | `r.headers` (dict case-insensitive) | **HEAD**, server mal configurato |
| Cookie settati dal server | `r.cookies.get_dict()` · `s.cookies` | sessioni, `/token` |
| Header `Allow` | `r.headers["Allow"]` (via **OPTIONS**) | scoperta verbi supportati |
| `Location` di un redirect | `r.headers["Location"]` con `allow_redirects=False` | 3xx che "scappa" |
| Errore verboso / traceback | provoca un input/verbo inatteso e leggi `r.text` | debug mode, metodi non gestiti |
| URL finale / catena redirect | `r.url` · `r.history` | dopo uno o più 3xx |
| Codice di stato | `r.status_code` | la flag è "comparire un 200/odd status" |

Promemoria rapido: `print(r.status_code, dict(r.headers), r.cookies.get_dict(), repr(r.text))`.

## Ricette per tipo di richiesta

### GET con parametri (query string)
Le coppie vanno nella **URL** (`?chiave=valore`). Usa `params`, non concatenare a mano.
```python
r = requests.get("http://target/server-records", params={"id": "flag"})
print(r.text)
```

### HEAD — solo header, nessun body
`HEAD` restituisce gli header di una GET equivalente **senza il corpo**: `r.text` è SEMPRE vuoto.
La flag, se c'è, è in un header extra non standard (es. `X-Flag`, `Flag`).
```python
r = requests.head("http://target/")
print(dict(r.headers))          # NON r.text
# print(r.headers.get("X-Flag"))
```

### Cookie / sessione (stato tra richieste)
`requests.get()` è *stateless*. Per conservare i cookie tra chiamate usa un oggetto `Session`,
che emula il browser (salva i `Set-Cookie` e li rimanda).
```python
s = requests.Session()
s.get("http://target/token")    # installa il cookie di sessione (spesso 204, body vuoto)
r = s.get("http://target/flag") # il cookie viene inviato in automatico
print(r.text, s.cookies.get_dict())
```

### POST form-urlencoded (`application/x-www-form-urlencoded`)
Formato legacy dei form web. Passa un **dizionario** a `data`: `requests` lo codifica e setta
l'header `Content-Type` da solo. (Attenzione: `{(...),(...)}` è un `set`, non un dict → errore.)
```python
r = requests.post("http://target/login", data={"username": "admin", "password": "admin"})
print(r.text)
```

### POST JSON (`application/json`)
Stesso scopo, formato moderno. Usa `json=` (non `data=`): serializza e setta `Content-Type: application/json`.
```python
r = requests.post("http://target/login", json={"username": "admin", "password": "admin"})
print(r.text)   # se risponde in JSON: r.json()
```

### OPTIONS + verbo inatteso
`OPTIONS` elenca i verbi supportati nell'header `Allow`. Un verbo **fuori** da quella lista,
non previsto dal server, può mandarlo in un percorso non gestito che trapela info/flag.
`requests` ha scorciatoie solo per i verbi comuni: per uno arbitrario usa `requests.request()`.
```python
r = requests.options("http://target/")
print(r.headers.get("Allow"))                 # es: HEAD, OPTIONS, GET

for m in ["DELETE", "TRACE", "PATCH", "PUT", "PROPFIND", "FOO", "FLAG"]:
    r = requests.request(m, "http://target/")
    print(m, r.status_code, repr(r.text))      # cerca quello che risponde "diverso"
```

## Casistiche simili (stessa logica, variante) — da provare se una delle sopra non basta

| Variante | Cosa provare con `requests` | Dove guardare |
|---|---|---|
| Header richiesto/controllato | `headers={"User-Agent": "...", "Referer": "...", "X-Forwarded-For": "127.0.0.1"}` | il server risponde la flag solo col valore giusto |
| Spoof IP / origine interna | `headers={"X-Forwarded-For": "127.0.0.1"}` o `X-Real-IP`, `Forwarded` | accessi "solo da localhost" |
| Redirect da non seguire | `allow_redirects=False` | `r.headers["Location"]`, `r.history`, body del 3xx |
| Basic Auth | `auth=("user", "pass")` | 401 → header `WWW-Authenticate`; poi body |
| Content negotiation | `headers={"Accept": "application/json"}` vs `text/html` | versione diversa della risorsa |
| Lingua | `headers={"Accept-Language": "it"}` | contenuto localizzato |
| Upload file (multipart) | `files={"f": ("a.txt", b"...", "text/plain")}` | risposta all'upload |
| PUT per creare/aggiornare | `requests.put(url, data=... )` poi rileggi con GET | risorsa creata |
| Parametri ripetuti / array | `params=[("k","a"), ("k","b")]` | gestione multi-valore |
| Cookie impostato a mano | `cookies={"role": "admin"}` o `s.cookies.set("admin","1")` | il server fida del cookie |
| Metodo "override" | header `X-HTTP-Method-Override: PUT` su una POST | WAF/proxy che filtra i verbi |
| Range parziale | `headers={"Range": "bytes=0-10"}` | risposta 206, leak dimensione/contenuto |

## Equivalenti `curl` (offline, senza Python)
```bash
curl -s 'http://target/path?id=flag'                 # GET con params
curl -sI http://target/                              # HEAD (solo header)
curl -s -c jar -b jar http://target/token; curl -s -b jar http://target/flag   # sessione/cookie
curl -s -d 'username=admin&password=admin' http://target/login                 # POST form
curl -s -H 'Content-Type: application/json' -d '{"username":"admin","password":"admin"}' http://target/login  # POST json
curl -s -X OPTIONS -i http://target/                 # OPTIONS -> header Allow
curl -s -X FOO -i http://target/                     # verbo arbitrario
curl -s -H 'X-Forwarded-For: 127.0.0.1' http://target/   # header custom
```

## Scorciatoia nel repo
Per setacciare in automatico tutti i posti dove può stare la flag:
`python3 templates/http_probe.py http://target/` (prova GET/HEAD/OPTIONS + verbi e segnala dove compare un `flag{...}`/`CCIT{...}`).
