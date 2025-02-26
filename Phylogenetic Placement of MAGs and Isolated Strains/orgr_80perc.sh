#!/bin/bash

# Check if input file is provided
if [ $# -lt 1 ]; then
  echo "Usage: $0 <input_file> [output_file]"
  exit 1
fi

input_file="$1"
output_file="${2:-output.txt}"

# Process the input file
awk -F'\t' '
NR == 1 {
    # Get the number of genomes (excluding the first column)
    num_genomes = NF - 1
    next
}
{
    group_name = $1    # Get the group name (first column)
    one_count = 0      # Initialize the counter for genomes with exactly 1 gene
    invalid = 0        # Flag for any genome column having more than 1 gene

    # Loop through all genome columns
    for (i = 2; i <= NF; i++) {
        if ($i > 1) { 
            invalid = 1    # Mark as invalid if any value is greater than 1
            break
        }
        if ($i == 1) {
            one_count++     # Count genomes with exactly 1 gene
        }
    }

    # If no invalid values and at least 80% have exactly 1 gene, print the group name
    if (invalid == 0 && one_count / (num_genomes * 1.0) >= 0.8) {
        print group_name
    }
}
' "$input_file" > "$output_file"

echo "Results written to $output_file"

