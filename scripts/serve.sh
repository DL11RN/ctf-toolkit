#!/usr/bin/env bash
# Avvia il toolkit come sito locale e apre il browser su triage.html.
# Uso: ./scripts/serve.sh [porta]   (default 8000)
set -euo pipefail
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PORT="${1:-8000}"
URL="http://localhost:${PORT}/triage.html"
echo "[*] Toolkit su ${URL}"
echo "    (Ctrl-C per fermare)"
# apre il browser dopo un attimo, in background
( sleep 1; xdg-open "${URL}" >/dev/null 2>&1 || true ) &
# serve solo in locale
python3 -m http.server "${PORT}" --bind 127.0.0.1
