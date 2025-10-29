#!/usr/bin/env bash

set -euo pipefail

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  echo "Usage: bash script.sh <path> [output_csv]" >&2
  exit 0
fi

if [ "$#" -lt 1 ]; then
  echo "Usage: bash script.sh <path> [output_csv]" >&2
  exit 1
fi

TARGET_PATH="$1"
OUTPUT_PATH="${2:-file_size_counts.csv}"

if [ ! -d "$TARGET_PATH" ]; then
  echo "Error: '$TARGET_PATH' is not a directory." >&2
  exit 1
fi

python3 - "$TARGET_PATH" "$OUTPUT_PATH" <<'PYCODE'
import csv
import os
import sys
from collections import Counter

root_path = sys.argv[1]
output_path = sys.argv[2]

size_counts = Counter()

for dirpath, _, filenames in os.walk(root_path):
    for filename in filenames:
        filepath = os.path.join(dirpath, filename)
        try:
            size = os.path.getsize(filepath)
        except OSError:
            continue
        size_counts[size] += 1

with open(output_path, "w", newline="") as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(("filesize", "count"))
    for size in sorted(size_counts):
        writer.writerow((f"{size} bytes", size_counts[size]))
PYCODE

echo "Wrote CSV to $OUTPUT_PATH"
