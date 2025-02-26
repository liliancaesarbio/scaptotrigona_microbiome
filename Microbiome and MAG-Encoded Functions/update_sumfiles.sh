#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <input1> <input2> <output>"
    exit 1
fi

# Input files and output file from command line arguments
input1="$1"
input2="$2"
output="$3"

# Extract column 3 from input1 and store it in a temporary file
awk '{print $3}' "$input1" > temp_input1_col3.txt

# Compare input2 with the names in input1's column 3
# Add missing names from input2 with "0 0" to the output
while read -r name; do
    if ! grep -q "^$name$" temp_input1_col3.txt; then
        echo -e "0 0 $name" >> temp_missing.txt
    fi
done < "$input2"

# Combine input1 and the missing entries, then sort
cat "$input1" temp_missing.txt | sort -k3 > "$output"

# Cleanup temporary files
rm temp_input1_col3.txt temp_missing.txt

echo "Output written to $output"

