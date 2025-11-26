# Master Inbox - Batch Documentation Update Plan

## Current Status (7/23 complete)

**Completed with Full Documentation:**
1. ✅ get-sent.mdx
2. ✅ get-messages.mdx (inbox-replies)
3. ✅ get-assigned.mdx (NEW)
4. ✅ get-views.mdx (NEW)
5. ✅ update-team-member.mdx (NEW)
6. ✅ get-unread.mdx
7. ✅ get-important.mdx

**Remaining to Complete: 16 endpoints**

---

## Batch 1: Inbox Views (4 endpoints)

### 1. get-snoozed.mdx
**API**: POST /v1/master-inbox/snoozed
**Schema**: Standard inbox filter (see COMPREHENSIVE_SCHEMA_TEMPLATE.md)
- Query: api_key, fetch_message_history
- campaignId max 5, emailAccountId max 10
- Sort: REPLY_TIME_DESC, SENT_TIME_DESC

**Key Content Needed:**
- Snooze workflow (snooze → reappear when expires)
- When to use vs archive
- Bulk unsnooze pattern

### 2. get-reminders.mdx
**API**: POST /v1/master-inbox/reminders
**Schema**: Standard inbox filter with unique sort
- Query: **api_key ONLY** (NO fetch_message_history)
- **Unique Sort**: REMINDER_TIME_DESC, REMINDER_TIME_ASC
- campaignId max 5, emailAccountId max 10

**Key Content Needed:**
- Reminder management workflow
- Due reminders vs upcoming
- Daily reminder digest pattern

### 3. get-scheduled.mdx
**API**: POST /v1/master-inbox/scheduled
**Schema**: Standard inbox filter with unique sort
- Query: api_key, fetch_message_history
- **Unique Sort**: SCHEDULED_TIME_DESC, SCHEDULED_TIME_ASC
- campaignId max 5, emailAccountId max 10

**Key Content Needed:**
- Scheduled send queue management
- Cancel/modify scheduled emails
- Optimal scheduling times analysis

### 4. get-archived.mdx
**API**: POST /v1/master-inbox/archived
**Schema**: Standard inbox filter
- Query: api_key, fetch_message_history
- campaignId max 5, emailAccountId max 10
- Sort: REPLY_TIME_DESC, SENT_TIME_DESC

**Key Content Needed:**
- Archive vs delete
- Bulk archive operations
- Archive retrieval for reporting

---

## Batch 2: Utility Endpoints (2 endpoints)

### 5. get-by-id.mdx
**API**: GET /v1/master-inbox/:id
**Schema**: Simple path param
- Path: id (number, required)
- Query: api_key (required)
- Response: Single inbox item with full details

**Key Content Needed:**
- Direct item fetch for detail views
- Deep linking support
- Share functionality

### 6. get-untracked.mdx
**API**: GET /v1/master-inbox/untracked-replies
**Schema**: Unique - GET with query params
- Query params:
  - api_key (required)
  - limit (1-100, default 20)
  - offset (default 0)
  - fetchAttachments (boolean, default false)
  - fetchBody (boolean, default false)
  - from_email (optional)
  - to_email (optional)
  - subject_line (optional)

**Key Content Needed:**
- What makes a reply "untracked"
- Manual email tracking
- Historical email import
- fetchAttachments vs fetchBody performance impact

---

## Batch 3: Lead Management Actions (6 endpoints)

### 7. mark-read.mdx
**API**: PATCH /v1/master-inbox/change-read-status
**Schema**: Simple body
- Body: email_lead_map_id (number), read_status (boolean)
- **CRITICAL**: Document /mark-unread deprecation

**Key Content Needed:**
- Migration from /mark-unread
- Bulk read status updates
- Read status management patterns

### 8. update-revenue.mdx
**API**: PATCH /v1/master-inbox/update-revenue
**Schema**: Simple body
- Body: email_lead_map_id (number), revenue (number, min 0)

**Key Content Needed:**
- ROI tracking
- Deal value updates
- Revenue reporting patterns
- Currency handling

