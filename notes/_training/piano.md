# PIANO DI ALLENAMENTO — 2 settimane

Obiettivo: non imparare "tutto", ma **riconoscere i pattern** più frequenti nelle gare CINI,
così in gara il triage è immediato. La palestra è `vendor/olicyber-writeups/` + TryHackMe.

## Come allenarsi (metodo, non solo lettura)
Per ogni writeup che studi:
1. Leggi SOLO il testo della sfida (non la soluzione). Prova a fare il triage con `notes/<cat>/00-triage.md`.
2. Tenta davvero 15-20 min. Poi leggi la soluzione.
3. Se hai sbagliato triage → **aggiorna** la riga giusta in `00-triage.md` (il repo migliora con te).
4. Se è saltata fuori una tecnica utile → aggiungi una riga nel cheatsheet con il comando chiave.
Regola d'oro: un writeup "capito" vale 5 "letti".

## Trovare materiale nel repo
```bash
rg -l "" vendor/olicyber-writeups | sed 's#vendor/olicyber-writeups/##' | sort   # elenco writeup
./search.sh "<tecnica>"        # es. ./search.sh "jwt"  ./search.sh "ret2libc"
ls vendor/olicyber-writeups/   # cartelle per anno/evento
```

## Calendario (adatta a servizio/impegni: ~1-1.5h/giorno, salta senza sensi di colpa)

### Settimana 1 — coprire le categorie, una al giorno
| Giorno | Categoria | Cosa fare |
|---|---|---|
| 1 | **Crypto** | RSA (e piccolo, n fattorizzabile, Wiener). Prova `RsaCtfTool`. 2-3 writeup crypto. |
| 2 | **Crypto** | AES: ECB byte-at-a-time, CBC bit-flipping, padding oracle (vedi `crypto-attacks/`). 2 writeup. |
| 3 | **Web** | SQLi + login bypass con `sqlmap` su lab THM. 2 writeup web. |
| 4 | **Web** | JWT, SSTI, LFI/traversal. Usa `vendor/payloads/`. 2 writeup. |
| 5 | **Reverse** | Ghidra su 1 crackme facile; poi angr (`templates/angr_find.py`). 1-2 writeup. |
| 6 | **Forensics** | Trio `file/exiftool/binwalk`, stego immagini (zsteg/steghide), 1 pcap in Wireshark. |
| 7 | **Recupero/misc** | Encoding con CyberChef, 1 pyjail, blockchain: leggi `notes/blockchain/00-triage.md`. |

### Settimana 2 — simulare la gara
| Giorno | Cosa fare |
|---|---|
| 8 | **Pwn base**: BOF + ret2win con `templates/pwn_remote.py`, `pwn cyclic` per l'offset. |
| 9 | **Pwn**: ret2libc / ROP (ROPgadget). Studia 1 writeup pwn passo-passo. |
| 10 | Torna sulla tua categoria **più debole** della settimana 1. |
| 11 | **Mini-simulazione**: 3 sfide a tempo (1h), ordini di difficoltà misti. Cronometra il triage. |
| 12 | **Simulazione** da 2-3h con più categorie insieme. Usa SOLO il repo, niente IA (come in gara). |
| 13 | Rivedi gli errori della simulazione. Aggiorna triage/cheatsheet dove ti sei bloccato. |
| 14 | **Leggero**: ripassa i `00-triage.md`, controlla l'ambiente (`import pwn, angr, z3`), riposa. |

## Priorità se hai poco tempo
Concentra l'80% su **crypto + web** (le più numerose e "a punti rapidi" nelle gare CINI),
poi forensics/misc per i quick-win. Pwn e reverse: almeno saper riconoscere e usare i template.

## Checklist pre-gara (giorno prima)
- [ ] `source .venv/bin/activate && python3 -c "import pwn, angr, z3; print('ok')"`
- [ ] CyberChef apre offline (`vendor/cyberchef/CyberChef_v*.html`)
- [ ] `./search.sh "test"` risponde con ripgrep
- [ ] `./scripts/update-vendor.sh` lanciato di recente (mirror aggiornati)
- [ ] Portatile carico + caricabatterie + adattatore di rete; Discord installato
- [ ] Sai il formato del flag e come si sottomette
