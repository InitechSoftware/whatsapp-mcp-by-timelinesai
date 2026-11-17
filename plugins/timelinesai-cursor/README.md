# TimelinesAI for Cursor

Run your team's WhatsApp inbox from Cursor. Ask what needs a reply, then reply, react, label and assign chats from a prompt. 60+ tools (messaging, triage, quick replies, webhooks, team, WABA analytics) for regular WhatsApp numbers and WhatsApp Business API (WABA) numbers, all running as **you**.

**Included in every TimelinesAI plan at no extra charge.** [Website](https://timelines.ai/whatsapp-mcp?utm_source=cursor&utm_medium=mcp_directory&utm_campaign=mcp_launch&utm_content=plugin_readme) · [Full tool reference](https://github.com/InitechSoftware/whatsapp-mcp-by-timelinesai/blob/main/docs/tools.md)

This plugin adds one hosted remote MCP server: `https://mcp.services.timelines.ai/mcp` (Streamable HTTP, OAuth). Nothing runs locally, and there are no API keys to manage.

## Requirements

- A TimelinesAI account with **at least one connected WhatsApp number**. Without one, most tools return empty results. [Start a 10-day free trial](https://app.timelines.ai/register/?utm_source=cursor&utm_medium=mcp_directory&utm_campaign=mcp_launch&utm_content=plugin_readme)
- A current Cursor version. Remote MCP with OAuth is supported on every plan.

## Install

### Option 1: plugin (this package)

Install **TimelinesAI** from the Cursor Marketplace, or run `/add-plugin` in Cursor and search for TimelinesAI.

### Option 2: config file

Add the server to `~/.cursor/mcp.json` for every project, or to `.cursor/mcp.json` to scope it to one project:

```json
{
  "mcpServers": {
    "timelinesai": {
      "url": "https://mcp.services.timelines.ai/mcp"
    }
  }
}
```

If the file already has other servers, add the `timelinesai` entry inside the existing `mcpServers` object.

### Option 3: one-click link

[Add TimelinesAI to Cursor](cursor://anysphere.cursor-deeplink/mcp/install?name=timelinesai&config=eyJ1cmwiOiJodHRwczovL21jcC5zZXJ2aWNlcy50aW1lbGluZXMuYWkvbWNwIn0%3D). This writes the same config as option 2.

## Sign in

1. Open **Cursor Settings → Tools & MCP** (or **Customize → MCPs** in newer versions). `timelinesai` shows as needing authentication.
2. Click **Connect** (or just ask the agent something that needs a TimelinesAI tool). A browser tab opens on TimelinesAI.
3. Sign in with your TimelinesAI account and approve access. Cursor keeps the token, so later sessions reconnect without asking.

Every call runs with your TimelinesAI role's permissions, exactly as in the TimelinesAI app.

## Verify it works

In Agent chat, ask:

> What needs me today?

or, for a read-only check:

> Use timelinesai to show my workspace quotas and connected WhatsApp accounts.

The second prompt calls `workspace_quotas` and `workspace_whatsapp_accounts`, which only read data. If both return your workspace, you're set.

## Tools (66)

| Group | Count | Examples |
|---|---|---|
| Workspace and team (shared) | 7 | `workspace_quotas`, `workspace_team`, `workspace_me`, `workspace_invite` |
| Quick replies (shared) | 5 | `quick_reply_list`, `quick_reply_create`, `quick_reply_update` |
| Webhooks (shared) | 5 | `webhook_list`, `webhook_create`, `webhook_update` |
| WhatsApp: QR-connected numbers | 24 | `list_chats`, `chat_history`, `chat_send_message`, `chat_assign`, `chat_add_note`, `whatsapp_account_start_phone_pairing` |
| WhatsApp Business API (WABA) | 25 | `waba_list_chats`, `waba_templates`, `waba_chat_send_template`, `waba_account_analytics` |

If you connected before 11 Nov 2026, disconnect and reconnect once to get webhooks, quick-reply editing and invitations.

Full schemas and example prompts: [`docs/tools.md`](https://github.com/InitechSoftware/whatsapp-mcp-by-timelinesai/blob/main/docs/tools.md).

Cursor asks for approval before each tool call by default. Keep it that way for write tools until you're comfortable: see the safety notes below.

## Safety

This server controls a real WhatsApp inbox.

- **Writes are real and immediate.** Messages sent via MCP look exactly like messages sent in the TimelinesAI app. There is no sandbox and no undo.
- **Quota is shared** with the app. MCP messages draw from the same monthly messaging budget; `workspace_quotas` shows what's left.
- **WABA template sends are billed by Meta** (`waba_start_chat`, `waba_chat_send_template`). Free-text WABA messages only work while the chat's service window is open.

## Troubleshooting

- **The server shows a red dot or "needs authentication".** Click Connect in Tools & MCP to restart the sign-in. If the browser tab never opens, toggle the server off and on, or restart Cursor.
- **Tools return empty results.** Connect a WhatsApp number in the TimelinesAI dashboard first.
- **Cursor warns about too many tools.** If you run several MCP servers, turn off the TimelinesAI tools you don't need in Tools & MCP. For example, if you only have QR-connected numbers, turn off the `waba_*` tools.
- **Anything else:** [open an issue](https://github.com/InitechSoftware/whatsapp-mcp-by-timelinesai/issues) or email support@timelines.ai.

## License

[MIT](https://github.com/InitechSoftware/whatsapp-mcp-by-timelinesai/blob/main/LICENSE) © 2026 Initech Software / TimelinesAI
