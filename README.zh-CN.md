# .claude

这个仓库的设计目标是：直接作为你home目录下的 ~/.claude 使用。

对应英文文档见 [README.md](README.md)。

## 目标

将 Claude Code 配置放入 Git 管理，实现一次配置、多机同步、行为一致。

## 在新环境部署

1. 备份已有配置（如存在）：

   mv ~/.claude ~/.claude.bak 2>/dev/null || true

2. 克隆仓库到 ~/.claude：

   git clone https://github.com/randomseed713/.claude.git ~/.claude

3. 执行初始化：

   cd ~/.claude
   bash setup.sh

## 已启用的插件

以下插件在 `settings.json` 中已启用：

| 插件 | 描述 |
|------|------|
| everything-claude-code | Agents、skills、hooks、commands、rules 和 MCP 配置集合 |
| claude-hud | Claude Code 状态栏显示 |
| superpowers | 头脑风暴、规划、TDD、调试、代码审查等工作流技能 |
| clangd-lsp | C/C++ 语言服务器 |
| pyright-lsp | Python 语言服务器 |

## 已启用的 MCP 服务器

| MCP 服务器 | 描述 |
|------------|------|
| context7 | 实时文档查询 |
| faas-skylarkmcpserver | Skylark（语雀） MCP 服务器（内部） |
| arkai-dimamcpserver | Dima MCP 服务器（内部） |
| antcodemcp-code-mcpserver | AntCode MCP 服务器（内部） |
