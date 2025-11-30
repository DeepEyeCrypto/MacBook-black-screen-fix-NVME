#!/bin/bash

# ==============================================================================
# NVMe ULTIMATE STABILITY FIX (Heartbeat Edition)
# ==============================================================================
# 1. Hardens Power Settings (No Sleep/Hibernate)
# 2. Installs "Heartbeat Service" to prevent 15-min SSD Freeze
# 3. Forces Integrated GPU (for 15" models stability)
# ==============================================================================

set -e
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Error: Run with sudo${NC}"
   exit 1
fi

echo -e "${YELLOW}Starting NVMe Stability Patch...${NC}"

# ------------------------------------------------------------------------------
# STEP 1: CLEANUP & POWER SETTINGS
# ------------------------------------------------------------------------------
echo -e "${GREEN}[1/3] Locking Power Settings...${NC}"

# Kill old sleep/hibernate files
rm -f /var/vm/sleepimage
touch /var/vm/sleepimage
chflags uchg /var/vm/sleepimage

# Disable ALL deep sleep triggers
sudo pmset -a hibernatemode 0
sudo pmset -a standby 0
sudo pmset -a autopoweroff 0
sudo pmset -a powernap 0
sudo pmset -a tcpkeepalive 0
sudo pmset -a womp 0
sudo pmset -a darkwakes 0

# Push timers to 24 hours (Safety Net)
sudo pmset -a standbydelaylow 86400
sudo pmset -a standbydelayhigh 86400
sudo pmset -a autopoweroffdelay 86400

# Never Sleep Display/System
sudo pmset -a sleep 0
sudo pmset -a displaysleep 0
sudo pmset -a disksleep 0
sudo pmset -a lidwake 1

# Charging Specifics (Fix Black Screen on AC)
sudo pmset -c acwake 0
sudo pmset -c lessbright 0
sudo pmset -c gpuswitch 0 2>/dev/null || true

# NVRAM Boot Args (Panic Prevention)
# nvme=-1: Basic Power Mgmt
# iog=0x0: Clamshell Fix
sudo nvram boot-args="nvme=-1 iog=0x0"

echo "✓ Power rules applied."

# ------------------------------------------------------------------------------
# STEP 2: INSTALL HEARTBEAT DAEMON (The Real Fix)
# ------------------------------------------------------------------------------
echo -e "${GREEN}[2/3] Installing NVMe Heartbeat Service...${NC}"

# Create the script
cat << 'EOF' > /usr/local/bin/nvme_heartbeat.sh
#!/bin/bash
# NVMe Keep-Alive Script
# Writes to disk every 10 mins to prevent SSD controller sleep
while true; do
    # 1. Write timestamp to tmp file (Wake up SSD)
    date +%s > /tmp/.nvme_keepalive
    sync
    
    # 2. Simulate user activity (Wake up Display Controller)
    caffeinate -u -t 1
    
    # 3. Check Lid State & Force Wake if needed
    LID=$(ioreg -r -k AppleClamshellState | grep "AppleClamshellState" | cut -d = -f 2 | tr -d ' ')
    if [[ "$LID" == "No" ]]; then
        caffeinate -u -t 1
    fi
    
    # Sleep for 600 seconds (10 mins) - well within 15 min timeout
    sleep 600
done
EOF

chmod +x /usr/local/bin/nvme_heartbeat.sh

# Create LaunchDaemon
cat << 'EOF' > /Library/LaunchDaemons/com.nvme.heartbeat.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.nvme.heartbeat</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/nvme_heartbeat.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>
EOF

# Reload Service
launchctl unload /Library/LaunchDaemons/com.nvme.heartbeat.plist 2>/dev/null || true
launchctl load /Library/LaunchDaemons/com.nvme.heartbeat.plist

echo "✓ Heartbeat Service Running."

# ------------------------------------------------------------------------------
# STEP 3: FINISH
# ------------------------------------------------------------------------------
echo ""
echo -e "${GREEN}✓ SUCCESS!${NC}"
echo "System is now protected against 15-minute NVMe freeze."
echo "IMPORTANT: Please RESTART your Mac now."
