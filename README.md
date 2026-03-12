# .claude

> 直接作为 `~/.claude` 使用，实现一次配置、多机同步。

## 快速部署

```bash
# 1. 备份已有配置
mv ~/.claude.json ~/.claude.json.bak 2>/dev/null || true
mv ~/.claude ~/.claude.bak 2>/dev/null || true

# 2. 克隆仓库
git clone https://github.com/randomseed713/.claude.git ~/.claude

# 3. 初始化
cd ~/.claude && bash setup.sh
```
