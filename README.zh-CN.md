# .claude

**中文** | [English](README.md)

我个人的 [Claude Code](https://docs.anthropic.com/en/docs/claude-code) 配置、自定义命令与智能体，专为沉浸式编程（vibe coding）而优化。

## 包含内容

- **配置（Settings）** – 个人 Claude Code 配置文件（`settings.json`、快捷键等）
- **命令（Commands）** – 可复用的斜杠命令，加速日常开发任务
- **智能体（Agents）** – 用于特定工作流的自定义子智能体定义

## 环境要求

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code)（推荐使用最新版本）

## 安装

> **注意：** 以下步骤会替换你现有的 `~/.claude` 目录，请务必提前备份。

```bash
# 1. 备份当前 Claude 配置
mv ~/.claude ~/.claude.bak

# 2. 将本仓库克隆到 ~/.claude
git clone https://github.com/randomseed713/.claude.git ~/.claude
```

完成！下次打开 Claude Code 时，它会自动加载新的配置、命令和智能体。

## 更新

```bash
cd ~/.claude
git pull
```

## 恢复原始配置

如果你想恢复到之前的配置：

```bash
rm -rf ~/.claude
mv ~/.claude.bak ~/.claude
```

## 许可证

[MIT](LICENSE) © 2026 randomseed713
