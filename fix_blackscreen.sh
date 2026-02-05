#!/bin/bash
# Enhanced macOS power profile for NVMe MacBook (desktop mode)

set -e

echo "Applying NVMe / sleep fix profile..."

# Ask for sudo once
if ! sudo -v; then
  echo "sudo authentication failed"
  exit 1
fi

# Keep sudo alive while script runs
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# ===== AC POWER (charger) =====
sudo pmset -c \
  sleep 0 \
  displaysleep 0 \
  disksleep 0 \
  powernap 0 \
  tcpkeepalive 0 \
  womp 0 \
  standby 0 \
  autopoweroff 0 \
  hibernatemode 0 \
  ttyskeepawake 1

# ===== BATTERY POWER =====
# (You can change displaysleep/sleep later if you ever get a new battery.)
sudo pmset -b \
  sleep 0 \
  displaysleep 0 \
  disksleep 0 \
  powernap 0 \
  tcpkeepalive 0 \
  womp 0 \
  standby 0 \
  autopoweroff 0 \
  hibernatemode 0 \
  ttyskeepawake 1

# ===== GLOBAL =====
sudo pmset -a lidwake 1 acwake 1 lessbright 0

echo
echo "Done. Current custom profiles:"
pmset -g custom

echo
echo "To reset to factory defaults later, run:  sudo pmset restoredefaults"
