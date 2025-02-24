# README
Here, you will find the scripts and commands used to analyze the Scaptotrigona microbiome data—although flags and details regarding commands/analyses are also provided in the manuscript methods section. The pipeline includes both amplicon sequencing (16S and ITS) and shotgun sequencing. While ASVs, count tables, and taxonomic classifications are available as supplementary material in the manuscript, raw shotgun sequencing data can be accessed in the NCBI Sequence Read Archive (SRA) under Project ID PRJNA1216660.

By following this pipeline, you should be able to reproduce our results or apply the analyses to other datasets for comparison. Note that file names or directory paths should be adjusted accordingly, which is highlighted in the pipeline as comments.

The pipeline is organized following the methods section of the manuscript:

# Amplicon Data and Statistical Analyses
Contains inputs, scripts, and commands for 16S amplicon sequencing, ITS amplicon analyses, and statistical analyses on alpha and beta diversity.
Software includes: R, DADA2, Vegan
External databases: SILVA v.138.1 (silva_nr99_v138.1_train_set.fa and silva_species_assignment_v138.1.fa) and UNITE v.9 (sh_general_release_dynamic_25.07.2023)

# Metagenome Assembly and Binning
Contains scripts and commands for metagenome assembly, coverage mapping, and binning.
Software includes: metaSPAdes, Bowtie2, Metabat, checkM, dRep, Samtools
External databases: SILVA SSU database v.138.1 (2,224,740 SSU rRNA sequences) and fungi_odb10 (2024-01-08, 549 genomes, 758 BUSCOs)

# Strain Diversity in Metagenome-Assembled Genomes (MAGs)
Contains scripts and commands for strain diversity prediction.
Software: InStrain

# Phylogenetic Placement of MAGs and Isolated Strains
Contains scripts and commands for maximum likelihood phylogenetic inference.
Software includes: BLAST+, OrthoFinder, MAFFT, IQ-TREE
External databases: NCBI nr database (version November 10/11/2023)

# Microbiome and MAG-Encoded Functions
Contains scripts and commands for coding sequence predictions, recovery of region-specific coverage, and functional enrichment analyses.
Software includes: Prokka, eggnog-mapper, DRAM, R
External databases: eggNOG DB v.5.0.2
