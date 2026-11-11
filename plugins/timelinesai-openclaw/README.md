# TimelinesAI for WhatsApp

WhatsApp control and visibility for teams, from OpenClaw. TimelinesAI connects your team's real WhatsApp inbox, regular WhatsApp numbers and WhatsApp API numbers, to your agent. Ask which chats need a reply, who has waited longest or what a customer asked last week, then send WhatsApp messages, label, assign and close chats without opening the inbox.

Built for sales and support teams that use TimelinesAI as their WhatsApp CRM and shared inbox.

Connect once with your TimelinesAI login (OAuth sign-in), then ask in plain language. The agent can also act on what it finds: reply, react, label, open or close chats and assign them to teammates. Every action runs as you, with your role's permissions, and uses the same messaging quota as the TimelinesAI app. It covers regular WhatsApp numbers connected by QR code and WhatsApp API numbers, including approved message templates.

## What you can do

- **Ask your inbox:** find chats waiting on a reply, summarise conversations, check your quota
- **Act from a prompt:** reply, react, label, assign, open and close chats
- **Both kinds of number:** regular WhatsApp and the WhatsApp Business API, including approved templates
- **One sign-in:** your TimelinesAI account (OAuth), nothing to copy or paste

## Try asking

1. Show my unread WhatsApp chats from the last 24 hours and flag any that look urgent.
2. Find open WhatsApp chats with no reply from us in 2 days and draft a follow-up for each.
3. Which WhatsApp numbers are connected, and how much of this month's message quota is left?
4. Which WhatsApp chats this week mention pricing? One line each, newest first.
5. Draft a reply to my most recent unanswered WhatsApp chat and wait for my OK before sending.

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

TimelinesAI is an independent product. It is not made by, affiliated with, or endorsed by WhatsApp or Meta.
