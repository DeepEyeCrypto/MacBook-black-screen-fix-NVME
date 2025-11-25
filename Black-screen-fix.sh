#!/bin/bash

# ==============================================================================
# macOS Unified Power Management Script (NVMe-Optimized)
# ==============================================================================
# All settings apply to BOTH battery and charger modes
# Optimized for third-party NVMe SSDs
# ==============================================================================

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Error: Run with sudo${NC}" 
   echo "Usage: sudo ./power-management.sh"
   exit 1
fi

echo -e "${YELLOW}===================================================${NC}"
echo -e "${YELLOW}   macOS Unified Power Management (NVMe Fix)${NC}"
echo -e "${YELLOW}===================================================${NC}"
echo ""

# Backup current settings
echo -e "${GREEN}[1/3] Creating backup...${NC}"
pmset -g > ~/pmset_backup_$(date +%Y%m%d_%H%M%S).txt
echo "Backup saved: ~/pmset_backup_$(date +%Y%m%d_%H%M%S).txt"
echo ""

# Apply unified settings for ALL power sources (-a flag)
echo -e "${GREEN}[2/3] Applying unified power settings...${NC}"
sudo pmset -a displaysleep 0          # Never sleep display
sudo pmset -a sleep 0                 # Never sleep system
sudo pmset -a disksleep 0             # Never sleep disk
sudo pmset -a hibernatemode 0         # Disable hibernation (NVMe fix)
sudo pmset -a standby 0               # Disable standby (NVMe fix)
sudo pmset -a autopoweroff 0          # Disable auto power off (NVMe fix)
sudo pmset -a powernap 0              # Disable Power Nap
sudo pmset -a tcpkeepalive 0          # Disable TCP keepalive
sudo pmset -a womp 0                  # Disable wake on network
sudo pmset -a ttyskeepawake 1         # Keep awake for SSH sessions
sudo pmset -a darkwakes 0             # Disable dark wake events
sudo pmset -a proximitywake 0         # Disable proximity wake
sudo pmset -a lidwake 1               # Wake when lid opens (important!)
sudo pmset -a acwake 1                # Wake when AC connects
sudo pmset -a lessbright 0            # No auto-dim
sudo pmset -a halfdim 0               # No half-brightness
sudo pmset -a sms 0                   # Disable motion sensor (SSD optimization)
sudo pmset -a standbydelaylow 0       # NVMe optimization
sudo pmset -a standbydelayhigh 0      # NVMe optimization

echo "✓ Unified settings applied (battery + charger)"
echo ""

# Display current settings
echo -e "${GREEN}[3/3] Current power settings:${NC}"
echo -e "${YELLOW}===================================================${NC}"
pmset -g
echo ""

# Instructions
echo -e "${YELLOW}===================================================${NC}"
echo -e "${YELLOW}   Important: SMC + PRAM Reset Required${NC}"
echo -e "${YELLOW}===================================================${NC}"
echo "For NVMe lid wake fix, perform this sequence:"
echo ""
echo "1. Shutdown your Mac"
echo "2. Hold Power button for 10 seconds (SMC reset)"
echo "3. Start Mac and IMMEDIATELY press: Cmd+Opt+P+R"
echo "4. Hold for 3 startup chimes (20 seconds)"
echo ""
echo -e "${GREEN}✓ Configuration complete!${NC}"
echo "To restore: sudo pmset restoredefaults"
echo ""
