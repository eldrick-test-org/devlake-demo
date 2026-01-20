
$ErrorActionPreference = "Stop"

$sqlFile = "seed_data.sql"
$scopeId = "eldrick-test-org"
$projectName = "DevLake Demo"
$connectionId = 1
$repoScopeId = "github:GithubRepo:1:1135867696" # Found via DB check

# 1. Schema Creation & Cleanup
$sql = @"
-- Copilot Impact Schema
CREATE TABLE IF NOT EXISTS _tool_copilot_enterprise_metrics (
    connection_id bigint unsigned NOT NULL,
    scope_id varchar(255) NOT NULL,
    day date NOT NULL,
    active_users int DEFAULT NULL,
    total_seats int DEFAULT NULL,
    created_at datetime DEFAULT NULL,
    updated_at datetime DEFAULT NULL,
    _raw_data_params varchar(255),
    _raw_data_table varchar(255),
    _raw_data_id bigint unsigned,
    _raw_data_remark longtext,
    PRIMARY KEY (connection_id, scope_id, day)
);

-- Cleanup
DELETE FROM _tool_copilot_enterprise_metrics WHERE scope_id = '$scopeId';
DELETE FROM _tool_copilot_org_metrics WHERE scope_id = '$scopeId';
DELETE FROM _tool_copilot_language_metrics WHERE scope_id = '$scopeId';
DELETE FROM project_pr_metrics WHERE project_name = '$projectName' AND id LIKE 'fake-pr-%';
DELETE FROM cicd_deployment_commits WHERE cicd_scope_id = '$repoScopeId' AND id LIKE 'fake-deploy-%';
DELETE FROM incidents WHERE scope_id = '$repoScopeId' AND id LIKE 'fake-inc-%';
DELETE FROM project_incident_deployment_relationships WHERE id LIKE 'fake-rel-%';

"@

# 2. Data Generation Loop
$startDate = (Get-Date).AddDays(-90)
$totalSeats = 100

