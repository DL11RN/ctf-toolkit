# WEB — Triage

**Apri questo per primo.** Riconosci cosa hai davanti, poi vai al punto giusto in `vendor/`.
`[P]` = PayloadsAllTheThings · `[H]` = HackTricks · `[W]` = ctf-wiki

## Ispezione iniziale (sempre)
```bash
# Mappa veloce dell'app
curl -sI https://target/            # header, server, redirect, cookie
whatweb https://target/ 2>/dev/null # tecnologie (se installato)
# Contenuti nascosti
ffuf -u https://target/FUZZ -w vendor/seclists/Discovery/Web-Content/raft-medium-directories.txt
# Guarda SEMPRE: commenti HTML, /robots.txt, /sitemap.xml, file sorgente se forniti,
# header di risposta, cookie (flag, struttura), parametri GET/POST, 403/redirect sospetti.
```

## Schema: "se osservo X → controlla Y → apri Z"

| Osservi | Ipotesi da controllare | Dove approfondire |
|---|---|---|
| Form di login / query che finisce nel DB | SQL injection (anche blind/time-based) | `[P]` SQL Injection · `[H]` SQL injection |
| DB NoSQL (Mongo), JSON nei parametri | NoSQL injection | `[P]` NoSQL Injection |
| Cookie/token con tre parti `xxx.yyy.zzz` | JWT: alg `none`, chiave debole, confusione RS/HS | `[P]` JSON Web Token · `[H]` JWT |
| Input riflesso dentro template server | SSTI (Jinja2, Twig, ...) | `[P]` Server Side Template Injection |
| L'app fa richieste a URL che controlli | SSRF | `[P]` Server Side Request Forgery |
| Oggetti/stringhe serializzate | Deserializzazione insicura | `[P]` Insecure Deserialization · `[H]` per linguaggio |
| Path/filename nei parametri | Path traversal / LFI / RFI | `[P]` Directory Traversal, File Inclusion |
| Input riflesso nell'HTML + bot/admin visita | XSS (riflesso/stored, furto cookie admin) | `[P]` XSS Injection |
| Merge di oggetti lato JS (Node) | Prototype pollution | `[P]` Prototype Pollution |
| Upload file | Bypass estensione/MIME, webshell | `[P]` Upload Insecure Files |
| Comando di sistema con input utente | Command injection | `[P]` Command Injection |
| Doppia richiesta cambia lo stato | Race condition | `[H]` Race condition |
| Controllo accessi per ID (`?id=`) | IDOR / broken access control | `[H]` IDOR |
| GraphQL endpoint | Introspection, query abuse | `[H]` GraphQL |

## Se ti danno il sorgente (frequente in CINI)
1. Cerca dove l'input utente entra in: query SQL, `eval`/`exec`, template, `open()`/path, `system()`, deserializzazione.
2. Guarda controlli di autenticazione/autorizzazione aggirabili.
3. Confronta logica attesa vs implementata (bug logici: sconti, bilanci, confronti `==` vs `===`).
4. `./search.sh "<funzione sospetta>"` per trovare la tecnica collegata.

## Writeup OliCyber
`vendor/olicyber-writeups/` → cartella Web. Grep per tecnica: `./search.sh "sqli"` ecc.
