#!/bin/bash

# ==============================================================================
# FINAL ULTIMATE FIX: macOS NVMe Black Screen & Sleep Issues
# ==============================================================================
# 1. Disables ALL sleep/hibernate modes
# 2. Pushes deep sleep timers to 24 hours (prevents 15-min crash)
# 3. Deletes corrupt sleepimage file
# 4. Forces display to wake on lid open
# ==============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Root permission check
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Error: Please run with sudo${NC}" 
   echo "Usage: sudo ./fix_nvme.sh"
   exit 1
fi

echo -e "${YELLOW}Starting NVMe Black Screen Fix...${NC}"
echo ""

# ------------------------------------------------------------------------------
# STEP 1: Corrupt Hibernate File Cleanup
# ------------------------------------------------------------------------------
echo -e "${GREEN}[1/4] Cleaning up corrupt hibernate file...${NC}"
# Remove existing sleepimage
if [ -f /var/vm/sleepimage ]; then
    rm -f /var/vm/sleepimage
    echo "Deleted old sleepimage."
fi

# Create a dummy locked file to prevent macOS from writing new hibernation data
touch /var/vm/sleepimage
chflags uchg /var/vm/sleepimage
echo "Locked sleepimage to prevent future corruption."
echo ""

# ------------------------------------------------------------------------------
# STEP 2: Apply Unified Power Settings (-a for Battery & Charger)
# ------------------------------------------------------------------------------
echo -e "${GREEN}[2/4] Disabling sleep and hibernation...${NC}"

# Core Sleep Settings (The "Never Sleep" rules)
sudo pmset -a sleep 0                 # System never sleeps
sudo pmset -a displaysleep 0          # Display never sleeps automatically
sudo pmset -a disksleep 0             # SSD never spins down (Crucial for NVMe)

# Disable Deep Sleep & Hibernation (The cause of crashes)
sudo pmset -a hibernatemode 0         # Disable hibernation
sudo pmset -a standby 0               # Disable standby
sudo pmset -a autopoweroff 0          # Disable auto power off
sudo pmset -a powernap 0              # Disable background tasks
sudo pmset -a tcpkeepalive 0          # Disable network keepalive
sudo pmset -a womp 0                  # Disable wake on LAN
sudo pmset -a darkwakes 0             # Disable partial wakes

# ------------------------------------------------------------------------------
# STEP 3: Override Safety Timers (The 15-minute Fix)
# ------------------------------------------------------------------------------
echo -e "${GREEN}[3/4] Pushing safety timers to 24 hours...${NC}"
# Even if sleep is 0, we push these timers to 86400 seconds (24 hours)
# to ensure the system NEVER attempts to enter deep sleep automatically.
sudo pmset -a standbydelaylow 86400
sudo pmset -a standbydelayhigh 86400
sudo pmset -a autopoweroffdelay 86400

# ------------------------------------------------------------------------------
# STEP 4: Wake Settings
# ------------------------------------------------------------------------------
echo -e "${GREEN}[4/4] Configuring wake settings...${NC}"
sudo pmset -a lidwake 1               # FORCE wake when lid is opened
sudo pmset -a acwake 1                # Wake when charger is connected
sudo pmset -a lessbright 0            # Don't dim display
sudo pmset -a halfdim 0               # Don't half-dim display

echo ""
echo -e "${GREEN}✓ SUCCESS: All settings applied.${NC}"
echo ""

# ------------------------------------------------------------------------------
# Final Check & Instructions
# ------------------------------------------------------------------------------
echo -e "${YELLOW}Current Power Settings:${NC}"
pmset -g
echo ""
echo -e "${RED}!!! IMPORTANT !!!${NC}"
echo "Script run karne ke baad, ye FINAL step zaroor karein:"
echo "1. Shut Down your Mac."
echo "2. Perform an SMC Reset (Hold Power button for 10s on startup)."
echo "3. Perform a PRAM Reset (Cmd+Opt+P+R) immediately after turning on."
echo ""
echo "Agar iske baad bhi issue aaye, to NVMe boot argument use karna padega:"
echo "Command: sudo nvram boot-args=\"nvme=-1\""
