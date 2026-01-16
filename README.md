# DevLake DORA Demo App

A simple Node.js application designed to simulate a software development lifecycle for generating DORA metrics in [Apache DevLake](https://devlake.apache.org/).

This repository is used to demonstrate and validate the **GitHub Copilot Impact Dashboard** by providing a controlled source of signals:
- **Deployment Frequency** (via GitHub Actions)
- **Lead Time for Changes** (via Pull Requests)
- **Change Failure Rate** (via Simulated Failures)
- **Time to Restore Service** (via Incident Issues)

## Getting Started

### Local Development
1. Install dependencies:
   ```bash
   npm install
   ```
2. Start the server:
   ```bash
   npm start
   ```
3. Visit `http://localhost:3000` to view the simulation dashboard.

## Generating Metrics
See [USAGE.md](USAGE.md) for detailed instructions on how to trigger deployments, simulate failures, and manage incidents to populate your DORA dashboard.

---
Part of the DevLake Copilot Metrics Research initiative.
