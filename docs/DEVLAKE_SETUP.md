# DevLake Local Setup Guide

This guide provides step-by-step instructions for setting up a local DevLake environment using the custom fork (`ewega/incubator-devlake`) which includes the GitHub Copilot adoption plugin and dashboards.

## Prerequisites

- **Docker Desktop** installed and running
- **Git** installed
- **PowerShell** (Windows) or Bash (Linux/Mac)
- **GitHub Personal Access Token (PAT)** with scopes:
  - `repo` - Full repository access
  - `read:org` - Read organization data
  - `read:user` or `user:email` - Required for GraphQL API
  - `copilot` - Access Copilot usage metrics (if using Copilot plugin)
  - `manage_billing:copilot` - Access Copilot billing/seats data

## Directory Structure

```
devlake-demo/           # This repository
incubator-devlake/      # Fork of apache/incubator-devlake (sibling directory)
```

Ensure the `incubator-devlake` fork is cloned as a sibling directory:
```bash
cd ..
git clone https://github.com/ewega/incubator-devlake.git
```

## Step 1: Build Custom Docker Images

The custom images include the `gh-copilot` plugin and Copilot dashboards not available in upstream DevLake.

### 1.1 Build Backend Image
```powershell
cd ..\incubator-devlake\backend
docker build -t devlake-backend:local -f Dockerfile .
```
*Note: First build takes 5-10 minutes (compiles libgit2 and Go dependencies)*

### 1.2 Build Config UI Image
```powershell
cd ..\incubator-devlake\config-ui

# IMPORTANT: Ensure nginx.sh has Unix line endings (LF, not CRLF)
# On Windows, run this first:
(Get-Content nginx.sh -Raw) -replace "`r`n", "`n" | Set-Content nginx.sh -NoNewline

docker build -t devlake-config-ui:local -f Dockerfile .
```

### 1.3 Build Grafana Dashboard Image
```powershell
cd ..\incubator-devlake\grafana
docker build -t devlake-dashboard:local -f Dockerfile .
```

## Step 2: Configure Environment

Create a `.env` file in the `devlake-demo` directory (if not exists):

```env
# DevLake Configuration
MYSQL_ROOT_PASSWORD=admin
MYSQL_USER=merico
MYSQL_PASSWORD=merico
MYSQL_DATABASE=lake

# Encryption key (generate a random 128-bit hex string)
ENCRYPTION_SECRET=your-32-character-hex-string-here

# API settings
API_TIMEOUT=120s
API_RETRY=3
```

## Step 3: Start the Stack

```powershell
cd devlake-demo
docker-compose up -d
```

### Port Mappings (to avoid conflicts)
| Service | Internal Port | External Port |
|---------|---------------|---------------|
| MySQL | 3306 | 3307 |
| Grafana | 3000 | 3004 |
| DevLake API | 8080 | 8085 |
| Config UI | 4000 | 4004 |

### Verify Services
```powershell
# Check all containers are running
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | Select-String "devlake-demo"

# Test API health
Invoke-RestMethod -Uri "http://localhost:8085/ping"

