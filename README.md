# TOC-Move: Recursive Structure-Preserving Move Tool for Bash

**TOC-Move** is a lightweight Bash utility for selectively moving files and folders based on their names, while preserving directory structure. Unlike `rsync`, it performs true **moves** instead of copy-then-delete, making it ideal for situations where disk I/O should be minimized, drives are unstable or speed is of the essence.

---

## 🚀 What It Does

- Recursively scans a source directory for files and folder structures, matching a given list of names or wildcard patterns.
- Moves only those matching files/folders to a destination, **preserving the relative path structure**.
- Skips anything already present in the destination.
- Supports **dry-run mode** with full logging before committing to changes.

---

## 🔧 Why Use This Instead of `rsync`?

- `rsync --remove-source-files` **copies** and then deletes, which is inefficient and can strain disks.
- This tool performs direct **`mv`** operations only for files/folders that are missing in the destination.
- Designed for speed and **minimal disk wear** — especially useful for:
  - Drives showing early signs of failure
  - Working with large, sparse, or fragmented datasets
  - Keeping data in place on block-level optimized storage

---

## ✅ Features

- ✅ Dry-run mode with logging
- ✅ Wildcard and exact filename matching
- ✅ Full relative path preservation
- ✅ Safe: will not overwrite existing files or folders
- ✅ Simple Bash, no dependencies

---

## ❌ Limitations

- Does not compare file content, timestamps, or checksums — presence is determined by **path only**
- Only matches files/folders by **basename** (not full relative paths)
- Not a syncing or backup tool — it's purpose-built for **one-way selective moving**

---

## 🧠 Use Cases

- You interrupted an `rsync`, and want to finish moving files **without re-copying everything**
- You’re working with fragile drives and want to avoid unnecessary writes
- You want to de-duplicate or consolidate folders quickly with zero overhead
- You need a manual, controlled move operation with safety checks

---

## 📦 Usage

1. **Edit the script config**:

   SOURCE="/your/source/path"
   DEST="/your/destination/path"
   DRYRUN=true  # Set to false when ready

2. **List filenames/folders to match**:
   
   MATCHES=('docker' 'notes.txt' 'backup_data')
   WILDCARDS=('log_*' '*.img')

📝 Example

    SOURCE="/mnt/hdd"
    DEST="/mnt/backup"
    MATCHES=("docker" "appdata" "data.log")
    WILDCARDS=("report_*" "*.bak")
    DRYRUN=true  # Preview what would move
