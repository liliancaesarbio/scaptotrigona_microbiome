import sys
import os

# Check if the input file is provided
if len(sys.argv) != 2:
    print("Usage: python process_contigs.py <input_file>")
    sys.exit(1)

# Get the input file name from the command-line argument
input_file = sys.argv[1]

# Generate output file names based on the input file name
base_name = os.path.splitext(input_file)[0]
output_bacteria = f"{base_name}_bacteria.txt"
output_fungi = f"{base_name}_fungi.txt"
output_insecta = f"{base_name}_insecta.txt"

# Initialize lists for each category
bacteria_contigs = []
fungi_contigs = []
insecta_contigs = []

# Open and process the input file
try:
    with open(input_file, "r") as file:
        # Skip the header
        next(file)
        for line in file:
            # Split the line into columns
            columns = line.strip().split()
            if len(columns) != 2:
                continue  # Skip malformed lines
            contig, classification = columns
            # Add contigs to the appropriate list
            if classification == "Bacteria":
                bacteria_contigs.append(contig)
            elif classification == "Fungi":
                fungi_contigs.append(contig)
            elif classification == "Insecta":
                insecta_contigs.append(contig)

    # Write the results to their respective files
    with open(output_bacteria, "w") as file:
        file.write("\n".join(bacteria_contigs))

    with open(output_fungi, "w") as file:
        file.write("\n".join(fungi_contigs))

    with open(output_insecta, "w") as file:
        file.write("\n".join(insecta_contigs))

    print("Files generated:")
    print(f"- {output_bacteria}")
    print(f"- {output_fungi}")
    print(f"- {output_insecta}")

except FileNotFoundError:
    print(f"Error: File '{input_file}' not found.")
    sys.exit(1)
except Exception as e:
    print(f"An error occurred: {e}")
    sys.exit(1)

