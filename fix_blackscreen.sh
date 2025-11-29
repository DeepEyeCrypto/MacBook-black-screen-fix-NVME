#!/bin/bash

# ==============================================================================
# ULTIMATE MACBOOK NVME FIXER (v3.0)
# ==============================================================================
# 1. Fixes NVMe Kernel Panics (Sleep/Wake Crash)
# 2. Fixes Charging Black Screen (AC Power Issue)
# 3. Installs "Wake Monitor" to prevent 15-min Lid Closed Black Screen
# ==============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Error: Run with sudo${NC}" 
   exit 1
fi

echo -e "${YELLOW}Starting Ultimate NVMe & Black Screen Fix...${NC}"
echo ""

# ------------------------------------------------------------------------------
# PART 1: SYSTEM SETTINGS & NVMe PROTECTION
# ------------------------------------------------------------------------------
echo -e "${GREEN}[1/4] Applying Power & NVMe Settings...${NC}"

# Remove corrupt sleepimage
rm -f /var/vm/sleepimage
touch /var/vm/sleepimage
chflags uchg /var/vm/sleepimage

# Global Disable of Deep Sleep (Crucial for NVMe)
sudo pmset -a hibernatemode 0
sudo pmset -a standby 0
sudo pmset -a autopoweroff 0
sudo pmset -a powernap 0
sudo pmset -a tcpkeepalive 0
sudo pmset -a womp 0
sudo pmset -a darkwakes 0

# Push safety timers to 24 hours (Prevents 15-min auto-sleep trigger)
sudo pmset -a standbydelaylow 86400
sudo pmset -a standbydelayhigh 86400
sudo pmset -a autopoweroffdelay 86400

# Display & Wake Settings
sudo pmset -a lidwake 1
sudo pmset -a sleep 0
sudo pmset -a displaysleep 0
sudo pmset -a disksleep 0

# Charger Specific Fixes (Backlight Protection)
sudo pmset -c acwake 0
sudo pmset -c lessbright 0
sudo pmset -c halfdim 0
sudo pmset -c gpuswitch 0 2>/dev/null || true

echo "✓ Power settings applied."

# ------------------------------------------------------------------------------
# PART 2: NVRAM BOOT ARGUMENTS (CLAMSHELL FIX)
# ------------------------------------------------------------------------------
echo -e "${GREEN}[2/4] Updating NVRAM Boot Args...${NC}"
# nvme=-1 : Basic power management for NVMe
# iog=0x0 : Clamshell/Display wake fix
sudo nvram boot-args="nvme=-1 iog=0x0"
echo "✓ Boot arguments updated."

# ------------------------------------------------------------------------------
# PART 3: INSTALLING FORCE WAKE MONITOR (The 15-min Fix)
# ------------------------------------------------------------------------------
echo -e "${GREEN}[3/4] Installing Background Wake Monitor...${NC}"

# Create the monitoring script in /usr/local/bin
cat << 'EOF' > /usr/local/bin/wakemonitor.sh
#!/bin/bash
# This script runs in background and forces display on if lid is open
while true; do
    # Check Lid State (No = Open, Yes = Closed)
    LID_STATUS=$(ioreg -r -k AppleClamshellState | grep "AppleClamshellState" | cut -d = -f 2 | tr -d ' ')
    
    if [[ "$LID_STATUS" == "No" ]]; then
        # If lid is OPEN, send a user activity signal to wake display
        caffeinate -u -t 1
    fi
    # Check every 5 seconds
    sleep 5
done
EOF

# Make it executable
chmod +x /usr/local/bin/wakemonitor.sh

# Create LaunchDaemon to run it automatically at startup
cat << 'EOF' > /Library/LaunchDaemons/com.user.wakemonitor.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.wakemonitor</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/bin/wakemonitor.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>
EOF

# Load the service immediately
launchctl load /Library/LaunchDaemons/com.user.wakemonitor.plist 2>/dev/null || true
launchctl start com.user.wakemonitor 2>/dev/null || true

echo "✓ Wake Monitor installed & started."

# ------------------------------------------------------------------------------
# PART 4: FINISHING UP
# ------------------------------------------------------------------------------
echo ""
echo -e "${GREEN}✓ SUCCESS: Full System Patch Applied!${NC}"
echo ""
echo -e "${RED}!!! MANDATORY STEP !!!${NC}"
echo "Abhi RESTART karein aur turant PRAM RESET karein (Cmd+Opt+P+R)."
echo "Yeh zaroori hai taaki NVRAM boot args apply hon."
echo ""
