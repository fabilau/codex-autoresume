# Security Model

## Goals

Codex Session Watch is designed to automate as little as possible while still resuming deliberately selected sessions.

### Explicit opt-in

A session is never eligible merely because it exists. Its thread ID must be present in the local selection file.

### No GUI automation

The project does not use:

- macOS Accessibility permissions;
- AppleScript;
- simulated mouse input;
- simulated keyboard input.

### No per-session CLI resume process

The project does not use `codex exec resume` as an automated fallback.

### Interactive helper installation only

If the managed Codex daemon package is missing, the watcher may offer to install it only when invoked interactively. A launchd background check will fail instead of installing software silently.

### Fail closed

If the app-server response does not provide a sufficiently reliable indication that ordinary usage is available, the watcher does not resume selected sessions.

### Local data

The watcher stores local state below:

```text
~/.local/state/codex-session-watch/
```

Logs are stored below:

```text
~/Library/Logs/CodexSessionWatch/
```

The project itself does not add telemetry or upload these files.

## Important limitation

Resuming a Codex session allows that session to continue operating under its existing Codex configuration, working directory, approval policy, tools, and permissions. Selecting a session means you are intentionally authorizing the watcher to submit the configured continuation prompt to that session when the conditions are met.
