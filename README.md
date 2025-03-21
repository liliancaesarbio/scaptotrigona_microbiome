# Manuscript: Spatial Segregation and Cross-Domain Interactions Drive Stingless Bee Hive Microbiome Assembly

This repository contains all previously unreported custom computer code used to generate results reported in this stingless bee microbiome manuscript. Full details on commands and analyses, sufficient for reproducibility, are also provided in the manuscript’s methods section.

Custom scripts used in each manuscript section are provided accordingly, covering amplicon sequencing (16S and ITS) and shotgun sequencing. To use these scripts/commands, adjust file names and directory paths as needed. Most analyses also require installing specific software and databases, as specified below.

ASVs, count tables, and taxonomic classifications are included as supplementary material with the manuscript, while raw shotgun sequencing data is available in the NCBI Sequence Read Archive (SRA) under Project ID PRJNA1216660. Metagenome-assembled genomes (MAGs) can be found in: scaptotrigona_microbiome/Metagenome Assembly and Binning/MAGs/

# Folder: Amplicon Data and Statistical Analyses
Contains inputs, scripts, and commands for 16S amplicon sequencing, ITS amplicon analyses, and statistical analyses on alpha and beta diversity.

Software required to run code/scripts: R, DADA2 

External databases: SILVA v.138.1 (silva_nr99_v138.1_train_set.fa and silva_species_assignment_v138.1.fa) and UNITE v.9 (sh_general_release_dynamic_25.07.2023)

# Folder: Metagenome Assembly and Binning
Contains custom scripts related to running metagenome assembly, coverage mapping, and binning.

Interpreters required to run code/scripts: Bash, Python, Perl

Other software used in this section includes: metaSPAdes, Bowtie2, Metabat, checkM, dRep, Samtools

External databases: SILVA SSU database v.138.1 (2,224,740 SSU rRNA sequences) and fungi_odb10 (2024-01-08, 549 genomes, 758 BUSCOs)

# Folder: Strain Diversity in Metagenome-Assembled Genomes (MAGs)
Contains intermediate files from strain diversity prediction.

Software used in this section: InStrain

# Folder: Phylogenetic Placement of MAGs and Isolated Strains
Contains custom scripts related to maximum likelihood phylogenetic inferences.

Interpreters required to run code/scripts: Bash, Python

Software used in this section includes: BLAST+, OrthoFinder, MAFFT, IQ-TREE

External databases: NCBI nr database (version November 10/11/2023)

# Folder: Microbiome and MAG-Encoded Functions
Contains custom scripts used for coding sequence predictions, recovery of region-specific coverage, and functional enrichment analyses.

Interpreters required to run code/scripts: Bash, Python

Other software used in this section includes: Prokka, eggnog-mapper, DRAM

External databases: eggNOG DB v.5.0.2

# Feel free to contact me with questions: liliancaesarbio@gmail.com or lcaesar@iu.edu
