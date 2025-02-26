#!/bin/bash

# Check for the correct number of arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <input1> <input2> <output>"
    exit 1
fi

# Assign arguments to variables
input1="$1"
input2="$2"
output="$3"

# Temporary file to store intermediate results
temp_file=$(mktemp)

# Filter input1 for coverage > 0 and extract ID, column 2, and coverage (handle tab-delimited file)
awk -F'\t' '$3 > 0 {print $1, $2, $3}' "$input1" > "$temp_file"

# Clear the output file if it exists
> "$output"

# Process each line in the filtered results
while read -r id col2 coverage; do
    # Find the corresponding line in input2 (handle space-delimited file)
    taxonomy=$(grep -m 1 "^$id" "$input2" | cut -d' ' -f2-)

    # Determine if it's Bacteria, Fungi, or Insecta
    if echo "$taxonomy" | grep -q "Bacteria"; then
        category="Bacteria"
    elif echo "$taxonomy" | grep -q "Fungi"; then
        category="Fungi"
    elif echo "$taxonomy" | grep -q "Insecta"; then
        category="Insecta"
    else
        category="Unknown"
    fi

    # Append the result to the output file
    echo -e "$id\t$col2\t$coverage\t$category" >> "$output"
done < "$temp_file"

# Remove the temporary file
rm "$temp_file"

echo "Output written to $output"

