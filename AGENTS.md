# DevLake DORA Demo - Agent Operating Manual

This repository is a simulation environment for generating DORA metrics in Apache DevLake. It consists of a simple Node.js app, a local DevLake stack with custom images, and PowerShell scripts for simulating development lifecycle events.

## 📚 Core Documentation
These documents contain essential operational procedures:
- **[docs/DEVLAKE_SETUP.md](docs/DEVLAKE_SETUP.md)**: **CRITICAL**. Contains custom Docker build steps, port mappings, and API automation scripts. Read this before touching `docker-compose.yml` or handling configuration.
- **[docs/USAGE.md](docs/USAGE.md)**: Explains how the simulation works, how to manually trigger signals, and the logic behind DORA metrics generation.

## Project Architecture & Context

- **Purpose:** To demonstrate GitHub Copilot impact by generating controlled DORA signals (Deploy Frequency, Lead Time, Change Failure Rate, MTTR).
- **Core Components:**
  - **Node.js App (`server.js`):** A dummy target for deployments.
  - **DevLake Stack (`docker-compose.yml`):** Runs `mysql`, `grafana`, `devlake` (backend), and `config-ui` using **custom local images**.
  - **Simulation Engine (`scripts/`):** PowerShell scripts utilizing `gh` CLI to create real GitHub Artifacts (Issues, PRs, Workflow Runs).
- **Directory Dependency:** This repo expects a sibling directory `incubator-devlake` (fork `ewega/incubator-devlake`) for building custom Docker images.

## Critical Workflows

### 1. Building Custom Images (Prerequisite)
Before running `docker-compose`, images must be built from the sibling `incubator-devlake` repo.
**Warning:** `config-ui/nginx.sh` often has CRLF issues on Windows.
```powershell
# Example workflow in sibling repo
cd ../incubator-devlake/backend; docker build -t devlake-backend:local .
cd ../incubator-devlake/config-ui; docker build -t devlake-config-ui:local .
cd ../incubator-devlake/grafana; docker build -t devlake-dashboard:local .
```
See [docs/DEVLAKE_SETUP.md](docs/DEVLAKE_SETUP.md) for full details.

### 2. Running the Infrastructure
Start the stack with `docker-compose up -d`. Note the non-standard port mappings to avoid conflicts:
- **Config UI:** http://localhost:4004 (not 4000)
- **Grafana:** http://localhost:3004 (not 3000)
- **API:** http://localhost:8085 (not 8080)
- **MySQL:** Port 3307 (not 3306)

### 3. DORA Simulation
Use `simulate_dora.ps1` to generate metrics data.
- **Requirement:** `gh` CLI must be authenticated (`gh auth login`).
- **Functionality:** Creates incidents, triggers "failed" deployments, and merges PRs automatically.
- **Usage:** `.\scripts\simulate_dora.ps1`
- See [docs/USAGE.md](docs/USAGE.md) for manual triggers.

## Codebase Conventions

- **Scripting:** Prefer **PowerShell** for all automation and setup scripts.
- **API Interaction:** DevLake configuration (Connections, Scopes, Blueprints) is automated via `Invoke-RestMethod` rather than the UI. See [docs/DEVLAKE_SETUP.md](docs/DEVLAKE_SETUP.md) for payload examples.
- **Environment:**
  - Local images are tagged `:local`.
  - Secrets (DB passwords, Encryption keys) are managed in `.env`.
- **Simulation Logic:**
  - "Incidents" = Issues with `incident` label.
  - "Failed Deploys" = Workflows run with input `simulate_failure=true`.

## Troubleshooting & Common Specificities
- **CRLF/LF Issues:** if `config-ui` container fails, check line endings in `nginx.sh` in the sibling repo.
- **GraphQL Errors:** DevLake GitHub plugin needs `read:user` or `user:email` PAT scopes.
- **Service Availability:** Always check `http://localhost:8085/ping` before running configuration scripts.
