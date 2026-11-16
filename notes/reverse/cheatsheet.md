# REVERSE — Cheatsheet (comandi e strumenti)

## Prima occhiata
```bash
file ./chall
strings -n6 ./chall | less
strings -n6 ./chall | grep -iE 'flag|correct|wrong|CCIT|\{'
nm -C ./chall 2>/dev/null | grep -i -E 'main|check|win|flag'
ltrace ./chall ; strace -f ./chall           # cosa chiama a runtime
```

## Disassemblatori / decompilatori
| Tipo | Strumento | Note |
|---|---|---|
| ELF/PE | **Ghidra** | gratis, ottimo decompilatore. `analyzeHeadless` per script |
| ELF/PE | radare2 / Cutter | `r2 -A ./chall`, `aaa`, `pdf @ main` |
| ELF/PE | IDA Free | decompilatore limitato ma comodo |
| .pyc | `pycdc` / `decompyle3` / `uncompyle6` | Python compilato |
| .NET | dnSpy / ILSpy | |
| Java | CFR / procyon / jd-gui | `java -jar cfr.jar app.jar` |
| packed | `upx -d` | poi rianalizza |

## radare2 minimo
```
r2 -A ./chall
afl                 # lista funzioni
s main ; pdf        # disassembla main
VV                  # vista grafo
iz                  # stringhe nel data
```

## Automazione (quando la logica è un vincolo)
- **angr** → `templates/angr_find.py` (raggiungi "success", evita "wrong").
- **z3** → `templates/solve_z3.py` (inverti trasformazioni carattere-per-carattere).

## Approccio
1. Trova la funzione di **confronto** (dove l'input incontra il "giusto").
2. Trasformazione reversibile? Invertila (a mano o z3).
3. Validatore complesso / molti rami? angr.
4. Anti-debug / anti-tamper? Patcha i salti condizionali o risolvi staticamente.

## Dove
`vendor/ctf-wiki/` (reverse), `vendor/hacktricks/`. `./search.sh "angr"`, `./search.sh "ghidra"`.
