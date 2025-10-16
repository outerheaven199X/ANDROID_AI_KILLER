# 🚀 Quick Start Guide

## Option 1: Automated Setup (Recommended)

Run the PowerShell setup script:
```powershell
.\setup-adb.ps1
```

## Option 2: Manual Setup

### Install ADB Manually
1. **Download** [Android Platform Tools](https://developer.android.com/studio/releases/platform-tools)
2. **Extract** to `C:\platform-tools\`
3. **Add to PATH**: 
   - Open System Properties → Environment Variables
   - Add `C:\platform-tools\` to your PATH
   - Restart terminal

### Enable Developer Options on Phone
1. **Settings** → **About Phone** → **Build Number** (tap 7 times)
2. **Settings** → **Developer Options** → **Enable USB Debugging**
3. **For WiFi ADB**: Enable **"Wireless debugging"** in Developer Options
4. **Connect phone via USB OR WiFi** and authorize when prompted

## Connect Your Phone (WiFi ADB)

```powershell
# Connect to your phone (replace with your phone's IP)
.\connect-phone.ps1 192.168.1.100

# Or run without IP to be prompted
.\connect-phone.ps1
```

## Test Your Setup

```bash
# Check if ADB works
adb devices

# Should show your phone like:
# List of devices attached
# 192.168.1.100:5555    device
```

## Run the AI Disable Script

### Windows (PowerShell) - Easiest Method:
```powershell
# Test what would be affected (safe)
.\run-script.ps1 dryrun

# Apply the changes
.\run-script.ps1 apply

# Check results
.\run-script.ps1 audit

# Rollback if needed
.\run-script.ps1 rollback
```

### Alternative Method (Direct bash):
```bash
# Test what would be affected (safe)
bash de-ai-sm-s711u.sh dryrun

# Apply the changes
bash de-ai-sm-s711u.sh apply

# Check results
bash de-ai-sm-s711u.sh audit
```

## Rollback (if needed)

```bash
./de-ai-sm-s711u.sh rollback
```

That's it! Your AI assistants are now disabled but can be easily restored.
