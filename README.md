---
author: DevLake Demo Team
description: Complete guide for DevLake DORA metrics and GitHub Copilot Impact Dashboard setup
last_changed: 2026-02-09
---

# DevLake DORA Demo App

A simple Node.js application designed to simulate a software development lifecycle for generating DORA metrics in [Apache DevLake](https://devlake.apache.org/).

This repository is used to demonstrate and validate the **GitHub Copilot Impact Dashboard** by providing a controlled source of signals:
- **Deployment Frequency** (via GitHub Actions)
- **Lead Time for Changes** (via Pull Requests)
- **Change Failure Rate** (via Simulated Failures)
- **Time to Restore Service** (via Incident Issues)

## Table of Contents

- [Repository Structure](#repository-structure)
- [Prerequisites](#prerequisites)
- [Building Custom DevLake Images](#building-custom-devlake-images)
- [Configure Environment](#configure-environment)
- [Starting the Stack](#starting-the-stack)
- [Creating GitHub Connection](#creating-github-connection)
- [Creating GitHub Copilot Connection](#creating-github-copilot-connection)
- [Creating Scope Config](#creating-scope-config)
- [Adding Repository and Org Scopes](#adding-repository-and-org-scopes)
- [Creating Project and Blueprint](#creating-project-and-blueprint)
- [Triggering First Collection](#triggering-first-collection)
- [Data Seeding](#data-seeding)
- [Service URLs and Access](#service-urls-and-access)
- [Generating DORA Test Data](#generating-dora-test-data)
- [Troubleshooting](#troubleshooting)

## Repository Structure

```
devlake-demo/
├── .github/workflows/     # CI/CD pipelines for DORA metrics
│   ├── ci.yml             # PR checks
│   └── deploy-prod.yml    # Production deployments (with failure simulation)
├── docs/
│   ├── DEVLAKE_SETUP.md   # [DEPRECATED] Redirects to this README
│   ├── USAGE.md           # How to generate DORA metrics
│   └── plan.md            # Implementation plan
├── public/                # Static web assets
├── scripts/
│   ├── simulate_dora.ps1      # Automated DORA signal generation
│   ├── seed_copilot_impact.sql # Seed Copilot adoption metrics
│   ├── seed_dora.sql          # Seed DORA metrics
│   ├── seed_data.sql          # Comprehensive seed data
│   ├── seed_data.ps1          # PowerShell seed data generator
│   └── export-to-powerbi.ps1  # Export data for Power BI
├── docker-compose.yml     # Local DevLake stack
├── server.js              # Express app
└── package.json
```

## Prerequisites

Before setting up DevLake locally, ensure you have:

- **Docker Desktop** installed and running
- **Git** installed
- **PowerShell** (Windows) or Bash (Linux/Mac)
- **GitHub CLI (`gh`)** authenticated - Run `gh auth login`
- **GitHub Personal Access Token (PAT)** with the following scopes:
  - `repo` - Full repository access
  - `read:org` - Read organization data
  - `read:user` or `user:email` - Required for GraphQL API
  - `copilot` - Access Copilot usage metrics (if using Copilot plugin)
  - `manage_billing:copilot` - Access Copilot billing/seats data

### Directory Structure

This repository expects a sibling directory structure:

```
devlake-demo/           # This repository
incubator-devlake/      # Fork of apache/incubator-devlake (sibling directory)
```

Clone the `incubator-devlake` fork as a sibling directory:

```bash
cd ..
git clone https://github.com/ewega/incubator-devlake.git
```

> [!IMPORTANT]
> The custom fork (`ewega/incubator-devlake`) includes the GitHub Copilot adoption plugin and dashboards not available in upstream Apache DevLake.

## Building Custom DevLake Images

The custom images include the `gh-copilot` plugin and Copilot dashboards not available in upstream DevLake. All three images must be built before running the stack.

### Build Backend Image

```powershell
cd ..\incubator-devlake\backend
docker build -t devlake-backend:local -f Dockerfile .
```

> [!NOTE]
> First build takes 5-10 minutes (compiles libgit2 and Go dependencies)

### Build Config UI Image

```powershell
cd ..\incubator-devlake\config-ui

# IMPORTANT: Ensure nginx.sh has Unix line endings (LF, not CRLF)
# On Windows, run this first:
(Get-Content nginx.sh -Raw) -replace "`r`n", "`n" | Set-Content nginx.sh -NoNewline

docker build -t devlake-config-ui:local -f Dockerfile .
```

> [!WARNING]
> The `nginx.sh` file often has Windows line endings (CRLF) which will cause the container to fail. The command above fixes this issue.

### Build Grafana Dashboard Image

```powershell
cd ..\incubator-devlake\grafana
docker build -t devlake-dashboard:local -f Dockerfile .
```

## Configure Environment

Create a `.env` file in the `devlake-demo` directory (if it doesn't exist):

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

> [!TIP]
> Generate a random encryption secret using: `openssl rand -hex 16`

## Starting the Stack

Navigate to the `devlake-demo` directory and start all services:

```powershell
cd devlake-demo
docker-compose up -d
```

### Port Mappings

The stack uses non-standard port mappings to avoid conflicts with other local services:

| Service | Internal Port | External Port |
|---------|---------------|---------------|
| MySQL | 3306 | **3307** |
| Grafana | 3000 | **3004** |
| DevLake API | 8080 | **8085** |
| Config UI | 4000 | **4004** |

### Verify Services

```powershell
# Check all containers are running
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" | Select-String "devlake-demo"

# Test API health
Invoke-RestMethod -Uri "http://localhost:8085/ping"

# Verify plugins are loaded (should include 'github' and 'gh-copilot')
Invoke-RestMethod -Uri "http://localhost:8085/plugins" | ForEach-Object { $_.plugin }
```

## Creating GitHub Connection

Create a GitHub connection for collecting repository data:

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

> [!IMPORTANT]
> Replace `your-org-name` and `ghp_your_token_here` with your actual GitHub organization name and Personal Access Token.

## Creating GitHub Copilot Connection

Create a separate connection for collecting GitHub Copilot metrics:

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

## Creating Scope Config

Configure DORA patterns for identifying deployments, production environments, and incidents:

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

### DORA Pattern Explanations

- **`deploymentPattern: "(?i)deploy"`** - Matches GitHub Actions workflows with "deploy" in the name (case-insensitive)
- **`productionPattern: "(?i)prod"`** - Matches environments containing "prod" to identify production deployments
- **`issueTypeIncident: "incident"`** - Issues labeled with "incident" are treated as incidents for MTTR calculation

## Adding Repository and Org Scopes

### Add Repository Scope

First, retrieve the GitHub repository ID, then add it as a scope:

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

### Add Copilot Scope

Add your organization as a Copilot scope:

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

## Creating Project and Blueprint

### Create Project

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

### Configure Blueprint Connections

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

> [!NOTE]
> The blueprint runs daily at midnight (`cronConfig = "0 0 * * *"`). Adjust the cron expression as needed.

## Triggering First Collection

Manually trigger the blueprint to start collecting data:

```powershell
# Trigger the blueprint
Invoke-RestMethod -Uri "http://localhost:8085/blueprints/$blueprintId/trigger" -Method Post

# Monitor progress
$status = Invoke-RestMethod -Uri "http://localhost:8085/pipelines/1" -Method Get
Write-Host "Status: $($status.status) | Progress: $($status.finishedTasks)/$($status.totalTasks)"
```

> [!TIP]
> The first data collection can take several minutes depending on repository size and API rate limits.

## Data Seeding

For testing and demonstration purposes, you can seed the database with sample data without waiting for real data collection.

### Available Seed Scripts

The `scripts/` directory contains several SQL scripts for seeding different types of data:

#### `seed_copilot_impact.sql`

Seeds GitHub Copilot adoption metrics including:
- Enterprise-level Copilot usage data
- Organization-level metrics
- Language-specific adoption data
- 90 days of historical data with 3 adoption phases (low, medium, high)

```powershell
docker exec -i devlake-demo-mysql-1 mysql -umerico -pmerico lake < scripts/seed_copilot_impact.sql
```

#### `seed_dora.sql`

Seeds DORA metrics for the demo project:
- Deployment records (successful and failed)
- Incident issues for MTTR calculation
- Pull requests for lead time metrics
- Linked to the `dora-demo-project` project

```powershell
docker exec -i devlake-demo-mysql-1 mysql -umerico -pmerico lake < scripts/seed_dora.sql
```

#### `seed_data.sql`

Comprehensive seed file that includes:
- Complete GitHub dashboard data (commits, PRs, deployments)
- Full Copilot Impact dashboard data
- Pre-configured with realistic metrics and trends

```powershell
docker exec -i devlake-demo-mysql-1 mysql -umerico -pmerico lake < scripts/seed_data.sql
```

#### `seed_data.ps1`

PowerShell script that generates `seed_data.sql` with randomized but realistic data:
- Creates phased adoption patterns (3 phases over 90 days)
- Generates daily metrics with realistic variance
- Supports customization of date ranges and metrics

```powershell
# Generate new seed data
.\scripts\seed_data.ps1

# Then load it
docker exec -i devlake-demo-mysql-1 mysql -umerico -pmerico lake < scripts/seed_data.sql
```

### How to Use Seed Scripts

1. **Ensure the stack is running:**
   ```powershell
   docker-compose up -d
   ```

2. **Choose the appropriate seed script based on your needs:**
   - Use `seed_dora.sql` for DORA metrics only
   - Use `seed_copilot_impact.sql` for Copilot metrics only
   - Use `seed_data.sql` for complete dashboard data

3. **Execute the seed script:**
   ```powershell
   docker exec -i devlake-demo-mysql-1 mysql -umerico -pmerico lake < scripts/seed_dora.sql
   ```

4. **Verify the data in Grafana:**
   - Navigate to http://localhost:3004
   - Login with `admin` / `admin`
   - Open the relevant dashboard (DORA or Copilot Impact)

> [!WARNING]
> Seeding will insert data into existing tables. If you need a clean slate, reset the database first using the troubleshooting steps below.

## Service URLs and Access

Once the stack is running, access the following services:

| Service | URL | Credentials |
|---------|-----|-------------|
| Config UI | http://localhost:4004 | N/A |
| Grafana | http://localhost:3004 | admin / admin |
| DevLake API | http://localhost:8085 | N/A |

### Available Dashboards in Grafana

After logging into Grafana:

- **DORA** - Deployment Frequency, Lead Time for Changes, Change Failure Rate, Mean Time to Restore
- **GitHub Copilot** - Adoption metrics, usage trends, seat utilization, language breakdowns

> [!TIP]
> Default Grafana credentials can be changed on first login. Make sure to remember your new password.

## Generating DORA Test Data

### Quick Start with Demo App

Run the Node.js demo application:

```bash
npm install
npm start
# Visit http://localhost:3000
```

### Automated Simulation Script

Use the simulation script to automatically generate DORA signals:

```powershell
.\scripts\simulate_dora.ps1
```

This script creates:
- Incident issues (with `incident` label)
- Failed deployments (for Change Failure Rate)
- Pull requests (for Lead Time calculation)
- Successful deployments (for Deployment Frequency)

> [!IMPORTANT]
> The simulation script requires `gh` CLI to be authenticated. Run `gh auth login` first.

### Manual Methods

For more control over individual signals, see **[docs/USAGE.md](docs/USAGE.md)** for manual methods including:
- Creating incidents manually
- Triggering specific workflow runs
- Managing pull request lifecycles

## Troubleshooting

### Container Won't Start

Check container logs to identify the issue:

```powershell
docker logs devlake-demo-devlake-1 --tail 50
```

Common issues:
- Missing custom images (rebuild using steps in [Building Custom DevLake Images](#building-custom-devlake-images))
- Port conflicts (check if ports 3004, 3307, 4004, or 8085 are already in use)
- Insufficient Docker resources (increase memory allocation in Docker Desktop)

### GraphQL Errors About Missing Scopes

If you see errors about missing GraphQL permissions:

**Solution 1:** Ensure your PAT has `read:user` or `user:email` scope

**Solution 2:** Disable GraphQL on the connection:

```powershell
# Disable GraphQL on connection
$update = @{ 
    enableGraphql = $false
    name = "your-org-name"
    endpoint = "https://api.github.com/"
    authMethod = "AccessToken"
    token = "ghp_your_token_here"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:8085/plugins/github/connections/1" -Method Patch -Body $update -ContentType "application/json"
```

### Config UI Shows "nginx.sh Not Found"

This indicates the `nginx.sh` file has Windows line endings (CRLF) instead of Unix line endings (LF).

**Fix:**

```powershell
cd ..\incubator-devlake\config-ui
(Get-Content nginx.sh -Raw) -replace "`r`n", "`n" | Set-Content nginx.sh -NoNewline
docker build -t devlake-config-ui:local -f Dockerfile .
```

Then restart the stack:

```powershell
cd ..\devlake-demo
docker-compose restart config-ui
```

### Reset Everything

To completely reset the environment and start fresh:

```powershell
# Stop and remove all containers, networks, and volumes
docker-compose down -v

# Restart the stack
docker-compose up -d
```

> [!CAUTION]
> The `-v` flag deletes all database volumes, which means **all collected data will be lost**. You'll need to reconfigure connections and re-collect or re-seed data.

### API Connection Timeouts

If API requests timeout during data collection:

1. Increase API timeout in `.env`:
   ```env
   API_TIMEOUT=300s
   ```

2. Restart the DevLake container:
   ```powershell
   docker-compose restart devlake
   ```

### MySQL Connection Issues

If you can't connect to MySQL:

```powershell
# Test MySQL connection
docker exec -it devlake-demo-mysql-1 mysql -umerico -pmerico lake -e "SELECT 1;"

# Check if MySQL is listening on the correct port
docker port devlake-demo-mysql-1
```

---

Part of the DevLake Copilot Metrics Research initiative.
