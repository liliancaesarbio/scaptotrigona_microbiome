def process_brite_file(input_file):
    output = []
    current_k = None

    with open(input_file, 'r') as file:
        for line in file:
            line = line.strip()
            if line.startswith("BRITE classification for"):
                # Extract the current KXXXXX identifier
                current_k = line.split()[-1].strip(":")
            elif current_k and line.startswith("0"):
                # Append lines starting with '0', prefixed with current KXXXXX
                output.append(f"{current_k} {line}")
    
    return output

# Example usage
if __name__ == "__main__":
    import sys

    if len(sys.argv) < 2:
        print("Usage: python script.py <input_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    result = process_brite_file(input_file)
    for line in result:
        print(line)

