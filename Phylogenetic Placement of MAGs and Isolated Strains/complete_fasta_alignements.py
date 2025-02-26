import sys

# Check if the correct number of arguments is provided
if len(sys.argv) != 4:
    print("Usage: python script.py <input1> <input2> <output>")
    sys.exit(1)

# Get file names from command-line arguments
input1_file = sys.argv[1]
input2_file = sys.argv[2]
output_file = sys.argv[3]

# Read the list of names from input1
with open(input1_file, "r") as f:
    input1_names = [line.strip() for line in f]

# Read the multifasta file into a dictionary
fasta_dict = {}
with open(input2_file, "r") as f:
    header = None
    for line in f:
        line = line.strip()
        if line.startswith(">"):
            header = line[1:]  # Remove the ">" from the header
            fasta_dict[header] = ""
        elif header:
            fasta_dict[header] += line  # Append the sequence

# Determine the length of sequences (assume all sequences have the same length)
sequence_lengths = [len(seq) for seq in fasta_dict.values()]
if sequence_lengths:
    default_length = max(sequence_lengths)  # Use the maximum length for dashes
else:
    default_length = 0  # If no sequences are present, default to 0

# Open the output file and write sequences in the order of input1
with open(output_file, "w") as out:
    for name in input1_names:
        # Check if the name matches any header
        matching_header = None
        for header in fasta_dict.keys():
            if name in header:  # Match if the name is a substring of the header
                matching_header = header
                break

        if matching_header:
            # Write the existing sequence
            out.write(f">{matching_header}\n")
            out.write(f"{fasta_dict[matching_header][:default_length]}\n")
        else:
            # Write a new entry with dashes
            out.write(f">{name}\n")
            out.write(f"{'-' * default_length}\n")

print(f"Output written to {output_file}")

