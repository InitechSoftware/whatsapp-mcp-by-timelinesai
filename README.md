# WhatsApp MCP by TimelinesAI

> **Run your team's WhatsApp inbox from Claude, ChatGPT, Cursor or any AI assistant.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![MCP](https://img.shields.io/badge/Model%20Context%20Protocol-1.0-blue)](https://modelcontextprotocol.io)
[![Works with Claude](https://img.shields.io/badge/Works%20with-Claude-orange)](https://claude.ai)
[![Works with ChatGPT](https://img.shields.io/badge/Works%20with-ChatGPT-10a37f)](https://chatgpt.com/plugins/plugin_asdk_app_6a26d97bd46081918642a70d07cf07d4)
[![Works with Cursor](https://img.shields.io/badge/Works%20with-Cursor-black)](https://cursor.com)
[![smithery badge](https://smithery.ai/badge/tools-3uci/timelinesai-whatsapp)](https://smithery.ai/servers/tools-3uci/timelinesai-whatsapp)

Connect your **TimelinesAI WhatsApp inbox** to Claude, ChatGPT, Cursor, Codex, Grok or any MCP client. Ask what needs a reply, then reply, react, label and assign chats from a prompt. 60+ tools, all running as **you**: read and reply to chats, manage labels, notes and quick replies, set up webhooks, invite teammates and pull WABA analytics, for both regular WhatsApp numbers and WhatsApp Business API (WABA) numbers.

**Included in every TimelinesAI plan at no extra charge.** [Website](https://timelines.ai/whatsapp-mcp?utm_source=github&utm_medium=mcp_directory&utm_campaign=mcp_launch&utm_content=readme_top) · [Setup guide](https://timelines.ai/whatsapp-mcp-guide) · [MCP Academy](https://timelines.ai/academy/mcp)

---

## What is this?

The TimelinesAI MCP server is a remote control for your real WhatsApp inbox inside [TimelinesAI](https://timelines.ai). Connect once with your TimelinesAI login, then your AI assistant gains 60+ tools across **chat discovery**, **messaging**, **triage** (labels, assignments, notes, read/unread, AI autoresponse), **quick replies**, **webhooks**, **team management**, **message insights**, **WABA analytics**, **phone-code pairing** and **workspace introspection**, for both regular WhatsApp numbers (connected by QR code) and **WhatsApp Business API (WABA)** numbers.

It's a hosted server: nothing to install, no API keys. Your assistant connects to `https://mcp.services.timelines.ai/mcp` and you sign in once.

No sandbox. Writes are real and visible to your contacts. Recipients cannot tell whether a message came from the UI or from an AI assistant: it's all just you.

## Requirements

- A **TimelinesAI account** with **at least one connected WhatsApp number** in your workspace. Without a connected number, most tools return empty results or errors. The MCP is a remote control for your real inbox, not a sandbox.
- An AI assistant that supports remote MCP servers (all the clients below do).

Don't have a TimelinesAI account yet? **[Start a 10-day free trial →](https://app.timelines.ai/register/?utm_source=github&utm_medium=mcp_directory&utm_campaign=mcp_launch&utm_content=readme_requirements)**

---

## Quick setup (~1 min)

Server URL for every client: `https://mcp.services.timelines.ai/mcp`

### ChatGPT

Open the **[TimelinesAI plugin in ChatGPT](https://chatgpt.com/plugins/plugin_asdk_app_6a26d97bd46081918642a70d07cf07d4)**, click **Connect** and sign in with your TimelinesAI account. Then ask: *"@TimelinesAI what needs me today?"*

### Claude (claude.ai and Claude Desktop)

In Claude, open **Customize → Connectors → Add custom connector**, paste the server URL and sign in with your TimelinesAI account.

### Claude Code

```bash
claude mcp add --transport http timelinesai https://mcp.services.timelines.ai/mcp
```

Claude Code opens a browser tab the first time a tool is used. Sign in with your TimelinesAI account.

Prefer a plugin? `/plugin marketplace add InitechSoftware/whatsapp-mcp-by-timelinesai`, then `/plugin install timelinesai-whatsapp@timelinesai`. The plugin launches a local proxy, so it needs **Node.js 18+**; the command above doesn't.

### Cursor

**[Add to Cursor](cursor://anysphere.cursor-deeplink/mcp/install?name=timelinesai&config=eyJ1cmwiOiJodHRwczovL21jcC5zZXJ2aWNlcy50aW1lbGluZXMuYWkvbWNwIn0%3D)** (one click), or add this to `~/.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "timelinesai": {
      "url": "https://mcp.services.timelines.ai/mcp"
    }
  }
}
```

The sign-in window opens on the first tool call.

### Codex

Add to `~/.codex/config.toml`:

```toml
[mcp_servers.timelinesai]
url = "https://mcp.services.timelines.ai/mcp"
```

Then run `codex mcp login timelinesai` once and approve in the browser. Codex doesn't start the sign-in on its own.

### Grok Build

```bash
grok mcp add timelinesai https://mcp.services.timelines.ai/mcp
```

Then type `/mcps`, select **timelinesai** and press **`i`** to sign in. Grok Build doesn't start the sign-in on its own.

### Any other MCP client

Add `https://mcp.services.timelines.ai/mcp` as a remote server (Streamable HTTP) and sign in when prompted.

> See [`examples/`](examples/) for ready-to-copy config files.

---

## First thing to try

After connecting, ask your assistant:

> *"What needs me today?"*

or, for a tour:

> *"What tools does the timelinesai MCP server expose? Group them by purpose and give me one example prompt per group."*

---

## Tool catalog (66 tools)

Two parallel sets of tools (one for **regular WhatsApp numbers** connected by QR code, one for **WhatsApp Business API (WABA)** numbers) plus workspace, quick-reply and webhook tools shared by both. Use the set that matches the number you are working with.

| Group | Tools |
|---|---|
| Workspace and team (shared) | 7 |
| Quick replies (shared) | 5 |
| Webhooks (shared) | 5 |
| WhatsApp: QR-connected numbers | 24 |
| WhatsApp Business API (WABA) | 25 |
| **Total** | **66** |

> **Connected before 11 Nov 2026?** Webhooks, quick-reply editing and invitations need extra permissions. Disconnect and reconnect the MCP once to get them. If one of these tools returns 401 or 403, reconnecting is the first fix.

### Workspace and team: 7 tools

Shared by both sets. Everything except `workspace_invite` and `workspace_invitation_revoke` is read-only.

| Tool | Purpose |
|---|---|
| `workspace_quotas` | Current plan, seats, messaging + API call quotas, billing period |
| `workspace_whatsapp_accounts` | Connected QR WhatsApp accounts (id, phone, owner, status) |
| `workspace_team` | Teammates, roles, invitation status, account bindings. Use for assign emails in both sets |
| `workspace_me` | Who this connection is signed in as: user, role and team. Check before invites or revokes |
| `workspace_invite` | Invite someone to the workspace by email, with role and team. Needs admin rights. Re-sends a pending invite |
| `workspace_invitation_revoke` | Revoke a pending invitation. Needs admin rights |
| `get_more_tools` | Ask the server for additional tools that fit a goal |

### Quick replies: 5 tools

Saved text replies your team uses in WhatsApp chats (shown as Templates in the app). These are not WABA message templates. Visibility can be private, public or read-only.

| Tool | Purpose |
|---|---|
| `quick_reply_list` | List quick replies, newest-edited first |
| `quick_reply_details` | One quick reply, including its text |
| `quick_reply_create` | Save a new quick reply with a name, text, visibility and optional team |
| `quick_reply_update` | Change name, text, visibility or team |
| `quick_reply_delete` | Delete a quick reply for everyone it is shared with |

### Webhooks: 5 tools

Subscribe your own URL to workspace events (messages, chats, calls, WhatsApp accounts, WABA messages and templates). The endpoint must answer 2xx within 5 seconds. Payload shapes: [webhooks guide](https://timelines.ai/docs/guides/webhooks).

| Tool | Purpose |
|---|---|
| `webhook_list` | Subscriptions with URL, event type, enabled flag and consecutive failure count |
| `webhook_details` | One webhook by id |
| `webhook_create` | Subscribe a URL to an event type. Idempotent per URL plus event type |
| `webhook_update` | Change URL or event type, or pause and resume deliveries |
| `webhook_delete` | Remove a subscription for good |

### WhatsApp (QR-connected numbers): 24 tools

#### Chat discovery + inspection: 6 tools

Browse and read. No writes.

| Tool | Purpose |
|---|---|
| `list_chats` | Filter chats by status, labels, assignee, group/direct, phone, name, dates, WA account. Paginated 50/page |
| `chat_details` | Full metadata for a single chat |
| `chat_history` | List messages in a chat. Filter by date and direction, page with message-UID cursors |
| `message_details` | Inspect a single message |
| `message_status_history` | Sending timeline of one message: when it was sent, delivered and read |
| `message_reactions` | Who reacted to a message and with which emoji |

#### Messaging writes: 5 tools

**Quota-consuming.** Same monthly messaging budget as the TimelinesAI UI.

| Tool | Purpose |
|---|---|
| `chat_send_message` | Send a message (text, attachment, or reply) in an existing chat |
| `whatsapp_account_send_message` | Send a message to any phone via a specific WA account (creates the chat if none exists: a cold send) |
| `message_reply` | Threaded reply to a specific message |
| `message_react` | Set or clear an emoji reaction on a message |
| `file_upload_from_url` | Store a file from a public URL and get a `file_uid` to send as an attachment |

#### Chat mutations: 11 tools

State + triage operations on chats. Idempotent label and assign ops.

| Tool | Purpose |
|---|---|
| `chat_open` | Reopen a closed chat |
| `chat_close` | Close a chat |
| `chat_assign` | Assign chat to a teammate by email (use `workspace_team` to discover emails) |
| `chat_unassign` | Unassign current responsible teammate |
| `chat_set_label` | Add a label to a chat |
| `chat_remove_label` | Remove a label from a chat |
| `chat_rename` | Rename the chat in TimelinesAI and synced CRMs |
| `chat_mark_read` | Mark the chat read in the shared inbox (the contact is not told) |
| `chat_mark_unread` | Mark the chat unread in the shared inbox |
| `chat_set_ai_autoresponse` | Turn the AI auto-reply on or off for this chat |
| `chat_add_note` | Add an internal note, visible to teammates only, never sent to the contact |

#### Connect a number: 2 tools

| Tool | Purpose |
|---|---|
| `whatsapp_account_start_phone_pairing` | Start linking a WhatsApp number by phone code, no QR scan. Needs the `accounts:write` permission |
| `whatsapp_account_phone_pairing_status` | Read the pairing state and the 8-character code to enter in WhatsApp > Linked devices |

### WhatsApp Business API (WABA): 25 tools

#### Accounts + chat discovery: 8 tools

Browse and read. No writes.

| Tool | Purpose |
|---|---|
| `waba_accounts` | WABA numbers you can send from. Use `id` as `waba_account_id` |
| `waba_account_details` | One WABA account: status, owner, display phone number, Meta ids |
| `waba_list_chats` | WABA chats you can see. Filter by open/closed, assignee, WABA account, phone; 50/page. Check `service_window_is_open` before sending |
| `waba_chat_details` | One WABA chat: service window, assignment, labels, WABA account |
| `waba_chat_history` | Messages in a WABA chat, newest first. Filter by date and direction, page with message-UID cursors |
| `waba_message_details` | Inspect one WABA message; failed sends include `failure_reason` |
| `waba_message_status_history` | Sending timeline of one WABA message; a failed step carries Meta's failure reason |
| `waba_message_reactions` | Who reacted to a WABA message and with which emoji |

#### Analytics: 2 tools

| Tool | Purpose |
|---|---|
| `waba_account_analytics` | Sent and delivered messages per day over a date range, with optional breakdown by country, pricing category or pricing type. Covers the whole WhatsApp Business Account |
| `waba_account_analytics_result` | Fetch an analytics result that was still pending |

#### Templates: 2 tools

| Tool | Purpose |
|---|---|
| `waba_templates` | Message templates you can use, 50/page. Only `APPROVED` templates can be sent |
| `waba_template_details` | One template's components, status, and the WABA accounts it can be sent from. Call before any template send |

#### Messaging writes: 4 tools

**Template sends incur a Meta charge.** Free text only works while the chat's service window is open.

| Tool | Purpose |
|---|---|
| `waba_start_chat` | Start a new chat with a phone number using an approved template. Meta charge |
| `waba_chat_send_message` | Free-text message in an existing WABA chat, only while `service_window_is_open` is true |
| `waba_chat_send_template` | Send an approved template in an existing WABA chat: the way to message when the service window is closed. Meta charge |
| `waba_message_react` | Set or clear an emoji reaction on a WABA message |

#### Chat mutations: 9 tools

State + triage operations on WABA chats. After any mutation, `waba_chat_details` returns the authoritative state.

| Tool | Purpose |
|---|---|
| `waba_chat_open` | Reopen a closed WABA chat |
| `waba_chat_close` | Close a WABA chat |
| `waba_chat_assign` | Assign a WABA chat to a teammate by email (from `workspace_team`) |
| `waba_chat_unassign` | Clear the WABA chat's assignee |
| `waba_chat_set_label` | Add a label, keeping existing labels |
| `waba_chat_remove_label` | Remove one label, keeping the others; no-op if the label isn't on the chat |
| `waba_chat_rename` | Rename the WABA chat in TimelinesAI and synced CRMs |
| `waba_chat_mark_read` | Mark the WABA chat read in the shared inbox |
| `waba_chat_mark_unread` | Mark the WABA chat unread in the shared inbox |

→ Full schemas and example prompts: [`docs/tools.md`](docs/tools.md)

---

## How sign-in works

The server uses OAuth. The first time your assistant connects, a browser window opens on TimelinesAI. Sign in to your TimelinesAI account and approve access. Your assistant keeps the sign-in, so later sessions reconnect without asking.

If you're already signed in to TimelinesAI in your browser, approval can take a single click.

Every action runs **as you**: your role's permissions in TimelinesAI apply to MCP calls exactly as they apply to UI actions.

---

## Safety + production behavior

> ⚠️ **This MCP server controls a real WhatsApp inbox.** Read this section before sending writes.

- **Messages sent via MCP are indistinguishable from messages sent in the UI.** Recipients cannot tell.
- **Writes are real and immediate.** No undo. Confirm before bulk actions.
- **Quota is shared** with UI usage: MCP messages draw from the same monthly messaging budget. Call `workspace_quotas` to see headroom.
- **WABA template messages are charged by Meta.** `waba_start_chat` and `waba_chat_send_template` send approved templates, which Meta bills for. Free-text `waba_chat_send_message` only works while the chat's service window is open.
- **No sandbox mode.** Practice on your own number first if you're unsure.
- **Without a connected WhatsApp number**, most tools return empty results or errors. Connect a number in TimelinesAI first.

---

## Get started

1. **[Start a 10-day free trial of TimelinesAI →](https://app.timelines.ai/register/?utm_source=github&utm_medium=mcp_directory&utm_campaign=mcp_launch&utm_content=readme_cta)**
2. Connect a WhatsApp number in the TimelinesAI dashboard.
3. Pick your assistant above and connect it.
4. Sign in, then ask: *"What needs me today?"*

---

## Links

- **WhatsApp MCP page**: [timelines.ai/whatsapp-mcp](https://timelines.ai/whatsapp-mcp?utm_source=github&utm_medium=mcp_directory&utm_campaign=mcp_launch&utm_content=readme_links)
- **Setup guide**: [timelines.ai/whatsapp-mcp-guide](https://timelines.ai/whatsapp-mcp-guide)
- **MCP Academy** (short lessons, no signup): [timelines.ai/academy/mcp](https://timelines.ai/academy/mcp)
- **Sign up**: [app.timelines.ai/register](https://app.timelines.ai/register/?utm_source=github&utm_medium=mcp_directory&utm_campaign=mcp_launch&utm_content=readme_links)
- **MCP server endpoint**: `https://mcp.services.timelines.ai/mcp`
- **Model Context Protocol**: [modelcontextprotocol.io](https://modelcontextprotocol.io)
- **Issues / feedback**: [open an issue](../../issues) in this repo

---

## License

[MIT](LICENSE) © 2026 Initech Software / TimelinesAI
