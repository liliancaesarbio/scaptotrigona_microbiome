import sys
from collections import defaultdict

def main(input_file, output_file):
    # Create a dictionary to store sums for each ID in column 5
    sums = defaultdict(lambda: [0, 0])

    # Open the input file for reading
    with open(input_file, 'r') as f:
        for line in f:
            # Split the line into columns (using tab as delimiter)
            columns = line.strip().split('\t')
            
            # Skip empty lines
            if not columns or len(columns) < 5:
                continue  # Skip if line is empty or doesn't have enough columns

            value1 = float(columns[0])  # Value from column 1
            value2 = float(columns[1])  # Value from column 2
            id5 = columns[4]  # ID from column 5

            # Sum the values for the same ID in column 5
            sums[id5][0] += value1
            sums[id5][1] += value2

    # Open the output file for writing
    with open(output_file, 'w') as out:
        for id5, (sum1, sum2) in sums.items():
            # Write the summed values to the output file, formatted to 2 decimal places
            out.write(f"{sum1:.2f}\t{sum2:.2f}\t{id5}\n")

if __name__ == "__main__":
    input_file = sys.argv[1]  # Input file (tab-delimited)
    output_file = sys.argv[2]  # Output file to write the result

    main(input_file, output_file)

