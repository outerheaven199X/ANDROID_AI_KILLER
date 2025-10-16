# 🛡️ Android AI Killer

**Reversibly disable Google Assistant, Gemini, Bixby, and other AI surfaces on Android devices**

A safe, non-root tool to reclaim control over your Android device by disabling intrusive AI features while maintaining full system functionality.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform: Android](https://img.shields.io/badge/Platform-Android-green.svg)](https://www.android.com/)
[![ADB Required](https://img.shields.io/badge/ADB-Required-blue.svg)](https://developer.android.com/studio/command-line/adb)

---

## 📋 Table of Contents

- [Why This Tool?](#-why-this-tool)
- [Features](#-features)
- [What Gets Disabled](#-what-gets-disabled)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
  - [Option A: WiFi ADB (Recommended)](#option-a-wifi-adb-recommended)
  - [Option B: USB Connection](#option-b-usb-connection)
- [Usage](#-usage)
- [Supported Devices](#-supported-devices)
- [Safety & Rollback](#-safety--rollback)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🎯 Why This Tool?

Modern Android devices come packed with AI features that:
- Run constantly in the background
- Consume battery and resources
- Send data to cloud services
- Cannot be easily disabled through settings

**Android AI Killer** gives you back control—safely and reversibly.

---

## ✨ Features

- **✅ Fully Reversible** - Creates automatic backups for easy rollback
- **✅ No Root Required** - Uses standard ADB package management
- **✅ Safe Operation** - Disables packages (doesn't uninstall), skips critical system apps
- **✅ WiFi & USB Support** - Works with both connection methods
- **✅ Comprehensive Logging** - Tracks all operations with timestamps
- **✅ Cross-Platform** - Works on Windows, macOS, and Linux
- **✅ Tiered Approach** - Organized by Google, Samsung, and on-device AI packages
- **✅ Idempotent** - Safe to run multiple times

---

## 🎯 What Gets Disabled

### Tier A - Google Assistant
- Google Quick Search Box (voice search & Google Assistant)
- Google Assistant app
- Bard/Gemini AI

### Tier B - On-Device AI
- Android System Intelligence
- Private Compute Services
- On-device Personalization
- *(Google Play Services is intentionally skipped to maintain app functionality)*

### Tier C - Samsung AI (Samsung devices only)
- Bixby Agent & Wakeup
- Samsung SPage
- Vision Intelligence
- Rubin AI features
- Routines automation

**Total**: Up to 14 AI packages depending on device model and carrier

---

## 🔧 Prerequisites

### Required Software
- **ADB (Android Debug Bridge)** - Part of Android Platform Tools
- **Bash** (Windows: Git Bash or WSL, macOS/Linux: built-in)

### Android Phone Requirements
- Android 11 or higher (recommended)
- Developer Options enabled
- USB Debugging or Wireless Debugging enabled

---

## 🚀 Quick Start

### Installation

#### Windows (PowerShell)
```powershell
# Install ADB using setup script
.\setup-adb.ps1
```

#### macOS (Homebrew)
```bash
brew install android-platform-tools
```

#### Linux (Debian/Ubuntu)
```bash
sudo apt-get update
sudo apt-get install android-tools-adb
```

---

### Option A: WiFi ADB (Recommended)

**Benefits**: No cable needed, more stable, works from anywhere on your network

#### Step 1: Enable Wireless Debugging on Phone
1. **Settings** → **About Phone** → Tap **Build Number** 7 times
2. **Settings** → **Developer Options** → Enable **"Wireless debugging"**
3. Tap **"Pair device with pairing code"**
4. Note the **IP address**, **pairing port**, and **pairing code**

#### Step 2: Pair Your Computer

**Windows:**
```powershell
# Example: adb pair [IP]:[PAIRING_PORT] [CODE]
adb pair 192.168.1.100:39241 655527

# Connect to device (use main port shown in Wireless debugging)
adb connect 192.168.1.100:37681

# Verify connection
adb devices
```

**macOS/Linux:**
```bash
# Pair with code
adb pair 192.168.1.100:39241 655527

# Connect to device
adb connect 192.168.1.100:37681

# Verify connection
adb devices
```

#### Step 3: Run the Script

**Windows:**
```powershell
# Preview what will be disabled
.\run-script.ps1 dryrun

# Apply the AI disable
.\run-script.ps1 apply
```

**macOS/Linux:**
```bash
# Preview what will be disabled
./android-ai-killer.sh dryrun

# Apply the AI disable
./android-ai-killer.sh apply
```

---

### Option B: USB Connection

**Benefits**: Works without WiFi, simpler initial setup

#### Step 1: Enable USB Debugging on Phone
1. **Settings** → **About Phone** → Tap **Build Number** 7 times
2. **Settings** → **Developer Options** → Enable **"USB Debugging"**
3. Connect phone to computer via USB cable
4. **Authorize** the computer when prompted on phone

#### Step 2: Verify Connection
```bash
# Check if device is detected
adb devices

# You should see:
# List of devices attached
# ABC123DEF456    device
```

#### Step 3: Run the Script

**Windows:**
```powershell
# Preview what will be disabled
bash android-ai-killer.sh dryrun

# Apply the AI disable
bash android-ai-killer.sh apply
```

**macOS/Linux:**
```bash
# Preview what will be disabled
./android-ai-killer.sh dryrun

# Apply the AI disable
./android-ai-killer.sh apply
```

---

## 🎮 Usage

### Available Commands

```bash
./android-ai-killer.sh [command]
```

| Command | Description |
|---------|-------------|
| `dryrun` | Preview what packages would be disabled (safe, no changes) |
| `apply` | Disable AI packages and create backup |
| `audit` | Show all currently disabled packages on device |
| `rollback [file]` | Re-enable packages from backup file |
| `dnsblock` | Print DNS block entries for Pi-hole/hosts file |

### Examples

```bash
# Always test first with dryrun
./android-ai-killer.sh dryrun

# Apply changes
./android-ai-killer.sh apply

# Check what was disabled
./android-ai-killer.sh audit

# Rollback to restore AI functionality
./android-ai-killer.sh rollback

# Rollback from specific backup
./android-ai-killer.sh rollback /tmp/de-ai-sm-s711u/disabled-packages-1234567890.txt
```

---

## 📱 Supported Devices

**✅ Works on ANY Android Device**

The script is **completely device-agnostic** - it automatically detects your device model, Android version, and adapts accordingly.

**Tested and Confirmed:**
- Samsung Galaxy S23 FE (SM-S711U)
- Samsung Galaxy S21/S22/S23/S24 series
- Samsung Galaxy Note series
- Google Pixel devices (all models)

**Compatible With:**
- **Any Android 11+ device** with Google Play Services
- **All Samsung devices** with One UI 4.0+
- **Custom ROM devices** (AOSP, LineageOS, GrapheneOS, etc.)
- **Any manufacturer**: Google, Samsung, OnePlus, Xiaomi, Motorola, etc.

**How It Works**: The script queries your device for installed packages and only disables what's actually present. Missing packages are safely skipped - no configuration needed!

---

## 🛡️ Safety & Rollback

### What Happens When You Run "Apply"?

1. **Backup Created**: Automatic backup file with timestamp
2. **Packages Disabled**: Apps are disabled at user level (not uninstalled)
3. **System Intact**: Critical system apps (like Google Play Services) are preserved
4. **Logs Generated**: Full audit trail of all operations

### Rollback Instructions

Rollback is **instant and automatic**:

```bash
# Use most recent backup
./android-ai-killer.sh rollback

# Or specify a backup file
./android-ai-killer.sh rollback /tmp/android-ai-killer/disabled-packages-[timestamp].txt
```

All disabled packages will be re-enabled immediately. No reboot required.

### Log Files Location

- **Windows**: `C:\Users\[username]\AppData\Local\Temp\android-ai-killer\`
- **macOS/Linux**: `/tmp/android-ai-killer/`

Each session creates:
- `disabled-packages-[timestamp].txt` - Backup for rollback
- `log-[timestamp].txt` - Full operation log

---

## 🔧 Troubleshooting

### "adb not found" Error

**Install Android Platform Tools:**
- **Windows**: Run `.\setup-adb.ps1` or install via [Scoop](https://scoop.sh/)
- **macOS**: `brew install android-platform-tools`
- **Linux**: `sudo apt-get install android-tools-adb`

### "No device found" Error

**USB Connection:**
- Check USB cable (try different cable/port)
- Enable USB Debugging in Developer Options
- Authorize computer when prompted on phone
- Try `adb kill-server && adb start-server`

**WiFi Connection:**
- Ensure phone and computer are on same WiFi network
- Check if Wireless Debugging is still enabled
- IP address may have changed (check in Developer Options)
- Try re-pairing with new code

### "Connection refused" on WiFi

- The pairing port (for `adb pair`) is different from connection port
- Check the main "Wireless debugging" screen for correct port
- Typical pairing port: 39xxx, connection port: 37xxx or 40xxx

### "Unauthorized" Device

- Check phone for USB debugging authorization popup
- Tap "Always allow from this computer" and approve
- If popup doesn't appear, disable and re-enable USB Debugging

### Script Runs But Nothing Happens

Some packages may already be disabled or not present on your device variant. Check the log file:

```bash
# Windows
cat C:\Users\[username]\AppData\Local\Temp\android-ai-killer\log-*.txt

# macOS/Linux
cat /tmp/android-ai-killer/log-*.txt
```

### WiFi Connection Drops Frequently

- Keep phone screen on during operations
- Disable battery optimization for ADB
- Move closer to WiFi router
- Use USB connection as alternative

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Report Issues**: Found a bug or compatibility issue? [Open an issue](https://github.com/outerheaven199X/ANDROID_AI_KILLER/issues)
2. **Add Device Support**: Test on your device and report results
3. **Improve Documentation**: Help make instructions clearer
4. **Submit Pull Requests**: Code improvements and new features

### Testing on Your Device

```bash
# Run dryrun and share output
./android-ai-killer.sh dryrun > my-device-test.txt

# Include device info
adb shell getprop ro.product.model
adb shell getprop ro.build.display.id
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## ⚠️ Disclaimer

**Use at your own risk.** This tool modifies system package states. While fully reversible and tested, always:
- Backup important data before use
- Test with `dryrun` first
- Keep the backup files safe
- Understand that disabling system apps may affect device functionality

This tool is for educational and personal use. Not affiliated with Google, Samsung, or any Android device manufacturer.

---

## 🙏 Acknowledgments

- Android Open Source Project for ADB tools
- Community testers and contributors
- Everyone who values digital autonomy

---

## 📞 Support

- **Documentation**: [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
- **WiFi Setup**: [WIFI_ADB_SETUP.md](WIFI_ADB_SETUP.md)
- **Quick Start**: [QUICK_START.md](QUICK_START.md)
- **Issues**: [GitHub Issues](https://github.com/outerheaven199X/ANDROID_AI_KILLER/issues)

---

**Made with ❤️ for digital freedom**

*Last Updated: October 16, 2025*