import sys
from collections import Counter

def process_file(input_file):
    classifications_to_count = {"Bacteria", "Fungi", "Virus", "Insecta"}
    node_classification_counts = {}

    with open(input_file, "r") as file:
        next(file)  # Skip header
        for line in file:
            fields = line.strip().split("\t")
            if len(fields) < 3:
                continue  # Skip malformed lines
            node, _, classification = fields
            if classification in classifications_to_count:
                if node not in node_classification_counts:
                    node_classification_counts[node] = Counter()
                node_classification_counts[node][classification] += 1

    # Generate output
    print("Contig\tConsensus_Classification")
    for node, counts in node_classification_counts.items():
        if counts:
            consensus_classification = counts.most_common(1)[0][0]
            print(f"{node}\t{consensus_classification}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python classify_node.py <input_file>")
        sys.exit(1)

    input_file = sys.argv[1]
    process_file(input_file)

