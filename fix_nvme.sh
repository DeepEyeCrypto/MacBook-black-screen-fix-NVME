#!/bin/bash

# ==============================================================================
# FINAL ULTIMATE FIX v2.0: NVMe + Charging Black Screen Fix
# ==============================================================================
# 1. Disables Deep Sleep/Hibernation (Global NVMe Fix)
# 2. Pushes Sleep Timers to 24 Hours (15-min crash Fix)
# 3. Fixes Display Backlight issues on Charger (AC Power Fix)
# ==============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Error: Run with sudo${NC}" 
   exit 1
fi

echo -e "${YELLOW}Applying NVMe + Charging Black Screen Fixes...${NC}"
echo ""

# ------------------------------------------------------------------------------
# STEP 1: Cleanup Corrupt Hibernate File
# ------------------------------------------------------------------------------
echo -e "${GREEN}[1/4] Cleaning hibernate file...${NC}"
if [ -f /var/vm/sleepimage ]; then
    rm -f /var/vm/sleepimage
fi
# Lock the file so macOS can't write corrupt data
touch /var/vm/sleepimage
chflags uchg /var/vm/sleepimage

# ------------------------------------------------------------------------------
# STEP 2: Global NVMe Safety Settings (All Sources)
# ------------------------------------------------------------------------------
echo -e "${GREEN}[2/4] Applying Global NVMe Safety Rules...${NC}"
# Disable all deep sleep modes that crash NVMe
sudo pmset -a hibernatemode 0
sudo pmset -a standby 0
sudo pmset -a autopoweroff 0
sudo pmset -a powernap 0
sudo pmset -a tcpkeepalive 0
sudo pmset -a womp 0
sudo pmset -a darkwakes 0

# Push safety timers to 24 hours (86400 sec) to prevent 15-min crashes
sudo pmset -a standbydelaylow 86400
sudo pmset -a standbydelayhigh 86400
sudo pmset -a autopoweroffdelay 86400

# ------------------------------------------------------------------------------
# STEP 3: Wake & Display Settings (Global)
# ------------------------------------------------------------------------------
echo -e "${GREEN}[3/4] Configuring Global Wake Rules...${NC}"
sudo pmset -a lidwake 1               # Force wake on lid open
sudo pmset -a sleep 0                 # System never sleeps
sudo pmset -a displaysleep 0          # Display never sleeps
sudo pmset -a disksleep 0             # Disk never sleeps

# ------------------------------------------------------------------------------
# STEP 4: CHARGER SPECIFIC FIXES (New Addition)
# ------------------------------------------------------------------------------
echo -e "${GREEN}[4/4] Applying Charger (AC) Backlight Fixes...${NC}"
# Fixes black screen specifically when plugged in:

# 1. Disable 'Wake on AC Attach' (Prevents glitchy wake when plugging in)
sudo pmset -c acwake 0

# 2. Disable Dimming features (Fixes backlight driver getting stuck)
sudo pmset -c lessbright 0
sudo pmset -c halfdim 0

# 3. Force Integrated GPU on Charger (Prevents dGPU crash on 15" models)
# Note: If you have a 13" model, this command is harmless/ignored.
sudo pmset -c gpuswitch 0 2>/dev/null || true

echo ""
echo -e "${GREEN}✓ SUCCESS: All fixes applied!${NC}"
echo ""
echo -e "${YELLOW}Current Settings:${NC}"
pmset -g
echo ""
echo -e "${RED}IMPORTANT:${NC} Restart now and perform an SMC Reset immediately."
