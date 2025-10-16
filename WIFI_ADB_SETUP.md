# 📶 WiFi ADB Setup Guide

## 🔧 Initial USB Setup (One-time only)

You'll need to do this **once** to enable WiFi ADB:

### Method 1: Using ADB Commands
```bash
# Connect via USB first
adb devices

# Enable WiFi ADB (Android 11+)
adb tcpip 5555

# Get your phone's IP address
adb shell ip route | grep wlan
# OR check in Settings → WiFi → Connected Network
```

### Method 2: Using Developer Options
1. **Settings** → **Developer Options**
2. **Enable "Wireless debugging"**
3. **Tap "Pair device with pairing code"**
4. **Note the IP address and port** (usually 192.168.x.x:xxxx)

## 📱 Connect Over WiFi

### Option A: Direct Connection
```bash
# Connect to your phone's IP (replace with your actual IP)
adb connect 192.168.1.100:5555

# Verify connection
adb devices
# Should show: 192.168.1.100:5555    device
```

### Option B: Using Pairing Code
```bash
# Pair with code (from Developer Options)
adb pair 192.168.1.100:xxxx

# Then connect
adb connect 192.168.1.100:5555
```

## 🚀 Run the AI Disable Script

Once connected via WiFi, the script works exactly the same:

```bash
# Test what would be affected
./de-ai-sm-s711u.sh dryrun

# Apply the changes
./de-ai-sm-s711u.sh apply

# Check results
./de-ai-sm-s711u.sh audit
```

## 🔄 Reconnecting After Reboot

WiFi ADB connection may drop after phone reboot. To reconnect:

```bash
# Reconnect to your phone
adb connect 192.168.1.100:5555

# Or use the pairing method again if needed
```

## 🛠 Troubleshooting WiFi ADB

### "Connection refused" Error
- Ensure phone and computer are on same WiFi network
- Check if IP address changed (phones often get new IPs)
- Try pairing method instead of direct connection

### "Device not found" Error
- Re-enable "Wireless debugging" in Developer Options
- Restart ADB server: `adb kill-server && adb start-server`
- Try pairing with new code

### Connection Drops Frequently
- Check WiFi signal strength
- Disable battery optimization for ADB
- Keep phone screen on during operations

## 📋 Quick WiFi ADB Commands

```bash
# Check current connections
adb devices

# Kill and restart ADB server
adb kill-server
adb start-server

# Disconnect specific device
adb disconnect 192.168.1.100:5555

# Connect to device
adb connect 192.168.1.100:5555
```

## 🎯 Advantages of WiFi ADB

✅ **No USB cable needed**  
✅ **Works from anywhere on same network**  
✅ **No USB debugging authorization popups**  
✅ **More stable for long operations**  
✅ **Can work with multiple devices**  

## ⚠️ Security Notes

- WiFi ADB is only secure on trusted networks
- Disable when not needed
- Use pairing codes for additional security
- Consider using VPN on untrusted networks

The AI disable script works identically with WiFi ADB - no changes needed!
