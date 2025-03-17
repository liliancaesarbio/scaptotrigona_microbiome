import sys

def main(input1_file, input2_file, output_file):
    # Open input1 and input2 files
    with open(input1_file, 'r') as f1, open(input2_file, 'r') as f2:
        input1 = [line.strip().split() for line in f1.readlines()]
        input2 = [line.strip().split() for line in f2.readlines()]

    # Create a dictionary from input2 where key is the ID in column 5 and value is tuple of column 1 and 6
    input2_dict = {row[4]: (row[0], row[5]) for row in input2}
    
    # Debugging: print the dictionary to ensure it's correctly populated
    print("Sample data from input2_dict:")
    for key, value in input2_dict.items():
        print(f"ID: {key}, Data: {value}")

    # Open the output file for writing
    with open(output_file, 'w') as out:
        # Process each line from input1
        for row in input1:
            id1 = row[0]  # ID from input1 (column 1)
            if id1 in input2_dict:
                # If there is a match in input2_dict, write the data to the output file
                data = input2_dict[id1]
                # Debugging: print the matching IDs and their data
                print(f"Match found for {id1}: {data}")
                # Write as tab-delimited by concatenating with \t
                out.write(data[0] + '\t' + data[1] + '\t' + '\t'.join(row) + '\n')
            else:
                # If no match, print a message
                print(f"No match found for {id1}")

if __name__ == "__main__":
    input1_file = sys.argv[1]  # First input file (input1)
    input2_file = sys.argv[2]  # Second input file (input2)
    output_file = sys.argv[3]  # Output file to write the result

    main(input1_file, input2_file, output_file)

