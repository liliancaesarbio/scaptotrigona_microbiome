#!/usr/bin/env python3

import sys
from collections import OrderedDict

def read_fasta(filename):
    """Read a FASTA file and return sequences in order."""
    sequences = []
    current_sequence = []
    
    with open(filename) as f:
        for line in f:
            line = line.strip()
            if line.startswith('>'):
                if current_sequence:
                    sequences.append(''.join(current_sequence))
                current_sequence = []
            elif line:
                current_sequence.append(line)
    
    if current_sequence:
        sequences.append(''.join(current_sequence))
    
    return sequences

def get_common_headers(filename):
    """Get the simplified headers from the first file."""
    headers = []
    with open(filename) as f:
        for line in f:
            if line.startswith('>'):
                header = line.strip()[1:]  # Remove '>'
                # Split by underscores and remove the last two parts
                parts = header.split('_')
                if len(parts) >= 2:
                    simple_header = '_'.join(parts[:-2])
                else:
                    simple_header = header
                headers.append(simple_header)
    return headers

def concatenate_alignments(input_files):
    """Concatenate sequences in order, regardless of headers."""
    # Get sequences from all files
    all_sequences = []
    for filename in input_files:
        sequences = read_fasta(filename)
        all_sequences.append(sequences)
    
    # Get number of sequences from first file
    n_sequences = len(all_sequences[0])
    
    # Verify all files have same number of sequences
    for sequences in all_sequences[1:]:
        if len(sequences) != n_sequences:
            print(f"Error: Files have different numbers of sequences")
            sys.exit(1)
    
    # Get headers from first file
    headers = get_common_headers(input_files[0])
    
    # Concatenate sequences in order
    concatenated = OrderedDict()
    for i in range(n_sequences):
        concatenated_seq = ''
        for file_sequences in all_sequences:
            concatenated_seq += file_sequences[i]
        concatenated[headers[i]] = concatenated_seq
    
    return concatenated

def write_fasta(sequences, output_file):
    """Write the concatenated sequences to a FASTA file."""
    with open(output_file, 'w') as f:
        for header, sequence in sequences.items():
            f.write(f'>{header}\n')
            # Write sequence in lines of 60 characters
            for i in range(0, len(sequence), 60):
                f.write(f'{sequence[i:i+60]}\n')

def main():
    if len(sys.argv) < 3:
        print("Usage: python script.py output.fasta input1.fasta input2.fasta ...")
        sys.exit(1)
    
    output_file = sys.argv[1]
    input_files = sys.argv[2:]
    
    # Concatenate alignments
    concatenated = concatenate_alignments(input_files)
    
    # Write output
    write_fasta(concatenated, output_file)

if __name__ == "__main__":
    main()
