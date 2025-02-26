import argparse
from Bio import Entrez

# Set your email for NCBI Entrez API
Entrez.email = "lcaesar@iu.edu"

# Function to fetch taxonomy information using NCBI Entrez API
def get_taxonomy(protein_id):
    try:
        # Fetch summary from the protein database
        handle = Entrez.esummary(db="protein", id=protein_id)
        record = Entrez.read(handle)
        handle.close()

        # Get Taxonomy ID
        tax_id = record[0]['TaxId']

        # Fetch taxonomy details
        tax_handle = Entrez.efetch(db="taxonomy", id=tax_id, retmode="xml")
        tax_record = Entrez.read(tax_handle)
        tax_handle.close()

        # Extract taxonomy details
        taxonomy = tax_record[0]["Lineage"]
        species = tax_record[0]["ScientificName"]
        return f"{taxonomy}; {species}"
    except Exception as e:
        return f"Error ({str(e)})"

# Main script
def process_file(input_file, output_file):
    with open(input_file, "r") as infile, open(output_file, "w") as outfile:
        for line in infile:
            if line.strip():  # Skip empty lines
                columns = line.strip().split("\t")
                protein_id = columns[1]  # Extract protein ID from column 2
                taxonomy = get_taxonomy(protein_id)  # Fetch taxonomy
                outfile.write(f"{line.strip()}\t{taxonomy}\n")
    print(f"Annotated file saved to {output_file}")

# Command-line argument parsing
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Annotate input file with taxonomy information from NCBI.")
    parser.add_argument("input_file", help="Path to the input file.")
    parser.add_argument("output_file", help="Path to save the annotated output.")
    args = parser.parse_args()
    process_file(args.input_file, args.output_file)

