# Implementation Plan - DevLake Demo App

## Problem Statement
To validate the "GitHub Copilot Impact Dashboard," we need a controlled repository (`devlake-demo`) that generates consistent DORA metrics. This repository must simulate a full development lifecycle—including coding, deploying, and handling incidents—to provide the necessary data points (deployments, incidents, PRs) for DevLake to ingest and correlate with Copilot adoption.

## Proposed Solution
Transform the local `devlake-demo` directory into a Node.js application with a suite of GitHub Actions workflows and Issue Templates specifically designed to produce DORA signals.

## Workplan

### 1. Application Scaffolding
- [x] **Initialize Node.js App**: Create a simple Express server (`server.js`) and `package.json`.
- [x] **Git Configuration**: Initialize git and set remote to `eldrick-test-org/devlake-demo`.
- [x] **UI Implementation**: Create a simple frontend (`public/index.html`) to make the app look realistic.

### 2. DORA Metrics "Signal" Generators

#### A. Deployment Frequency & Lead Time for Changes
*Target*: Frequent successful deployments triggered by PR merges.
- [x] **CI Pipeline (`.github/workflows/ci.yml`)**: Runs unit tests on PRs.
- [x] **CD Pipeline (`.github/workflows/deploy-prod.yml`)**: 
    - [x] Triggers on `push` to `main`.
    - [x] **Naming Convention**: Must match DevLake's default regex (e.g., "Production Deploy").
    - [x] **Job Steps**: Simulate a build and deploy process (sleep, echo).

#### B. Change Failure Rate & Time to Restore Service
*Target*: Incidents caused by deployments, and their resolution.
- [x] **Incident Issue Template (`.github/ISSUE_TEMPLATE/incident.md`)**:
    - [x] Pre-filled with `incident` label.
    - [x] Used to manually signal that a deployment caused a failure.
- [x] **Workflow Failure Option**: Add a `workflow_dispatch` input to the CD pipeline to force a failure (simulating an immediate deployment failure).

### 3. Documentation & Usage
- [x] **Create `USAGE.md`**: Step-by-step guide to generating metrics:
    1.  **Lead Time**: Create a PR, change code, merge.
    2.  **Deployment**: Watch `deploy-prod` run automatically.
    3.  **Failure/Restore**: Create an Issue with `incident` label, then close it after a few minutes.

## Notes & Considerations
- **Authentication**: I will stage all changes locally. You must perform the `git push`.
- **DevLake Configuration**: You will need to ensure your DevLake Project config uses the standard regexes:
    - Deployments: `(?i)deploy` or `(?i)prod`
    - Incidents: `(?i)incident` (Label)
