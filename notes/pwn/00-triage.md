# PWN (binary exploitation) — Triage

`[W]` = ctf-wiki (pwn) · `[H2H]` = shellphish/how2heap · `[HT]` = HackTricks

> Scopo di questo file: riconoscere la **classe di vulnerabilità** e le **protezioni**, poi
> aprire la tecnica completa in `vendor/`. I passi di sfruttamento stanno nelle fonti, non qui.

## Ispezione iniziale (sempre, in ordine)
```bash
file ./chall                 # arch, statico/dinamico, stripped?
checksec --file=./chall      # RELRO, Canary, NX, PIE (pwntools fornisce checksec)
strings ./chall | less       # stringhe, format, path, /bin/sh?
./chall                      # comportamento: cosa chiede? cosa stampa?
# Se c'e' libc fornita:
./scripts/..  # usa pwninit o patchelf per agganciare la libc giusta (vedi cheatsheet.md)
```
Annota: la libc fornita (versione → `strings libc.so.6 | grep "GNU C"`), gli indirizzi/leak che il programma regala, e se l'input ha una lunghezza non controllata.

## Dalla protezione / dall'osservazione → dove guardare
| Osservi / manca | Classe & direzione | Dove |
|---|---|---|
| input in buffer senza limite, no canary | Stack buffer overflow | `[W]` stackoverflow |
| overflow + c'è una funzione "win" | Redirezione del flusso a funzione esistente | `[W]` |
| NX attivo, serve ROP | Riuso di codice (ROP) con `ROPgadget`/pwntools | `[W]` rop, `[HT]` ROP |
| printf con stringa controllata dall'utente | Format string (leak / scrittura) | `[W]` fmtstr |
| canary presente | Serve un leak del canary prima dell'overflow | `[W]` canary |
| PIE attivo | Serve un leak per de-randomizzare la base | `[W]` pie |
| allocazioni/free controllabili (menu heap) | Vulnerabilità su heap (UAF, double free, ecc.) | `[H2H]`, `[W]` heap |
| syscall disponibili / no `system` | Catena verso `execve` (ROP syscall) | `[W]` |
| filtro seccomp | Open-Read-Write invece di shell | `[W]` seccomp, `seccomp-tools` |

## Heap: come orientarti
`vendor/how2heap/` contiene un esempio compilabile **per ciascuna tecnica**, versionato per glibc.
1. Trova la **versione glibc** del target.
2. Apri la cartella `how2heap` corrispondente a quella glibc.
3. Scegli l'esempio che corrisponde alla primitiva che hai (es. use-after-free, double free...).
Nota: dalla glibc 2.32 c'è il safe-linking dei puntatori nei bin — conta la versione.

## Debug
`pwndbg` o `gef` (vedi `cheatsheet.md` per installarli). Comodi: `cyclic`/`cyclic -l` (offset),
`checksec`, `vmmap`, `telescope`, `find`.

## Template
`templates/pwn_remote.py` — scheletro pwntools (locale/remoto/gdb) da adattare.

## Writeup OliCyber
`vendor/olicyber-writeups/` → Pwn. `./search.sh "ret2libc"`, `./search.sh "format string"`.
