#!/usr/bin/env bash
# android-ai-killer.sh — Reversibly disable Assistant/Gemini/Bixby surfaces (non-root, user 0)
# Works on any Android device - automatically detects your device model
# Usage: ./android-ai-killer.sh [dryrun|apply|rollback [file]|audit|dnsblock]

set -Eeuo pipefail
IFS=$'\n\t'

LOGDIR="${LOGDIR:-/tmp/android-ai-killer}"
mkdir -p "$LOGDIR"
NOW="$(date +%s)"
BACKUP_FILE="${LOGDIR}/disabled-packages-${NOW}.txt"
LOGFILE="${LOGDIR}/log-${NOW}.txt"

# --- Package tiers (keep it minimal & explicit)
TIER_A=(                               # Core Google assistant entrypoints
  com.google.android.googlequicksearchbox
  com.google.android.apps.googleassistant
  com.google.android.apps.bard
)
TIER_B=(                               # On-device AI/PCS (may impact "smart" features)
  com.google.android.as
  com.google.android.privatecomputeservices
  com.google.android.ondevicepersonalization
  com.google.android.gms                 # DO NOT disable; listed to show it's intentionally skipped
)
TIER_C=(                               # Samsung AI surfaces
  com.samsung.android.bixby.agent
  com.samsung.android.bixby.wakeup
  com.samsung.android.app.spage
  com.samsung.android.visionintelligence
  com.samsung.android.rubin.app
  com.samsung.android.app.routines
)

die(){ printf '%s\n' "ERROR: $*" >&2; exit 1; }
info(){ printf '%s\n' "$*"; }
log(){ printf '%s\n' "$*" | tee -a "$LOGFILE" >/dev/null; }

# --- ADB/device checks
command -v adb >/dev/null 2>&1 || die "adb not in PATH. Install Android platform-tools."

# pick first connected 'device' (not offline/unauthorized)
mapfile -t DEVLINES < <(adb devices | awk 'NR>1 && $2=="device"{print $1}')
[ "${#DEVLINES[@]}" -ge 1 ] || die "No device found. Enable USB debugging and authorize this computer."
export ADB_SERIAL="${DEVLINES[0]}"
adb -s "$ADB_SERIAL" wait-for-device

MODEL="$(adb -s "$ADB_SERIAL" shell getprop ro.product.model 2>/dev/null | tr -d '\r')"
BUILDID="$(adb -s "$ADB_SERIAL" shell getprop ro.build.display.id 2>/dev/null | tr -d '\r')"
info "Connected: ${MODEL:-unknown}  (${ADB_SERIAL})  build: ${BUILDID:-unknown}"

# --- Helpers
pkg_present(){ # $1=pkg -> prints pkg if installed (enabled or disabled)
  local p="$1"
  adb -s "$ADB_SERIAL" shell pm list packages | tr -d '\r' | cut -d: -f2 | grep -Fxq "$p" && printf '%s\n' "$p"
}

list_present(){ # list all present from args
  local p
  for p in "$@"; do pkg_present "$p"; done
}

disable_pkg(){ # idempotent; records for rollback
  local p="$1"
  if pkg_present "$p" >/dev/null; then
    log "Disabling: $p"
    adb -s "$ADB_SERIAL" shell pm disable-user --user 0 "$p" 2>&1 | tee -a "$LOGFILE" >/dev/null
    printf '%s\n' "$p" >> "$BACKUP_FILE"
  else
    log "Not installed: $p"
  fi
}

enable_pkg(){ # enable if present
  local p="$1"
  if pkg_present "$p" >/dev/null; then
    log "Enabling: $p"
    adb -s "$ADB_SERIAL" shell pm enable "$p" 2>&1 | tee -a "$LOGFILE" >/dev/null || true
  else
    log "Missing on device (skip): $p"
  fi
}

audit_disabled(){ adb -s "$ADB_SERIAL" shell pm list packages -d | sed 's/^package://'; }

dns_block_entries(){ cat <<'EOF'
# Gemini / Google AI (coarse; may affect other Google services)
0.0.0.0 bard.google.com
0.0.0.0 gemini.google.com
0.0.0.0 api.bard.google.com
0.0.0.0 gen-prod.sandbox.googleapis.com
0.0.0.0 privatecompute.googleapis.com
# Samsung AI (endpoints vary by region/feature)
0.0.0.0 samsungapis.com
0.0.0.0 api.samsungcloudsolution.com
EOF
}

usage(){
  cat <<EOF
Usage: $0 [dryrun|apply|rollback [backupfile]|audit|dnsblock]
  dryrun    List candidate packages present on device
  apply     Disable candidates (records ${BACKUP_FILE} for rollback)
  rollback  Re-enable packages from backup file (or latest if omitted)
  audit     Show all disabled packages on device
  dnsblock  Print coarse Pi-hole/hosts entries for Gemini endpoints
EOF
}

cmd="${1:-dryrun}"
case "$cmd" in
  dryrun)
    info "=== DRY RUN: scanning for AI/assistant packages ==="
    info "TIER A:"; list_present "${TIER_A[@]}" | sed 's/^/  - /'
    info "TIER B:"; list_present "${TIER_B[@]}" | sed 's/^/  - /'
    info "TIER C:"; list_present "${TIER_C[@]}" | sed 's/^/  - /'
    ;;
  apply)
    : > "$LOGFILE"
    log "Timestamp: $(date --iso-8601=seconds)"
    log "Device: $MODEL ($ADB_SERIAL)"
    log "Build: $BUILDID"
    info "Backup file: $BACKUP_FILE"
    info "--- TIER A ---"
    for p in "${TIER_A[@]}"; do disable_pkg "$p"; done
    info "--- TIER B ---"
    for p in "${TIER_B[@]}"; do
      [ "$p" = "com.google.android.gms" ] && { log "Skip Play Services: $p"; continue; }
      disable_pkg "$p"
    done
    info "--- TIER C ---"
    for p in "${TIER_C[@]}"; do disable_pkg "$p"; done
    info "Done. To rollback: $0 rollback '$BACKUP_FILE'"
    ;;
  rollback)
    BACKUP="${2:-$(ls -1tr "${LOGDIR}"/disabled-packages-* 2>/dev/null | tail -n1 || true)}"
    if [ -z "${BACKUP:-}" ] || [ ! -f "$BACKUP" ]; then
      info "No backup file found; best-effort re-enable of known packages."
      for p in "${TIER_A[@]}" "${TIER_B[@]}" "${TIER_C[@]}"; do enable_pkg "$p"; done
    else
      info "Rolling back using: $BACKUP"
      while IFS= read -r pkg; do [ -n "$pkg" ] && enable_pkg "$pkg"; done < "$BACKUP"
      info "Rollback complete."
    fi
    ;;
  audit)
    info "=== Disabled packages ==="
    audit_disabled
    ;;
  dnsblock)
    dns_block_entries
    ;;
  -h|--help|help)
    usage
    ;;
  *)
    usage; exit 1
    ;;
esac
