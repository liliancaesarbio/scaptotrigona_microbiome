#!/bin/bash

# Specify the folder name and file name as arguments
folder_name="$1"
file_name="$2"

# Check if the folder and file are provided
if [ -z "$folder_name" ] || [ -z "$file_name" ]; then
  echo "Usage: $0 <folder_name> <file_name>"
  exit 1
fi

# Check if the file exists
if [ ! -f "$file_name" ]; then
  echo "File '$file_name' not found!"
  exit 1
fi

# Add folder name in front of each header in the given file
awk -v folder="$folder_name" '
  /^>/ { 
    # Modify header lines
    print ">" folder "_" substr($0, 2)
    next
  } 
  { 
    # Print sequence lines as they are
    print $0
  }
' "$file_name" > "${file_name%.fasta}_modified.fasta"

