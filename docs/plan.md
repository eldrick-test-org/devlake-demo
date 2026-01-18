# Implementation Plan - Local DevLake Environment (Fork)

## Problem Statement
We need to validate the "GitHub Copilot Impact Dashboard" and DORA metrics using a local DevLake instance. This instance must run from the `incubator-devlake` fork (`ewega/incubator-devlake`) which contains the custom `gh-copilot` plugin and Grafana dashboards. The standard Docker images do not contain these changes.

## Proposed Solution
We will build custom Docker images from the local `incubator-devlake` source code and orchestrate them using an updated `docker-compose.yml` in the `devlake-demo` directory. This allows us to test the full stack (Backend + Config UI + Grafana) with our custom changes.

## Workplan

### 1. Build Custom Docker Images
*Perform these builds from the `../incubator-devlake` directory context.*
- [x] **Backend Image**: Build `devlake-backend:local` from `backend/`.
    - Command: `docker build -t devlake-backend:local -f Dockerfile .` (inside `backend/`)
- [x] **Config UI Image**: Build `devlake-config-ui:local` from `config-ui/`.
    - Command: `docker build -t devlake-config-ui:local -f Dockerfile .` (inside `config-ui/`)
- [x] **Grafana Dashboard Image**: Build `devlake-dashboard:local` from `grafana/`.
    - Command: `docker build -t devlake-dashboard:local -f Dockerfile .` (inside `grafana/`)

### 2. Configure Local Orchestration
- [x] **Update `docker-compose.yml`**: Modify the existing file in `devlake-demo` to:
    - Point `devlake` service to `devlake-backend:local`.
    - Point `config-ui` service to `devlake-config-ui:local`.
    - Point `grafana` service to `devlake-dashboard:local`.
    - Ensure `.env` file exists and is referenced correctly.

### 3. Execution & Verification
- [x] **Start Stack**: Run `docker-compose up -d`.
- [x] **Verify Services**:
    - Config UI: `http://localhost:4004`
    - Grafana: `http://localhost:3004`
    - DevLake API: `http://localhost:8085`

### 4. Data Connection Setup (Automated via API)
- [x] **GitHub Connection**: Created connection `eldrick-test-org` (ID: 1) with REST API (GraphQL disabled due to scope limitation).
- [x] **gh-copilot Connection**: Created connection `eldrick-test-org-copilot` (ID: 1) for Copilot metrics.
- [x] **Scope Config**: Created `dora-config` with deployment/production patterns and incident label detection.
- [x] **Repository Scope**: Added `eldrick-test-org/devlake-demo` (GitHub ID: 1135867696).
- [x] **Copilot Scope**: Added `eldrick-test-org` organization.
- [x] **Project & Blueprint**: Created "DevLake Demo" project with blueprint connecting both plugins.
- [x] **Data Sync**: Triggered pipeline #2 - completed successfully!

### 5. Collected Data Summary
| Table | Count |
|-------|-------|
| cicd_deployments | 7 |
| cicd_pipelines | 14 |
| pull_requests | 2 |
| issues | 1 |
| _tool_copilot_org_metrics | 58 |
| _tool_copilot_seats | 2 |

### 6. Access URLs
- **Config UI**: http://localhost:4004
- **Grafana**: http://localhost:3004 (admin/admin)
- **DevLake API**: http://localhost:8085

## Notes & Considerations
- **Build Time**: The initial backend build compiles `libgit2` and Go dependencies, which may take 5-10 minutes.
- **Docker Context**: We must be careful with build contexts. The `Makefile` suggests entering the subdirectories (`backend`, `config-ui`, `grafana`) before building.
