# setup-adb.ps1 - Quick ADB installation script for Windows
# Run this script to install Android Platform Tools (ADB)

Write-Host "Setting up Android Platform Tools (ADB)..." -ForegroundColor Green

# Check if Scoop is installed
if (Get-Command scoop -ErrorAction SilentlyContinue) {
    Write-Host "Scoop found. Installing Android Platform Tools..." -ForegroundColor Green
    scoop install adb
} else {
    Write-Host "Scoop not found. Installing Scoop first..." -ForegroundColor Yellow
    
    # Install Scoop
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
    
    # Refresh PATH
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH", "User")
    
    Write-Host "Scoop installed. Now installing Android Platform Tools..." -ForegroundColor Green
    scoop install adb
}

Write-Host "`nVerifying ADB installation..." -ForegroundColor Blue
try {
    $adbVersion = adb version 2>&1
    Write-Host "ADB installed successfully!" -ForegroundColor Green
    Write-Host "Version: $($adbVersion[0])" -ForegroundColor Cyan
} catch {
    Write-Host "ADB installation failed. Please install manually." -ForegroundColor Red
    Write-Host "Download from: https://developer.android.com/studio/releases/platform-tools" -ForegroundColor Yellow
}

Write-Host "`nNext steps:" -ForegroundColor Blue
Write-Host "1. Connect your Android phone via USB OR WiFi" -ForegroundColor White
Write-Host "2. Enable USB Debugging in Developer Options" -ForegroundColor White
Write-Host "3. For WiFi: Enable 'Wireless debugging' in Developer Options" -ForegroundColor White
Write-Host "4. Run: adb devices" -ForegroundColor White
Write-Host "5. Run: ./de-ai-sm-s711u.sh dryrun" -ForegroundColor White

Write-Host "`nReady to disable AI on your phone!" -ForegroundColor Green