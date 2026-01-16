# Test GitHub Token
# Replace YOUR_TOKEN_HERE with your actual token

$token = "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"

Write-Host "Testing GitHub token..." -ForegroundColor Yellow
Write-Host ""

# Test 1: Basic user endpoint
Write-Host "Test 1: Fetching user info..." -ForegroundColor Cyan
$response = curl -s -H "Authorization: Bearer $token" https://api.github.com/user
Write-Host $response
Write-Host ""

# Test 2: User orgs endpoint (the one DevLake is calling)
Write-Host "Test 2: Fetching user orgs (this is what DevLake calls)..." -ForegroundColor Cyan
$response = curl -s -H "Authorization: Bearer $token" https://api.github.com/user/orgs
Write-Host $response
Write-Host ""

Write-Host "If you see 'Bad credentials' above, the token is invalid." -ForegroundColor Red
Write-Host "If you see JSON data, the token is valid!" -ForegroundColor Green
