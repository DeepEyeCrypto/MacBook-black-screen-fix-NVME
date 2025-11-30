# MacBook-black-screen-fix-NVME
# macOS Advanced Power Management Script

A comprehensive Bash script to disable all sleep, hibernation, and power-saving features on macOS for uninterrupted operation during critical tasks.

## 🎯 Purpose

This script is designed for users who need their Mac to **remain fully awake** during:

- **Cryptocurrency trading and market monitoring** (24/7 uptime required)
- **Long-running downloads or uploads**
- **Server operations and remote access**
- **Video rendering and compilation tasks**
- **Machine learning model training**
- **Network packet capture and monitoring**
- **Live streaming and recording**

## ⚙️ What It Does

### Core Power Settings

| Setting | AC Power | Battery | Description |
|---------|----------|---------|-------------|
| `displaysleep` | 0 | 0 | Display never sleeps |
| `sleep` | 0 | 0 | System never sleeps |
| `disksleep` | 0 | 0 | Hard disk never spins down |
| `hibernatemode` | 0 | 0 | Hibernation completely disabled |
| `standby` | 0 | 0 | Standby mode disabled |
| `autopoweroff` | 0 | 0 | Auto power-off disabled |

### Network & Wake Settings

- **Power Nap** (OFF): Prevents automatic background updates during "sleep"
- **TCP Keep Alive** (OFF): Disables network connection maintenance
- **Wake on Network** (OFF): Prevents network packets from waking the Mac
- **Dark Wakes** (OFF): Prevents hidden wake events for background tasks
- **Proximity Wake** (OFF): Bluetooth devices cannot wake your Mac

### Advanced Features

- **SSH Session Protection**: `ttyskeepawake=1` keeps Mac awake during remote sessions
- **GPU Performance Mode**: Forces discrete GPU for maximum performance (where supported)
- **Sudden Motion Sensor** (OFF): Disables HDD protection (unnecessary for SSDs)
- **Auto-Backup**: Creates timestamped backup of current settings before changes

## 📋 Requirements

- macOS 10.10 or later (Intel or Apple Silicon)
- Administrator (sudo) access
- Terminal access

## 🚀 Installation & Usage

### 1. Download the Script

Download or create the script

```bash
curl -O https://raw.githubusercontent.com/DeepEyeCrypto/MacBook-black-screen-fix-NVME/refs/heads/main/fix_blackscreen.sh

```

### 2. Run the Script
```bash
chmod +x fix_nvme.sh
sudo ./fix_nvme.sh

```

### 3. Verify Settings



## 🛠️ Troubleshooting

### Mac Still Sleeping?

**Reset SMC (System Management Controller):**

#### Intel Macs:
1. Shut down your Mac
2. Press and hold: `Shift + Control + Option + Power` for 10 seconds
3. Release all keys
4. Turn on your Mac

#### Apple Silicon Macs:
1. Shut down your Mac
2. Wait 30 seconds
3. Turn on your Mac (SMC resets automatically)

### Display Still Dimming?


### Need Temporary Sleep Prevention?

Use the built-in `caffeinate` command:


## ⚠️ Important Warnings

### Battery Life
Running these settings on battery power will **significantly reduce battery life**. Your Mac will consume full power even when idle.

### Overheating
Continuous operation without sleep may cause:
- Increased fan noise
- Higher temperatures
- Potential thermal throttling during intensive tasks

**Monitor temperatures using:**
- Activity Monitor → Window → CPU History
- Third-party tools: Macs Fan Control, iStat Menus

### macOS Updates
System updates may reset some power settings. Re-run the script after major macOS updates.

## 🔍 Advanced Options

### Disable Internal Prevent Sleep Assertion

## 📊 Performance Considerations

### For Trading & Real-Time Applications

This configuration ensures:
- No missed market opportunities due to sleep
- Continuous network connectivity
- Instant response to price alerts
- Uninterrupted API connections

### For Development & SSH Work

- Remote sessions never disconnect
- Build processes complete without interruption
- Docker containers remain active
- Network services stay available

## 🔐 Security Note

Disabling sleep may expose your Mac to unauthorized access if left unattended. Consider:

- Setting a screen saver with password requirement
- Using automatic screen lock
- Enabling FileVault encryption
- Implementing physical security measures


## 📝 Script Features

- ✅ Color-coded output for clarity
- ✅ Automatic backup of existing settings
- ✅ Error handling and validation
- ✅ Progress indicators
- ✅ Comprehensive logging
- ✅ Safe execution with error checking

## 🤝 Contributing

Issues, suggestions, and improvements are welcome. This script is designed for advanced users who understand the trade-offs of disabling sleep features.

## 📄 License

Free to use and modify. No warranty provided.

## 🔗 Related Resources

- [Apple pmset Manual](https://ss64.com/osx/pmset.html)
- [macOS Power Management Guide](https://eclecticlight.co/2017/01/20/power-management-in-detail-using-pmset/)
- [Caffeinate Command Reference](https://ss64.com/osx/caffeinate.html)

---

**Version:** 2.0  
**Last Updated:** November 2025  
**Tested On:** macOS Sonoma, Ventura, Monterey

