#!/bin/bash
set -e

echo "Starting unified Claude Code config initialization..."

# Optional override for installation command, for example:
# export CLAUDE_INSTALL_CMD='curl -fsSL https://claude.ai/install.sh | bash'
CLAUDE_INSTALL_CMD="${CLAUDE_INSTALL_CMD:-curl -fsSL https://claude.ai/install.sh | bash}"
SETTINGS_FILE="settings.json"

prompt_with_default() {
    local prompt="$1"
    local default_value="$2"
    local input
    read -r -p "${prompt} [${default_value}]: " input
    if [ -z "$input" ]; then
        printf '%s' "$default_value"
    else
        printf '%s' "$input"
    fi
}

prompt_secret_optional_keep() {
    local prompt="$1"
    local existing="$2"
    local input
    read -r -s -p "$prompt" input
    echo
    if [ -z "$input" ]; then
        printf '%s' "$existing"
    else
        printf '%s' "$input"
    fi
}

install_or_update_claude_cli() {
    # 1) Install or update latest Claude CLI
    if command -v claude >/dev/null 2>&1; then
        echo "Claude CLI detected. Attempting to update..."
        if claude update; then
            echo "Claude CLI updated successfully."
        else
            echo "Warning: 'claude update' failed."
            echo "You can reinstall with: ${CLAUDE_INSTALL_CMD}"
        fi
    else
        echo "Claude CLI not found. Installing with official command..."
        if eval "${CLAUDE_INSTALL_CMD}"; then
            echo "Claude CLI installation command completed."
        else
            echo "Warning: Automatic Claude CLI installation failed."
            echo "Run manually: ${CLAUDE_INSTALL_CMD}"
        fi
    fi
    
    if command -v claude >/dev/null 2>&1; then
        echo "Claude CLI ready: $(claude --version 2>/dev/null || echo 'version unavailable')"
    else
        echo "Warning: 'claude' command is still not available on PATH."
    fi
}

install_or_update_claude_cli

# 2) Interactively configure auth/base URL and optional models in settings.json
if [ -f "$SETTINGS_FILE" ] && command -v jq >/dev/null 2>&1; then
    if [ -t 0 ]; then
        echo "Configuring ${SETTINGS_FILE}..."
        
        current_token="$(jq -r '.env.ANTHROPIC_AUTH_TOKEN // ""' "$SETTINGS_FILE")"
        current_base_url="$(jq -r '.env.ANTHROPIC_BASE_URL // "https://coding.dashscope.aliyuncs.com/apps/anthropic"' "$SETTINGS_FILE")"
        current_model="$(jq -r '.env.ANTHROPIC_MODEL // ""' "$SETTINGS_FILE")"
        current_opus_model="$(jq -r '.env.ANTHROPIC_DEFAULT_OPUS_MODEL // ""' "$SETTINGS_FILE")"
        current_sonnet_model="$(jq -r '.env.ANTHROPIC_DEFAULT_SONNET_MODEL // ""' "$SETTINGS_FILE")"
        current_haiku_model="$(jq -r '.env.ANTHROPIC_DEFAULT_HAIKU_MODEL // ""' "$SETTINGS_FILE")"
        current_small_fast_model="$(jq -r '.env.ANTHROPIC_SMALL_FAST_MODEL // ""' "$SETTINGS_FILE")"
        
        new_base_url="$(prompt_with_default "ANTHROPIC_BASE_URL" "$current_base_url")"
        
        if [ -z "$current_token" ] || [ "$current_token" = "<YOUR_TOKEN>" ]; then
            while true; do
                read -r -s -p "ANTHROPIC_AUTH_TOKEN (required): " new_token
                echo
                if [ -n "$new_token" ]; then
                    break
                fi
                echo "Token cannot be empty."
            done
        else
            new_token="$(prompt_secret_optional_keep "ANTHROPIC_AUTH_TOKEN (press Enter to keep existing): " "$current_token")"
        fi
        
        echo "Optional model fields (press Enter to keep current value)."
        new_model="$(prompt_with_default "ANTHROPIC_MODEL" "$current_model")"
        new_opus_model="$(prompt_with_default "ANTHROPIC_DEFAULT_OPUS_MODEL" "$current_opus_model")"
        new_sonnet_model="$(prompt_with_default "ANTHROPIC_DEFAULT_SONNET_MODEL" "$current_sonnet_model")"
        new_haiku_model="$(prompt_with_default "ANTHROPIC_DEFAULT_HAIKU_MODEL" "$current_haiku_model")"
        new_small_fast_model="$(prompt_with_default "ANTHROPIC_SMALL_FAST_MODEL" "$current_small_fast_model")"
        
        tmp_file="$(mktemp)"
        jq \
        --arg token "$new_token" \
        --arg base_url "$new_base_url" \
        --arg model "$new_model" \
        --arg opus_model "$new_opus_model" \
        --arg sonnet_model "$new_sonnet_model" \
        --arg haiku_model "$new_haiku_model" \
        --arg small_fast_model "$new_small_fast_model" \
        '.env.ANTHROPIC_AUTH_TOKEN = $token
       | .env.ANTHROPIC_BASE_URL = $base_url
       | .env.ANTHROPIC_MODEL = $model
       | .env.ANTHROPIC_DEFAULT_OPUS_MODEL = $opus_model
       | .env.ANTHROPIC_DEFAULT_SONNET_MODEL = $sonnet_model
       | .env.ANTHROPIC_DEFAULT_HAIKU_MODEL = $haiku_model
        | .env.ANTHROPIC_SMALL_FAST_MODEL = $small_fast_model' \
        "$SETTINGS_FILE" > "$tmp_file"
        mv "$tmp_file" "$SETTINGS_FILE"
        echo "Updated ${SETTINGS_FILE}."
    else
        echo "Non-interactive shell detected. Skipping prompt-based ${SETTINGS_FILE} update."
    fi
else
    echo "Warning: ${SETTINGS_FILE} not found or jq is unavailable; skipping interactive configuration."
fi

# 3) Configure MCP servers via standalone script
if [ -f "setup-mcp.sh" ]; then
    bash "setup-mcp.sh"
else
    echo "Warning: setup-mcp.sh not found; skipping MCP setup."
fi

# 4) Restrict sensitive config permissions
chmod 600 settings.json 2>/dev/null || true

echo "Initialization complete. You can now run claude with a consistent environment."