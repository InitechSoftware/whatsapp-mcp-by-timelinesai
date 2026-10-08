# WhatsApp MCP by TimelinesAI

> **Full-blown MCP server — every workspace action exposed to your AI assistant.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![MCP](https://img.shields.io/badge/Model%20Context%20Protocol-1.0-blue)](https://modelcontextprotocol.io)
[![Works with Claude](https://img.shields.io/badge/Works%20with-Claude-orange)](https://claude.ai)
[![Works with Cursor](https://img.shields.io/badge/Works%20with-Cursor-black)](https://cursor.com)
[![smithery badge](https://smithery.ai/badge/tools-3uci/timelinesai-whatsapp)](https://smithery.ai/servers/tools-3uci/timelinesai-whatsapp)

Drive your **TimelinesAI WhatsApp inbox** from Claude, Cursor, Claude Code, or any MCP-compatible client. List chats, read history, send messages, react, label, assign teammates, check quotas — all 34 tools, all as **you**, for both regular WhatsApp numbers and WhatsApp Business API (WABA) numbers.

---

## What is this?

The TimelinesAI MCP server is a remote control for your real WhatsApp inbox inside [TimelinesAI](https://timelines.ai). Connect once via OAuth, then your AI assistant gains 34 tools across **chat discovery**, **messaging**, **triage** (labels + assignments), and **workspace introspection** — for both regular WhatsApp numbers (connected by QR code) and **WhatsApp Business API (WABA)** numbers.

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

### Claude Code (plugin)

Prefer one-step install via the TimelinesAI plugin marketplace:

```bash
/plugin marketplace add InitechSoftware/whatsapp-mcp-by-timelinesai
/plugin install timelinesai-whatsapp@timelinesai
```

This auto-wires the MCP server — no manual config. A browser tab opens on first use for OAuth. Update later with `/plugin marketplace update timelinesai`.

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

## Tool catalog (34 tools)

Two parallel sets of tools — one for **regular WhatsApp numbers** connected by QR code, one for **WhatsApp Business API (WABA)** numbers — plus three workspace tools shared by both. Use the set that matches the number: `workspace_whatsapp_accounts` lists QR numbers, `waba_accounts` lists WABA numbers.

| Group | Tools |
|---|---|
| Workspace (shared) | 3 |
| WhatsApp — QR-connected numbers | 14 |
| WhatsApp Business API (WABA) | 17 |
| **Total** | **34** |

### Workspace — 3 tools

Read-only introspection. Cheap to call. Shared by both sets.

| Tool | Purpose |
|---|---|
| `workspace_quotas` | Current plan, seats, messaging + API call quotas, billing period |
| `workspace_whatsapp_accounts` | Connected QR WhatsApp accounts (id, phone, owner, status) |
| `workspace_team` | Teammates, roles, invitation status, account bindings — use for assign emails in both sets |

### WhatsApp (QR-connected numbers) — 14 tools

#### Chat discovery + inspection — 4 tools

Browse and read. No writes.

| Tool | Purpose |
|---|---|
| `list_chats` | Filter chats by status, labels, assignee, group/direct, phone, name, dates, WA account — paginated 50/page |
| `chat_details` | Full metadata for a single chat |
| `chat_history` | List messages in a chat — filter by date and direction, page with message-UID cursors |
| `message_details` | Inspect a single message |

#### Messaging writes — 4 tools

**Quota-consuming.** Same monthly messaging budget as the TimelinesAI UI.

| Tool | Purpose |
|---|---|
| `chat_send_message` | Send a message (text, attachment, or reply) in an existing chat |
| `whatsapp_account_send_message` | Send a message to any phone via a specific WA account (creates chat if none exists — cold send) |
| `message_reply` | Threaded reply to a specific message |
| `message_react` | Set or clear an emoji reaction on a message |

#### Chat mutations — 6 tools

State + triage operations on chats. Idempotent label and assign ops.

| Tool | Purpose |
|---|---|
| `chat_open` | Reopen a closed chat |
| `chat_close` | Close a chat |
| `chat_assign` | Assign chat to a teammate by email (use `workspace_team` to discover emails) |
| `chat_unassign` | Unassign current responsible teammate |
| `chat_set_label` | Add a label to a chat |
| `chat_remove_label` | Remove a label from a chat |

### WhatsApp Business API (WABA) — 17 tools

#### Accounts + chat discovery — 5 tools

Browse and read. No writes.

| Tool | Purpose |
|---|---|
| `waba_accounts` | WABA numbers you can send from — use `id` as `waba_account_id` |
| `waba_list_chats` | WABA chats you can see — filter by open/closed, assignee, WABA account, phone; 50/page. Check `service_window_is_open` before sending |
| `waba_chat_details` | One WABA chat: service window, assignment, labels, WABA account |
| `waba_chat_history` | Messages in a WABA chat, newest first — filter by date and direction, page with message-UID cursors |
| `waba_message_details` | Inspect one WABA message; failed sends include `failure_reason` |

#### Templates — 2 tools

| Tool | Purpose |
|---|---|
| `waba_templates` | Message templates you can use, 50/page. Only `APPROVED` templates can be sent |
| `waba_template_details` | One template's components, status, and the WABA accounts it can be sent from. Call before any template send |

#### Messaging writes — 4 tools

**Template sends incur a Meta charge.** Free text only works while the chat's service window is open.

| Tool | Purpose |
|---|---|
| `waba_start_chat` | Start a new chat with a phone number using an approved template. Meta charge |
| `waba_chat_send_message` | Free-text message in an existing WABA chat — only while `service_window_is_open` is true |
| `waba_chat_send_template` | Send an approved template in an existing WABA chat — the way to message when the service window is closed. Meta charge |
| `waba_message_react` | Set or clear an emoji reaction on a WABA message |

#### Chat mutations — 6 tools

State + triage operations on WABA chats. After any mutation, `waba_chat_details` returns the authoritative state.

| Tool | Purpose |
|---|---|
| `waba_chat_open` | Reopen a closed WABA chat |
| `waba_chat_close` | Close a WABA chat |
| `waba_chat_assign` | Assign a WABA chat to a teammate by email (from `workspace_team`) |
| `waba_chat_unassign` | Clear the WABA chat's assignee |
| `waba_chat_set_label` | Add a label, keeping existing labels |
| `waba_chat_remove_label` | Remove one label, keeping the others; no-op if the label isn't on the chat |

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
- **WABA template messages are charged by Meta.** `waba_start_chat` and `waba_chat_send_template` send approved templates, which Meta bills for. Free-text `waba_chat_send_message` only works while the chat's service window is open.
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
