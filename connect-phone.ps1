# connect-phone.ps1 - Connect to Android phone via WiFi ADB
# Usage: .\connect-phone.ps1 [IP_ADDRESS]

param(
    [string]$PhoneIP = ""
)

Write-Host "WiFi ADB Connection Helper" -ForegroundColor Green

if ($PhoneIP -eq "") {
    Write-Host "`nNo IP address provided." -ForegroundColor Yellow
    Write-Host "`nTo find your phone's IP address:" -ForegroundColor Cyan
    Write-Host "1. Open Settings on your phone" -ForegroundColor White
    Write-Host "2. Go to WiFi or Network" -ForegroundColor White
    Write-Host "3. Tap on your connected WiFi network" -ForegroundColor White
    Write-Host "4. Look for 'IP address' (usually 192.168.x.x)" -ForegroundColor White
    Write-Host "`nOR enable 'Wireless debugging' in Developer Options to see the IP" -ForegroundColor White
    
    $PhoneIP = Read-Host "`nEnter your phone's IP address"
}

# Default port for WiFi ADB
$Port = 5555

Write-Host "`nConnecting to phone at ${PhoneIP}:${Port}..." -ForegroundColor Blue

try {
    # Kill any existing ADB server to start fresh
    adb kill-server | Out-Null
    Start-Sleep -Seconds 1
    
    # Connect to phone
    $result = adb connect "${PhoneIP}:${Port}" 2>&1
    Write-Host $result -ForegroundColor Green
    
    Start-Sleep -Seconds 2
    
    # Check devices
    Write-Host "`nConnected devices:" -ForegroundColor Blue
    adb devices
    
    Write-Host "`nConnection established!" -ForegroundColor Green
    Write-Host "`nNext steps:" -ForegroundColor Cyan
    Write-Host "1. Test connection: bash de-ai-sm-s711u.sh dryrun" -ForegroundColor White
    Write-Host "2. Apply changes: bash de-ai-sm-s711u.sh apply" -ForegroundColor White
    
} catch {
    Write-Host "`nConnection failed!" -ForegroundColor Red
    Write-Host "Make sure:" -ForegroundColor Yellow
    Write-Host "- Your phone and computer are on the same WiFi network" -ForegroundColor White
    Write-Host "- 'Wireless debugging' is enabled in Developer Options" -ForegroundColor White
    Write-Host "- The IP address is correct" -ForegroundColor White
}

