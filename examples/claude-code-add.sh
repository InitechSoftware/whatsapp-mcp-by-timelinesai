#!/usr/bin/env bash
# Register the TimelinesAI MCP server with Claude Code.
# Run once. Restart Claude Code after. Browser tab opens on first tool use for OAuth.

claude mcp add timelinesai -- \
  npx -y mcp-remote@latest \
  https://mcp.services.timelines.ai/mcp \
  --host 127.0.0.1
