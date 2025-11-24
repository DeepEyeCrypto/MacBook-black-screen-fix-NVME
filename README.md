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

