# API Documentation Fixes — Validation Report

**PR:** https://github.com/Smartlead-Public/docs/pull/9
**ClickUp Ticket:** https://app.clickup.com/t/86d2gp141
**Validated Against:** Backend Joi route schemas in `smartlead-be`
**Files Fixed:** 28 MDX files
**Date:** 2026-04-01

---

## How Issues Were Found

Every parameter in the documentation was compared against the actual `celebrate`/`Joi` validation schemas in three backend route files:

- `server/api/routes/v1/campaigns.js` — Campaign Statistics + Inbox
- `server/api/routes/v1/master_inbox.js` — Master Inbox
- `server/api/routes/analytics.js` — Global Analytics

Issues fell into five categories:

1. **Wrong endpoint path** — docs pointed to an internal endpoint, not the public v1 API
2. **Non-existent parameters** — params in the docs that the backend never reads or validates
3. **Missing required params** — params the backend requires that were absent or marked optional
4. **Wrong types** — `string` documented where backend expects `integer`, or vice versa
5. **Wrong constraints** — incorrect max/min/default values

---

## Campaign Statistics

### `GET /campaigns/{campaign_id}/statistics`
**File:** `api-reference/campaign-statistics/get-by-id.mdx`

| # | Issue | Fix |
|---|-------|-----|
| 1 | `campaign_id` path param typed as `string` | Changed to `integer` |
| 2 | `email_sequence_number` typed as `string` with no constraints — docs described it as accepting array format like `{1,2,3}` | Changed to `integer`, added constraint: min 1, max 20 (single number only — backend is `Joi.number().min(1).max(20)`) |
| 3 | `limit` had no max constraint mentioned | Added "max 1000" note |

---

### `GET /campaigns/{campaign_id}/analytics-by-date`
**File:** `api-reference/campaign-statistics/get-by-date-range.mdx`

| # | Issue | Fix |
|---|-------|-----|
| 1 | `start_date` marked optional with a default value | Removed default, marked `required` |
| 2 | `end_date` marked optional with a default value | Removed default, marked `required` |
| 3 | `time_zone` param missing entirely | Added as optional IANA timezone string |

---

### `GET /campaigns/{campaign_id}/top-level-analytics-by-date`
**File:** `api-reference/campaign-statistics/top-level-by-date.mdx`

| # | Issue | Fix |
|---|-------|-----|
| 1 | `start_date` had a hardcoded default `2022-12-16` and appeared optional | Removed default, marked `required` |
| 2 | `end_date` had a hardcoded default `2022-12-23` and appeared optional | Removed default, marked `required` |

---

### `GET /campaigns/{campaign_id}/leads-statistics`
**File:** `api-reference/campaign-statistics/lead-statistics.mdx`

| # | Issue | Fix |
|---|-------|-----|
| 1 | API path in frontmatter was `/lead-statistics` (singular) | Corrected to `/leads-statistics` (plural) — backend route is `leads-statistics` |
| 2 | `created_at_gt` param documented but does not exist in backend validation | Removed entirely |
| 3 | `limit` typed as `string` with default "1" | Changed to `integer`, removed fake default, added "max 100" constraint |
| 4 | `offset` typed as `string` with default "1" | Changed to `integer`, removed default |
| 5 | Code examples used wrong path `/lead-statistics` | Updated to `/leads-statistics` |

---

## Global Analytics

### `GET /analytics/campaign/list`
**File:** `api-reference/analytics/campaign-list.mdx`

| # | Issue | Fix |
|---|-------|-----|
| 1 | `start_date` documented as required — does not exist in backend | Removed |
| 2 | `end_date` documented as required — does not exist in backend | Removed |
| 3 | `timezone` documented — does not exist in backend | Removed |
| 4 | `campaign_ids` documented — does not exist in backend | Removed |

Backend only accepts: `client_ids` (optional).

---

### `GET /analytics/client/list`
**File:** `api-reference/analytics/client-list.mdx`

| # | Issue | Fix |
|---|-------|-----|
| 1–4 | Same as `campaign/list` — `start_date`, `end_date`, `timezone`, `campaign_ids` all documented but absent from backend | All removed |

---

### `GET /analytics/client/month-wise-count`
**File:** `api-reference/analytics/month-wise-client-count.mdx`

| # | Issue | Fix |
|---|-------|-----|
| 1–4 | Same as above — `start_date`, `end_date`, `timezone`, `campaign_ids` absent from backend | All removed |

---

### `GET /analytics/overall-stats-v2`
**File:** `api-reference/analytics/overview.mdx`

