#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WATCHER="$ROOT/bin/codex-session-watch"
TMP="${TMPDIR:-/tmp}/codex-session-watch-check.$$"
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP"

printf 'Checking Bash syntax...\n'
bash -n "$WATCHER"
bash -n "$ROOT/install.sh"

printf 'Checking safety invariants...\n'
if grep -Ev '^[[:space:]]*#' "$WATCHER" | grep -Eq 'codex[[:space:]]+exec[[:space:]]+resume'; then
  echo 'ERROR: automatic codex exec resume usage detected.' >&2
  exit 1
fi
if grep -Eq '/usr/bin/osascript|System Events|AXIsProcessTrusted' "$WATCHER"; then
  echo 'ERROR: GUI automation / Accessibility dependency detected.' >&2
  exit 1
fi

grep -q 'MANAGED_HELPER_BIN=' "$WATCHER"
grep -q 'selected-threads.txt' "$WATCHER"
grep -q 'usageLimitExceeded' "$WATCHER"
grep -q 'ordinaryUsageAllowed' "$WATCHER"

printf 'Checking public repository language...\n'
if grep -nE '([äöüÄÖÜß]|Verwendung:|Ungueltig|Waehle|Auswahl|Projekt gespeichert|Prueflauf|zurueck|fuer Remote)' "$WATCHER"; then
  echo 'ERROR: non-English user-facing text remains in the watcher.' >&2
  exit 1
fi

if command -v swiftc >/dev/null 2>&1 && [[ "$(uname -s)" == "Darwin" ]]; then
  printf 'Type-checking embedded Swift helper...\n'
  awk '
    /cat > "\$HELPER_SOURCE" <<\x27SWIFT\x27/ {capture=1; next}
    capture && $0 == "SWIFT" {exit}
    capture {print}
  ' "$WATCHER" > "$TMP/SessionWatchClient.swift"
  swiftc -typecheck "$TMP/SessionWatchClient.swift"
else
  printf 'Skipping Swift type-check (requires macOS + swiftc).\n'
fi

printf 'Repository checks passed.\n'
