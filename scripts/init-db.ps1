# PowerShell script to initialize or re-initialize the database
# This script ensures the schema and dummy data are loaded

Write-Host "Initializing database..." -ForegroundColor Green

# Check if containers are running
$postgresRunning = docker compose ps postgres -q
if (-not $postgresRunning) {
    Write-Host "PostgreSQL container is not running. Starting containers..." -ForegroundColor Yellow
    docker compose up -d postgres
    Start-Sleep -Seconds 5
}

# Wait for PostgreSQL to be ready
Write-Host "Waiting for PostgreSQL to be ready..." -ForegroundColor Yellow
$maxAttempts = 30
$attempt = 0
do {
    $attempt++
    $ready = docker compose exec -T postgres pg_isready -U postgres 2>&1
    if ($ready -match "accepting connections") {
        Write-Host "PostgreSQL is ready!" -ForegroundColor Green
        break
    }
    if ($attempt -ge $maxAttempts) {
        Write-Host "PostgreSQL failed to become ready after $maxAttempts attempts" -ForegroundColor Red
        exit 1
    }
    Start-Sleep -Seconds 1
} while ($true)

# Check if tables exist
Write-Host "Checking if database is initialized..." -ForegroundColor Yellow
$tableCount = docker compose exec -T postgres psql -U postgres -d benavides -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';" 2>&1 | Out-String
$tableCount = $tableCount.Trim()

if ([int]$tableCount -eq 0) {
    Write-Host "Database is empty. Loading schema..." -ForegroundColor Yellow
    Get-Content db/schema/schema.sql | docker compose exec -T postgres psql -U postgres -d benavides
    
    Write-Host "Loading dummy data..." -ForegroundColor Yellow
    Get-Content db/dummy-data/dummy.sql | docker compose exec -T postgres psql -U postgres -d benavides
    
    Write-Host "Database initialized successfully!" -ForegroundColor Green
} else {
    Write-Host "Database already has $tableCount tables. Skipping initialization." -ForegroundColor Yellow
    Write-Host "To force re-initialization, run: docker compose down -v" -ForegroundColor Yellow
}

Write-Host "Done!" -ForegroundColor Green

