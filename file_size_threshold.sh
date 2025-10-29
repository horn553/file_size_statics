#!/usr/bin/env bash

set -euo pipefail

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  echo "Usage: bash file_size_threshold.sh <path> <threshold_bytes> [output_csv]" >&2
  exit 0
fi

if [ "$#" -lt 2 ]; then
  echo "Usage: bash file_size_threshold.sh <path> <threshold_bytes> [output_csv]" >&2
  exit 1
fi

TARGET_PATH="$1"
THRESHOLD_RAW="$2"
OUTPUT_PATH="${3:-files_over_threshold.csv}"

if [ ! -d "$TARGET_PATH" ]; then
  echo "Error: '$TARGET_PATH' is not a directory." >&2
  exit 1
fi

if [[ ! "$THRESHOLD_RAW" =~ ^[0-9]+$ ]]; then
  echo "Error: threshold must be an integer byte value." >&2
  exit 1
fi

python3 - "$TARGET_PATH" "$THRESHOLD_RAW" "$OUTPUT_PATH" <<'PYCODE'
import csv
import os
import sys

root_path = sys.argv[1]
threshold = int(sys.argv[2])
output_path = sys.argv[3]

rows = []
checked = 0

print(f"Scanning '{root_path}' for files larger than {threshold} bytes...", file=sys.stderr, flush=True)

for dirpath, _, filenames in os.walk(root_path):
    for name in filenames:
        filepath = os.path.join(dirpath, name)
        try:
            size = os.path.getsize(filepath)
        except OSError:
            continue
        checked += 1
        if checked % 100 == 0:
            print(f"Scanned {checked} files so far...", file=sys.stderr, flush=True)
        if size > threshold:
            rows.append((name, size, filepath))

rows.sort(key=lambda item: (-item[1], item[2]))

with open(output_path, "w", newline="") as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(("filename", "filesize", "filepath"))
    writer.writerows(rows)

print(f"Finished scanning {checked} files; writing {len(rows)} matches.", file=sys.stderr, flush=True)
PYCODE

echo "Wrote CSV to $OUTPUT_PATH"
