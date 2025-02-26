# Check if a folder path is provided
if [[ -z "$1" ]]; then
    echo "Usage: $0 /path/to/folder"
    exit 1
fi

# Get the folder path from the first argument
target_folder="$1"

# Find the .fna and .faa files in the specified folder
fna_file=$(ls "${target_folder}"/*.fna 2>/dev/null)
faa_file=$(ls "${target_folder}"/*.faa 2>/dev/null)

# Ensure both files are found
if [[ -z "$fna_file" || -z "$faa_file" ]]; then
    echo "Error: Could not find .fna or .faa file in the specified directory."
    exit 1
fi

# Extract the header from the .fna file
header=$(grep -m1 '^>' "$fna_file")

# Extract the ID and full species name (first three space-separated fields)
id_species=$(echo "$header" | awk '{print $1"_"$2"_"$3}')

# Remove the leading '>' from the header
id_species=${id_species#>}

# Define the new filename for the .faa file
new_faa_file="${target_folder}/${id_species}.faa"

# Copy the original .faa file to the new file
cp "$faa_file" "$new_faa_file"

echo "Copied $faa_file to $new_faa_file"

