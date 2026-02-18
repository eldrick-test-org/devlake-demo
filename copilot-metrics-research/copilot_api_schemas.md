# GitHub Copilot Usage Metrics API — Response Schemas

> Comprehensive schema reference for all 8 Copilot Usage Metrics REST API endpoints.
> Validated against live responses from the `avocado-corp` enterprise (February 2026).

---

## 1. Endpoint Catalog

All endpoints are part of the **Copilot Usage Metrics API** (public preview).
Enterprise policy **"Copilot usage metrics"** must be **Enabled everywhere** for data to be generated.

| # | Endpoint | Scope | Description |
|---|----------|-------|-------------|
| 1 | `GET /enterprises/{enterprise}/copilot/metrics/reports/enterprise-1-day?day=DAY` | Enterprise | Enterprise aggregate metrics for a specific day |
| 2 | `GET /enterprises/{enterprise}/copilot/metrics/reports/enterprise-28-day/latest` | Enterprise | Latest 28-day enterprise aggregate metrics |
| 3 | `GET /enterprises/{enterprise}/copilot/metrics/reports/users-1-day?day=DAY` | Enterprise | Enterprise user-level metrics for a specific day |
| 4 | `GET /enterprises/{enterprise}/copilot/metrics/reports/users-28-day/latest` | Enterprise | Latest 28-day enterprise user-level metrics |
| 5 | `GET /orgs/{org}/copilot/metrics/reports/organization-1-day?day=DAY` | Organization | Org aggregate metrics for a specific day |
| 6 | `GET /orgs/{org}/copilot/metrics/reports/organization-28-day/latest` | Organization | Latest 28-day org aggregate metrics |
| 7 | `GET /orgs/{org}/copilot/metrics/reports/users-1-day?day=DAY` | Organization | Org user-level metrics for a specific day |
| 8 | `GET /orgs/{org}/copilot/metrics/reports/users-28-day/latest` | Organization | Latest 28-day org user-level metrics |

---

## 2. Metadata Response Schemas

Every endpoint above returns a **metadata envelope** with signed download links — not the report data itself. You must follow a two-step flow:

1. **Request metadata** → receive signed URLs and date range.
2. **Download report file(s)** → GET each URL in `download_links` to retrieve the actual metrics JSON.
3. **Parse report** → JSON (aggregate) or JSON Lines (user-level).

> **⚠️ Signed URLs expire** — download promptly after receiving the metadata response.

### 1-Day Metadata Response

Returned by endpoints #1, #3, #5, #7.

```json
{
  "download_links": ["string (signed URL)"],
  "report_day": "string (YYYY-MM-DD)"
}
```

**Example** (validated `enterprise-1-day`, `avocado-corp`, 2026-02-10):
```json
{
  "download_links": [
    "https://copilot-reports-acc0engfa5gra7ha.b01.azurefd.net/enterprise-1-day-report/blue/v0/2026-02-10/..."
  ],
  "report_day": "2026-02-10"
}
```

### 28-Day Metadata Response

Returned by endpoints #2, #4, #6, #8.

```json
{
  "download_links": ["string (signed URL)"],
  "report_start_day": "string (YYYY-MM-DD)",
  "report_end_day": "string (YYYY-MM-DD)"
}
```

**Example** (validated `enterprise-28-day`, `avocado-corp`, 2026-02-13):
```json
{
  "download_links": [
    "https://copilot-reports-acc0engfa5gra7ha.b01.azurefd.net/enterprise-28-day-report/blue/v0/2026-02-12/..."
  ],
  "report_end_day": "2026-02-12",
  "report_start_day": "2026-01-16"
}
```

---

## 3. Enterprise Aggregate Report File Schema

**Used by:** Endpoint #1 (`enterprise-1-day`) and Endpoint #2 (`enterprise-28-day`).

**Format:** JSON (single object).

### 1-Day Report File

A flat JSON object with one day's aggregate data. Validated against live `enterprise-1-day` download (2026-02-10).

```json
{
  "day": "string (YYYY-MM-DD)",
  "enterprise_id": "string",
  "daily_active_users": "integer",
  "user_initiated_interaction_count": "integer",
  "code_generation_activity_count": "integer",
  "code_acceptance_activity_count": "integer",
  "loc_suggested_to_add_sum": "integer",
  "loc_suggested_to_delete_sum": "integer",
  "loc_added_sum": "integer",
  "loc_deleted_sum": "integer",
  "pull_requests": {
    "total_reviewed": "integer",
    "total_created": "integer",
    "total_created_by_copilot": "integer",
    "total_reviewed_by_copilot": "integer"
  },
  "totals_by_ide": "array<TotalsByIde>",
  "totals_by_feature": "array<TotalsByFeature>",
  "totals_by_language_feature": "array<TotalsByLanguageFeature>",
  "totals_by_language_model": "array<TotalsByLanguageModel>",
  "totals_by_model_feature": "array<TotalsByModelFeature>"
}
```

