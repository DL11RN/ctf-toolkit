#!/usr/bin/env bash
# Scarica l'ultima release standalone di CyberChef (HTML offline) in vendor/cyberchef/.
# CyberChef e' un'unica pagina HTML autonoma: una volta scaricata funziona senza rete.
set -euo pipefail

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="vendor/cyberchef"
mkdir -p "$DEST"

API="https://api.github.com/repos/gchq/CyberChef/releases/latest"

echo "[*] Cerco l'ultima release di CyberChef..."
# URL dell'asset .zip della release (nome tipo CyberChef_vX.Y.Z.zip)
ASSET_URL="$(curl -fsSL "$API" \
  | grep -oE '"browser_download_url": *"[^"]+\.zip"' \
  | head -n1 | sed -E 's/.*"(https[^"]+)".*/\1/')"

if [ -z "${ASSET_URL:-}" ]; then
  echo "[!] Non ho trovato l'asset zip. Scarica a mano da https://github.com/gchq/CyberChef/releases" >&2
  exit 1
fi

echo "[*] Scarico: $ASSET_URL"
TMP="$(mktemp -d)"
curl -fsSL "$ASSET_URL" -o "$TMP/cyberchef.zip"
unzip -o -q "$TMP/cyberchef.zip" -d "$DEST"
rm -rf "$TMP"

echo "[+] Pronto. Apri nel browser il file CyberChef_*.html in: $DEST"
ls -1 "$DEST" | sed 's/^/    /'
