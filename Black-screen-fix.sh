#!/bin/bash

# Enhanced macOS Power Management Script
# Disables sleep and power-saving features for uninterrupted operation

echo "Applying enhanced power management settings..."

# ===== AC POWER (Charger) Settings =====
sudo pmset -c displaysleep 0          # Never sleep display
sudo pmset -c sleep 0                 # Never sleep system
sudo pmset -c disksleep 0             # Never sleep hard disk
sudo pmset -c powernap 0              # Disable Power Nap
sudo pmset -c tcpkeepalive 0          # Disable TCP keepalive
sudo pmset -c womp 0                  # Disable wake on network access
sudo pmset -c standby 0               # Disable standby mode
sudo pmset -c autopoweroff 0          # Disable auto power off/hibernation
sudo pmset -c hibernatemode 0         # Disable hibernation completely
sudo pmset -c ttyskeepawake 1         # Prevent sleep during SSH/remote sessions

# ===== BATTERY POWER Settings =====
sudo pmset -b displaysleep 0          # Never sleep display
sudo pmset -b sleep 0                 # Never sleep system
sudo pmset -b disksleep 0             # Never sleep hard disk
sudo pmset -b powernap 0              # Disable Power Nap
sudo pmset -b tcpkeepalive 0          # Disable TCP keepalive
sudo pmset -b womp 0                  # Disable wake on network access
sudo pmset -b standby 0               # Disable standby mode
sudo pmset -b autopoweroff 0          # Disable auto power off
sudo pmset -b hibernatemode 0         # Disable hibernation
sudo pmset -b ttyskeepawake 1         # Prevent sleep during SSH/remote sessions

# ===== Additional Settings (All Power Sources) =====
sudo pmset -a lidwake 1               # Wake when lid is opened
sudo pmset -a acwake 1                # Wake when AC is connected
sudo pmset -a lessbright 0            # Disable dimming on battery

echo ""
echo "✓ Enhanced power settings applied successfully!"
echo ""
echo "Current power settings:"
pmset -g

echo ""
echo "To restore defaults later, run: sudo pmset restoredefaults"