> **Note:** The 1-day report does **not** include `weekly_active_users`, `monthly_active_users`, `monthly_active_chat_users`, or `monthly_active_agent_users`. Those rolling metrics only appear in the 28-day report.

> **Note:** `pull_requests` was added in a later API revision (present in Feb 2026 data, absent in Nov/Dec 2025 data).

### 28-Day Report File

A wrapper object containing `day_totals` — an array of per-day aggregates for the 28-day window. Validated against `avocado_corp_enterprise_28_day.json` (Nov–Dec 2025).

```json
{
  "report_start_day": "string (YYYY-MM-DD)",
  "report_end_day": "string (YYYY-MM-DD)",
  "enterprise_id": "string",
  "created_at": "string (timestamp)",
  "day_totals": [
    {
      "day": "string (YYYY-MM-DD)",
      "enterprise_id": "string",
      "daily_active_users": "integer",
      "weekly_active_users": "integer",
      "monthly_active_users": "integer",
      "monthly_active_chat_users": "integer",
      "monthly_active_agent_users": "integer",
      "user_initiated_interaction_count": "integer",
      "code_generation_activity_count": "integer",
      "code_acceptance_activity_count": "integer",
      "loc_suggested_to_add_sum": "integer",
      "loc_suggested_to_delete_sum": "integer",
      "loc_added_sum": "integer",
      "loc_deleted_sum": "integer",
      "pull_requests": {
        "total_reviewed": "integer",
        "total_created": "integer",
        "total_created_by_copilot": "integer",
        "total_reviewed_by_copilot": "integer"
      },
      "totals_by_ide": "array<TotalsByIde>",
      "totals_by_feature": "array<TotalsByFeature>",
      "totals_by_language_feature": "array<TotalsByLanguageFeature>",
      "totals_by_language_model": "array<TotalsByLanguageModel>",
      "totals_by_model_feature": "array<TotalsByModelFeature>"
    }
  ]
}
```

---

## 4. Enterprise Users Report File Schema

**Used by:** Endpoint #3 (`users-1-day`) and Endpoint #4 (`users-28-day`).

**Format:** JSON Lines (one JSON record per line, one line per user per day).

Validated against live `users-1-day` download (2026-02-10).

```json
{
  "user_id": "integer",
  "user_login": "string",
  "day": "string (YYYY-MM-DD)",
  "enterprise_id": "string",
  "user_initiated_interaction_count": "integer",
  "code_generation_activity_count": "integer",
  "code_acceptance_activity_count": "integer",
  "loc_suggested_to_add_sum": "integer",
  "loc_suggested_to_delete_sum": "integer",
  "loc_added_sum": "integer",
  "loc_deleted_sum": "integer",
  "used_agent": "boolean",
  "used_chat": "boolean",
  "totals_by_ide": "array<UserTotalsByIde>",
  "totals_by_feature": "array<TotalsByFeature>",
  "totals_by_language_feature": "array<TotalsByLanguageFeature>",
  "totals_by_language_model": "array<TotalsByLanguageModel>",
  "totals_by_model_feature": "array<TotalsByModelFeature>"
}
```

For the 28-day variant, the download file contains one JSON record per line for each user for each day in the 28-day window. The record schema is identical.

---

## 5. Organization Aggregate Report File Schema

**Used by:** Endpoint #5 (`organization-1-day`) and Endpoint #6 (`organization-28-day`).

**Format:** JSON (single object).

The organization aggregate report follows the **same schema** as the enterprise aggregate report (Section 3), with `org_id` in place of `enterprise_id`. The structure, field names, and nested arrays are identical.

