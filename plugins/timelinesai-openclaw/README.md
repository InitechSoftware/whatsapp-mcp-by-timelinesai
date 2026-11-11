# TimelinesAI

Connect your team's WhatsApp inbox to OpenClaw and any other MCP client. Ask what needs a reply, then reply, label and assign chats from a prompt.

TimelinesAI gives your AI assistant access to your team's real WhatsApp inbox. Connect once with your TimelinesAI login (OAuth sign-in), then ask in plain language:

- What needs me today?
- Which chats have had no reply for two days?
- Summarise everything this customer asked this month.

The assistant can also act on what it finds: reply, react, label, open or close chats, and assign them to teammates. Every action runs as you, with your role's permissions, and uses the same messaging quota as the TimelinesAI app. It covers regular WhatsApp numbers connected by QR code and WhatsApp Business API numbers, including approved message templates.

## What you can do

- **Ask your inbox:** find chats waiting on a reply, summarise conversations, check your quota
- **Act from a prompt:** reply, react, label, assign, open and close chats
- **Both kinds of number:** regular WhatsApp and the WhatsApp Business API, including approved templates
- **One sign-in:** your TimelinesAI account (OAuth), nothing to copy or paste

## Example prompts

1. What needs me today?
2. Walk my Monday inbox: group unread chats by rep and flag anything stalled 2+ days.
3. Which customers asked about pricing this week? One line each.
4. How much messaging quota do we have left this month?
5. Assign every unassigned chat from today to Anna and label it "new lead".

## Who it's for

- **Team leads and managers:** a morning briefing of what's waiting, who's behind, what's stalled
- **Sales teams:** follow-ups on leads that went quiet, without scrolling the inbox
- **Support teams:** triage, labelling and assignment from the assistant they already use

## What's in this package

One skill, `whatsapp-inbox`, which makes the agent read the chat before it summarises and confirm the recipient and exact text before it sends anything, plus the server definition in `.mcp.json`. No local code.

## Install

```bash
openclaw plugins install clawhub:timelinesai-whatsapp
```

If your OpenClaw build does not load the bundled remote server (`openclaw plugins inspect timelinesai-whatsapp` shows it as unsupported), add it directly and sign in:

```bash
openclaw mcp add timelinesai --url https://mcp.services.timelines.ai/mcp --auth oauth
openclaw mcp login timelinesai
```

Sign-in is a browser OAuth sign-in to your TimelinesAI account, where you also connect your WhatsApp number. A TimelinesAI account is required.

## Pricing

Included in every TimelinesAI plan at no extra charge. There is a free trial.

## Privacy and data handling

- Hosted connector: every tool call goes to `mcp.services.timelines.ai`, operated by TimelinesAI.
- It reads, and when you ask it to, sends WhatsApp messages for the account you sign in with.
- No credentials in this package; OpenClaw stores the OAuth tokens. No telemetry in the package.
- The tool set is served remotely, so it can change without a new package version.
- Full details: https://timelines.ai/whatsapp-mcp/privacy

More: https://timelines.ai/whatsapp-mcp?utm_source=openclaw&utm_medium=marketplace&utm_campaign=mcp_listing
