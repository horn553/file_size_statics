# File Size Statics

This repository offers a single shell script, `file_size_counts.sh`, that scans a directory tree, buckets files by their byte size, and emits a CSV with the number of files for each size.

## Requirements

- Bash 4+
- Python 3.7+ (used for walking the directory and writing the CSV)

## Usage

### Run from a local clone

```bash
bash file_size_counts.sh <path-to-scan> [output.csv]
```

- `path-to-scan` (required): directory whose files you want counted.
- `output.csv` (optional): where to write the CSV; defaults to `./file_size_counts.csv`.

Example:

```bash
bash file_size_counts.sh ./src stats.csv
```

### Run directly via curl

Once this repository is hosted somewhere that serves raw files, you can execute it without cloning:

```bash
curl -sSL https://raw.githubusercontent.com/horn553/file_size_statics/refs/heads/main/file_size_counts.sh | bash -s -- <path-to-scan> [output.csv]
```

Replace the URL with the raw location of `file_size_counts.sh` in your hosting solution (e.g., a Git hosting provider).

## Output Format

The script writes a CSV with headers:

```
filesize,count
12 bytes,4
4096 bytes,2
...
```

Each row lists the file size in bytes (unit included) followed by the number of files with that exact size found under the target directory.
