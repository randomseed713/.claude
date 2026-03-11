# .claude

[中文文档](README.zh-CN.md) | **English**

My personal [Claude Code](https://docs.anthropic.com/en/docs/claude-code) settings, custom commands, and agents optimised for vibe coding.

## What's included

- **Settings** – personal Claude Code configuration (`settings.json`, key-bindings, etc.)
- **Commands** – reusable slash-commands that speed up everyday tasks
- **Agents** – custom sub-agent definitions for specialised workflows

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) (latest version recommended)

## Installation

> **Note:** These steps will replace your existing `~/.claude` directory. Make sure you back it up first.

```bash
# 1. Back up your current Claude settings
mv ~/.claude ~/.claude.bak

# 2. Clone this repository into ~/.claude
git clone https://github.com/randomseed713/.claude.git ~/.claude
```

That's it — the next time you open Claude Code it will pick up the new settings, commands, and agents automatically.

## Updating

```bash
cd ~/.claude
git pull
```

## Restoring your original settings

If you ever want to go back to your previous configuration:

```bash
rm -rf ~/.claude
mv ~/.claude.bak ~/.claude
```

## License

[MIT](LICENSE) © 2026 randomseed713
