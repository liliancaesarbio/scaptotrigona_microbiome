import sys
import requests

def fetch_brite_classification(brite_id):
    """Fetch and extract BRITE classification from KEGG."""
    url = f"http://rest.kegg.jp/get/{brite_id}"
    try:
        response = requests.get(url)
        response.raise_for_status()  # Raise an error for bad responses
        # Parse and extract BRITE section
        lines = response.text.splitlines()
        brite_classification = []
        record = False
        for line in lines:
            if line.startswith("BRITE"):
                record = True
            elif record and not line.startswith(" "):
                break
            elif record:
                brite_classification.append(line.strip())
        return "\n".join(brite_classification) if brite_classification else "No BRITE classification found."
    except requests.exceptions.RequestException as e:
        return f"Error fetching {brite_id}: {e}"

def main(input_file, output_file):
    """Read KO IDs from the second column of a file and fetch their BRITE classifications."""
    try:
        with open(input_file, 'r') as file:
            brite_ids = []
            for line in file:
                columns = line.strip().split()  # Adjust the delimiter if needed (e.g., .split('\t') for tab-delimited files)
                if len(columns) > 1:  # Ensure there are at least two columns
                    brite_ids.append(columns[1])  # Extract the second column (KO ID)
        
        with open(output_file, 'w') as outfile:
            for brite_id in brite_ids:
                print(f"Fetching BRITE classification for {brite_id}...")
                classification = fetch_brite_classification(brite_id)
                outfile.write(f"BRITE classification for {brite_id}:\n{classification}\n\n")
                print(f"BRITE classification for {brite_id} saved.")
    except FileNotFoundError:
        print(f"Error: File '{input_file}' not found.")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python fetch_brite_classifications.py <input_filename> <output_filename>")
    else:
        main(sys.argv[1], sys.argv[2])

