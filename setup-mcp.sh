#!/bin/bash
set -e

# Configure MCP directly in this script.
# Add new entries in install_default_mcp_servers.

########################################
# MCP LIST (edit here)
########################################
install_default_mcp_servers() {
    echo "Configuring MCP servers from setup-mcp.sh..."
    
    # Add URL MCP: add_url_mcp "name" "transport" "url" [scope]
    # Add CMD MCP: add_cmd_mcp "name" "transport" "scope" "cmd" "arg1" ...
    
    # https://code.claude.com/docs/zh-CN/mcp#流行的-mcp-servers
    add_url_mcp \
    "context7" \
    "http" \
    "https://mcp.context7.com/mcp" || true
    
    # https://wohu.antgroup-inc.cn/mcp/mcp/s/mcp.ant.faas.skylarkmcpserver.skylarkmcpserver
    add_cmd_mcp \
    "faas-skylarkmcpserver-skylarkmcpserver" \
    "STREAMABLE_HTTP" \
    "user" \
    "utoo-proxy" \
    "https://mcpgwoffice-prod.alipay.com/mcpgw/v1/shttpproxy/message/MAIN_CHAIR_mcp.ant.faas.skylarkmcpserver.skylarkmcpserver" || true
    
    # https://wohu.antgroup-inc.cn/mcp/mcp/s/mcp.ant.arkai.dimamcpserver
    add_cmd_mcp \
    "arkai-dimamcpserver" \
    "SSE" \
    "user" \
    "utoo-proxy" \
    "https://mcpnexus-prod.alipay.com/sse?serverCode=mcp.ant.arkai.dimamcpserver" || true
    
    # https://wohu.antgroup-inc.cn/mcp/mcp/s/mcp.ant.antcodemcp.code.mcpserver_beta
    add_cmd_mcp \
    "antcodemcp-code-mcpserver_beta" \
    "SSE" \
    "user" \
    "utoo-proxy" \
    "https://mcpnexus-prod.alipay.com/sse?serverCode=mcp.ant.antcodemcp.code.mcpserver_beta" || true
}

########################################
# MCP HELPERS (do not edit unless needed)
########################################

add_url_mcp() {
    local name="$1"
    local transport="$2"
    local target_url="$3"
    local scope="${4:-}"
    
    if [ -z "$name" ] || [ -z "$transport" ] || [ -z "$target_url" ]; then
        echo "Warning: Invalid URL MCP config; skipped."
        return 1
    fi
    
    local cmd=(claude mcp add --transport "$transport")
    if [ -n "$scope" ]; then
        cmd+=( -s "$scope" )
    fi
    cmd+=( "$name" "$target_url" )
    
    echo "Adding URL MCP: ${name} (transport=${transport}, scope=${scope:-default})"
    if "${cmd[@]}"; then
        echo "MCP server added: ${name}"
        return 0
    fi
    
    echo "Warning: Failed to add MCP server '${name}'."
    return 1
}

add_cmd_mcp() {
    local name="$1"
    local transport="$2"
    local scope="$3"
    shift 3
    local target_cmd=("$@")
    
    if [ -z "$name" ] || [ -z "$transport" ] || [ "${#target_cmd[@]}" -eq 0 ]; then
        echo "Warning: Invalid command MCP config; skipped."
        return 1
    fi
    
    local cmd=(claude mcp add)
    if [ -n "$scope" ]; then
        cmd+=( -s "$scope" )
    fi
    cmd+=( "$name" -- "${target_cmd[@]}" -t "$transport" )
    
    echo "Adding CMD MCP: ${name} (transport=${transport}, scope=${scope:-default})"
    if "${cmd[@]}"; then
        echo "MCP server added: ${name}"
        return 0
    fi
    
    echo "Warning: Failed to add MCP server '${name}'."
    return 1
}

main() {
    if ! command -v claude >/dev/null 2>&1; then
        echo "Warning: 'claude' command not found; skipping MCP setup."
        return
    fi
    
    install_default_mcp_servers
}

main
