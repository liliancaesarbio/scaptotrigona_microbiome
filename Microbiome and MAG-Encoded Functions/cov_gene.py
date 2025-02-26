#!/usr/bin/env python3

import argparse
from collections import defaultdict

# Global variables
VERBOSE = False
DEPTH = defaultdict(list)
GENES = defaultdict(list)


def parse_args():
    parser = argparse.ArgumentParser(
        description="Calculate gene depth from provirus and depth files."
    )
    parser.add_argument("provirus_file", help="Path to the provirus file (space-delimited).")
    parser.add_argument(
        "depth_files",
        nargs="+",
        help="Paths to the depth files (tab-delimited, one or more).",
    )
    parser.add_argument(
        "-verbose",
        action="store_true",
        help="Enable verbose output (default: False).",
    )
    args = parser.parse_args()
    global VERBOSE
    VERBOSE = args.verbose
    return args.provirus_file, args.depth_files


def get_genes(file):
    """Reads the provirus file (space-delimited) and populates the GENES dictionary."""
    with open(file, "r") as fh:
        for line in fh:
            parts = line.strip().split()  # Space-delimited
            if len(parts) < 4:  # Ensure enough columns
                continue
            contig = parts[0]  # Exact contig name
            gene_id = parts[1]  # Gene ID
            try:
                start = int(parts[2])
                end = int(parts[3])
            except ValueError:
                continue

            # Ensure start <= end and determine orientation
            if start > end:
                orient = -1
                start, end = end, start
            else:
                orient = 1

            if contig not in GENES:
                GENES[contig] = []
            GENES[contig].append((start, end, orient, gene_id))


def get_depth(files):
    """Reads the depth files (tab-delimited) and populates the DEPTH dictionary."""
    for file in files:
        with open(file, "r") as fh:
            for line in fh:
                parts = line.strip().split("\t")  # Tab-delimited
                if len(parts) < 3:
                    continue
                contig = parts[0].split("_length")[0]  # Match up to the first "_length"
                try:
                    position = int(parts[1])
                    depth = float(parts[2])
                except ValueError:
                    continue

                if contig in GENES:
                    while len(DEPTH[contig]) <= position:
                        DEPTH[contig].append(0)
                    DEPTH[contig][position] = depth


def find_gene_depth():
    """Calculates the average depth for each gene."""
    for contig in sorted(GENES.keys()):
        for gene in GENES[contig]:
            start, end, orient, gene_id = gene
            depth = 0
            valid_positions = 0

            for i in range(start, end + 1):
                if i < len(DEPTH[contig]) and DEPTH[contig][i] > 0:
                    depth += DEPTH[contig][i]
                    valid_positions += 1

            if valid_positions > 0:
                depth /= valid_positions  # Average depth

            # Print the output in the desired format
            if orient < 0:
                print(f"{depth:.5f}\t{contig}\t{end}\t{start}\t{gene_id}")
            else:
                print(f"{depth:.5f}\t{contig}\t{start}\t{end}\t{gene_id}")


def main():
    provirus_file, depth_files = parse_args()
    get_genes(provirus_file)
    get_depth(depth_files)
    find_gene_depth()


if __name__ == "__main__":
    main()

