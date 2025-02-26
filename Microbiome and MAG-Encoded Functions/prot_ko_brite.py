import sys

def process_files(input1_path, input2_path, output_path):
    # Parse input2 into a dictionary mapping KO to unique BRITE classifications
    brite_map = {}
    with open(input2_path, 'r') as f:
        for line in f:
            parts = line.strip().split(" ", 2)
            if len(parts) == 3:  # Ensure the line has all three components
                ko, _, classification = parts
                brite_map.setdefault(ko, set()).add(classification)  # Use a set to ensure uniqueness

    # Process input1 and generate the output
    with open(input1_path, 'r') as f, open(output_path, 'w') as out:
        for line in f:
            id_, ko = line.strip().split()
            if ko in brite_map:
                for classification in sorted(brite_map[ko]):  # Sort classifications for consistent output
                    out.write(f"{id_}  {ko} {classification}\n")
            else:
                out.write(f"{id_}  {ko} -\n")

if __name__ == "__main__":
    # Ensure the correct number of arguments
    if len(sys.argv) != 4:
        print("Usage: python process_inputs.py <input1> <input2> <output>")
        sys.exit(1)

    # Read command-line arguments
    input1_path = sys.argv[1]
    input2_path = sys.argv[2]
    output_path = sys.argv[3]

    # Process the files
    process_files(input1_path, input2_path, output_path)
    print(f"Output written to {output_path}")

