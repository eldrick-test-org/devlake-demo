# DevLake DORA Demo App

A simple Node.js application designed to simulate a software development lifecycle for generating DORA metrics in [Apache DevLake](https://devlake.apache.org/).

This repository is used to demonstrate and validate the **GitHub Copilot Impact Dashboard** by providing a controlled source of signals:
- **Deployment Frequency** (via GitHub Actions)
- **Lead Time for Changes** (via Pull Requests)
- **Change Failure Rate** (via Simulated Failures)
- **Time to Restore Service** (via Incident Issues)

## Repository Structure

```
devlake-demo/
├── .github/workflows/     # CI/CD pipelines for DORA metrics
│   ├── ci.yml             # PR checks
│   └── deploy-prod.yml    # Production deployments (with failure simulation)
├── docs/
│   ├── DEVLAKE_SETUP.md   # Complete local DevLake setup guide
│   ├── USAGE.md           # How to generate DORA metrics
│   └── plan.md            # Implementation plan
├── public/                # Static web assets
├── scripts/
│   ├── simulate_dora.ps1  # Automated DORA signal generation
│   └── export-to-powerbi.ps1
├── docker-compose.yml     # Local DevLake stack
├── server.js              # Express app
└── package.json
```

## Quick Start

### Run the Demo App
```bash
npm install
npm start
# Visit http://localhost:3000
```

### Run DevLake Locally
See **[docs/DEVLAKE_SETUP.md](docs/DEVLAKE_SETUP.md)** for complete instructions on:
- Building custom Docker images from the fork
- Configuring connections via API
- Setting up DORA and Copilot metric collection
- Accessing Grafana dashboards

### Generate DORA Test Data
```powershell
.\scripts\simulate_dora.ps1
```
See **[docs/USAGE.md](docs/USAGE.md)** for manual methods.

## DevLake Access (when running locally)

| Service | URL | Credentials |
|---------|-----|-------------|
| Config UI | http://localhost:4004 | N/A |
| Grafana | http://localhost:3004 | admin / admin |
| DevLake API | http://localhost:8085 | N/A |

---
Part of the DevLake Copilot Metrics Research initiative.
