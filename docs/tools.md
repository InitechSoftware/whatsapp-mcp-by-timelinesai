# Tool Reference

Full reference for all 34 tools exposed by the TimelinesAI MCP server at `https://mcp.services.timelines.ai/mcp`.

There are two parallel sets of tools, plus three workspace tools that both sets share:

| Group | Tools |
|---|---|
| [Workspace](#workspace-meta) (shared) | 3 |
| [WhatsApp: QR-connected numbers](#whatsapp-qr-connected-numbers) | 14 |
| [WhatsApp Business API (WABA)](#whatsapp-business-api-waba) | 17 |
| **Total** | **34** |

Use the set that matches the number. `workspace_whatsapp_accounts` lists QR numbers, and `waba_accounts` lists WABA numbers.

Each entry lists arguments and one or more example prompts you can send to your AI assistant.

---

## Workspace Meta

Read-only introspection. Low quota cost. Safe to call at any time.

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

---

## WhatsApp Business API (WABA)

17 tools for WhatsApp Business API numbers. They work like the QR set, with two WhatsApp rules on top:

- **Free text only inside the service window.** Check `service_window_is_open` (from `waba_list_chats` or `waba_chat_details`) before sending free text. When the window is closed, send an approved template.
- **New conversations start with a template.** Use `waba_start_chat` with an `APPROVED` template. Template sends are charged by Meta.

### Accounts + chat discovery

Browse and read. No writes.

#### `waba_accounts`

The WABA numbers you can send from. Use each `id` as `waba_account_id`.

**Arguments:** none

**Example prompts:**
- "Which WhatsApp Business API numbers can I send from?"

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
