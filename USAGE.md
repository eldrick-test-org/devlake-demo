# DevLake DORA Metrics Generator

This repository is designed to simulate a software development lifecycle to generate DORA metrics for DevLake.

## How to Generate Metrics

### 1. Deployment Frequency & Lead Time for Changes
To generate these metrics, you need to simulate code changes and deployments.

1.  **Create a Pull Request**:
    *   Create a new branch: `git checkout -b feature/new-update`
    *   Make a dummy change to `server.js` or `README.md`.
    *   Push and open a PR.
    *   The `CI` workflow will run.
2.  **Merge the PR**:
    *   Merge the Pull Request into `main`.
    *   The `Production Deploy` workflow will automatically run.
    *   *DevLake Signal*: This counts as a **Deployment** and provides the end timestamp for **Lead Time**.

### 2. Change Failure Rate
To simulate a failed deployment:

1.  Go to the **Actions** tab.
2.  Select **Production Deploy**.
3.  Click **Run workflow**.
4.  Check the box **Simulate a deployment failure?**.
5.  Click **Run workflow**.
    *   *DevLake Signal*: This counts as a **Failed Deployment**.

### 3. Time to Restore Service
To simulate an incident and its resolution:

1.  **Create an Incident**:
    *   Go to **Issues** > **New Issue**.
    *   Select **Incident**.
    *   Fill in details and submit.
    *   *DevLake Signal*: Issue creation with label `incident` marks the start of an incident.
2.  **Resolve the Incident**:
    *   Close the Issue when "fixed".
    *   *DevLake Signal*: Issue closing marks the service restoration.

<!-- Simulation run at 01/16/2026 21:00:52 -->
