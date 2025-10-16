# 📱 Android AI Disable Script - Deployment Guide

## 🛠 Prerequisites

### 1. Install Android Platform Tools (ADB)

**Option A: Using Scoop (Recommended for Windows)**
```powershell
# Install Scoop if you don't have it
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression

# Install Android platform tools
scoop install android-platform-tools
```

**Option B: Manual Installation**
1. Download [Android Platform Tools](https://developer.android.com/studio/releases/platform-tools) from Google
2. Extract to `C:\platform-tools\`
3. Add `C:\platform-tools\` to your Windows PATH environment variable
4. Restart your terminal

**Option C: Using Chocolatey**
```powershell
choco install adb
```

### 2. Enable Developer Options on Your Phone

1. **Open Settings** → **About Phone**
2. **Tap "Build Number" 7 times** until you see "You are now a developer!"
3. **Go back to Settings** → **Developer Options**
4. **Enable "USB Debugging"**
5. **Enable "Install via USB"** (if available)

### 3. Connect Your Phone

1. **Connect phone to computer** via USB cable
2. **Select "File Transfer" or "MTP" mode** when prompted on phone
3. **Authorize USB debugging** when the popup appears on your phone
4. **Check connection** by running: `adb devices`

## 🚀 Deployment Steps

### Step 1: Verify ADB Connection
```bash
# Check if your phone is detected
adb devices

# Should show something like:
# List of devices attached
# ABC123DEF456    device
```

### Step 2: Test the Script (Dry Run)
```bash
# Run the script in dry-run mode to see what packages would be affected
./de-ai-sm-s711u.sh dryrun
```

### Step 3: Apply the AI Disable
```bash
# Actually disable the AI packages
./de-ai-sm-s711u.sh apply
```

### Step 4: Verify Changes
```bash
# Check what packages are now disabled
./de-ai-sm-s711u.sh audit
```

## 🔄 Rollback (If Needed)

If you want to restore the AI functionality:

```bash
# Rollback using the most recent backup
./de-ai-sm-s711u.sh rollback

# Or specify a specific backup file
./de-ai-sm-s711u.sh rollback /tmp/de-ai-sm-s711u/disabled-packages-1234567890.txt
```

## 🛡 Safety Features

### What the Script Does:
- **Disables** AI assistant packages (doesn't uninstall them)
- **Creates automatic backups** for easy rollback
- **Logs all operations** with timestamps
- **Skips critical system packages** (like Google Play Services)
- **Works without root** (uses user-level package management)

### What Gets Disabled:
- **Google Assistant** (QuickSearchBox, Assistant app, Bard)
- **Samsung Bixby** (Agent, Wakeup, SPage)
- **On-device AI services** (Private Compute Services, Personalization)
- **Vision Intelligence** and other Samsung AI features

### What Stays Enabled:
- **Google Play Services** (critical for app functionality)
- **Core system apps**
- **Regular Google apps** (Gmail, Maps, etc.)

## 🔧 Troubleshooting

### "adb not found" Error
- Install Android Platform Tools (see Prerequisites)
- Restart your terminal after installation
- Verify with: `adb version`

### "No device found" Error
- Check USB cable connection
- Enable USB Debugging in Developer Options
- Authorize the computer when prompted on phone
- Try different USB port/cable

### "Unauthorized" Device
- Check your phone for USB debugging authorization popup
- Tap "Allow" or "OK"
- If popup doesn't appear, disable and re-enable USB Debugging

### Script Permission Errors (Linux/Mac)
```bash
chmod +x de-ai-sm-s711u.sh
```

## 📊 Monitoring & Logs

### Log Files Location
- **Windows**: `C:\Users\[username]\AppData\Local\Temp\de-ai-sm-s711u\`
- **Linux/Mac**: `/tmp/de-ai-sm-s711u/`

### Log Contents
- Device information (model, build ID)
- Timestamp of operations
- List of disabled packages
- Any errors encountered

### Backup Files
- Automatic backups created with timestamp
- Contains list of disabled packages for rollback
- Format: `disabled-packages-[timestamp].txt`

## 🎯 Usage Examples

### Quick Start
```bash
# 1. Check what would be affected
./de-ai-sm-s711u.sh dryrun

# 2. Apply the changes
./de-ai-sm-s711u.sh apply

# 3. Verify results
./de-ai-sm-s711u.sh audit
```

### Advanced Usage
```bash
# Generate DNS block entries for network-level blocking
./de-ai-sm-s711u.sh dnsblock

# Rollback to specific backup
./de-ai-sm-s711u.sh rollback /path/to/backup-file.txt

# Show help
./de-ai-sm-s711u.sh --help
```

## ⚠️ Important Notes

1. **This script is reversible** - you can always rollback changes
2. **No root required** - works with standard user permissions
3. **Packages are disabled, not uninstalled** - they can be re-enabled
4. **Backup files are created automatically** - keep them safe
5. **Test with dryrun first** - always preview changes before applying

## 🆘 Getting Help

If you encounter issues:
1. Check the log files in the temp directory
2. Verify ADB connection with `adb devices`
3. Ensure USB Debugging is enabled and authorized
4. Try running the script with `dryrun` first to test

## 📱 Supported Devices

- **Samsung Galaxy S series** (S21, S22, S23, S24, etc.)
- **Samsung Galaxy Note series**
- **Google Pixel devices**
- **Most Android devices** with Google Play Services

The script automatically detects your device and adapts accordingly.
