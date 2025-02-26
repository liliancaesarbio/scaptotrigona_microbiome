import sys

# Define the taxonomy categories
categories = ["Bacteria", "Fungi", "Virus", "Insecta"]

def classify_taxonomy(taxonomy_line):
    """Classify taxonomy based on predefined categories."""
    for category in categories:
        if category in taxonomy_line:
            return category
    return "Other"

def process_files(input1_file, input2_file, output_file):
    """Process the input files and write the output."""
    # Parse input2 to create a gene-to-taxonomy mapping
    gene_taxonomy = {}
    with open(input2_file, "r") as file2:
        for line in file2:
            fields = line.strip().split("\t")
            if len(fields) < 13:
                continue  # Skip lines that don't have enough fields
            gene_id = fields[0]
            taxonomy = fields[12]  # Taxonomy is in the 13th column (0-indexed)
            classification = classify_taxonomy(taxonomy)
            gene_taxonomy[gene_id] = classification

    # Process input1 and produce the output
    with open(input1_file, "r") as file1, open(output_file, "w") as outfile:
        outfile.write("Contig\tGeneID\tClassification\n")  # Write header
        for line in file1:
            if not line.startswith("NODE_"):
                continue  # Skip lines not starting with "NODE_"
            fields = line.strip().split("\t")
            if len(fields) < 9:
                continue  # Skip lines without enough fields
            contig = fields[0]
            attributes = fields[8]
            gene_id = None
            for attr in attributes.split(";"):
                if attr.startswith("ID="):
                    gene_id = attr.split("=")[1]  # Extract gene ID
                    break
            if not gene_id:
                continue  # Skip if no gene ID found
            classification = gene_taxonomy.get(gene_id, "Other")  # Default to "Other" if gene not found
            outfile.write(f"{contig}\t{gene_id}\t{classification}\n")

def main():
    # Ensure correct usage
    if len(sys.argv) != 4:
        print("Usage: python script.py <input1_gff> <input2_taxa> <output>")
        sys.exit(1)

    # Parse command-line arguments
    input1_file = sys.argv[1]
    input2_file = sys.argv[2]
    output_file = sys.argv[3]

    # Process the files
    process_files(input1_file, input2_file, output_file)
    print(f"Processing complete! Output written to {output_file}")

if __name__ == "__main__":
    main()

