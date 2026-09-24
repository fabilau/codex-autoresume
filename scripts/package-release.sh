#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION="$(tr -d '[:space:]' < "$ROOT/VERSION")"
DIST="$ROOT/dist"
NAME="codex-session-watch-$VERSION"

"$ROOT/scripts/check-repo.sh"

rm -rf "$DIST"
mkdir -p "$DIST/$NAME"

cp -R \
  "$ROOT/bin" \
  "$ROOT/docs" \
  "$ROOT/scripts" \
  "$ROOT/.github" \
  "$ROOT/README.md" \
  "$ROOT/LICENSE" \
  "$ROOT/DISCLAIMER.md" \
  "$ROOT/NOTICE.md" \
  "$ROOT/CONTRIBUTING.md" \
  "$ROOT/SECURITY.md" \
  "$ROOT/CHANGELOG.md" \
  "$ROOT/VERSION" \
  "$ROOT/install.sh" \
  "$ROOT/Makefile" \
  "$ROOT/.gitignore" \
  "$DIST/$NAME/"

(
  cd "$DIST"
  tar -czf "$NAME.tar.gz" "$NAME"
  zip -qr "$NAME.zip" "$NAME"
  shasum -a 256 "$NAME.tar.gz" "$NAME.zip" > SHA256SUMS
)

printf 'Release artifacts created in %s\n' "$DIST"