| # | Issue | Fix |
|---|-------|-----|
| 1 | `start_date` missing or not marked required | Added as `required` |
| 2 | `end_date` missing or not marked required | Added as `required` |
| 3 | `timezone` missing or not marked required | Added as `required` (IANA string) |
| 4 | Optional params `client_ids`, `campaign_ids`, `is_agency`, `full_data` undocumented | Added as optional |
| 5 | Code examples missing required params | Updated |

---

### `GET /analytics/campaign/overall-stats`
**File:** `api-reference/analytics/campaign-performance.mdx`

| # | Issue | Fix |
|---|-------|-----|
| 1–3 | `start_date`, `end_date`, `timezone` not marked required | All marked `required` |
| 4 | Optional params `client_ids`, `campaign_ids`, `limit`, `offset`, `full_data` undocumented | Added as optional |
| 5 | Code examples missing required params | Updated |

---

### `GET /analytics/lead/overall-stats`
**File:** `api-reference/analytics/lead-stats.mdx`

| # | Issue | Fix |
|---|-------|-----|
| 1–3 | `start_date`, `end_date`, `timezone` not marked required | All marked `required` |
| 4 | Optional params `client_ids`, `campaign_ids` undocumented | Added as optional |
| 5 | Code examples missing required params | Updated |

---

### `GET /analytics/campaign/status-stats`
**File:** `api-reference/analytics/campaign-status-stats.mdx`

| # | Issue | Fix |
|---|-------|-----|
| 1 | `start_date` marked required | Changed to optional — backend has no `.required()` on this param |
| 2 | `end_date` marked required | Changed to optional |

---

### `GET /analytics/mailbox/overall-stats`
**File:** `api-reference/analytics/mailbox-health.mdx`

| # | Issue | Fix |
|---|-------|-----|
| 1 | `start_date` marked required | Changed to optional |
| 2 | `end_date` marked required | Changed to optional |

---

### `timezone` Required — 14 Analytics Endpoints

The following endpoints all use `Joi.string().required()` for the `timezone` param in the backend, but it was documented as optional (or missing) in the docs.

| File | Endpoint |
|------|----------|
| `day-wise-stats.mdx` | `GET /analytics/campaign/day-wise-stats` |
| `day-wise-sent-time.mdx` | `GET /analytics/campaign/day-wise-sent-time` |
| `day-wise-positive-reply.mdx` | `GET /analytics/campaign/day-wise-positive-reply` |
| `day-wise-positive-sent-time.mdx` | `GET /analytics/campaign/day-wise-positive-sent-time` |
| `campaign-response-stats.mdx` | `GET /analytics/campaign/response-stats` |
| `email-wise-health.mdx` | `GET /analytics/mailbox/email-wise-health` |
| `domain-wise-health.mdx` | `GET /analytics/mailbox/domain-wise-health` |
| `provider-performance.mdx` | `GET /analytics/mailbox/provider-performance` |
| `team-board-stats.mdx` | `GET /analytics/team/board-stats` |
| `lead-category-response.mdx` | `GET /analytics/lead/category-response` |
| `leads-for-first-reply.mdx` | `GET /analytics/lead/leads-for-first-reply` |
| `followup-reply-rate.mdx` | `GET /analytics/lead/followup-reply-rate` |
| `lead-to-reply-time.mdx` | `GET /analytics/lead/lead-to-reply-time` |
| `client-performance.mdx` | `GET /analytics/client/performance` |

**Fix applied to all 14:** Changed `timezone` from optional to `required`.

---

## Master Inbox

### `POST /campaigns/{campaign_id}/reply-email-thread`
**File:** `api-reference/inbox/reply.mdx`

| # | Issue | Fix |
|---|-------|-----|
| 1 | Endpoint path was `/api/v1/email-campaigns/send-email-thread` — this is an **internal** endpoint not available via the public API | Corrected to `/api/v1/campaigns/{campaign_id}/reply-email-thread` |
| 2 | `campaign_id` was a body param (`campaignId`) | Moved to path parameter |
| 3 | `id` body param documented — no equivalent in backend | Removed |
| 4 | All body params in camelCase — backend uses snake_case | Renamed all params: |
|   | `emailStatsId` → `email_stats_id` (required) | |
|   | `emailBody` → `email_body` (required) | |
|   | `toEmail` → `to_email` | |
|   | `toFirstName` → `to_first_name` | |
|   | `toLastName` → `to_last_name` | |
|   | `scheduledTime` → `scheduled_time` | |
|   | `replyMessageId` → `reply_message_id` | |
|   | `replyEmailBody` → `reply_email_body` | |
|   | `replyEmailTime` → `reply_email_time` | |
|   | `scheduleCondition` → `schedule_condition` | |
|   | `addSignature` → `add_signature` | |
|   | `seqType` → `seq_type` | |
| 5 | All code examples used wrong path and camelCase params | Updated to match corrected endpoint and params |

---

