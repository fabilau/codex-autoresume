# Troubleshooting

## Start with status

```bash
codex-session-watch status
```

## The managed Codex App Helper is missing

Run an interactive command:

```bash
codex-session-watch select
```

The watcher will offer to install the daemon-only managed Codex package.

Expected helper path:

```text
~/.codex/packages/app-server-daemon/current/bin/codex
```

## Remote-control socket is not ready

Try:

```bash
codex-session-watch daemon-start
codex-session-watch status
```

The expected socket is:

```text
~/.codex/app-server-control/app-server-control.sock
```

## No projects or sessions appear

Confirm that Codex has non-archived interactive sessions under the same `CODEX_HOME` used by the watcher.

If you use a custom Codex home:

```bash
CODEX_HOME=/path/to/codex-home codex-session-watch select
```

## The watcher does not resume a session

Run:

```bash
codex-session-watch once
```

The watcher resumes a selected session only when:

- the thread is selected;
- its latest turn failed because of `usageLimitExceeded`;
- the app server reports ordinary usage is available.

## launchd errors

```bash
cat "$HOME/Library/Logs/CodexSessionWatch/launchd.stderr.log"
```

## Main log

```bash
codex-session-watch logs
```

## Reset the selection

```bash
codex-session-watch select
```

Choose each project and select `none`, or remove the selection file manually:

```bash
: > "$HOME/.local/state/codex-session-watch/selected-threads.txt"
codex-session-watch restart
```
