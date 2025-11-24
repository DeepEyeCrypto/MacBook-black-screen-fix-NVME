#!/bin/bash

# ==============================================================================
# macOS Advanced Power Management Script
# ==============================================================================
# Purpose: Disable all sleep, hibernation, and power-saving features
# Use Case: Long-running tasks, trading operations, downloads, server work
# Compatible: macOS 10.10+ (Intel & Apple Silicon)
# ==============================================================================

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check for root privileges
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Error: This script must be run with sudo${NC}" 
   echo "Usage: sudo ./power-management.sh"
   exit 1
fi

echo -e "${YELLOW}===================================================${NC}"
echo -e "${YELLOW}   macOS Advanced Power Management Configuration${NC}"
echo -e "${YELLOW}===================================================${NC}"
echo ""

# Backup current settings
echo -e "${GREEN}[1/4] Backing up current power settings...${NC}"
pmset -g > ~/pmset_backup_$(date +%Y%m%d_%H%M%S).txt
echo "Backup saved to: ~/pmset_backup_$(date +%Y%m%d_%H%M%S).txt"
echo ""

# Apply AC Power (Charger) Settings
echo -e "${GREEN}[2/4] Applying AC Power settings...${NC}"
sudo pmset -c displaysleep 0          # Never sleep display
sudo pmset -c sleep 0                 # Never sleep system
sudo pmset -c disksleep 0             # Never sleep hard disk
sudo pmset -c powernap 0              # Disable Power Nap
sudo pmset -c tcpkeepalive 0          # Disable TCP keepalive
sudo pmset -c womp 0                  # Disable wake on network
sudo pmset -c standby 0               # Disable standby mode
sudo pmset -c autopoweroff 0          # Disable auto power off
sudo pmset -c hibernatemode 0         # Disable hibernation
sudo pmset -c ttyskeepawake 1         # Keep awake for SSH sessions
sudo pmset -c darkwakes 0             # Disable dark wake events
sudo pmset -c proximitywake 0         # Disable proximity wake
echo "✓ AC power settings applied"
echo ""

# Apply Battery Power Settings
echo -e "${GREEN}[3/4] Applying Battery Power settings...${NC}"
sudo pmset -b displaysleep 0          # Never sleep display
sudo pmset -b sleep 0                 # Never sleep system
sudo pmset -b disksleep 0             # Never sleep hard disk
sudo pmset -b powernap 0              # Disable Power Nap
sudo pmset -b tcpkeepalive 0          # Disable TCP keepalive
sudo pmset -b womp 0                  # Disable wake on network
sudo pmset -b standby 0               # Disable standby mode
sudo pmset -b autopoweroff 0          # Disable auto power off
sudo pmset -b hibernatemode 0         # Disable hibernation
sudo pmset -b ttyskeepawake 1         # Keep awake for SSH sessions
sudo pmset -b darkwakes 0             # Disable dark wake events
sudo pmset -b proximitywake 0         # Disable proximity wake
echo "✓ Battery power settings applied"
echo ""

# Apply Global Settings (All Power Sources)
echo -e "${GREEN}[4/4] Applying global settings...${NC}"
sudo pmset -a lidwake 1               # Wake when lid opens
sudo pmset -a acwake 1                # Wake when AC connects
sudo pmset -a lessbright 0            # Disable auto-dim on battery
sudo pmset -a halfdim 0               # Disable half-brightness before sleep
sudo pmset -a sms 0                   # Disable sudden motion sensor (HDD protection)
sudo pmset -a hibernatefile /dev/null 2>/dev/null || true  # Disable hibernate file
sudo pmset -a gpuswitch 2 2>/dev/null || true              # Force high-performance GPU
echo "✓ Global settings applied"
echo ""

# Display current settings
echo -e "${YELLOW}===================================================${NC}"
echo -e "${YELLOW}   Current Power Management Settings${NC}"
echo -e "${YELLOW}===================================================${NC}"
pmset -g
echo ""

# Additional recommendations
echo -e "${YELLOW}===================================================${NC}"
echo -e "${YELLOW}   Additional Recommendations${NC}"
echo -e "${YELLOW}===================================================${NC}"
echo "1. SMC Reset: If issues persist, reset SMC (see README.md)"
echo "2. Prevent sleep for specific tasks: caffeinate -d (display)"
echo "3. Restore defaults: sudo pmset restoredefaults"
echo ""

echo -e "${GREEN}✓ Power management configuration complete!${NC}"
echo -e "${GREEN}✓ Your Mac will now stay awake indefinitely${NC}"
echo ""
