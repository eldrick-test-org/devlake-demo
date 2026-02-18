# From Zero to DORA Metrics in 10 Minutes with GitHub Copilot CLI

What if deploying an entire dev analytics platform was as simple as chatting with Copilot? In this walkthrough, you'll go from nothing to a fully running [Apache DevLake](https://devlake.apache.org/) instance on Azure — connected to your GitHub org, collecting DORA and Copilot metrics, with Grafana dashboards ready — using a single Copilot CLI plugin.

> **What is Apache DevLake?**
> An open-source platform that pulls data from your DevOps tools (GitHub, Jira, Jenkins, etc.), normalizes it into a standard data model, and serves engineering metrics through Grafana dashboards. Think of it as a data warehouse purpose-built for DORA metrics, Copilot adoption tracking, and developer productivity insights.

<!-- SCREENSHOT: Architecture diagram showing GitHub → DevLake on Azure (MySQL + Backend + Config UI + Grafana) → DORA & Copilot dashboards -->

---

## Prerequisites

Before you start, make sure you have:

- **GitHub Copilot CLI** installed ([docs](https://docs.github.com/en/copilot/github-copilot-in-the-cli))
- **Azure CLI** logged in — run `az login` if needed
- **GitHub CLI** authenticated — run `gh auth status` to verify
- A **GitHub PAT** with these scopes: `repo`, `read:org`, `read:user`, `copilot`, `manage_billing:copilot`
- ~10 minutes ☕

---

## Step 1: Install the Deploy-DevLake Plugin

Copilot CLI supports plugins — skill packs that teach Copilot how to perform specific workflows. The `deploy-devlake` plugin handles the full DevLake lifecycle: deploying infrastructure, connecting data sources, and configuring what to collect.

Install it with one command:

```bash
copilot plugin install DevExpGBB/copilot-plugins:plugins/deploy-devlake
```

<!-- SCREENSHOT: Terminal showing the plugin install command and success output -->

---

## Step 2: Launch Copilot and Deploy

Start the Copilot CLI and tell it what you want:

```bash
copilot
```

Then type:

```
/deploy-devlake Deploy DevLake to Azure
```

Copilot explains that DevLake setup has **three phases**:

| Phase | What It Does |
|-------|-------------|
| **1 — Deploy** | Spin up the DevLake infrastructure (Azure or local Docker) |
| **2 — Configure Connections** | Create authenticated links to GitHub and Copilot |
| **3 — Configure Scopes & Project** | Pick repos, set DORA rules, trigger first data sync |

Choose **Full Setup** to run all three back-to-back.

<!-- SCREENSHOT: Copilot CLI showing the 3-phase explanation and the menu of options (Full Setup, Full Configuration, Deploy only, etc.) -->

---

### Phase 1 — Deploy to Azure

Copilot asks two things:

1. **Resource Group name** — e.g., `devlake-rg`
2. **Azure region** — e.g., `eastus`

That's it. Behind the scenes, Copilot runs a Bicep template that creates:

- **Azure MySQL** (Burstable B1ms) — DevLake's database
- **3 Container Instances** — the backend API, Config UI, and Grafana
- **Key Vault** — stores your DB password and encryption secret

Copilot waits for the backend health check to pass, then triggers the initial database migration automatically.

> **💰 Cost:** ~$30–50/month for official images. Tear down anytime with the included cleanup script.

<!-- SCREENSHOT: Copilot CLI showing Azure deployment progress — resource creation, health check polling, "DevLake is healthy!" message, and the printed endpoint URLs -->

<!-- SCREENSHOT (optional): Azure Portal resource group view showing the created resources (MySQL, 3 container instances, Key Vault) -->

---

### Phase 2 — Configure Connections

Now that DevLake is running, Copilot connects it to your data. It asks:

- **GitHub organization slug** — e.g., `octodemo`
- **Token** — use your `gh` CLI token (auto-detected) or paste a PAT
- **Copilot metrics?** — yes by default

> **What's a Connection?**
> An authenticated link between DevLake and a data source. You need one for **GitHub** (pulls repos, PRs, deployments, workflows) and optionally one for **Copilot** (pulls usage metrics — acceptance rates, active users, language breakdown).

Copilot validates your PAT scopes against what DevLake requires, tests the connection payload, and creates both connections. You'll see a clear "Test passed ✅" for each.

<!-- SCREENSHOT: Copilot CLI showing PAT scope validation, connection test results, and "Connection created" messages with IDs -->

---

### Phase 3 — Configure Scopes & Project

The final phase tells DevLake *what* to collect and *how* to interpret it. Copilot asks:

- **Which repos to track?** You can paste a comma-separated list (`org/repo1, org/repo2`), point to a CSV file, or browse your org's repos interactively
- **DORA patterns:**
  - Deployment workflow regex (default: `(?i)deploy`)
  - Production environment regex (default: `(?i)prod`)
  - Incident issue label (default: `incident`)
- **Project name** — defaults to your org name

> **DevLake Concepts — Quick Reference**
>
> | Concept | What It Means |
> |---------|--------------|
> | **Scope** | A data source to collect — a specific GitHub repo or a Copilot org |
> | **Scope Config** | DORA rules — what regex matches deployments, what's "production," which issue label means "incident" |
> | **Project** | Groups everything together and auto-creates a Blueprint |
> | **Blueprint** | The scheduled sync recipe — which connections + scopes to collect, on what schedule |

Copilot creates the scope config, adds your repos, builds the project, and triggers the first data sync. You'll see pipeline progress in real time:

```
[10s] Status: TASK_RUNNING | Tasks: 2/8
[30s] Status: TASK_RUNNING | Tasks: 5/8
[60s] Status: TASK_COMPLETED | Tasks: 8/8 ✅
```

<!-- SCREENSHOT: Copilot CLI showing interactive repo selection (numbered list from `gh repo list`) -->

<!-- SCREENSHOT: Copilot CLI showing pipeline progress monitoring and the "Setup complete!" banner with Grafana URL -->

---

## Step 3: Open Your Dashboards

Navigate to the Grafana URL that Copilot printed (typically `http://<your-host>:3000`). Default credentials: **admin / admin**.

You'll find two dashboards ready to go:

**DORA Dashboard** — The four key metrics that measure software delivery performance:
- **Deployment Frequency** — How often you ship to production
- **Lead Time for Changes** — From first commit to production deploy
- **Change Failure Rate** — % of deployments that cause incidents
- **Mean Time to Recovery** — How fast you resolve incidents

<!-- SCREENSHOT: Grafana DORA dashboard showing the four DORA metric panels with data from the synced repos -->

**Copilot Adoption Dashboard** — How your team is using GitHub Copilot:
- Active users over time
- Code suggestion acceptance rates
- Breakdown by language and editor
- Seat utilization

<!-- SCREENSHOT: Grafana Copilot Adoption dashboard showing usage trends, acceptance rates, and language breakdown -->

---

## What's Next?

- **Add more repos** or tweak DORA patterns anytime through the Config UI (`:4000`) or by re-running Phase 3
- **Daily syncs are already configured** — the blueprint runs on a `0 0 * * *` cron schedule
- **Explore the Copilot Impact dashboard** — correlates Copilot adoption trends with DORA metric improvements
- **Clean up Azure resources** when you're done: run `.\azure\cleanup.ps1` or `az group delete --name <resource-group>`

---

## Wrapping Up

In under 10 minutes, a single Copilot CLI conversation deployed an analytics platform to Azure, connected your GitHub org, configured DORA metric rules, and kicked off the first data sync. No YAML files. No manual API calls. No clicking through setup wizards.

The `deploy-devlake` plugin is open source — check out the [plugin repo](https://github.com/DevExpGBB/copilot-plugins) and the [Apache DevLake docs](https://devlake.apache.org/) to go deeper.

---

*Have feedback or questions? Open an issue on the [plugin repo](https://github.com/DevExpGBB/copilot-plugins/issues).*
