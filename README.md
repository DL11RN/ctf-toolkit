# ctf-toolkit

Kit di supporto **offline** per CTF Jeopardy (CINI / OliCyber.IT / CyberChallenge.IT).
Pensato per essere consultabile **senza rete e senza IA** durante la gara.

> Principio: le **fonti autorevoli** vivono in `vendor/` come submodule.
> Il valore aggiunto è in `notes/`: schemi di **triage** che, dato ciò che osservi,
> ti puntano alla tecnica giusta dentro `vendor/`. Un solo comando per cercare: `./search.sh`.

## 🖥️ Interfaccia web (consigliata)

Pagina locale cercabile con triage, comandi (con "copia") e how-to su tutte le categorie:
```bash
xdg-open triage.html                 # apertura diretta
# oppure, selfhosted:
python3 -m http.server 8000          # poi: http://localhost:8000/triage.html
```
Cerca mentre scrivi (`/` per il focus), filtra per categoria o per tipo (Comandi/Triage/Concetti).
È offline e autonoma. Per la profondità rimanda sempre ai mirror in `vendor/` e a `./search.sh`.

---

## Primo uso (sul portatile, CON rete, prima della gara)

```bash
git clone --recurse-submodules git@github.com:DL11RN/ctf-toolkit.git
cd ctf-toolkit

# Se hai clonato senza --recurse-submodules:
git submodule update --init --depth 1

# Aggiungere i submodule la prima volta (solo chi costruisce il repo):
./scripts/add-submodules.sh

# Risorse non-submodule:
./scripts/get-cyberchef.sh     # CyberChef standalone HTML -> vendor/cyberchef/
./scripts/get-seclists.sh      # SecLists (solo wordlist utili) -> vendor/seclists/

# Ambiente completo in un colpo (apt + venv + pip):
./scripts/install-tools.sh

# ...oppure solo Python:
python3 -m venv .venv
source .venv/bin/activate
pip install -r tools/requirements.txt
```

## Prima della gara: aggiorna tutto

```bash
./scripts/update-vendor.sh
```

## Durante la gara: cerca

```bash
./search.sh "padding oracle"
./search.sh "jwt none"
./search.sh "format string"
```
Cerca ricorsivamente in `vendor/` + `notes/` con contesto. È il comando che apri per primo.

---

## Mappa del repo

| Percorso | Cosa contiene |
|---|---|
| `notes/00-first-minutes.md` | **Leggilo prima di tutto.** Strategia dei primi minuti, triage di squadra, quick-win. |
| `notes/<categoria>/00-triage.md` | **Apri questo per primo per ogni sfida.** "Se osservi X → controlla Y → apri `vendor/...`". |
| `notes/<categoria>/cheatsheet.md` | Comandi di ispezione iniziale e scorciatoie. |
| `templates/` | Scaffold di script parametrici da adattare (client remoto, debug, solver). |
| `vendor/` | Mirror offline delle fonti (submodule). Non modificare a mano. |
| `scripts/` | Setup e aggiornamento dei mirror. |
| `tools/requirements.txt` | Strumenti Python da installare in venv. |

## Categorie coperte
`web` · `crypto` · `pwn` · `reverse` · `forensics` · `osint-misc` · `blockchain` (in misc)

## Flusso consigliato in gara
1. Leggi il testo della sfida e identifica la **categoria**.
2. Apri `notes/<categoria>/00-triage.md` e segui lo schema di riconoscimento.
3. Il triage ti rimanda al punto preciso in `vendor/` (tecnica completa) e, dove c'è, a un writeup OliCyber.
4. Parti da uno scaffold in `templates/` e adattalo.
5. Non trovi? `./search.sh "<parola chiave>"`.
