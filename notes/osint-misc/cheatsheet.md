# OSINT / MISC — Cheatsheet

## Encoding (il pane della misc)
```bash
# CyberChef "Magic" (vendor/cyberchef/) risolve catene di encoding automaticamente.
python3 -c "import base64;print(base64.b64decode('...'))"
python3 -c "import base64;print(base64.b32decode('...'))"
echo '...' | base64 -d ; echo '...' | xxd -r -p
```
Riconoscere: `=`/`==` finali → base64. Solo A-Z2-7 → base32. `<~ ~>` → base85/ascii85.
Testo con shift → ROT13/Caesar (CyberChef "ROT13 Brute Force").

## Interazione con servizi
```bash
nc host port                                  # a mano
# automatizza (calcoli veloci, molte domande, proof-of-work): templates/nc_client.py
```
Proof-of-Work tipico: "trova X tale che sha256(prefix+X) inizia con N zeri" → script veloce.

## Jail / sandbox (pyjail, bash)
- Leggi quali builtins/caratteri sono filtrati, poi cerca il bypass in `vendor/hacktricks/`.
- `./search.sh "pyjail"`, `./search.sh "sandbox escape"`.

## OSINT (solo fonti pubbliche)
| Hai | Dove guardare |
|---|---|
| Immagine | metadati `exiftool -a -G1 img.*` (GPS!), reverse image search, dettagli nello sfondo |
| Username | presenza cross-piattaforma |
| Dominio/IP | `whois`, DNS (`dig`), `crt.sh` (certificati), Wayback Machine |
| Coordinate | mappe + Street View |
| File doc/pdf | metadati (autore, software, revisioni) |

```bash
exiftool -a -G1 foto.jpg | grep -i gps
dig +short target ANY ; whois target
```

## Blockchain (in misc)
Vedi `notes/blockchain/00-triage.md`. In breve: leggi il contratto, cerca reentrancy /
`tx.origin` / overflow pre-0.8 / `delegatecall` / access control / segreti nello storage.

## Dove
`vendor/hacktricks/` (OSINT, sandbox), `vendor/ctf-wiki/`. `./search.sh "proof of work"`.