> **⚠️ Legacy API note:** The deprecated `GET /orgs/{org}/copilot/metrics` endpoint (sunset April 2, 2026) used a different nested schema with `copilot_ide_code_completions`, `copilot_ide_chat`, `copilot_dotcom_chat`, and `copilot_dotcom_pull_requests` top-level objects. That legacy format is documented in Section 10B below for reference. The current Usage Metrics Reports endpoints (#5 and #6) use the flat `totals_by_*` schema shown in Section 3.

---

## 6. Organization Users Report File Schema

**Used by:** Endpoint #7 (`users-1-day`) and Endpoint #8 (`users-28-day`).

**Format:** JSON Lines (one JSON record per line, one line per user per day).

The organization user-level report follows the **same schema** as the enterprise user-level report (Section 4), with `org_id` in place of `enterprise_id`. The per-user fields, nested breakdown arrays, and `used_agent`/`used_chat` booleans are identical.

---

## 7. Nested Object Schemas

### TotalsByIde

Used in aggregate report `totals_by_ide` arrays.

```json
{
  "ide": "string (e.g., 'vscode', 'intellij', 'vim', 'visualstudio')",
  "user_initiated_interaction_count": "integer",
  "code_generation_activity_count": "integer",
  "code_acceptance_activity_count": "integer",
  "loc_suggested_to_add_sum": "integer",
  "loc_suggested_to_delete_sum": "integer",
  "loc_added_sum": "integer",
  "loc_deleted_sum": "integer"
}
```

### UserTotalsByIde

Used in user-level report `totals_by_ide` arrays. Extends TotalsByIde with plugin/IDE version info.

```json
{
  "ide": "string",
  "user_initiated_interaction_count": "integer",
  "code_generation_activity_count": "integer",
  "code_acceptance_activity_count": "integer",
  "loc_suggested_to_add_sum": "integer",
  "loc_suggested_to_delete_sum": "integer",
  "loc_added_sum": "integer",
  "loc_deleted_sum": "integer",
  "last_known_plugin_version": {
    "sampled_at": "string (ISO 8601 timestamp)",
    "plugin": "string (e.g., 'copilot-chat', 'copilot', 'copilot-intellij')",
    "plugin_version": "string"
  },
  "last_known_ide_version": {
    "sampled_at": "string (ISO 8601 timestamp)",
    "ide_version": "string"
  }
}
```

### TotalsByFeature

```json
{
  "feature": "string (enum: see Feature Values below)",
  "user_initiated_interaction_count": "integer",
  "code_generation_activity_count": "integer",
  "code_acceptance_activity_count": "integer",
  "loc_suggested_to_add_sum": "integer",
  "loc_suggested_to_delete_sum": "integer",
  "loc_added_sum": "integer",
  "loc_deleted_sum": "integer"
}
```

### TotalsByLanguageFeature

```json
{
  "language": "string (e.g., 'typescript', 'python', 'ruby', 'go', 'others')",
  "feature": "string (enum: see Feature Values below)",
  "code_generation_activity_count": "integer",
  "code_acceptance_activity_count": "integer",
  "loc_suggested_to_add_sum": "integer",
  "loc_suggested_to_delete_sum": "integer",
  "loc_added_sum": "integer",
  "loc_deleted_sum": "integer"
}
```

### TotalsByLanguageModel

```json
{
  "language": "string",
  "model": "string (e.g., 'claude-4.5-sonnet', 'claude-opus-4.6', 'gpt-5.0', 'unknown', 'auto')",
  "code_generation_activity_count": "integer",
  "code_acceptance_activity_count": "integer",
  "loc_suggested_to_add_sum": "integer",
  "loc_suggested_to_delete_sum": "integer",
  "loc_added_sum": "integer",
  "loc_deleted_sum": "integer"
}
```

### TotalsByModelFeature

```json
{
  "model": "string",
  "feature": "string (enum: see Feature Values below)",
  "user_initiated_interaction_count": "integer",
  "code_generation_activity_count": "integer",
  "code_acceptance_activity_count": "integer",
  "loc_suggested_to_add_sum": "integer",
  "loc_suggested_to_delete_sum": "integer",
  "loc_added_sum": "integer",
  "loc_deleted_sum": "integer"
}
```

### PullRequests (aggregate reports only)

```json
{
  "total_reviewed": "integer",
  "total_created": "integer",
  "total_created_by_copilot": "integer",
  "total_reviewed_by_copilot": "integer"
}
```

---

## 8. Enumeration Values

### Feature Values (observed in actual data)

| Feature | Description |
|---------|-------------|
| `code_completion` | Inline code completions/suggestions |
| `chat_panel_agent_mode` | Chat panel in agent mode (agentic coding) |
| `chat_panel_ask_mode` | Chat panel in ask/question mode |
| `chat_panel_custom_mode` | Chat panel in custom mode |
| `chat_panel_edit_mode` | Chat panel in edit mode |
| `chat_panel_unknown_mode` | Chat panel mode unknown (often IntelliJ) |
| `agent_edit` | Agent-driven code edits (applied changes) |
| `chat_inline` | Inline chat (Ctrl+I / Cmd+I) |

### IDE Values (observed in actual data)

| IDE | Plugin Name |
|-----|-------------|
| `vscode` | copilot, copilot-chat |
| `intellij` | copilot-intellij |
| `visualstudio` | (Visual Studio) |
| `vim` | copilot.vim |
| `neovim` | copilot.vim |

### Model Values (observed in actual data)

| Model | Description |
|-------|-------------|
| `unknown` | Model not specified/tracked |
| `auto` | Auto-selected model |
| `claude-4.5-sonnet` | Anthropic Claude 4.5 Sonnet |
| `claude-4.5-haiku` | Anthropic Claude 4.5 Haiku |
| `claude-4.0-sonnet` | Anthropic Claude 4.0 Sonnet |
| `claude-opus-4` | Anthropic Claude Opus 4 |
| `claude-opus-4.5` | Anthropic Claude Opus 4.5 |
| `claude-opus-4.6` | Anthropic Claude Opus 4.6 |
| `gpt-4.1` | OpenAI GPT-4.1 |
| `gpt-4o` | OpenAI GPT-4o |
| `gpt-5.0` | OpenAI GPT-5.0 |
| `gpt-5.1` | OpenAI GPT-5.1 |
| `gpt-5.1-codex` | OpenAI GPT-5.1 Codex |
| `gpt-5-mini` | OpenAI GPT-5 Mini |
| `gpt-5-codex` | OpenAI GPT-5 Codex |
| `gemini-3.0-pro` | Google Gemini 3.0 Pro |
| `others` | Other models |

### Language Values (sample observed in actual data)

- `typescript`, `typescriptreact`, `javascript`
- `python`, `ruby`, `go`, `java`, `csharp`, `kotlin`
- `markdown`, `json`, `jsonc`, `yaml`, `xml`
- `css`, `html`, `tsx`
- `bash`, `shellscript`, `powershell`, `zsh`
- `dockerfile`, `terraform`, `bicep`
- `sql`, `kusto`, `proto3`
- `dotenv`, `properties`, `erb`, `github-actions-workflow`
- `unknown`, `others`

---

## 9. Authentication & Permissions

### Enterprise Endpoints (#1–#4)

| Token Type | Required Scope |
|------------|----------------|
| PAT (classic) | `manage_billing:copilot` or `read:enterprise` |
| Fine-grained PAT | Not supported for enterprise scope |
| GitHub App (installation) | "Enterprise Copilot metrics" permission (read) |
| GitHub App (user token) | "Enterprise Copilot metrics" permission (read) |

### Organization Endpoints (#5–#8)

| Token Type | Required Scope |
|------------|----------------|
| PAT (classic) | `read:org` |
| Fine-grained PAT | "Organization Copilot metrics" permission (read) |
| GitHub App (installation) | "Organization Copilot metrics" permission (read) |
| GitHub App (user token) | "Organization Copilot metrics" permission (read) |

### Common Requirements

- The authenticated user must be an **enterprise owner** (enterprise endpoints) or **organization owner** (org endpoints).
- Enterprise policy **"Copilot usage metrics"** must be set to **"Enabled everywhere"**.
- Standard GitHub API rate limits apply.

---

## 10. Additional Endpoints (Reference)

### 10A. Organization Billing Schema

**Endpoint:** `GET /orgs/{org}/copilot/billing`

```json
{
  "seat_breakdown": {
    "pending_invitation": "integer",
    "pending_cancellation": "integer",
    "added_this_cycle": "integer",
    "total": "integer",
    "active_this_cycle": "integer",
    "inactive_this_cycle": "integer"
  },
  "seat_management_setting": "string (e.g., 'assign_all', 'assign_selected')",
  "plan_type": "string ('business' | 'enterprise')",
  "public_code_suggestions": "string ('allow' | 'block')",
  "ide_chat": "string ('enabled' | 'disabled')",
  "cli": "string ('enabled' | 'disabled')",
  "platform_chat": "string ('enabled' | 'disabled')"
}
```

### 10B. Seat Assignment Schema

**Endpoint:** `GET /orgs/{org}/copilot/billing/seats`

```json
{
  "total_seats": "integer",
  "seats": [
    {
      "created_at": "string (ISO 8601 timestamp)",
      "assignee": {
        "login": "string",
        "id": "integer",
        "type": "string ('User' | 'Team')"
      },
      "pending_cancellation_date": "string | null",
      "plan_type": "string ('business' | 'enterprise')",
      "last_authenticated_at": "string (ISO 8601 timestamp)",
      "updated_at": "string (ISO 8601 timestamp)",
      "last_activity_at": "string (ISO 8601 timestamp)",
      "last_activity_editor": "string"
    }
  ]
}
```

### 10C. Legacy Organization Metrics Schema (Deprecated)

**Deprecated endpoints** (sunset April 2, 2026) — migrate to Usage Metrics Reports (endpoints #5–#8):
- `GET /orgs/{org}/copilot/metrics`
- `GET /enterprises/{enterprise}/copilot/metrics`

The legacy format used a different nested structure:

```json
[
  {
    "date": "string (YYYY-MM-DD)",
    "total_active_users": "integer",
    "total_engaged_users": "integer",
    "copilot_ide_code_completions": {
      "total_engaged_users": "integer",
      "editors": [
        {
          "name": "string",
          "total_engaged_users": "integer",
          "models": [
            {
              "name": "string",
              "is_custom_model": "boolean",
              "total_engaged_users": "integer",
              "languages": [
                {
                  "name": "string",
                  "total_engaged_users": "integer",
                  "total_code_suggestions": "integer",
                  "total_code_acceptances": "integer",
                  "total_code_lines_suggested": "integer",
                  "total_code_lines_accepted": "integer"
                }
              ]
            }
          ]
        }
      ]
    },
    "copilot_ide_chat": {
      "total_engaged_users": "integer",
      "editors": [
        {
          "name": "string",
          "total_engaged_users": "integer",
          "models": [
            {
              "name": "string",
              "is_custom_model": "boolean",
              "total_engaged_users": "integer",
              "total_chats": "integer",
              "total_chat_copy_events": "integer",
              "total_chat_insertion_events": "integer"
            }
          ]
        }
      ]
    },
    "copilot_dotcom_chat": {
      "total_engaged_users": "integer",
      "models": [
        {
          "name": "string",
          "is_custom_model": "boolean",
          "total_engaged_users": "integer",
          "total_chats": "integer"
        }
      ]
    },
    "copilot_dotcom_pull_requests": {
      "total_engaged_users": "integer",
      "repositories": [
        {
          "name": "string",
          "total_engaged_users": "integer",
          "models": [
            {
              "name": "string",
              "is_custom_model": "boolean",
              "total_engaged_users": "integer",
              "total_pr_summaries_created": "integer"
            }
          ]
        }
      ]
    }
  }
]
```

---

## 11. Key Metrics Definitions

| Metric | Definition |
|--------|------------|
| `daily_active_users` | Users who had any Copilot activity on that day |
| `weekly_active_users` | Users active in the past 7 days (rolling; 28-day reports only) |
| `monthly_active_users` | Users active in the past 28 days (rolling; 28-day reports only) |
| `monthly_active_chat_users` | Users who used chat features in the past 28 days (28-day reports only) |
| `monthly_active_agent_users` | Users who used agent features in the past 28 days (28-day reports only) |
| `user_initiated_interaction_count` | Chat messages, inline prompts initiated by user |
| `code_generation_activity_count` | Number of code suggestions/generations made |
| `code_acceptance_activity_count` | Number of suggestions accepted by user |
| `loc_suggested_to_add_sum` | Lines of code suggested for addition |
| `loc_suggested_to_delete_sum` | Lines of code suggested for deletion |
| `loc_added_sum` | Lines of code actually added (accepted) |
| `loc_deleted_sum` | Lines of code actually deleted (accepted) |
| `used_agent` | User utilized agent mode during the day (user-level reports only) |
| `used_chat` | User utilized chat features during the day (user-level reports only) |
| `pull_requests.total_created` | Total PRs created in the enterprise/org on that day |
| `pull_requests.total_created_by_copilot` | PRs created using Copilot |
| `pull_requests.total_reviewed` | Total PRs reviewed |
| `pull_requests.total_reviewed_by_copilot` | PRs reviewed using Copilot |

---

## 12. Data Availability Notes

- **Historical data:** Up to 1 year for report downloads
- **Data freshness:** Daily, processed overnight
- **Privacy threshold:** Metrics require 5+ users for aggregation (aggregate reports)
- **Download format:** JSON for enterprise/org aggregate reports; JSON Lines for user-level reports
- **Signed URLs:** Download links expire — fetch promptly after metadata request
- **Rate limits:** Standard GitHub API rate limits apply
- **Multiple download links:** Large reports may be split across multiple files in `download_links`
- **28-day window:** The 28-day report covers a rolling window; `report_start_day` and `report_end_day` define the range
- **1-day parameter:** The `day` query parameter accepts `YYYY-MM-DD` format; data must exist for that day
