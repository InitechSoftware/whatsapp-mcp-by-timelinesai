# Tool Reference

Full reference for all 18 tools exposed by the TimelinesAI MCP server at `https://mcp.services.timelines.ai/mcp`.

Tools are grouped by purpose. Each entry lists arguments, return shape, and one or more example prompts you can send to your AI assistant.

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

List all WhatsApp accounts connected to the current workspace.

**Arguments:** none

**Returns:** `{ whatsapp_accounts: [{ id, phone, connected_on, status, owner_name, owner_email, account_name }] }`

**Example prompts:**
- "Which WhatsApp accounts are connected?"
- "Show me the status of all my connected WA numbers."

### `workspace_team`

List teammates, teams, roles, and which WhatsApp accounts each teammate can access. The `email` field of each teammate is what `chat_assign` expects for its `responsible_email` argument.

**Arguments:** none

**Returns:** `{ teams: [{ title }], teammates: [{ user_id, display_name, email, role, team, status, invitation_status, created_at, whatsapp_accounts: [...] }] }`

**Example prompts:**
- "Who's on my team?"
- "List teammates with the Owner role."
- "Which teammates have access to my WhatsApp account?"
- "Find the email of the teammate named 'Alice' so I can assign chats to her."

---

## Chat Discovery + Inspection

Browse and read chats. No writes. No quota consumption beyond API calls.

### `list_chats`

List or search chats with rich filters. Paginated 50 items per page.

**Arguments:**
- `page` *(integer, ≥1)* — Page number
- `name` *(string)* — Substring filter for chat name
- `phone` *(string)* — Filter direct chats by phone number
- `whatsapp_account_id` *(string)* — Filter by WhatsApp account WID
- `closed` *(boolean)* — `true` = closed, `false` = open
- `read` *(boolean)* — `true` = read, `false` = unread
- `group` *(boolean)* — `true` = groups only, `false` = direct chats only
- `labels` *(array of strings)* — Chats with at least one of these labels
- `responsible` *(string)* — Assigned teammate email
- `chatgpt_autoresponse_enabled` *(boolean)*
- `created_after` *(ISO timestamp)*
- `created_before` *(ISO timestamp)*

**Returns:** `{ chats: [...], has_more_pages: boolean }`

**Example prompts:**
- "Show me unread chats assigned to me."
- "List all chats with the 'urgent' label opened this week."
- "Find direct chats with phone number +15551234567."

### `chat_details`

Full metadata for a single chat by ID.

**Example prompts:**
- "Get details on chat 99653."
- "What's the assigned teammate for chat 99653?"

### `chat_history`

Pull a context window of messages around a specific message — typically one page before and one page after.

**Example prompts:**
- "Show me the conversation around message UID abc-123."
- "Give me context on what led to the customer's last reply."

### `get_chat_messages`

Page through messages in a specific chat.

**Example prompts:**
- "Show me the last 20 messages from chat 99653."
- "Get the next page of messages in chat 99653."

### `message_details`

Inspect a single message by UID.

**Example prompts:**
- "Show me details of message UID abc-123."

---

## Messaging Writes

**⚠️ Quota-consuming.** These actions draw from the same monthly messaging quota as the TimelinesAI UI. Confirm before bulk operations.

### `chat_send_message`

Send a message in an existing chat. Supports plain text, attachments, and threaded replies (when replying to a specific message UID).

**Example prompts:**
- "Reply to chat 99653 with 'On my way, ETA 10 min.'"
- "Send 'Thanks!' to the chat with John."
- "Send the attached PDF to chat 99653 with a short note."

### `whatsapp_account_send_message`

Send a message to any phone number via a specific WhatsApp account (cold send). Creates a chat if none exists. Phone number must be in international format starting with `+`.

**Example prompts:**
- "Send 'Hello from MCP' to +15551234567 from my main account."
- "Reach out to +1555... about the proposal."

### `message_reply`

Threaded reply to a specific message (references the original — recipient sees the quoted reply UI).

**Example prompts:**
- "Reply to message UID abc-123 with 'Got it, will follow up.'"

### `message_react`

Set or clear an emoji reaction on a message. Pass an emoji to set; pass an empty value to clear.

**Example prompts:**
- "React to message UID abc-123 with 👍."
- "Add a ❤️ reaction to the last message in chat 99653."
- "Remove my reaction from message UID abc-123."

---

## Chat Mutations

State + triage operations on chats. Idempotent — calling `chat_set_label` twice with the same label is a no-op.

### `chat_open`

Reopen a closed chat.

**Example prompts:**
- "Reopen chat 99653."

### `chat_close`

Close a chat (archive from active inbox).

**Example prompts:**
- "Close chat 99653."
- "Mark this conversation as handled."

### Shared-inbox operations

Multi-teammate workspaces use labels + assignments for triage.

### `chat_set_label`

Add a label to a chat. Labels are workspace-scoped strings.

**Example prompts:**
- "Label chat 99653 as 'sales-qualified'."
- "Add 'follow-up' to chat 99653."

### `chat_remove_label`

Remove a label from a chat.

**Example prompts:**
- "Remove 'spam' from chat 99653."

### `chat_assign`

Assign a chat to a teammate by email address.

**Example prompts:**
- "Assign chat 99653 to jane@example.com."
- "Hand off this conversation to support@example.com."

### `chat_unassign`

Remove the current assignee from a chat.

**Example prompts:**
- "Unassign chat 99653."

---

## Conventions

### Phone numbers
- International format starting with `+` (e.g., `+15551234567`)
- For send-to-new-number operations, the tool will ask you to confirm the formatted number before sending

### Chat IDs
- Numeric integers (e.g., `99653`)
- Persistent across sessions

### Message UIDs
- UUID strings (e.g., `62f29dfa-1a99-43c4-9527-d8ccbbb55dfd`)
- Returned by `list_chats` as `last_message_uid` and by `get_chat_messages` for each message

### JID formats (chat identifiers from WhatsApp)
- `<phone>@c.us` — Direct chat (legacy contact JID)
- `<id>@s.whatsapp.net` — Direct chat (newer contact JID)
- `<id>@lid` — Linked ID (privacy-preserving identifier)
- `<id>@g.us` — Group chat
- `<id>@broadcast` — Broadcast list

### Pagination
- `list_chats` returns up to 50 items per page
- Check `has_more_pages` boolean before requesting next page
