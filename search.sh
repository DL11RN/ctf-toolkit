#!/usr/bin/env bash
# Ricerca rapida offline su note + mirror. Uso: ./search.sh "<termine>"
set -euo pipefail

if [ $# -eq 0 ]; then
  echo "Uso: $0 \"<termine di ricerca>\" [termine2 ...]" >&2
  echo "Esempi: $0 \"padding oracle\" ; $0 ret2libc ; $0 \"jwt none\"" >&2
  exit 1
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
QUERY="$*"

# Preferisci ripgrep; fallback a grep se assente.
if command -v rg >/dev/null 2>&1; then
  rg --smart-case --line-number --context 2 --max-columns 200 \
     --glob '!**/.git/**' \
     -- "$QUERY" "$ROOT/notes" "$ROOT/vendor" "$ROOT/templates" 2>/dev/null \
     || echo "Nessun risultato per: $QUERY"
else
  echo "[!] ripgrep (rg) non installato: uso grep. Installa rg per risultati migliori." >&2
  grep -rniI --color=auto -C2 \
     --exclude-dir=.git \
     -e "$QUERY" "$ROOT/notes" "$ROOT/vendor" "$ROOT/templates" 2>/dev/null \
     || echo "Nessun risultato per: $QUERY"
fi
