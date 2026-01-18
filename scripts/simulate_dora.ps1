# simulate_dora.ps1

$Repo = "eldrick-test-org/devlake-demo"
$BranchName = "feature/simulation-$(Get-Date -Format 'yyyyMMdd-HHmmss')"

Write-Host "🥑 DevLake DORA Simulation Initiated..." -ForegroundColor Green

# 1. Simulate Incident (Time to Restore Service)
Write-Host "`n[1/3] Simulating Incident (Time to Restore)..." -ForegroundColor Cyan
$issueBody = "Production service is experiencing high latency. Detected by automated monitoring."
# Ensure label exists (suppress error if it does)
gh label create incident --repo $Repo --color d73a4a --description "Incidents and outages" 2>$null

$issueUrl = gh issue create --repo $Repo --title "High Latency in Production" --body $issueBody --label "incident"
if ($issueUrl -match "/issues/(\d+)") {
    $issueNumber = $matches[1]
    Write-Host "   -> Created Incident Issue #$issueNumber" -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    gh issue close $issueNumber --repo $Repo --comment "Service restarted. Latency normalized."
    Write-Host "   -> Resolved Incident Issue #$issueNumber" -ForegroundColor Green
} else {
    Write-Host "   -> Failed to parse issue number from: $issueUrl" -ForegroundColor Red
}

# 2. Simulate Failed Deployment (Change Failure Rate)
Write-Host "`n[2/3] Simulating Failed Deployment (Change Failure Rate)..." -ForegroundColor Cyan
gh workflow run "Production Deploy" --repo $Repo -f simulate_failure=true
Write-Host "   -> Triggered 'Production Deploy' with Failure Simulation" -ForegroundColor Green

# 3. Simulate Successful Feature Delivery (Lead Time & Deploy Freq)
Write-Host "`n[3/3] Simulating Feature Delivery (Lead Time & Deploy Frequency)..." -ForegroundColor Cyan

# Create change
git checkout -b $BranchName
$date = Get-Date
Add-Content -Path "USAGE.md" -Value "`n<!-- Simulation run at $date -->"
git add USAGE.md
git commit -m "feat: simulation update $date"
git push -u origin $BranchName

# Create PR
Write-Host "   -> Creating Pull Request..."
$prUrl = gh pr create --repo $Repo --title "feat: simulation update $date" --body "Automated simulation PR" --base main
if ($prUrl -match "/pull/(\d+)") {
    $prNumber = $matches[1]
    Write-Host "   -> Created PR #$prNumber" -ForegroundColor Yellow

    # Merge PR (Triggers Deploy)
    Write-Host "   -> Merging PR..."
    Start-Sleep -Seconds 5 # Give GitHub a moment
    gh pr merge $prNumber --repo $Repo --merge --delete-branch
    Write-Host "   -> PR Merged! This will trigger the Production Deploy workflow." -ForegroundColor Green
} else {
    Write-Host "   -> Error: PR creation failed or could not parse URL from: $prUrl" -ForegroundColor Red
}

# Return to main
git checkout main
git pull

Write-Host "`n✅ Simulation Complete! Check your GitHub Actions and Issues tabs." -ForegroundColor Green
