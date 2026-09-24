#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WATCHER="$ROOT/bin/codex-session-watch"

if [[ ! -f "$WATCHER" ]]; then
  echo "ERROR: $WATCHER was not found." >&2
  echo "Run install.sh from a complete clone or release archive of Codex Session Watch." >&2
  exit 1
fi

chmod +x "$WATCHER"
exec "$WATCHER" install
