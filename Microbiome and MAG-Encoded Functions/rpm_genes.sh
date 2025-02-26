#!/bin/bash

# Check if input and output files are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <input_file> <output_file>"
    exit 1
fi

# Assign input and output file variables
input_file="$1"
output_file="$2"

# Calculate the sum of column 1 using awk and store as a float
sum_column_1=$(awk -F'\t' '{if ($1 ~ /^[0-9]+([.][0-9]+)?$/) sum+=$1} END {print sum}' $input_file)

# Check if sum of column 1 is zero (using bc for floating-point comparison)
if (( $(echo "$sum_column_1 == 0" | bc -l) )); then
    echo "Error: Sum of column 1 is zero, cannot calculate RPM."
    exit 1
fi

# Process each line, adding the RPM value in a new column (column 6)
awk -F'\t' -v sum=$sum_column_1 '{rpm=($1/sum)*1000000; print $0, rpm}' $input_file > $output_file

echo "Output saved to $output_file"

