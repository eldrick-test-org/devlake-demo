# DevLake Data Export Script for Power BI
# This script exports key DevLake tables to CSV files that can be imported into Power BI

Write-Host "DevLake to Power BI Export Tool" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""

# Database connection details
$dbHost = "localhost"
$dbPort = "3306"
$dbName = "lake"
$dbUser = "merico"
$dbPassword = "merico"

# Output directory
$outputDir = ".\powerbi-exports"
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

Write-Host "Exporting DevLake data to: $outputDir" -ForegroundColor Yellow
Write-Host ""

# Tables to export (key domain tables)
$tables = @(
    "repos",
    "commits", 
    "pull_requests",
    "issues",
    "board_issues",
    "users",
    "teams",
    "project_metrics"
)

# Check if mysql command is available
try {
    docker exec devlake-setup-mysql-1 mysql --version | Out-Null
} catch {
    Write-Host "Error: Cannot connect to MySQL container" -ForegroundColor Red
    Write-Host "Make sure DevLake is running (docker compose up -d)" -ForegroundColor Yellow
    exit 1
}

# Export each table
foreach ($table in $tables) {
    Write-Host "Exporting table: $table..." -ForegroundColor Cyan
    
    $outputFile = Join-Path $outputDir "$table.csv"
    
    # Export using docker exec to mysql container
    $query = "SELECT * FROM $table"
    $cmd = "mysql -h localhost -u $dbUser -p$dbPassword $dbName -e `"$query`" --batch --quick --silent | sed 's/\t/,/g'"
    
    try {
        docker exec devlake-setup-mysql-1 sh -c $cmd | Out-File -FilePath $outputFile -Encoding UTF8
        Write-Host "  ✓ Exported to: $outputFile" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ Failed to export $table" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Export complete! Files are in: $outputDir" -ForegroundColor Green
Write-Host ""
Write-Host "To import into Power BI:" -ForegroundColor Yellow
Write-Host "  1. Open Power BI Desktop" -ForegroundColor White
Write-Host "  2. Click 'Get Data' → 'Text/CSV'" -ForegroundColor White
Write-Host "  3. Select the CSV files from $outputDir" -ForegroundColor White
Write-Host "  4. Load and build your reports!" -ForegroundColor White
