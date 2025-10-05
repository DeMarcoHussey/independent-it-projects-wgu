#!/usr/bin/env bash
set -euo pipefail
LOG_DIR="$HOME/Support"
mkdir -p "$LOG_DIR"
TS="$(date +"%Y-%m-%dT%H:%M:%S%z")"
LOG_FILE="$LOG_DIR/network_log_$(date +%Y%m%d_%H%M%S).txt"

{
  echo "=== Network Diagnostics (Unix) ==="
  echo "$TS"
  echo "Host: $(hostname)"
  echo "User: $(whoami)"
  echo "------------------------------------"

  echo "IP / routes:"
  if command -v ip >/dev/null 2>&1; then
    ip a || true
    ip route || true
  else
    ifconfig 2>/dev/null || true
    netstat -rn 2>/dev/null || true
    route -n get default 2>/dev/null || true
  fi

  echo "Gateway ping:"
  GW="$(route -n get default 2>/dev/null | awk '/gateway/{print $2}' || true)"
  echo "Default gateway: ${GW:-unknown}"
  if [ -n "${GW:-}" ]; then ping -c 2 "$GW" || true; fi

  echo "Connectivity tests:"
  for h in 8.8.8.8 1.1.1.1 www.microsoft.com www.phila.gov; do
    echo "--- $h ---"
    ping -c 2 "$h" || true
  done

  echo "DNS resolution:"
  (nslookup www.microsoft.com || dig +short www.microsoft.com || host www.microsoft.com) 2>/dev/null || true

  echo "Wi-Fi (macOS):"
  /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I 2>/dev/null || true

  echo "------------------------------------"
  echo "Log saved to: $LOG_FILE"
} | tee "$LOG_FILE"

echo "Network diagnostics saved to $LOG_FILE"