# Verify plugins are loaded (should include 'github' and 'gh-copilot')
Invoke-RestMethod -Uri "http://localhost:8085/plugins" | ForEach-Object { $_.plugin }
```

## Step 4: Create Connections via API

### 4.1 Create GitHub Connection
```powershell
$futureDate = (Get-Date).AddYears(1).ToString("yyyy-MM-ddTHH:mm:ssZ")
$body = @{
    name = "your-org-name"
    endpoint = "https://api.github.com/"
    authMethod = "AccessToken"
    token = "ghp_your_token_here"
    enableGraphql = $true
    rateLimitPerHour = 12000
    tokenExpiresAt = $futureDate
    refreshTokenExpiresAt = $futureDate
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:8085/plugins/github/connections" -Method Post -Body $body -ContentType "application/json"
```

### 4.2 Create GitHub Copilot Connection
```powershell
$body = @{
    name = "your-org-copilot"
    endpoint = "https://api.github.com/"
    authMethod = "AccessToken"
    token = "ghp_your_token_here"
    organization = "your-org-name"
    rateLimitPerHour = 12000
    tokenExpiresAt = $futureDate
    refreshTokenExpiresAt = $futureDate
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:8085/plugins/gh-copilot/connections" -Method Post -Body $body -ContentType "application/json"
```

### 4.3 Create Scope Config for DORA
```powershell
$scopeConfig = @{
    name = "dora-config"
    connectionId = 1
    deploymentPattern = "(?i)deploy"      # Regex to match deployment workflows
    productionPattern = "(?i)prod"        # Regex to match production environment
    issueTypeIncident = "incident"        # Label that marks incidents
    refdiff = @{
        tagsPattern = ".*"
        tagsLimit = 10
        tagsOrder = "reverse semver"
    }
} | ConvertTo-Json -Depth 3

Invoke-RestMethod -Uri "http://localhost:8085/plugins/github/connections/1/scope-configs" -Method Post -Body $scopeConfig -ContentType "application/json"
```

### 4.4 Add Repository Scope
```powershell
# First get the GitHub repo ID
$headers = @{ Authorization = "Bearer ghp_your_token_here" }
$repo = Invoke-RestMethod -Uri "https://api.github.com/repos/your-org/your-repo" -Headers $headers

# Add as scope
$scope = @{
    data = @(
        @{
            githubId = $repo.id
            connectionId = 1
            name = $repo.name
            fullName = $repo.full_name
            htmlUrl = $repo.html_url
            cloneUrl = $repo.clone_url
            scopeConfigId = 1
        }
    )
} | ConvertTo-Json -Depth 3

Invoke-RestMethod -Uri "http://localhost:8085/plugins/github/connections/1/scopes" -Method Put -Body $scope -ContentType "application/json"
```

### 4.5 Add Copilot Scope
```powershell
$copilotScope = @{
    data = @(
        @{
            id = "your-org-name"
            connectionId = 1
            organization = "your-org-name"
            name = "your-org-name"
            fullName = "your-org-name"
        }
    )
} | ConvertTo-Json -Depth 3

Invoke-RestMethod -Uri "http://localhost:8085/plugins/gh-copilot/connections/1/scopes" -Method Put -Body $copilotScope -ContentType "application/json"
```

## Step 5: Create Project and Blueprint

### 5.1 Create Project
```powershell
$project = @{
    name = "Your Project Name"
    description = "DORA metrics and Copilot adoption"
    metrics = @(
        @{ pluginName = "dora"; enable = $true }
    )
} | ConvertTo-Json -Depth 3

$result = Invoke-RestMethod -Uri "http://localhost:8085/projects" -Method Post -Body $project -ContentType "application/json"
$blueprintId = $result.blueprint.id
```

### 5.2 Configure Blueprint Connections
```powershell
$blueprintUpdate = @{
    connections = @(
        @{
            pluginName = "github"
            connectionId = 1
            scopes = @(
                @{ scopeId = "YOUR_GITHUB_REPO_ID"; scopeName = "your-org/your-repo" }
            )
        },
        @{
            pluginName = "gh-copilot"
            connectionId = 1
            scopes = @(
                @{ scopeId = "your-org-name"; scopeName = "your-org-name" }
            )
        }
    )
    enable = $true
    cronConfig = "0 0 * * *"
    timeAfter = "2024-01-01T00:00:00Z"
} | ConvertTo-Json -Depth 4

Invoke-RestMethod -Uri "http://localhost:8085/blueprints/$blueprintId" -Method Patch -Body $blueprintUpdate -ContentType "application/json"
```

## Step 6: Trigger Data Sync

```powershell
# Trigger the blueprint
Invoke-RestMethod -Uri "http://localhost:8085/blueprints/$blueprintId/trigger" -Method Post

# Monitor progress
$status = Invoke-RestMethod -Uri "http://localhost:8085/pipelines/1" -Method Get
Write-Host "Status: $($status.status) | Progress: $($status.finishedTasks)/$($status.totalTasks)"
```

## Step 7: Access Dashboards

| Service | URL | Credentials |
|---------|-----|-------------|
| Config UI | http://localhost:4004 | N/A |
| Grafana | http://localhost:3004 | admin / admin |
| DevLake API | http://localhost:8085 | N/A |

### Available Dashboards in Grafana
- **DORA** - Deployment Frequency, Lead Time, Change Failure Rate, MTTR
- **GitHub Copilot** - Adoption metrics, usage trends, seat utilization

## Troubleshooting

### Container won't start
```powershell
docker logs devlake-demo-devlake-1 --tail 50
```

### GraphQL errors about missing scopes
Ensure your PAT has `read:user` or `user:email` scope, or disable GraphQL:
```powershell
# Disable GraphQL on connection
$update = @{ enableGraphql = $false; name = "..."; endpoint = "..."; authMethod = "AccessToken"; token = "..." } | ConvertTo-Json
Invoke-RestMethod -Uri "http://localhost:8085/plugins/github/connections/1" -Method Patch -Body $update -ContentType "application/json"
```

### Config UI shows "nginx.sh not found"
The `nginx.sh` file has Windows line endings. Fix with:
```powershell
cd ..\incubator-devlake\config-ui
(Get-Content nginx.sh -Raw) -replace "`r`n", "`n" | Set-Content nginx.sh -NoNewline
docker build -t devlake-config-ui:local -f Dockerfile .
```

### Reset everything
```powershell
docker-compose down -v  # Removes volumes (deletes all data)
docker-compose up -d
```

## Generating DORA Test Data

Use the simulation script to generate deployments, incidents, and PRs:
```powershell
.\scripts\simulate_dora.ps1
```

This creates:
- Incident issues (with `incident` label)
- Failed deployments (for Change Failure Rate)
- Pull requests (for Lead Time calculation)
