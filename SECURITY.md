# Security Policy

## Reporting a vulnerability

Please do not post credentials, auth tokens, private repository names, personal filesystem paths, or other sensitive information in a public issue.

If GitHub Private Vulnerability Reporting is enabled for this repository, use it for security-sensitive reports. Otherwise, open a minimal public issue asking the maintainer for a private reporting channel without including exploit details.

## Scope

Useful reports include issues involving:

- unintended session selection or automatic resumption;
- command or argument injection;
- unsafe local file permissions;
- insecure handling of the Codex control socket;
- installation behavior that could execute unexpected remote content;
- privilege escalation or unexpected macOS permission requirements;
- accidental exposure of authentication material or private session content.

## Design expectations

The project should continue to follow these principles:

- explicit session opt-in;
- no silent software installation from background jobs;
- no Accessibility or AppleScript dependency;
- no `codex exec resume` fallback;
- local-only watcher state;
- fail closed when the rate-limit state cannot be safely determined.