### 9. create-task.mdx
**API**: POST /v1/master-inbox/create-task
**Schema**:
```
{
  email_lead_map_id: number (required),
  name: string (required),
  description: string (optional),
  priority: enum LOW/MEDIUM/HIGH (default MEDIUM),
  due_date: ISO 8601 (optional)
}
```

**Key Content Needed:**
- Task management integration
- Priority levels explained
- Task notification system
- GTD (Getting Things Done) patterns

### 10. create-note.mdx
**API**: POST /v1/master-inbox/create-note
**Schema**:
```
{
  email_lead_map_id: number (required),
  note_message: string (required)
}
```

**Key Content Needed:**
- Collaboration via notes
- Call notes template
- Meeting notes template
- CRM sync patterns

### 11. block-domains.mdx
**API**: POST /v1/master-inbox/block-domains
**Schema**:
```
{
  domains: array<string> (min 1, required),
  source: string (default "manual")
}
```

**Key Content Needed:**
- Bulk domain blocking
- Source tracking (manual, bounce, complaint, invalid)
- Unblock process
- Bounce management automation

### 12. resume-lead.mdx
**API**: PATCH /v1/master-inbox/resume-lead
**Schema**:
```
{
  campaign_id: number (required),
  email_lead_map_id: number (required),
  resume_delay_days: number (min 0, nullable)
}
```

**Key Content Needed:**
- Resume vs restart
- Delay strategies
- Re-engagement campaigns
- Pause → Resume workflow

---

## Batch 4: Campaign Actions (2 endpoints)

### 13. set-reminder.mdx
**API**: POST /v1/master-inbox/set-reminder
**Schema**:
```
{
  email_lead_map_id: number (required),
  email_stats_id: string (required),
  message: string (required),
  reminder_time: ISO 8601 (required)
}
```

**Key Content Needed:**
- Reminder creation workflow
- Notification system
- Reminder vs task difference
- Multiple reminders per lead

### 14. push-to-subsequence.mdx
**API**: POST /v1/master-inbox/push-to-subsequence
**Schema**:
```
{
  email_lead_map_id: number (required),
  sub_sequence_id: number (required),
  sub_sequence_delay_time: number (min 0, default 0),
  stop_lead_on_parent_campaign_reply: boolean (default false)
}
```

**Key Content Needed:**
- Subsequence concept explained
- Branch logic use cases
- Interest-based routing
- Parent/child campaign relationship

---

## Batch 5: Communication (2 endpoints)

### 15. reply.mdx
**API**: POST /v1/master-inbox/reply
**Status**: NEEDS IMPLEMENTATION CHECK
**Schema**: TBD - must check controller

### 16. forward.mdx
**API**: POST /v1/master-inbox/forward
**Status**: NEEDS IMPLEMENTATION CHECK
**Schema**: TBD - must check controller

**Action Required:**
- Check `/server/controller/v1/master_inbox/masterInboxController.js`
- Check `/server/services/master_inbox/`
- Document actual request/response schemas

---

## Documentation Efficiency Strategy

Given 16 remaining endpoints, I'll create them in order of:
1. **Highest usage** (inbox views)
2. **Most complex** (subsequence, reminders)
3. **Simplest** (mark-read, update-revenue)
4. **Needs analysis** (reply, forward)

**Estimated Completion Time**: 8-10 hours

**Files to Create/Update**: 16 MDX files

**Documentation Standard**: Each file must include:
- ✅ Complete schema from implementation
- ✅ Query + body parameters
- ✅ Code examples (3 languages minimum)
- ✅ Common workflows (2-3)
- ✅ Response examples
- ✅ Related endpoints

---

## Implementation Verification Needed

For reply and forward endpoints, must verify:
1. Request body schema (check Joi validation)
2. Query parameters
3. Response structure
4. Business logic (reply threading, forward recipients, etc.)

**Files to check:**
```
/server/api/routes/v1/master_inbox.js
/server/controller/v1/master_inbox/masterInboxController.js
/server/services/master_inbox/
```

---

**Next Step**: Continue creating documentation files for all 16 remaining endpoints

