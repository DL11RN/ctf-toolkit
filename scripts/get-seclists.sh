#!/usr/bin/env bash
# Scarica SOLO le parti utili di SecLists via sparse-checkout (l'intero repo e' enorme).
# Cartelle incluse: Discovery/Web-Content, Passwords, Fuzzing.
set -euo pipefail

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="vendor/seclists"
URL="https://github.com/danielmiessler/SecLists"

if [ -d "$DEST/.git" ]; then
  echo "[*] SecLists gia' presente, aggiorno..."
  git -C "$DEST" pull --ff-only || true
  exit 0
fi

echo "[*] Clono SecLists in modalita' sparse (solo wordlist utili)..."
git clone --no-checkout --depth 1 --filter=blob:none "$URL" "$DEST"
git -C "$DEST" sparse-checkout init --cone
git -C "$DEST" sparse-checkout set \
  "Discovery/Web-Content" \
  "Passwords/Common-Credentials" \
  "Passwords/Leaked-Databases" \
  "Fuzzing"
git -C "$DEST" checkout

echo "[+] SecLists pronto in: $DEST"
echo "    Nota: rockyou.txt completo e' sotto Passwords/Leaked-Databases (rockyou.txt.tar.gz -> estrai)."
du -sh "$DEST" 2>/dev/null || true
