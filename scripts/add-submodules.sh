#!/usr/bin/env bash
# Aggiunge i mirror come submodule in vendor/. Verifica ogni URL con `git ls-remote`
# prima di aggiungerlo: se una fonte e' spostata/non raggiungibile, la SALTA e lo segnala.
# Da eseguire una sola volta, dalla radice del repo, con rete.
set -uo pipefail

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ ! -d .git ]; then
  echo "[!] Non sei nella radice di un repo git. Esegui: git init && git remote add origin ..." >&2
  exit 1
fi

# nome_locale  URL
# NB: gli URL sono quelli canonici noti; se uno fallisce la verifica, aggiornalo qui.
# HackTricks ha cambiato organizzazione in passato: fallback indicato nei commenti.
read -r -d '' REPOS <<'EOF'
hacktricks https://github.com/HackTricks-wiki/hacktricks
payloads https://github.com/swisskyrepo/PayloadsAllTheThings
gtfobins https://github.com/GTFOBins/GTFOBins.github.io
lolbas https://github.com/LOLBAS-Project/LOLBAS
ctf-wiki https://github.com/ctf-wiki/ctf-wiki
how2heap https://github.com/shellphish/how2heap
olicyber-writeups https://github.com/OliCyberIT/OliCyber.IT-Writeups
rsactftool https://github.com/RsaCtfTool/RsaCtfTool
crypto-attacks https://github.com/jvdsn/crypto-attacks
EOF

ok=0; skip=0
while read -r name url; do
  [ -z "$name" ] && continue
  echo "== $name  ($url)"
  if git ls-remote --exit-code "$url" >/dev/null 2>&1; then
    if [ -d "vendor/$name" ]; then
      echo "   gia' presente, salto l'add."
    else
      if git submodule add --depth 1 "$url" "vendor/$name"; then
        ok=$((ok+1))
      else
        echo "   [!] submodule add fallito per $name" >&2
        skip=$((skip+1))
      fi
    fi
  else
    echo "   [!] URL non raggiungibile: $url  -> SALTATO. Verifica/aggiorna l'URL." >&2
    skip=$((skip+1))
  fi
done <<< "$REPOS"

echo
echo "Fatto. Aggiunti/ok: $ok  |  saltati: $skip"
echo "Ora: git add .gitmodules vendor && git commit -m 'Add vendor submodules'"
echo "Poi: ./scripts/get-cyberchef.sh && ./scripts/get-seclists.sh"
