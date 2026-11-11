# TimelinesAI WhatsApp — OpenClaw plugin

Connects OpenClaw to the [TimelinesAI WhatsApp MCP server](https://timelines.ai/whatsapp-mcp?utm_source=openclaw&utm_medium=marketplace&utm_campaign=mcp_listing):
search and summarise WhatsApp chats, find unanswered conversations, and send messages, notes and labels.

Bundle plugin (Claude format): one skill, `whatsapp-inbox`, plus the server definition in `.mcp.json`. No local code.

## Install

```bash
openclaw plugins install clawhub:timelinesai-openclaw
```

If your OpenClaw build does not load the bundled remote server (`openclaw plugins inspect timelinesai-whatsapp` shows it as unsupported), add it directly and sign in with OAuth:

```bash
openclaw mcp add timelinesai --url https://mcp.services.timelines.ai/mcp --auth oauth
openclaw mcp login timelinesai
```

Sign-in is browser OAuth to your TimelinesAI account, where you also connect your WhatsApp number.
A TimelinesAI account is required (free trial available).

## Disclosure

- Hosted connector: every tool call goes to `mcp.services.timelines.ai`, operated by TimelinesAI.
- Reads and, on request, sends WhatsApp messages for the account you sign in with.
- No credentials in this package; OpenClaw stores the OAuth tokens. No telemetry in the package.
- The tool set is served remotely, so it can change without a new package version.
