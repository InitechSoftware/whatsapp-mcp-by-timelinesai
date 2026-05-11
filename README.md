# WhatsApp MCP by TimelinesAI

> **Full-blown MCP server — every workspace action exposed to your AI assistant.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![MCP](https://img.shields.io/badge/Model%20Context%20Protocol-1.0-blue)](https://modelcontextprotocol.io)
[![Works with Claude](https://img.shields.io/badge/Works%20with-Claude-orange)](https://claude.ai)
[![Works with Cursor](https://img.shields.io/badge/Works%20with-Cursor-black)](https://cursor.com)

Drive your **TimelinesAI WhatsApp inbox** from Claude, Cursor, Claude Code, or any MCP-compatible client. List chats, read history, send messages, react, label, assign teammates, check quotas — all 18 tools, all as **you**, all on the same quota the TimelinesAI UI uses.

---

## What is this?

The TimelinesAI MCP server is a remote control for your real WhatsApp inbox inside [TimelinesAI](https://timelines.ai). Connect once via OAuth, then your AI assistant gains 18 tools across **chat discovery**, **messaging**, **triage** (labels + assignments), and **workspace introspection**.

No sandbox. Writes are real and visible to your contacts. Recipients cannot tell whether a message came from the UI or from an AI assistant — it's all just you.

## Requirements

- A working **TimelinesAI production account** with **at least one connected WhatsApp account** in your workspace. Without a connected WA, most tools will return empty or error — the MCP is a remote control for your real inbox, not a sandbox.
- **Node.js 18+** locally (Cursor / Claude Desktop / Claude Code use `npx` to launch the `mcp-remote` proxy).

Don't have a TimelinesAI account yet? **[Sign up free →](https://app.timelines.ai/register/?utm_source=github&utm_medium=mcp_directory&utm_campaign=mcp_launch&utm_content=readme_requirements)**

---

## Quick setup (~1 min)

### Claude Code (CLI)

```bash
claude mcp add timelinesai -- npx -y mcp-remote@latest https://mcp.services.timelines.ai/mcp --host 127.0.0.1
```

Restart Claude Code. A browser tab will open on first use — log in with your TimelinesAI account to authorize. Done.

### Cursor

Edit `~/.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "timelinesai": {
      "command": "npx",
      "args": [
        "-y",
        "mcp-remote@latest",
        "https://mcp.services.timelines.ai/mcp",
        "--host", "127.0.0.1"
      ]
    }
  }
}
```

Restart Cursor.

### Claude Desktop

Open **Settings → Developer → Edit Config** and add:

```json
{
  "mcpServers": {
    "timelinesai": {
      "command": "npx",
      "args": [
        "-y",
        "mcp-remote@latest",
        "https://mcp.services.timelines.ai/mcp",
        "--host", "127.0.0.1"
      ]
    }
  }
}
```

**Fully quit** Claude Desktop (not just close the window) and reopen. A browser tab will open for OAuth on first use.

> See [`examples/`](examples/) for ready-to-copy config snippets per client.

---

## First thing to try

After your client restarts, ask it:

> *"What tools does the timelinesai MCP server expose? Group them by purpose and give me one example prompt per group."*

That gives you a personalized tour of what's available without reading any docs.

---

## Tool catalog (18 tools)

### Workspace meta — 3 tools

Read-only introspection. Cheap to call.

| Tool | Purpose |
|---|---|
| `workspace_quotas` | Current plan, seats, messaging + API call quotas, billing period |
| `workspace_whatsapp_accounts` | Connected WhatsApp accounts (id, phone, owner, status) |
| `workspace_team` | Teammates, roles, invitation status, account bindings |

### Chat discovery + inspection — 5 tools

Browse and read. No writes.

| Tool | Purpose |
|---|---|
| `list_chats` | Filter chats by status, labels, assignee, group/direct, phone, name, dates, WA account — paginated 50/page |
| `chat_details` | Full metadata for a single chat |
| `chat_history` | Conversation context window around a specific message |
| `get_chat_messages` | Page through messages in a chat |
| `message_details` | Inspect a single message |

### Messaging writes — 4 tools

**Quota-consuming.** Same monthly messaging budget as the TimelinesAI UI.

| Tool | Purpose |
|---|---|
| `chat_send_message` | Send a message (text, attachment, or reply) in an existing chat |
| `whatsapp_account_send_message` | Send a message to any phone via a specific WA account (creates chat if none exists — cold send) |
| `message_reply` | Threaded reply to a specific message |
| `message_react` | Set or clear an emoji reaction on a message |

### Chat mutations — 6 tools

State + triage operations on chats. Idempotent label and assign ops.

| Tool | Purpose |
|---|---|
| `chat_open` | Reopen a closed chat |
| `chat_close` | Close a chat |
| `chat_assign` | Assign chat to a teammate by email (use `workspace_team` to discover emails) |
| `chat_unassign` | Unassign current responsible teammate |
| `chat_set_label` | Add a label to a chat |
| `chat_remove_label` | Remove a label from a chat |

→ Full schemas and example prompts: [`docs/tools.md`](docs/tools.md)

---

## How authentication works

The server uses OAuth via the [`mcp-remote`](https://www.npmjs.com/package/mcp-remote) proxy. On first connection, your browser opens to `mcp.services.timelines.ai` — log in to your TimelinesAI account to authorize. Token is cached locally by `mcp-remote`; subsequent sessions reconnect without prompting.

On machines that already have an active TimelinesAI session (e.g. you're logged in to TimelinesAI in your default browser, or you've previously authorized the MCP via the Claude.ai integration), authorization may complete silently with no browser prompt.

Every action runs **as you** — your role's permissions in TimelinesAI apply to MCP calls exactly as they apply to UI actions.

---

## Safety + production behavior

> ⚠️ **This MCP server controls a real WhatsApp inbox.** Read this section before sending writes.

- **Messages sent via MCP are indistinguishable from messages sent in the UI.** Recipients cannot tell.
- **Writes are real and immediate.** No undo. Confirm before bulk actions.
- **Quota is shared** with UI usage — MCP messages draw from the same monthly messaging budget. Call `workspace_quotas` to see headroom.
- **No sandbox mode.** Practice on your own number first if you're unsure.
- **Without a connected WhatsApp account**, most tools return empty results or errors. Connect a WA account in TimelinesAI first.

---

## Get started

1. **[Sign up for TimelinesAI →](https://app.timelines.ai/register/?utm_source=github&utm_medium=mcp_directory&utm_campaign=mcp_launch&utm_content=readme_cta)**
2. Connect a WhatsApp account in the TimelinesAI dashboard.
3. Pick your client above (Claude Code, Cursor, or Claude Desktop) and paste the config.
4. Restart, authorize, ask your assistant what it can do.

---

## Links

- **TimelinesAI** — [timelines.ai](https://timelines.ai)
- **Sign up** — [app.timelines.ai/register](https://app.timelines.ai/register/?utm_source=github&utm_medium=mcp_directory&utm_campaign=mcp_launch&utm_content=readme_links)
- **MCP server endpoint** — `https://mcp.services.timelines.ai/mcp`
- **Model Context Protocol** — [modelcontextprotocol.io](https://modelcontextprotocol.io)
- **`mcp-remote` proxy** — [npm](https://www.npmjs.com/package/mcp-remote)
- **Issues / feedback** — [open an issue](../../issues) in this repo

---

## License

[MIT](LICENSE) © 2026 Initech Software / TimelinesAI
