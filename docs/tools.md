# Tool Reference

Full reference for all 66 tools exposed by the TimelinesAI MCP server at `https://mcp.services.timelines.ai/mcp`.

There are two parallel sets of tools, plus workspace, quick-reply and webhook tools that both sets share:

| Group | Tools |
|---|---|
| [Workspace and team](#workspace-meta) (shared) | 7 |
| [Quick replies](#quick-replies) (shared) | 5 |
| [Webhooks](#webhooks) (shared) | 5 |
| [WhatsApp: QR-connected numbers](#whatsapp-qr-connected-numbers) | 24 |
| [WhatsApp Business API (WABA)](#whatsapp-business-api-waba) | 25 |
| **Total** | **66** |

> **Connected before 11 Nov 2026?** Webhooks, quick-reply editing and invitations need extra permissions. Disconnect and reconnect the MCP once to get them. A 401 or 403 from one of these tools means reconnect first.

Use the set that matches the number. `workspace_whatsapp_accounts` lists QR numbers, and `waba_accounts` lists WABA numbers.

Each entry lists arguments and one or more example prompts you can send to your AI assistant.

---

## Workspace Meta

Introspection tools are read-only, low quota cost and safe to call at any time. `workspace_invite` and `workspace_invitation_revoke` change the team and need admin rights.

### `workspace_quotas`

Return current workspace plan, seat usage, messaging quota, API call quota, and billing period.

**Arguments:** none

**Returns:** `{ workspace_id, display_name, plan, seats: {total, used}, messaging_quota: {total, used, period_start, period_end}, api_calls_quota: {...}, non_recurring_quota: {...} }`

**Example prompts:**
- "How much of my messaging quota have I used this period?"
- "When does my current billing period end?"
- "Am I close to hitting my API call limit?"

### `workspace_whatsapp_accounts`

List the QR-connected WhatsApp accounts in the current workspace. For WABA numbers, use `waba_accounts`.

**Arguments:** none

**Returns:** `{ whatsapp_accounts: [{ id, phone, connected_on, status, owner_name, owner_email, account_name }] }`

**Example prompts:**
- "Which WhatsApp accounts are connected?"
- "Show me the status of all my connected WA numbers."

### `workspace_team`

List teammates, teams, roles, and which WhatsApp accounts each teammate can access. A teammate's `email` is the value `chat_assign` and `waba_chat_assign` expect as `user_email`.

**Arguments:** none

**Returns:** `{ teams: [{ title }], teammates: [{ user_id, display_name, email, role, team, status, invitation_status, created_at, whatsapp_accounts: [...] }] }`

**Example prompts:**
- "Who's on my team?"
- "List teammates with the Owner role."
- "Which teammates have access to my WhatsApp account?"
- "Find the email of the teammate named 'Alice' so I can assign chats to her."

### `workspace_me`

Who this connection is signed in as: the user, their role and their team. Read it before anything that needs admin rights, such as inviting or revoking.

**Arguments:** none

**Example prompts:**
- "Who am I signed in as, and what's my role?"
- "Can I invite teammates from this account?"

### `workspace_invite`

Invite someone to the workspace. They get an email. Inviting an address that is already in the workspace updates their role and team and re-sends the mail, so this also re-sends a pending invite. Needs admin rights.

**Arguments:** `email` *(string, required)*, `first_name`, `last_name`, `role` *(admin, team_supervisor, teammate, agent, collaborator)*, `team_title` *(defaults to "Default team")*

**Example prompts:**
- "Invite sam@example.com as an agent on the Support team."
- "Re-send the invitation to sam@example.com."

### `workspace_invitation_revoke`

Revoke a pending invitation. Needs admin rights.

**Arguments:** `user_id` *(integer, required)*: from `workspace_team`

**Example prompts:**
- "Cancel the pending invitation for sam@example.com."

### `get_more_tools`

Ask the server for additional tools that fit a goal. Today it returns the full list, so most clients will not need it.

**Arguments:** `context` *(string, required)*: the goal

---

## Quick replies

Saved text replies your team uses in WhatsApp chats and as free-text replies in WABA chats (shown as Templates in the app). These are not WABA message templates; for those use `waba_templates`.

### `quick_reply_list`

List quick replies, newest-edited first. No paging.

**Arguments:** none

**Example prompts:**
- "Show our saved quick replies."

### `quick_reply_details`

One quick reply with its text. Send the text with whichever send tool fits the chat. A file saved with a quick reply is not returned; send it separately.

**Arguments:** `quick_reply_id` *(integer, required)*

**Example prompts:**
- "Show the text of the 'Opening hours' quick reply."

### `quick_reply_create`

Save a new quick reply.

**Arguments:** `name` *(required, up to 160 characters)*, `text` *(required, up to 4096 characters)*, `visibility` *(public, private or read-only; default public)*, `team_title` *(omit to share with all teams)*

`private` is for you only. `public` can be used and edited by anyone it is shared with. `read-only` can be used by them, and changed only by you, an admin or the team supervisor. Owners and admins may pick any team; other roles always create in their own team.

**Example prompts:**
- "Save a private quick reply called 'Thanks' with the text 'Thanks for reaching out, we'll reply shortly.'"

### `quick_reply_update`

Change a quick reply. Only the fields you pass change. Pass `team_title` null to share with all teams again.

**Arguments:** `quick_reply_id` *(required)*, `name`, `text`, `visibility`, `team_title`

**Example prompts:**
- "Change the 'Opening hours' quick reply to say we open at 9."

### `quick_reply_delete`

Delete a quick reply for everyone it is shared with. A 403 means your role cannot change it.

**Arguments:** `quick_reply_id` *(integer, required)*

**Example prompts:**
- "Delete the 'Holiday 2025' quick reply."

---

## Webhooks

Subscribe your own URL to workspace events. The endpoint must answer 2xx within 5 seconds. Payload shapes: [webhooks guide](https://timelines.ai/docs/guides/webhooks). Existing webhooks may belong to an integration such as Zapier, Make or n8n, so changing or removing one can break it.

**Event types:** `message:new`, `message:sent:new`, `message:received:new`, `message:delivered`, `message:read`, `message:reaction`, `message:edited`, `message:deleted`, `chat:new`, `chat:incoming:new`, `chat:outgoing:new`, `chat:renamed`, `chat:responsible:assigned`, `chat:responsible:unassigned`, `call:incoming:missed`, `call:incoming:ended`, `call:outgoing:ended`, `whatsapp:account:connected`, `whatsapp:account:disconnected`, `whatsapp:account:suspended`, `whatsapp:account:resumed`, `whatsapp:account:reachout_timelock:active`, `whatsapp:account:reachout_timelock:cleared`, and for WABA: `waba:message:received`, `waba:message:delivered`, `waba:message:failed`, `waba:message:read`, `waba:chat:incoming`, `waba:chat:outgoing`, `waba:chat:assigned`, `waba:chat:unassigned`, `waba:chat:closed`, `waba:chat:reopened`, `waba:account:active`, `waba:account:disabled`, `waba:account:disconnected`, `waba:template:approved`, `waba:template:rejected`, `waba:template:disabled`.

### `webhook_list`

Subscriptions in the workspace: URL, event type, enabled flag and `errors_counter` (consecutive delivery failures).

**Arguments:** none

**Example prompts:**
- "Which webhooks do we have, and are any failing?"

### `webhook_details`

One webhook by id.

**Arguments:** `webhook_id` *(integer, required)*

### `webhook_create`

Subscribe a URL to an event type. Idempotent per URL plus event type: the same pair again returns and re-enables the existing subscription. To copy every message, subscribe `message:received:new` and `message:sent:new` separately.

**Arguments:** `url` *(https, required)*, `event_type` *(required)*, `enabled` *(default true)*

**Example prompts:**
- "Send every incoming message to https://example.com/hook."

### `webhook_update`

Change URL or event type, or set `enabled` to pause and resume deliveries. Fields you leave out keep their value.

**Arguments:** `webhook_id` *(required)*, `url`, `event_type`, `enabled`

**Example prompts:**
- "Pause the webhook that posts to https://example.com/hook."

### `webhook_delete`

Remove a subscription for good. To pause instead, use `webhook_update` with `enabled` false.

**Arguments:** `webhook_id` *(integer, required)*

---

## WhatsApp: QR-connected numbers

14 tools for regular WhatsApp numbers connected to TimelinesAI by QR code.

### Chat discovery + inspection

Browse and read chats. No writes. No messaging quota used.

#### `list_chats`

List or search chats with filters. Paginated, 50 items per page.

**Arguments:**
- `page` *(integer, ≥1)*: page number
- `name` *(string)*: substring filter for chat name
- `phone` *(string)*: filter direct chats by phone number
- `whatsapp_account_id` *(string)*: filter by WhatsApp account WID
- `closed` *(boolean)*: `true` = closed, `false` = open
- `read` *(boolean)*: `true` = read, `false` = unread
- `group` *(boolean)*: `true` = groups only, `false` = direct chats only
- `labels` *(array of strings)*: chats with at least one of these labels
- `responsible` *(string)*: assigned teammate email
- `chatgpt_autoresponse_enabled` *(boolean)*
- `created_after` *(ISO timestamp)*
- `created_before` *(ISO timestamp)*

**Returns:** `{ chats: [...], has_more_pages: boolean }`

**Example prompts:**
- "Show me unread chats assigned to me."
- "List all chats with the 'urgent' label opened this week."
- "Find direct chats with phone number +15551234567."

#### `chat_details`

Full metadata for a single chat: labels, assignment, open or closed, and related fields. Call it after any chat mutation to read the current state.

**Arguments:** `chat_id` *(string, required)*

**Example prompts:**
- "Get details on chat 99653."
- "Who is chat 99653 assigned to?"

#### `chat_history`

List the messages in a chat, with date and direction filters. Page through results with message-UID cursors or page numbers.

**Arguments:**
- `chat_id` *(string, required)*
- `after` / `before` *(ISO date, inclusive)*: date range
- `after_message` / `before_message` *(message UID)*: pagination cursors
- `from_me` *(boolean)*: `true` = sent from your account, `false` = received
- `page` *(number)*

**Example prompts:**
- "Show me the last messages in chat 99653."
- "What did the customer in chat 99653 send us last week?"
- "Summarise this conversation and tell me what they're waiting on."

#### `message_details`

Inspect a single message by UID.

**Arguments:** `message_uid` *(string, required)*

**Example prompts:**
- "Show me details of message UID abc-123."

#### `message_status_history`

The sending timeline for one message, in order, with a timestamp per step. Use it to answer when a message was delivered or read, or why it did not arrive. `message_details` gives only the current status.

**Arguments:** `message_uid` *(string, required)*

**Example prompts:**
- "When was message abc-123 delivered and read?"

#### `message_reactions`

Who has reacted to a message and with which emoji. Setting or clearing a reaction is `message_react`.

**Arguments:** `message_uid` *(string, required)*

### Messaging writes

**⚠️ Quota-consuming.** These actions draw from the same monthly messaging quota as the TimelinesAI UI. Confirm before bulk operations.

#### `chat_send_message`

Send a message in an existing chat. Provide `chat_id` plus `text`, an attachment (`file_uid`), or both. Optionally set `reply_to` to thread the message as a reply.

**Arguments:** `chat_id` *(required)*, `text`, `file_uid`, `reply_to`

**Quota:** one unit per plain-text message, typically two when an attachment is included.

**Example prompts:**
- "Reply to chat 99653 with 'On my way, ETA 10 min.'"
- "Send 'Thanks!' to the chat with John."

#### `whatsapp_account_send_message`

Send plain text to any phone number from a specific WhatsApp account (cold send). A chat is created if none exists. Both numbers use international format starting with `+`.

**Arguments:** `phone` *(required)*, `whatsapp_account_phone` *(required)*, `text` *(required)*

**Example prompts:**
- "Send 'Hello from MCP' to +15551234567 from my main account."

#### `message_reply`

Threaded reply to a specific message. The recipient sees the quoted reply.

**Arguments:** `chat_id` *(required)*, `reply_to` *(message UID, required)*, `text` *(required)*

**Example prompts:**
- "Reply to message UID abc-123 with 'Got it, will follow up.'"

#### `message_react`

Set or clear an emoji reaction on a message. Pass an emoji to set it, or an empty string to clear it.

**Arguments:** `message_uid` *(required)*, `reaction` *(required)*

**Example prompts:**
- "React to message UID abc-123 with 👍."
- "Remove my reaction from message UID abc-123."

#### `file_upload_from_url`

Store a file in the workspace from a publicly reachable URL and get its `uid`. Pass that uid as `file_uid` to `chat_send_message` to send it as an attachment. The uid can be reused for several sends.

**Arguments:** `download_url` *(required)*, `filename`, `content_type`

**Example prompts:**
- "Upload https://example.com/price-list.pdf and send it to chat 99653."

### Chat mutations

State and triage operations on chats. Each returns `{"status":"ok"}` on success. Call `chat_details` afterwards to confirm the new state. Labels are idempotent: adding a label the chat already has, or removing one it doesn't have, succeeds without changing anything.

#### `chat_open`

Reopen a closed chat. **Arguments:** `chat_id`

**Example prompts:**
- "Reopen chat 99653."

#### `chat_close`

Close a chat, which removes it from the active inbox. **Arguments:** `chat_id`

**Example prompts:**
- "Close chat 99653."
- "Mark this conversation as handled."

#### `chat_assign`

Assign a chat to a teammate by email. Get emails from `workspace_team`. **Arguments:** `chat_id`, `user_email`

**Example prompts:**
- "Assign chat 99653 to jane@example.com."

#### `chat_unassign`

Remove the current assignee from a chat. **Arguments:** `chat_id`

**Example prompts:**
- "Unassign chat 99653."

#### `chat_set_label`

Add a label to a chat. Labels are workspace-scoped strings. **Arguments:** `chat_id`, `label`

**Example prompts:**
- "Label chat 99653 as 'sales-qualified'."

#### `chat_remove_label`

Remove a label from a chat. Other labels stay. **Arguments:** `chat_id`, `label`

**Example prompts:**
- "Remove 'spam' from chat 99653."

#### `chat_rename`

Rename the chat in TimelinesAI and synced CRMs. Does not change the contact's WhatsApp profile name.

**Arguments:** `chat_id`, `name`

**Example prompts:**
- "Rename chat 99653 to 'Acme: Dana'."

#### `chat_mark_read` / `chat_mark_unread`

Set the shared-inbox read state. This is not a WhatsApp read receipt: the contact is not told.

**Arguments:** `chat_id`

**Example prompts:**
- "Mark chat 99653 unread so I come back to it."

#### `chat_set_ai_autoresponse`

Turn the AI auto-reply on or off for this one chat. The workspace setting is unchanged.

**Arguments:** `chat_id`, `enabled` *(boolean)*

**Example prompts:**
- "Turn off the AI auto-reply in chat 99653."

#### `chat_add_note`

Add an internal note. Visible to teammates in TimelinesAI only, never sent to the contact.

**Arguments:** `chat_id`, `text` *(up to 10,000 characters)*

**Example prompts:**
- "Add a note to chat 99653: customer wants a quote by Friday."

### Connect a number

#### `whatsapp_account_start_phone_pairing`

Start linking a QR WhatsApp number by phone code, without scanning a QR. Takes an international number with a leading `+` that the person has confirmed. Returns before a code exists. Needs the `accounts:write` permission. Omit `user_id` to link the signed-in user.

**Arguments:** `phone` *(required)*, `user_id`

**Example prompts:**
- "Connect my WhatsApp number +15551234567."

#### `whatsapp_account_phone_pairing_status`

State of a pairing link: `starting`, `awaiting_code` (shows the 8-character code to enter under WhatsApp > Linked devices > Link a device > Link with phone number instead), `connected`, `expired`, `code_unavailable` or `failed`.

**Arguments:** `id` *(from the start call)*

---

## WhatsApp Business API (WABA)

25 tools for WhatsApp Business API numbers. They work like the QR set, with two WhatsApp rules on top:

- **Free text only inside the service window.** Check `service_window_is_open` (from `waba_list_chats` or `waba_chat_details`) before sending free text. When the window is closed, send an approved template.
- **New conversations start with a template.** Use `waba_start_chat` with an `APPROVED` template. Template sends are charged by Meta.

### Accounts + chat discovery

Browse and read. No writes.

#### `waba_accounts`

The WABA numbers you can send from. Use each `id` as `waba_account_id`.

**Arguments:** none

**Example prompts:**
- "Which WhatsApp Business API numbers can I send from?"

#### `waba_account_details`

One WABA account by id: status, owner, display phone number and the Meta ids.

**Arguments:** `waba_account_id` *(integer, from `waba_accounts`)*

#### `waba_list_chats`

WABA chats you can see. Paginated, 50 items per page.

**Arguments:**
- `page` *(integer, ≥1)*
- `closed` *(boolean)*
- `responsible` *(string)*: teammate email from `workspace_team`
- `waba_account_id` *(string)*: comma-separated WABA account ids
- `whatsapp_phone` *(string)*: contact phone
- `with_msg` *(boolean)*: include the full last message

**Example prompts:**
- "Show open WABA chats assigned to me."
- "Which WABA chats still have an open service window?"

#### `waba_chat_details`

One WABA chat: service window, assignment, labels, and WABA account. Call it after any WABA mutation to read the current state.

**Arguments:** `chat_id` *(required)*

#### `waba_chat_history`

Messages in a WABA chat, newest first by default.

**Arguments:**
- `chat_id` *(required)*
- `after` / `before` *(ISO date, inclusive)*
- `after_message` / `before_message` *(message UID cursors)*
- `from_me` *(boolean)*
- `page` *(integer)*, `size` *(integer)*: messages per page
- `sorting_order` *(`asc` or `desc`)*

**Example prompts:**
- "Summarise the last week of this WABA conversation."

#### `waba_message_details`

One WABA message by UID. Failed sends include a `failure_reason`.

**Arguments:** `message_uid` *(required)*

**Example prompts:**
- "Why did my last template message to this customer fail?"

#### `waba_message_status_history`

The sending timeline for one WABA message. A failed step carries `failure_reason` with Meta's code, title and details.

**Arguments:** `message_uid`

**Example prompts:**
- "Why did my last template message not arrive?"

#### `waba_message_reactions`

Who has reacted to a WABA message and with which emoji.

**Arguments:** `message_uid`

### Analytics

#### `waba_account_analytics`

Sent and delivered messages per day over a date range, plus a breakdown by `COUNTRY`, `PRICING_CATEGORY` or `PRICING_TYPE`. Start and end are read as UTC; the day buckets come back in the business account's timezone, so the first and last can be partial. Figures cover every number on the same WhatsApp Business Account, not only the one you pass. Meta does not return cost figures for these accounts. Computed asynchronously: if not ready it returns a handle for `waba_account_analytics_result`.

**Arguments:** `waba_account_id`, `start`, `end`, `dimensions` *(optional, comma-separated)*

**Example prompts:**
- "How many WABA messages did we send and deliver in October, by country?"

#### `waba_account_analytics_result`

Read an analytics request that was still pending. `state` is `pending`, `ready` or `error`.

**Arguments:** `waba_account_id`, `handle_id`

### Templates

#### `waba_templates`

Message templates you can use, 50 per page. Only `APPROVED` templates can be sent.

**Arguments:** `page` *(integer)*. Keep paging while `has_more_pages` is true.

**Example prompts:**
- "List our approved WhatsApp templates."

#### `waba_template_details`

One template: its components, status, and the WABA accounts it can be sent from. Call it before any template send.

**Arguments:** `template_id` *(integer, required)*

### Messaging writes

**⚠️ Quota-consuming,** and template sends are charged by Meta.

#### `waba_start_chat`

Start a new WABA chat with a phone number using an approved template. `waba_account_id` must appear in both `waba_accounts` and the template's accounts.

**Arguments:** `waba_account_id` *(integer, required)*, `phone` *(required)*, `name` *(template name, required)*, `language` *(e.g. `en_US`, required)*, `variables` *(optional: `header` and `body` arrays)*

**Example prompts:**
- "Start a chat with +15551234567 using our 'welcome' template."

#### `waba_chat_send_message`

Free text in an existing WABA chat. Works only while `service_window_is_open` is true.

**Arguments:** `chat_id` *(required)*, `text` *(required)*

#### `waba_chat_send_template`

Send an approved template in an existing WABA chat. Use this when the service window is closed.

**Arguments:** `chat_id` *(required)*, `name` *(required)*, `language` *(required)*, `variables` *(optional)*

#### `waba_message_react`

Set or clear an emoji reaction on a WABA message. An empty string clears it.

**Arguments:** `message_uid` *(required)*, `reaction` *(required)*

### Chat mutations

Same behaviour as the QR set, applied to WABA chats. Each returns `{"status":"ok"}` on success. Confirm with `waba_chat_details`.

| Tool | Arguments | Does |
|---|---|---|
| `waba_chat_open` | `chat_id` | Reopen a closed WABA chat |
| `waba_chat_close` | `chat_id` | Close a WABA chat |
| `waba_chat_assign` | `chat_id`, `user_email` | Assign to a teammate |
| `waba_chat_unassign` | `chat_id` | Remove the assignee |
| `waba_chat_set_label` | `chat_id`, `label` | Add a label, keeping existing ones |
| `waba_chat_remove_label` | `chat_id`, `label` | Remove one label, keeping the others |
| `waba_chat_rename` | `chat_id`, `name` | Rename the chat in TimelinesAI |
| `waba_chat_mark_read` | `chat_id` | Mark read in the shared inbox |
| `waba_chat_mark_unread` | `chat_id` | Mark unread in the shared inbox |

---

## Conventions

### Phone numbers
- International format starting with `+` (e.g., `+15551234567`)

### Chat IDs
- Numeric IDs (e.g., `99653`), passed as strings
- Persistent across sessions
- QR chats and WABA chats have separate IDs. Use the tools from the matching set

### Message UIDs
- UUID strings (e.g., `62f29dfa-1a99-43c4-9527-d8ccbbb55dfd`)
- Returned by `list_chats` as `last_message_uid`, and by `chat_history` / `waba_chat_history` for each message

### JID formats (chat identifiers from WhatsApp)
- `<phone>@c.us`: direct chat (legacy contact JID)
- `<id>@s.whatsapp.net`: direct chat (newer contact JID)
- `<id>@lid`: linked ID (privacy-preserving identifier)
- `<id>@g.us`: group chat
- `<id>@broadcast`: broadcast list

### Pagination
- `list_chats`, `waba_list_chats` and `waba_templates` return up to 50 items per page
- Check `has_more_pages` before requesting the next page
- `chat_history` and `waba_chat_history` also accept message-UID cursors (`after_message`, `before_message`)
