# DevLake DORA Demo App

A Node.js app for simulating DORA metrics in [Apache DevLake](https://devlake.apache.org/) and validating the **GitHub Copilot Impact Dashboard**.

## Prerequisites

- **Docker Desktop** running
- **GitHub CLI** authenticated (`gh auth login`)
- **GitHub PAT** with scopes: `repo`, `read:org`, `read:user`, `copilot`, `manage_billing:copilot`
- **Sibling repo** `DevExpGBB/incubator-devlake` cloned alongside this repo (`cd .. && git clone https://github.com/DevExpGBB/incubator-devlake.git`)

## Building Custom DevLake Images

Build all three images from the sibling `incubator-devlake` fork before starting the stack:

```powershell
# Backend (first build takes 5-10 min)
cd ..\incubator-devlake\backend
docker build -t devlake-backend:local -f Dockerfile .

# Config UI (fix CRLF first on Windows)
cd ..\incubator-devlake\config-ui
(Get-Content nginx.sh -Raw) -replace "`r`n", "`n" | Set-Content nginx.sh -NoNewline
docker build -t devlake-config-ui:local -f Dockerfile .

# Grafana
cd ..\incubator-devlake\grafana
docker build -t devlake-dashboard:local -f Dockerfile .
```

## Starting the Stack

```powershell
cd devlake-demo
docker-compose up -d
# Verify: Invoke-RestMethod -Uri "http://localhost:8085/ping"
```

| Service | URL | Credentials |
|---------|-----|-------------|
| Config UI | http://localhost:4004 | N/A |
| Grafana | http://localhost:3004 | admin / admin |
| DevLake API | http://localhost:8085 | N/A |
| MySQL | localhost:3307 | merico / merico |

## Configuring Connections via API

### GitHub Connection

```powershell
$futureDate = (Get-Date).AddYears(1).ToString("yyyy-MM-ddTHH:mm:ssZ")
$body = @{
    name = "your-org-name"; endpoint = "https://api.github.com/"; authMethod = "AccessToken"
    token = "ghp_your_token_here"; enableGraphql = $true; rateLimitPerHour = 12000
    tokenExpiresAt = $futureDate; refreshTokenExpiresAt = $futureDate
} | ConvertTo-Json
Invoke-RestMethod -Uri "http://localhost:8085/plugins/github/connections" -Method Post -Body $body -ContentType "application/json"
```

### GitHub Copilot Connection

```powershell
$body = @{
    name = "your-org-copilot"; endpoint = "https://api.github.com/"; authMethod = "AccessToken"
    token = "ghp_your_token_here"; organization = "your-org-name"; rateLimitPerHour = 12000
    tokenExpiresAt = $futureDate; refreshTokenExpiresAt = $futureDate
} | ConvertTo-Json
Invoke-RestMethod -Uri "http://localhost:8085/plugins/gh-copilot/connections" -Method Post -Body $body -ContentType "application/json"
```

### Scope Config (DORA Patterns)

```powershell
$scopeConfig = @{
    name = "dora-config"; connectionId = 1
    deploymentPattern = "(?i)deploy"   # Match deployment workflows
    productionPattern = "(?i)prod"     # Match production environment
    issueTypeIncident = "incident"     # Label for incidents
    refdiff = @{ tagsPattern = ".*"; tagsLimit = 10; tagsOrder = "reverse semver" }
} | ConvertTo-Json -Depth 3
Invoke-RestMethod -Uri "http://localhost:8085/plugins/github/connections/1/scope-configs" -Method Post -Body $scopeConfig -ContentType "application/json"
```

### Add Repository Scope

```powershell
$headers = @{ Authorization = "Bearer ghp_your_token_here" }
$repo = Invoke-RestMethod -Uri "https://api.github.com/repos/your-org/your-repo" -Headers $headers
$scope = @{ data = @(@{
    githubId = $repo.id; connectionId = 1; name = $repo.name; fullName = $repo.full_name
    htmlUrl = $repo.html_url; cloneUrl = $repo.clone_url; scopeConfigId = 1
})} | ConvertTo-Json -Depth 3
Invoke-RestMethod -Uri "http://localhost:8085/plugins/github/connections/1/scopes" -Method Put -Body $scope -ContentType "application/json"
```

### Add Copilot Scope

```powershell
$copilotScope = @{ data = @(@{
    id = "your-org-name"; connectionId = 1; organization = "your-org-name"
    name = "your-org-name"; fullName = "your-org-name"
})} | ConvertTo-Json -Depth 3
Invoke-RestMethod -Uri "http://localhost:8085/plugins/gh-copilot/connections/1/scopes" -Method Put -Body $copilotScope -ContentType "application/json"
```

## Creating Project and Blueprint

```powershell
# Create project
$project = @{
    name = "Your Project Name"; description = "DORA metrics and Copilot adoption"
    metrics = @(@{ pluginName = "dora"; enable = $true })
} | ConvertTo-Json -Depth 3
$result = Invoke-RestMethod -Uri "http://localhost:8085/projects" -Method Post -Body $project -ContentType "application/json"
$blueprintId = $result.blueprint.id

# Configure blueprint connections
$blueprintUpdate = @{
    connections = @(
        @{ pluginName = "github"; connectionId = 1; scopes = @(@{ scopeId = "YOUR_GITHUB_REPO_ID"; scopeName = "your-org/your-repo" }) },
        @{ pluginName = "gh-copilot"; connectionId = 1; scopes = @(@{ scopeId = "your-org-name"; scopeName = "your-org-name" }) }
    )
    enable = $true; cronConfig = "0 0 * * *"; timeAfter = "2024-01-01T00:00:00Z"
} | ConvertTo-Json -Depth 4
Invoke-RestMethod -Uri "http://localhost:8085/blueprints/$blueprintId" -Method Patch -Body $blueprintUpdate -ContentType "application/json"

# Trigger first collection
Invoke-RestMethod -Uri "http://localhost:8085/blueprints/$blueprintId/trigger" -Method Post
```

## Data Seeding

Seed the database with sample data instead of waiting for real collection:

| Script | Purpose | Command |
|--------|---------|---------|
| `scripts/seed_copilot_impact.sql` | Copilot adoption metrics (90 days, 3 phases) | `docker exec -i devlake-demo-mysql-1 mysql -umerico -pmerico lake < scripts/seed_copilot_impact.sql` |
| `scripts/seed_dora.sql` | DORA metrics (deployments, incidents, PRs) | `docker exec -i devlake-demo-mysql-1 mysql -umerico -pmerico lake < scripts/seed_dora.sql` |
| `scripts/seed_data.sql` | Complete dashboard data (GitHub + Copilot) | `docker exec -i devlake-demo-mysql-1 mysql -umerico -pmerico lake < scripts/seed_data.sql` |
| `scripts/seed_data.ps1` | Generate fresh `seed_data.sql` with random data | `.\scripts\seed_data.ps1` |

## Generating DORA Test Data

```bash
npm install && npm start   # Run demo app at http://localhost:3000
```

```powershell
.\scripts\simulate_dora.ps1   # Auto-generate incidents, deployments, and PRs
```

See **[docs/USAGE.md](docs/USAGE.md)** for manual signal generation methods.

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Container won't start | `docker logs devlake-demo-devlake-1 --tail 50` — check for missing images or port conflicts |
| GraphQL scope errors | Ensure PAT has `read:user` scope, or disable GraphQL on the connection |
| Config UI nginx.sh error | Fix CRLF: `(Get-Content nginx.sh -Raw) -replace "\`r\`n", "\`n" \| Set-Content nginx.sh -NoNewline` then rebuild |
| Reset everything | `docker-compose down -v && docker-compose up -d` (⚠️ deletes all data) |
| API timeouts | Set `API_TIMEOUT=300s` in `.env` and restart: `docker-compose restart devlake` |

---
Part of the DevLake Copilot Metrics Research initiative.
