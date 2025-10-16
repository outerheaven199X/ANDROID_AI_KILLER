# run-script.ps1 - Wrapper to run the AI disable script on Windows
# Usage: .\run-script.ps1 [dryrun|apply|rollback|audit|dnsblock]

param(
    [string]$Command = "dryrun"
)

$ScriptPath = "android-ai-killer.sh"

Write-Host "Running Android AI Disable Script..." -ForegroundColor Green
Write-Host "Command: $Command" -ForegroundColor Cyan

# Check if bash is available
if (-not (Get-Command bash -ErrorAction SilentlyContinue)) {
    Write-Host "`nERROR: bash not found!" -ForegroundColor Red
    Write-Host "Install Git for Windows: https://git-scm.com/download/win" -ForegroundColor Yellow
    exit 1
}

# Check if ADB is available
if (-not (Get-Command adb -ErrorAction SilentlyContinue)) {
    Write-Host "`nERROR: adb not found!" -ForegroundColor Red
    Write-Host "Run: .\setup-adb.ps1" -ForegroundColor Yellow
    exit 1
}

# Check if device is connected
$devices = adb devices 2>&1 | Select-String "device$"
if ($devices.Count -eq 0) {
    Write-Host "`nERROR: No device connected!" -ForegroundColor Red
    Write-Host "Run: .\connect-phone.ps1 [your-phone-ip]" -ForegroundColor Yellow
    exit 1
}

Write-Host "`n--- Starting script ---`n" -ForegroundColor Blue

# Run the bash script
bash $ScriptPath $Command

Write-Host "`n--- Script completed ---" -ForegroundColor Blue

