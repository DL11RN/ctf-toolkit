# OSINT / MISC — Triage

`[W]` = ctf-wiki · `[HT]` = HackTricks

## MISC: prima mossa
- Capisci che **tipo** di sfida è: encoding? programmazione? jail? protocollo di rete? QR?
- Encoding a catena → **CyberChef** offline (`vendor/cyberchef/`), funzione "Magic".

| Osservi | Prova | Dove |
|---|---|---|
| Testo strano (base64/32/85, hex, rot) | CyberChef "Magic"; `./search.sh "encoding"` | `[W]` |
| Prompt Python/shell ristretto | Escape da sandbox/jail (pyjail, bash) | `[HT]` python sandbox, `[W]` |
| Server da interrogare a mano | `nc host port`; automatizza con pwntools | `templates/nc_client.py` |
| Proof of Work all'ingresso | Script che risolve il PoW prima di connettersi | `[W]` |
| Tanti calcoli da fare in fretta | Script di automazione (pwntools `recvuntil`/`sendline`) | — |
| "Programming challenge" | Risolvi con uno script, non a mano | — |

## OSINT: prima mossa
- Parti da ciò che ti danno: username, foto, email, dominio, coordinate.
- Lavora **solo** con fonti pubbliche; obiettivo didattico della gara.

| Hai | Dove cercare |
|---|---|
| Username | ricerca cross-piattaforma (sherlock, se consentito/offline no) |
| Immagine | reverse image search; **metadati**: `exiftool` (GPS!) |
| Dominio / IP | whois, DNS, certificati (crt.sh), Wayback Machine |
| Coordinate / luogo | mappe, Street View, dettagli nello sfondo |
| Email | provider, breach pubblici (solo lecito) |

Riferimenti OSINT: `[HT]` sezione OSINT; raccolte in `[P]`/`[W]` dove presenti.

## BLOCKCHAIN (parcheggiata in misc)
Era buzzword l'anno scorso; preparazione minima:
- Smart contract Solidity dato → leggi il sorgente, cerca: visibilità funzioni, `tx.origin`,
  reentrancy, overflow (pre-0.8), `delegatecall`, access control mancante.
- Strumenti: `[HT]` Blockchain/Smart Contracts; CTF-Wiki se presente.
- Interazione: web3.py / cast (foundry) se installati.
`./search.sh "reentrancy"` · `./search.sh "solidity"`.

## Writeup OliCyber
`vendor/olicyber-writeups/` → Misc. `./search.sh "jail"`, `./search.sh "proof of work"`.
