# File Size Statics

This repository offers two shell scripts for analyzing file sizes:

- `file_size_counts.sh` scans a directory tree, buckets files by their exact byte size, and emits a CSV with the number of files for each size.
- `file_size_threshold.sh` lists every file larger than a supplied threshold and writes a CSV of `filename,filesize,filepath`.

## Requirements

- Bash 4+
- Python 3.7+ (used for walking the directory and writing the CSV)

## Usage

### Count Files by Exact Size

Run from a local clone:

```bash
bash file_size_counts.sh <path-to-scan> [output.csv]
```

- `path-to-scan` (required): directory whose files you want counted.
- `output.csv` (optional): where to write the CSV; defaults to `./file_size_counts.csv`.

Example: `bash file_size_counts.sh ./src stats.csv`

Run directly via curl once hosted somewhere that serves raw files:

```bash
curl -sSL https://raw.githubusercontent.com/horn553/file_size_statics/refs/heads/main/file_size_counts.sh | bash -s -- <path-to-scan> [output.csv]
```

Replace the URL with the raw location of `file_size_counts.sh` in your hosting solution (e.g., a Git hosting provider).

**Output format**

```
filesize,count
12 bytes,4
4096 bytes,2
...
```

Each row lists the file size in bytes (unit included) followed by the number of files with that exact size found under the target directory.

### List Files Over a Threshold

Run from a local clone:

```bash
curl -sSL https://raw.githubusercontent.com/horn553/file_size_statics/refs/heads/main/file_size_threshold.sh | bash -s -- <path-to-scan> <threshold-bytes> [output.csv]
```

- `path-to-scan` (required): directory whose files you want scanned.
- `threshold-bytes` (required): minimum byte size; only files larger than this value are included.
- `output.csv` (optional): destination for the CSV; defaults to `./files_over_threshold.csv`.

**Output format**

```
filename,filesize,filepath
```

Rows are sorted by descending size and then alphabetically by path when sizes match.
