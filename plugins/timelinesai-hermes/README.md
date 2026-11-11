# TimelinesAI WhatsApp — Hermes plugin

Connects Hermes to the [TimelinesAI WhatsApp MCP server](https://timelines.ai/whatsapp-mcp?utm_source=hermes&utm_medium=marketplace&utm_campaign=mcp_listing):
search and summarise WhatsApp chats, find unanswered conversations, and send messages, notes and labels.

Agent Plugins v1 package (`plugin.json` + `mcp.json` + `skills/`). Configuration only, no local code.

## Install

```bash
hermes plugins install timelinesai-whatsapp
hermes plugins enable timelinesai-whatsapp
```

On first use Hermes opens a browser for OAuth sign-in to your TimelinesAI account and
connects your WhatsApp number there. A TimelinesAI account is required (free trial available).

## Disclosure

- Hosted connector: every tool call goes to `mcp.services.timelines.ai`, operated by TimelinesAI.
- Reads and, on request, sends WhatsApp messages for the account you sign in with.
- Credentials: OAuth tokens are stored by Hermes; none are in this package.
- No telemetry in the package. The tool set is served remotely and is not covered by the pinned commit.
- The package marks the server `untrusted`, so Hermes asks before tool calls run.
