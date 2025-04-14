#!/bin/bash

# === CONFIGURATION ===
SOURCE="/path/to/source"
DEST="/path/to/destination"
LOGFILE="$DEST/move_log_$(date '+%Y%m%d_%H%M%S').log"
DRYRUN=true  # Set to false to perform actual moves

# === NAMES TO MATCH (files or folders) ===
MATCHES=(
  'example_file.txt' 'backup_data' 'important_notes.log'
  'docker' 'configs' 'archive.img'
)
WILDCARDS=('log_*' 'cache-*')

# === LOGGING FUNCTION ===
log() {
  echo "$1" | tee -a "$LOGFILE"
}

log "=== Starting TOC-preserving recursive move ($(date)) ==="
log "Source: $SOURCE"
log "Destination: $DEST"
log "Dry-run mode: $DRYRUN"
log "Logging to: $LOGFILE"
log ""

# === MAIN WALK ===
find "$SOURCE" -mindepth 1 ! -path "$DEST/*" | while read -r item; do
  relpath="${item#$SOURCE/}"
  base="$(basename "$item")"
  matched=false

  # Check exact name matches
  for name in "${MATCHES[@]}"; do
    if [[ "$base" == "$name" ]]; then
      matched=true
      break
    fi
  done

  # Check wildcard matches
  if ! $matched; then
    for pattern in "${WILDCARDS[@]}"; do
      if [[ "$base" == $pattern ]]; then
        matched=true
        break
      fi
    done
  fi

  # === If matched ===
  if $matched; then
    # If it's a folder, walk inside and handle files individually
    if [ -d "$item" ]; then
      find "$item" -type f -o -type d | while read -r subitem; do
        subrel="${subitem#$SOURCE/}"
        dest="$DEST/$subrel"
        if [ ! -e "$dest" ]; then
          log "Would move: $subitem -> $dest"
          if ! $DRYRUN; then
            mkdir -p "$(dirname "$dest")"
            mv "$subitem" "$dest"
            log "Moved: $subitem -> $dest"
          fi
        fi
      done
    else
      # It's a matched file
      dest="$DEST/$relpath"
      if [ ! -e "$dest" ]; then
        log "Would move: $item -> $dest"
        if ! $DRYRUN; then
          mkdir -p "$(dirname "$dest")"
          mv "$item" "$dest"
          log "Moved: $item -> $dest"
        fi
      fi
    fi
  fi
done

log ""
log "=== Script finished at $(date) ==="
