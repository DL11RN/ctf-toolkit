# WEB — Cheatsheet (comandi)

## Ricognizione
```bash
curl -sSIL https://target/                 # header, redirect, cookie, server
curl -sS https://target/ | less            # HTML grezzo: commenti, form, path JS
whatweb https://target/                    # tecnologie
# Directory/file nascosti
ffuf -u https://target/FUZZ -w vendor/seclists/Discovery/Web-Content/raft-medium-directories.txt -mc all -fc 404
ffuf -u https://target/FUZZ -w vendor/seclists/Discovery/Web-Content/raft-medium-files.txt -mc 200,301,302,403
# Vhost / subdomain (se pertinente)
ffuf -u https://target/ -H "Host: FUZZ.target" -w <wordlist>
```

## Richieste manuali (l'arma più versatile)
```bash
# GET/POST con dati e cookie
curl -sS 'https://target/api' -d 'user=admin&pass=x' -b 'session=...' -H 'Content-Type: application/x-www-form-urlencoded'
# Header utili da testare: X-Forwarded-For, X-Original-URL, Referer, User-Agent
# Salva e rigioca richieste: usa Burp (Repeater/Intruder) o requests in Python (templates)
```

## Strumenti per classe (uso lecito, didattico)
| Classe | Strumento | Nota |
|---|---|---|
| SQLi | `sqlmap -u '...' --batch` | parti con `--dbs`, poi `--dump`; `--level/--risk` se serve |
| JWT | `pyjwt` / jwt_tool | verifica alg, prova chiavi deboli con rockyou |
| Dir brute | `ffuf` / `feroxbuster` | vedi sopra |
| Password form | `hydra` | solo se la sfida lo richiede |
| Template/SSTI | payload per engine | → `vendor/payloads/Server Side Template Injection` |

## Dove stanno i payload
`vendor/payloads/` (PayloadsAllTheThings) ha una cartella per ciascuna classe con payload pronti.
`vendor/hacktricks/` ha la spiegazione passo-passo. Usa `./search.sh "<classe>"`.

## Promemoria
- Guarda SEMPRE il **sorgente** (se fornito) e i **cookie**. Metà delle web si risolve lì.
- Bot/admin che "visita" un URL → pensa XSS/CSRF per rubare il suo cookie/azione.
- Errori verbosi = regalo: leggi stack trace, query, path.
