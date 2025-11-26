# Master Inbox - Complete Request Schema Reference

This document provides the complete request schema that applies to ALL master inbox filter endpoints.

## Endpoints Using This Schema

- POST /v1/master-inbox/sent
- POST /v1/master-inbox/inbox-replies
- POST /v1/master-inbox/assigned-me
- POST /v1/master-inbox/unread-replies
- POST /v1/master-inbox/important
- POST /v1/master-inbox/snoozed
- POST /v1/master-inbox/reminders (different sortBy options)
- POST /v1/master-inbox/scheduled (different sortBy options)
- POST /v1/master-inbox/archived
- POST /v1/master-inbox/views (adds subSequenceId filter)

## Query Parameters

### All Endpoints (except /reminders)
```
api_key: string (required)
fetch_message_history: boolean (default: false)
```

### /reminders Only
```
api_key: string (required)
```
(No fetch_message_history parameter)

## Complete Request Body Schema

```json
{
  "offset": number (min: 0, default: 0),
  "limit": number (min: 1, max: 20, default: 20),
  "filters": {
    "search": string (max: 30 chars, nullable),
    
    "leadCategories": {
      "unassigned": boolean (nullable),
      "isAssigned": boolean (nullable),
      "categoryIdsNotIn": array<number> (max: 10 items, nullable),
      "categoryIdsIn": array<number> (max: 10 items, nullable)
    },
    
    "emailStatus": string | array<string> (nullable),
    // Valid values: "Opened", "Clicked", "Replied", "Unsubscribed", "Bounced", "Accepted", "Not Replied"
    
    "campaignId": number | array<number> (nullable),
    // Array limits vary by endpoint:
    // - sent: max 15
    // - inbox-replies, unread-replies, important, snoozed, scheduled, archived: max 5
    // - assigned-me, views: single value only
    
    "emailAccountId": number | array<number> (nullable),
    // Array limits vary by endpoint:
    // - sent: unlimited
    // - inbox-replies: max 20
    // - unread-replies, important, snoozed, scheduled, archived: max 10
    // - assigned-me, views: single value only
    
    "campaignTeamMemberId": number | array<number> (nullable),
    // Array limits vary by endpoint:
    // - sent, inbox-replies, unread-replies, important, snoozed, reminders, scheduled, archived: max 10
    // - assigned-me, views: single value only
    
    "campaignTagId": number | array<number> (nullable),
    // Array limits vary by endpoint:
    // - sent, inbox-replies, unread-replies, important, snoozed, reminders, scheduled, archived: max 10
    // - assigned-me, views: single value only
    
    "campaignClientId": number | array<number> (nullable),
    // Array limits vary by endpoint:
    // - sent, inbox-replies, unread-replies, important, snoozed, reminders, scheduled, archived: max 10
    // - assigned-me, views: single value only
    
    "replyTimeBetween": [string, string] (nullable),
    // Array of 2 ISO 8601 datetime strings
    // Example: ["2025-01-01T00:00:00Z", "2025-01-31T23:59:59Z"]
    
    "subSequenceId": number (nullable)
    // ONLY available in /views endpoint
  },
  
  "sortBy": string (nullable),
  // Options vary by endpoint:
  // - Most endpoints: "REPLY_TIME_DESC", "SENT_TIME_DESC"
  // - /reminders: "REMINDER_TIME_DESC", "REMINDER_TIME_ASC"
  // - /scheduled: "SCHEDULED_TIME_DESC", "SCHEDULED_TIME_ASC"
}
```

## Response Structure

All filter endpoints return the same structure:

```json
{
  "messages": [
    {
      "id": "string",
      "campaign_lead_map_id": "string",
      "lead": {
        "email": "string",
        "first_name": "string",
        "last_name": "string",
        "company": "string",
        "phone": "string"
      },
      "campaign": {
        "id": number,
        "name": "string"
      },
      "email_account": {
        "id": number,
        "email": "string",
        "name": "string"
      },
      "last_message": {
        "id": "string",
        "subject": "string",
        "body": "string",
        "received_at": "ISO 8601 datetime",
        "sent_from": "string",
        "sent_to": "string"
      },
      "message_history": [] (only if fetch_message_history=true),
      "email_status": "string",
      "category": {
        "id": number,
        "name": "string"
      },
      "assigned_to": {
        "id": number,
        "name": "string",
        "email": "string"
      },
      "stats": {
        "total_sent": number,
        "total_opened": number,
        "total_clicked": number,
        "total_replied": number,
        "last_activity": "ISO 8601 datetime"
      },
      "is_read": boolean,
      "is_important": boolean,
      "is_archived": boolean,
      "tags": ["string"]
    }
  ],
  "total_count": number,
  "offset": number,
  "limit": number
}
```

## Common Error Responses

### 422 - Validation Error
```json
{
  "error": "limit must be between 1 and 20",
  "field": "limit",
  "provided_value": 50
}
```

### 422 - Array Limit Exceeded
```json
{
  "error": "campaignId array cannot exceed 5 items",
  "field": "filters.campaignId",
  "provided_count": 10,
  "max_allowed": 5
}
```

### 401 - Unauthorized
```json
{
  "message": "Invalid API Key"
}
```

