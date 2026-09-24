# Architecture

Codex Session Watch has two main pieces:

1. a Bash controller that manages installation, launchd, state, logs, and the managed Codex daemon;
2. a small Swift client embedded inside the Bash script and compiled locally on macOS.

## Managed daemon

The watcher expects the daemon-owned Codex binary at:

```text
~/.codex/packages/app-server-daemon/current/bin/codex
```

The watcher uses the managed daemon lifecycle commands to enable remote control and start the local app server.

The app server exposes a Unix-domain control socket below `CODEX_HOME`:

```text
~/.codex/app-server-control/app-server-control.sock
```

## Session discovery

The Swift helper connects to the local control socket using WebSocket + JSON-RPC and performs the normal app-server initialization handshake.

It asks for non-archived interactive threads, groups them by working directory, and presents those directories as projects.

The user must explicitly choose sessions. Selected thread IDs are persisted in a local text file.

## Resume logic

For each selected thread, the watcher checks:

1. whether ordinary usage is currently permitted;
2. whether the most recent turn failed specifically because of `usageLimitExceeded`.

Only if both conditions are satisfied does it resume the thread and start a new turn with the configured continuation prompt.

## Why no `codex exec resume`?

Spawning independent CLI resume processes can create extra permission prompts, separate process lifecycles, and accidental interaction with sessions the user did not intend to automate.

This project instead uses one managed local app-server daemon and explicit thread selection.

## launchd

The watcher installs a per-user LaunchAgent and runs a one-shot check at the configured interval. If no sessions are selected, the LaunchAgent is disabled.
