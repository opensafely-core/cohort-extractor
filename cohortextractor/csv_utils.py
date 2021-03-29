import csv
import gzip


def write_rows_to_csv(rows, filename):
    filename = str(filename)
    if filename.endswith(".csv"):
        with open(filename, "w", newline="") as csvfile:
            writer = csv.writer(csvfile)
            for row in rows:
                writer.writerow(row)
    elif filename.endswith(".csv.gz"):
        # `gzip.open` defaults to 9 (max compression) whereas the default
        # speed/compression tradeoff in the command line tool is 6
        with gzip.open(filename, "wt", newline="", compresslevel=6) as gzfile:
            writer = csv.writer(gzfile)
            for row in rows:
                writer.writerow(row)
    else:
        raise RuntimeError(f"Unsupported extension for CSV file: {filename}")


def is_csv_filename(filename):
    filename = str(filename)
    return filename.endswith(".csv") or filename.endswith(".csv.gz")