for ($i = 0; $i -lt 90; $i++) {
    $currentDate = $startDate.AddDays($i)
    $dateStr = $currentDate.ToString("yyyy-MM-dd")
    $datetimeStr = $currentDate.ToString("yyyy-MM-dd HH:mm:ss")

    # --- Phase Logic ---
    if ($i -lt 30) {
        # Phase 1: Low Adoption, Bad DORA
        $adoptionPct = Get-Random -Minimum 10 -Maximum 25
        $baseCycleTimeHours = 48
        $deployChance = 20 # 20% chance of deploy (Low Freq)
        $failChance = 30   # 30% CFR
        $mttrHours = 8
    }
    elseif ($i -lt 60) {
        # Phase 2: Growing Adoption, Better DORA
        $adoptionPct = Get-Random -Minimum 30 -Maximum 60
        $baseCycleTimeHours = 24
        $deployChance = 50 
        $failChance = 15
        $mttrHours = 4
    }
    else {
        # Phase 3: High Adoption, Elite DORA
        $adoptionPct = Get-Random -Minimum 75 -Maximum 95
        $baseCycleTimeHours = 8
        $deployChance = 90
        $failChance = 5
        $mttrHours = 1
    }

    # ==========================
    # Copilot Metrics
    # ==========================
    $activeUsers = [Math]::Round($totalSeats * ($adoptionPct / 100))
    $suggestions = $activeUsers * (Get-Random -Minimum 30 -Maximum 50)
    $acceptances = [Math]::Round($suggestions * ($adoptionPct / 250)) # Higher adoption -> slightly better acceptance
    
    # 1. Enterprise Metrics (Impact Dashboard)
    $sql += "INSERT INTO _tool_copilot_enterprise_metrics (connection_id, scope_id, day, active_users, total_seats, created_at, updated_at) VALUES ($connectionId, '$scopeId', '$dateStr', $activeUsers, $totalSeats, NOW(), NOW());`n"

    # 2. Org Metrics (Adoption Dashboard Panels 1-4)
    # Sync active_users to ensure dashboards match
    $sql += "INSERT INTO _tool_copilot_org_metrics (connection_id, scope_id, date, total_active_users, seat_total, seat_active_count, completion_suggestions, completion_acceptances, ide_chats, dotcom_chats, total_engaged_users, created_at, updated_at) VALUES ($connectionId, '$scopeId', '$dateStr', $activeUsers, $totalSeats, $activeUsers, $suggestions, $acceptances, 0, 0, $activeUsers, NOW(), NOW());`n"

    # 3. Language Metrics (Adoption Dashboard Panels 5-6)
    # Fixes the "Messy" dashboard look
    $pythonSugg = [Math]::Round($suggestions * 0.4)
    $goSugg = [Math]::Round($suggestions * 0.3)
    $tsSugg = $suggestions - $pythonSugg - $goSugg
    
    foreach ($langData in @(@{l="Python";s=$pythonSugg}, @{l="Go";s=$goSugg}, @{l="TypeScript";s=$tsSugg})) {
        $lName = $langData.l
        $lSugg = $langData.s
        $lAcc = [Math]::Round($lSugg * 0.3)
        $sql += "INSERT INTO _tool_copilot_language_metrics (connection_id, scope_id, date, language, editor, suggestions, acceptances, lines_suggested, lines_accepted, engaged_users) VALUES ($connectionId, '$scopeId', '$dateStr', '$lName', 'vscode', $lSugg, $lAcc, 0, 0, 10);`n"
    }

    # ==========================
    # DORA Metrics (PRs)
    # ==========================
    # Impact: Lead Time for Changes
    $prCount = Get-Random -Minimum 2 -Maximum 6
    for ($j = 0; $j -lt $prCount; $j++) {
        $prId = "fake-pr-$i-$j"
        $variance = (Get-Random -Minimum -20 -Maximum 20) / 100
        $cycleTimeHours = $baseCycleTimeHours * (1 + $variance)
        $cycleTimeMins = [Math]::Round($cycleTimeHours * 60)
        
        # Link deployment to PR for Lead Time calculation (metric requires it)
        # We'll just generate PR metrics directly for simplicity as DORA dashboard uses project_pr_metrics heavily
        $createdDate = $currentDate.AddMinutes(-$cycleTimeMins).ToString("yyyy-MM-dd HH:mm:ss")
        $sql += "INSERT INTO project_pr_metrics (id, project_name, pr_cycle_time, pr_created_date, pr_merged_date, created_at, updated_at) VALUES ('$prId', '$projectName', $cycleTimeMins, '$createdDate', '$datetimeStr', NOW(), NOW());`n"
    }

    # ==========================
    # DORA Metrics (Deployments & Incidents)
    # ==========================
    # Impact: Deployment Frequency & Change Failure Rate
    
    if ((Get-Random -Minimum 0 -Maximum 100) -lt $deployChance) {
        $deployId = "fake-deploy-$i"
        $deploySha = "sha-$i"
        
        # 1. Deploy
        $sql += "INSERT INTO cicd_deployment_commits (id, cicd_scope_id, cicd_deployment_id, name, result, status, environment, created_date, queued_date, started_date, finished_date, commit_sha, repo_id, repo_url, created_at, updated_at) VALUES ('$deployId', '$repoScopeId', '$deployId', '$deployId', 'SUCCESS', 'SUCCESS', 'PRODUCTION', '$datetimeStr', '$datetimeStr', '$datetimeStr', '$datetimeStr', '$deploySha', '$repoScopeId', 'fake-url', NOW(), NOW());`n"
        
        # 2. Incident? (CFR Impact)
        if ((Get-Random -Minimum 0 -Maximum 100) -lt $failChance) {
            $incId = "fake-inc-$i"
            $relId = "fake-rel-$i"
            
            # Create incident 1 hour after deploy
            $incCreated = $currentDate.AddHours(1)
            $incCreatedStr = $incCreated.ToString("yyyy-MM-dd HH:mm:ss")
            
            # Resolve it based on MTTR phase
            $incResolved = $incCreated.AddHours($mttrHours)
            $incResolvedStr = $incResolved.ToString("yyyy-MM-dd HH:mm:ss")
            
            # Lead time minutes (Time to Restore)
            $leadTimeMins = $mttrHours * 60

            # Important: 'table' column must match project_mapping for DORA dashboard (usually 'boards')
            # Note: Escaping backticks for PowerShell string interpolation (``table``)
            $sql += "INSERT INTO incidents (id, scope_id, ``table``, created_date, resolution_date, lead_time_minutes, created_at, updated_at) VALUES ('$incId', '$repoScopeId', 'boards', '$incCreatedStr', '$incResolvedStr', $leadTimeMins, NOW(), NOW());`n"
            
            # Link Incident to Deployment (Critical for CFR)
            # Note: In project_incident_deployment_relationships, 'id' IS the incident_id
            $sql += "INSERT INTO project_incident_deployment_relationships (id, project_name, deployment_id, created_at, updated_at) VALUES ('$incId', '$projectName', '$deployId', NOW(), NOW());`n"
        }
    }
}

Set-Content -Path $sqlFile -Value $sql
Write-Host "Generated SQL seed file at $sqlFile"
