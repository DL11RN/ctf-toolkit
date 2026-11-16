# REVERSE ENGINEERING — Triage

`[W]` = ctf-wiki (reverse) · `[HT]` = HackTricks

## Ispezione iniziale
```bash
file ./chall
strings -n6 ./chall | less        # flag in chiaro? messaggi? librerie?
nm -C ./chall 2>/dev/null          # simboli (se non stripped)
ltrace ./chall ; strace ./chall    # chiamate libc / syscall a runtime
```
Prima di decompilare: prova input ovvi, guarda `strings`, guarda cosa confronta.

## Dal tipo di binario → strumento
| Hai | Strumento consigliato | Dove |
|---|---|---|
| ELF/PE nativo | Ghidra (decompilatore), oppure IDA Free / Cutter(radare2) | `[W]` tools |
| Logica basata su confronti/vincoli | Esecuzione simbolica con **angr** | `templates/angr_find.py`, `[W]` angr |
| Trasformazioni su input per arrivare al flag | **z3** per invertire i vincoli | `templates/solve_z3.py` |
| Python compilato (.pyc) | Decompila: `pycdc`/`decompyle3`/`uncompyle6` | `[HT]` python |
| .NET | dnSpy / ILSpy | `[HT]` .NET |
| Java/JAR | jd-gui / CFR / procyon | `[HT]` java |
| Codice offuscato/packed | Controlla UPX (`upx -d`), poi dump a runtime | `[W]` |
| Anti-debug presente | Patcha i salti, oppure risolvi staticamente | `[W]` |

## Approccio tipico
1. Trova la funzione che **confronta** l'input con qualcosa (spesso `strcmp`, loop di confronto, check char-per-char).
2. Se è una trasformazione reversibile → invertila a mano o con z3.
3. Se è un keygen/validatore complesso → angr per raggiungere il blocco "success".

## Template
`templates/angr_find.py` (raggiungi un indirizzo, evita un altro) · `templates/solve_z3.py` (vincoli).

## Writeup OliCyber
`vendor/olicyber-writeups/` → Reverse. `./search.sh "angr"`, `./search.sh "pyc"`.