### `POST /campaigns/{campaign_id}/forward-email`
**File:** `api-reference/inbox/forward.mdx`

| # | Issue | Fix |
|---|-------|-----|
| 1 | Endpoint path was `/api/v1/email-campaigns/forward-reply-email` — internal endpoint | Corrected to `/api/v1/campaigns/{campaign_id}/forward-email` |
| 2 | `campaignId` body param | Moved to path parameter (`campaign_id`) |
| 3 | `emailStatsId`, `emailThreadId`, `forwardEmailSubject`, `forwardEmailBody`, `forwardToEmailIds` — none of these match backend | All removed |
| 4 | Correct body params were entirely absent | Added: `message_id` (string, required), `stats_id` (string, required), `to_emails` (string, required — comma-separated) |
| 5 | All code examples wrong | Fully rewritten |

---

### `POST /master-inbox/unread-replies`
**File:** `api-reference/inbox/get-unread.mdx`

| # | Issue | Fix |
|---|-------|-----|
| 1 | `emailAccountId` array max described as "20 accounts" | Corrected to "10 accounts" — backend validation is `Joi.array().max(10)` |

---

---

## What Was Already Correct

These endpoints and parameters were validated against the backend and required **no changes**. PR #8 (pre-existing) had already fixed some of these; others were correct from the start.

### Campaign Statistics

| Endpoint | File | Status |
|----------|------|--------|
| `GET /campaigns/{campaign_id}/statistics` — `api_key`, `offset`, `limit`, `email_status`, `sent_time_start_date`, `sent_time_end_date` params | `get-by-id.mdx` | Correct |
| `GET /campaigns/{campaign_id}/analytics-by-date` — path, HTTP method, response shape | `get-by-date-range.mdx` | Correct |
| `GET /campaigns/{campaign_id}/top-level-analytics-by-date` — path, HTTP method | `top-level-by-date.mdx` | Correct |
| `GET /campaigns/{campaign_id}/leads-statistics` — `event_time_gt` param, `api_key` | `lead-statistics.mdx` | Correct |
| `GET /campaigns/{campaign_id}/mailbox-statistics` — path, HTTP method, all params | `mailbox-statistics.mdx` | Correct — no changes needed |

### Global Analytics

| Endpoint | File | Status |
|----------|------|--------|
| `GET /analytics/campaign/list` — path, HTTP method, `client_ids` param | `campaign-list.mdx` | Correct (after removing phantom params) |
| `GET /analytics/client/list` — path and method | `client-list.mdx` | Correct |
| `GET /analytics/client/month-wise-count` — path and method | `month-wise-client-count.mdx` | Correct |
| `GET /analytics/campaign/status-stats` — path, `client_ids`, `campaign_ids` optional params | `campaign-status-stats.mdx` | Correct |
| `GET /analytics/mailbox/overall-stats` — path, optional params | `mailbox-health.mdx` | Correct |
| All 14 day-wise/health/performance endpoints — paths, HTTP methods, `start_date`/`end_date` params | Various | Correct (only `timezone` required-ness was wrong) |

### Master Inbox

| Endpoint | File | Status |
|----------|------|--------|
| `GET /master-inbox/messages` — path, all params | `get-messages.mdx` | Correct — no changes needed |
| `GET /master-inbox/lead-replies` — path, all params | `get-lead-replies.mdx` | Correct — no changes needed |
| `PATCH /master-inbox/{id}/category` — path, body params | `update-category.mdx` | Correct — no changes needed |
| `POST /master-inbox/unread-replies` — path, method, `emailAccountIds` array type, `startDate`/`endDate` params | `get-unread.mdx` | Correct (only max count was wrong) |
| `GET /master-inbox/reminders` — path, params | `get-reminders.mdx` | Correct — no changes needed |
| `GET /master-inbox/{id}` — path, method | `get-by-id.mdx` | Correct — no changes needed |
| `POST /master-inbox/sent` — path, method | `sent.mdx` | Correct — no changes needed |

### What PR #8 Already Fixed (Before This PR)

PR #8 addressed a separate set of issues before this validation work began:

| Fix | File |
|-----|------|
| Campaign Statistics paths updated from old route format | Multiple campaign-statistics files |
| Response examples populated with real response shapes | Several files |
| 422 / error response examples added | Several files |
| `api_key` query param added where missing | Several files |

---

## Summary by Issue Type

| Issue Type | Count |
|------------|-------|
| Wrong endpoint path (internal vs public API) | 2 |
| Non-existent parameters removed | 12 |
| Missing required params added | 9 |
| Optional/required status corrected | 18 |
| Wrong param types fixed | 4 |
| Wrong constraints (max/min/default) corrected | 5 |
| Code examples updated | 8 |
| **Total issues fixed** | **58** |
