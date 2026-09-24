# Codex Session Watch

> **Pick the Codex sessions that matter. Let them resume automatically when usage becomes available again.**

[![macOS](https://img.shields.io/badge/macOS-Apple%20Silicon%20%7C%20Intel-black?logo=apple)](https://www.apple.com/macos/)
[![Shell](https://img.shields.io/badge/Shell-Bash-4EAA25?logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Status](https://img.shields.io/badge/status-community%20project-orange)](#disclaimer)

**Codex Session Watch** is a lightweight macOS watcher for Codex desktop sessions. It uses the managed local Codex app-server daemon, lets you explicitly choose projects and sessions, and resumes only those selected sessions after a usage-limit interruption.

No Accessibility permission. No AppleScript. No blind `codex exec resume` loop. No automatic opt-in for every session on your machine.

---

## Why use it?

Long-running Codex work can stop when account usage is temporarily unavailable. Codex Session Watch is designed for the simple case where you want selected sessions to continue later without manually reopening each one.

### Highlights

- **Project-first selection** — choose a project, then choose sessions inside that project.
- **Explicit opt-in** — only sessions you selected can be resumed.
- **Safe selection loop** — after choosing sessions in one project, you return to the project list and can continue selecting elsewhere.
- **Managed Codex daemon** — uses the local Codex app-server daemon instead of spawning `codex exec resume` for every session.
- **Helper detection** — if the managed Codex App Helper is missing, the tool asks whether it should install it.
- **No GUI automation** — no Accessibility permission, no AppleScript, no fake mouse/keyboard input.
- **launchd integration** — runs in the background at a configurable interval.
- **Fail-closed rate-limit behavior** — if the watcher cannot safely determine that ordinary usage is available, it does not resume anything.
- **Local state** — selected thread IDs, helper code, and logs stay on your Mac.

## How it works

```text
Codex desktop sessions
        |
        v
Managed Codex app-server daemon
        |
        +--> Project list
        |       |
        |       +--> Session selection
        |               |
        |               +--> selected thread IDs only
        |
        +--> Rate-limit state
        |
        +--> Last turn state
                |
                +--> usageLimitExceeded + usage available
                         |
                         v
                  thread/resume
                         +
                    turn/start
                      "Continue"
```

The watcher deliberately does **not** use `codex exec resume`. The selected session is resumed through the local app-server protocol.

## Requirements

- macOS
- Xcode Command Line Tools (`swiftc`)
- Codex authentication/configuration already available under `~/.codex`
- Managed Codex App Helper / app-server daemon

If the managed helper is missing, `install`, `select`, `restart`, or `daemon-start` can offer to install the daemon-only Codex package interactively.

The expected managed helper path is:

```text
~/.codex/packages/app-server-daemon/current/bin/codex
```

## Installation

### Recommended: clone the repository

```bash
git clone https://github.com/fabilau/codex-autoresume.git
cd codex-session-watch
./install.sh
```

The installer will:

1. check for the managed Codex App Helper;
2. ask before installing it if it is missing;
3. compile the small local Swift app-server client;
4. enable/start the managed Codex app-server daemon;
5. open the project/session selector;
6. install the watcher under `~/.local/bin`;
7. create a user LaunchAgent only when at least one session is selected.

### Xcode Command Line Tools

If `swiftc` is missing:

```bash
xcode-select --install
```

## Session selection

Run:

```bash
codex-session-watch select
```

You first choose a project:

```text
Codex project selection
=======================

[ ]   1  backend-api       (0/4 selected)
      /Users/me/Projects/backend-api

[x]   2  desktop-client    (2/6 selected)
      /Users/me/Projects/desktop-client

  0  Done / finish selection

Project:
```

After choosing a project, only sessions from that project are displayed:

```text
Project: backend-api
====================

[ ]   1  idle        Add API pagination
[x]   2  idle        Fix deployment pipeline
[ ]   3  idle        Refactor auth middleware

Examples: 1,2,5-7   |   all   |   none
Empty input or 'back' = return without changes.

Session selection:
```

After saving that project, the watcher returns to the project list. You can repeat the process for as many projects as you want.

## Commands

| Command | Purpose |
|---|---|
| `codex-session-watch install` | Install/update the watcher, helper, daemon configuration, selector, and LaunchAgent. |
| `codex-session-watch select` | Change the project/session selection. |
| `codex-session-watch once` | Run one check immediately. |
| `codex-session-watch status` | Show helper, daemon, LaunchAgent, and selected-session status. |
| `codex-session-watch logs` | Follow the watcher log. |
| `codex-session-watch restart` | Reload the watcher LaunchAgent. |
| `codex-session-watch daemon-start` | Start/enable the managed Codex app-server daemon. |
| `codex-session-watch daemon-stop` | Stop the managed Codex app-server daemon. |
| `codex-session-watch uninstall` | Remove the watcher and LaunchAgent. |

After installation, the command is normally available at:

```text
~/.local/bin/codex-session-watch
```

If `~/.local/bin` is not in your shell `PATH`, run the full path or add it to your shell configuration.

## Configuration

The watcher supports these environment variables:

| Variable | Default | Description |
|---|---:|---|
| `CODEX_HOME` | `~/.codex` | Codex home directory. |
| `CONTINUE_PROMPT` | `Continue` | Text sent when a selected usage-limited session is resumed. |
| `CHECK_INTERVAL` | `60` | launchd interval in seconds. |
| `ALLOW_LEGACY_RATE_FALLBACK` | `0` | Compatibility fallback for older app-server versions without `ordinaryUsageAllowed`. Leave disabled unless required. |

Example:

```bash
CONTINUE_PROMPT="Continue from where you stopped." \
CHECK_INTERVAL=120 \
./bin/codex-session-watch install
```

## Files created on your Mac

```text
~/.local/bin/codex-session-watch
~/.local/state/codex-session-watch/
~/Library/LaunchAgents/local.codex-session-watch.plist
~/Library/Logs/CodexSessionWatch/
```

The managed Codex daemon itself uses Codex-owned paths below `~/.codex`.

## Security model

This project is intentionally conservative:

- it does not automatically select all sessions;
- it does not invoke `codex exec resume`;
- it does not request macOS Accessibility permissions;
- it does not use AppleScript or UI automation;
- it does not install the Codex helper from a background LaunchAgent;
- helper installation is offered only during an interactive command;
- when usage availability cannot be determined safely, the watcher does nothing;
- the selected thread IDs are stored locally in a plain-text state file.

See [docs/SECURITY-MODEL.md](docs/SECURITY-MODEL.md) for more detail.

## Troubleshooting

### Show current state

```bash
codex-session-watch status
```

### Run once in the foreground

```bash
codex-session-watch once
```

### Follow logs

```bash
codex-session-watch logs
```

### Managed helper missing

Run:

```bash
codex-session-watch select
```

The watcher will ask whether it should install the daemon-only managed Codex package.

More troubleshooting: [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md).

## Updating

Pull the latest changes and reinstall:

```bash
git pull
./install.sh
```

Your saved selection remains in the local state directory unless you remove it manually.

## Uninstalling

```bash
codex-session-watch uninstall
```

The watcher intentionally keeps selection state and logs for troubleshooting. To remove those too:

```bash
rm -rf \
  "$HOME/.local/state/codex-session-watch" \
  "$HOME/Library/Logs/CodexSessionWatch"
```

## Support the project

If this project saves you time, you can support continued development:

**[☕ Donate / Support Codex Session Watch](https://revolut.me/fabilrzs)**

## Disclaimer

This is an independent community project and is **not affiliated with, sponsored by, endorsed by, or officially supported by OpenAI**.

The software is provided **"AS IS"**, without warranties or guarantees. You use it entirely at your own risk. The maintainer does not accept liability for data loss, unintended code changes, interrupted work, usage charges, account restrictions, permission prompts, service outages, security incidents, loss of productivity, or any direct, indirect, incidental, special, exemplary, or consequential damages arising from use of this project, to the maximum extent permitted by applicable law.

Read the full plain-language maintainer notice in [DISCLAIMER.md](DISCLAIMER.md). The legally operative license terms are in [LICENSE](LICENSE).

## Contributing

Issues and pull requests are welcome. Please read [CONTRIBUTING.md](CONTRIBUTING.md) first.

Security-sensitive reports should follow [SECURITY.md](SECURITY.md).

## License

MIT — see [LICENSE](LICENSE).
