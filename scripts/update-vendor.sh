#!/usr/bin/env bash
# Aggiorna tutti i mirror in un colpo. Eseguilo con rete, qualche giorno prima della gara.
set -uo pipefail

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "== Submodule (vendor/*) =="
git submodule update --init --remote --depth 1 || echo "[!] alcuni submodule non aggiornati"

echo
echo "== CyberChef =="
./scripts/get-cyberchef.sh || echo "[!] CyberChef non aggiornato"

echo
echo "== SecLists =="
./scripts/get-seclists.sh || echo "[!] SecLists non aggiornato"

echo
echo "[+] Aggiornamento completato. Ricorda: commit dei nuovi puntatori submodule:"
echo "    git add vendor && git commit -m 'Update vendor mirrors'"
