# Contributing

Thanks for helping improve Codex Session Watch.

## Before opening a pull request

1. Keep the project macOS-focused unless a change explicitly introduces and documents another platform.
2. Preserve the opt-in model: never automatically select every session.
3. Do not introduce `codex exec resume` as an automatic fallback.
4. Do not add Accessibility, AppleScript, or GUI automation as a silent fallback.
5. Keep helper installation interactive. Background runs must never install software automatically.
6. Avoid sending telemetry from this project.
7. Keep user-facing text and documentation in English.

## Local checks

Run:

```bash
./scripts/check-repo.sh
```

On macOS, the check script also type-checks the embedded Swift helper when `swiftc` is available.

## Pull requests

Please include:

- a short description of the problem;
- the behavior before and after the change;
- macOS and Codex versions used for testing;
- any relevant logs with secrets, tokens, personal paths, and private repository names removed.

## Style

- Shell must remain compatible with the macOS-provided Bash unless the project explicitly changes that requirement.
- Prefer fail-closed behavior for uncertain rate-limit or session state.
- Keep logs useful but avoid recording secrets.
