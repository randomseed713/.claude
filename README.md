# .claude

This repository is designed to be used directly as your home directory Claude config folder at ~/.claude.

For Chinese documentation, see [README.zh-CN.md](README.zh-CN.md).

## Goal

Keep Claude Code settings in Git so you can clone once and use the same behavior across machines.

## Deploy on a new machine

1. Backup existing config if present:

	 mv ~/.claude ~/.claude.bak 2>/dev/null || true

2. Clone this repository as ~/.claude:

	 git clone https://github.com/randomseed713/.claude.git ~/.claude

3. Initialize:

	 cd ~/.claude
	 bash setup.sh

## Enabled Plugins

These plugins are enabled in `settings.json`:

| Plugin | Description |
|--------|-------------|
| everything-claude-code | Agents, skills, hooks, commands, rules, and MCP configurations |
| claude-hud | Status line display for Claude Code |
| superpowers | Workflow skills for brainstorming, planning, TDD, debugging, code review |
| clangd-lsp | C/C++ language server |
| pyright-lsp | Python language server |

## Enabled MCP Servers

| MCP Server | Description |
|------------|-------------|
| context7 | Live documentation lookup |
| faas-skylarkmcpserver | Skylark MCP server (internal) |
| arkai-dimamcpserver | Dima MCP server (internal) |
| antcodemcp-code-mcpserver | AntCode MCP server (internal) |

