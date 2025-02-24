#### 16S with DADA2 in RSSTUDIO

# ORGANIZING FILES FOR THE ANALYSES, OUTSIDE RSTUDIO
#samples
GSF3362-C-_1_R1.fastq.gz
GSF3362-C-_2_R1.fastq.gz
GSF3362-FOOD_SBBG2_R1.fastq.gz
GSF3362-FOOD_SBBP3_R1.fastq.gz
GSF3362-FOOD_SBBP4_R1.fastq.gz
GSF3362-FOOD_SBSC1_R1.fastq.gz
GSF3362-FOOD_SBSC2_R1.fastq.gz
GSF3362-FOOD_SDBG1_R1.fastq.gz
GSF3362-FOOD_SDBP1_R1.fastq.gz
GSF3362-FOOD_SDBP2_R1.fastq.gz
GSF3362-FOOD_SDSC1_R1.fastq.gz
GSF3362-FOOD_SDSC2_R1.fastq.gz
GSF3362-FORAGER_SBBG1_R1.fastq.gz
GSF3362-FORAGER_SBBG2_R1.fastq.gz
GSF3362-FORAGER_SBBP3_R1.fastq.gz
GSF3362-FORAGER_SBBP4_R1.fastq.gz
GSF3362-FORAGER_SBSC1_R1.fastq.gz
GSF3362-FORAGER_SBSC2_R1.fastq.gz
GSF3362-FORAGER_SDBG1_R1.fastq.gz
GSF3362-FORAGER_SDBG2_R1.fastq.gz
GSF3362-FORAGER_SDBP1_R1.fastq.gz
GSF3362-FORAGER_SDBP2_R1.fastq.gz
GSF3362-FORAGER_SDSC2_R1.fastq.gz
GSF3362-GUARD_SBBP3_R1.fastq.gz
GSF3362-GUARD_SBSC1_R1.fastq.gz
GSF3362-GUARD_SBSC2_R1.fastq.gz
GSF3362-GUARD_SDBG1_R1.fastq.gz
GSF3362-GUARD_SDSC1_R1.fastq.gz
GSF3362-GUARD_SDSC2_R1.fastq.gz
GSF3362-HONEY_SBBG1_R1.fastq.gz
GSF3362-HONEY_SBBG2_R1.fastq.gz
GSF3362-HONEY_SBBP3_R1.fastq.gz
GSF3362-HONEY_SBBP4_R1.fastq.gz
GSF3362-HONEY_SBSC1_R1.fastq.gz
GSF3362-HONEY_SBSC2_R1.fastq.gz
GSF3362-HONEY_SDBG1_R1.fastq.gz
GSF3362-HONEY_SDBG2_R1.fastq.gz
GSF3362-HONEY_SDBP1_R1.fastq.gz
GSF3362-HONEY_SDSC1_R1.fastq.gz
GSF3362-HONEY_SDSC2_R1.fastq.gz
GSF3362-LARVAE1_SBBP4_R1.fastq.gz
GSF3362-LARVAE1_SDBP2_R1.fastq.gz
GSF3362-LARVAE1_SDBP4_R1.fastq.gz
GSF3362-LARVAE2_SBBP4_R1.fastq.gz
GSF3362-LARVAE_SBBP2_R1.fastq.gz
GSF3362-LARVAE_SBSC2_R1.fastq.gz
GSF3362-LARVAE_SDSC1_R1.fastq.gz
GSF3362-NURSE_SBBG1_R1.fastq.gz
GSF3362-NURSE_SBBG2_R1.fastq.gz
GSF3362-NURSE_SBBP3_R1.fastq.gz
GSF3362-NURSE_SBBP4_R1.fastq.gz
GSF3362-NURSE_SBSC1_R1.fastq.gz
GSF3362-NURSE_SBSC2_R1.fastq.gz
GSF3362-NURSE_SDBG1_R1.fastq.gz
GSF3362-NURSE_SDBG2_R1.fastq.gz
GSF3362-NURSE_SDBP1_R1.fastq.gz
GSF3362-NURSE_SDBP2_R1.fastq.gz
GSF3362-NURSE_SDSC1_R1.fastq.gz
GSF3362-NURSE_SDSC2_R1.fastq.gz
GSF3362-POLLEN_SBBP2_R1.fastq.gz
GSF3362-POLLEN_SBBP3_R1.fastq.gz
GSF3362-POLLEN_SDBG1_R1.fastq.gz
GSF3362-POLLEN_SDBG2_R1.fastq.gz
GSF3362-POLLEN_SDBP1_R1.fastq.gz
GSF3362-POLLEN_SDBP2_R1.fastq.gz
GSF3362-POLLEN_SDSC1_R1.fastq.gz
GSF3362-POLLEN_SDSC2_R1.fastq.gz

# running analyses with dada2 (1.16)
# decompress all gz files in a folder
gzip -d -k *.gz

# make folder to move all decompressed files
mkdir 16S_decompress
mv *fastq 16S_decompress/

# delete first part of the files' names
cd 16S_decompress
for file in *; do mv "$file" "${file#GSF3362-}"; done
# then delete the first _
for i in *; do newi=$(echo $i | sed 's/_//'); mv $i $newi; done

# download silva database
wget https://zenodo.org/records/4587955/files/silva_nr99_v138.1_train_set.fa.gz?download=1
wget https://zenodo.org/records/4587955/files/silva_species_assignment_v138.1.fa.gz?download=1

# make a file with the taxa info
gunzip silva_nr99_v138.1_train_set.fa.gz
gunzip silva_species_assignment_v138.1.fa.gz

# get the taxa
grep ">" silva_nr99_v138.1_train_set.fa > silva_nr99_v138.1_train_set
grep ">" silva_species_assignment_v138.1.fa > silva_species_assignment_v138.1

# zip back the sequences
gzip silva_nr99_v138.1_train_set.fa
gzip silva_species_assignment_v138.1.fa




##### ANALYSES IN RSTUDIO WITH DADA2
#sequencing came demultiplexed, without adaptors and primers, ready to use

#ORGANIZING FILES
# setup directory
setwd("/path")

# load dada
library(dada2)
library(Rcpp)

# give the path to the directory containing the fastq files after unzipping
path <- "/path"
list.files(path) #lists what is in that directory

# Get the sample names from the filenames. Forward and reverse fastq filenames have format: SAMPLENAME_R1.fastq and SAMPLENAME_R2.fastq
fnFs <- sort(list.files(path, pattern="_R1.fastq", full.names = TRUE))
fnRs <- sort(list.files(path, pattern="_R2.fastq", full.names = TRUE))
if(length(fnFs) != length(fnRs)) stop("Forward and reverse files do not match.") #check if both files match

# Extract sample names, assuming filenames have format: SAMPLENAME_XX.fastq
sample.names <- sapply(strsplit(basename(fnFs), "_"), `[`, 1)
sample.names

# QUALITY AND FILTERING
# plot all samples per quality of bases, forward
plotQualityProfile(fnFs) #save a pdf using rstudio

# plot all samples per quality of bases, reverse
plotQualityProfile(fnRs) #save a pdf using rstudio

# assign names for the filtered files, but first create folder, using the terminal, named "filtered"
filt_path <- file.path(path, "filtered") # Place filtered files in filtered/ subdirectory
filtFs <- file.path(filt_path, paste0(sample.names, "_F_filt.fastq.gz"))
filtRs <- file.path(filt_path, paste0(sample.names, "_R_filt.fastq.gz"))

# filtering
out <- filterAndTrim(fnFs, filtFs, fnRs, filtRs, truncLen=c(200,225),
                     maxN=0, maxEE=c(2,2), truncQ=2, rm.phix=TRUE, minLen=175,
                     compress=TRUE, multithread=TRUE) # On Windows set multithread=FALSE
head(out)

# plot all samples per quality of bases, forward
plotQualityProfile(filtFs)

# plot all samples per quality of bases, reverse
plotQualityProfile(filtRs)

# learning the error rates, there is no problem if it uses different data amount to estimate error
errF <- learnErrors(filtFs, multithread=TRUE)
errR <- learnErrors(filtRs, multithread=TRUE)

# plot them, you want the observed (black dots) to track well with the estimated (black line)
plotErrors(errF, nominalQ=TRUE) #save a pdf using rstudio
plotErrors(errR, nominalQ=TRUE) #save a pdf using rstudio

# dereplicate
derepFs <- derepFastq(filtFs, verbose=TRUE)
derepRs <- derepFastq(filtRs, verbose=TRUE)

# name the derep-class objects by the sample names
names(derepFs) <- sample.names
names(derepRs) <- sample.names

#Infer the sequence variants in each sample
dadaFs <- dada(derepFs, err=errF, multithread=TRUE)
dadaRs <- dada(derepRs, err=errR, multithread=TRUE)

# merge denoised paired reads
mergers <- mergePairs(dadaFs, derepFs, dadaRs, derepRs, verbose=TRUE, minOverlap=50)

# Inspect the merger data.frame from the samples 10, just random example
head(mergers[[10]])
length(mergers) # 67 elements in this list, one for each of our samples
names(mergers) # the names() function gives us the name of each element of the list 


# MAKE TABLES AND REMOVE BAD ASVS
# construct sequencing table
seqtab <- makeSequenceTable(mergers)

# The sequences being tabled vary in length, just checking
dim(seqtab)

# Inspect distribution of sequence lengths
table(nchar(getSequences(seqtab)))
#225 233 251 252 253 254 343 
#2   1   7  20 721  15   1 

# remove chimeras
seqtab.nochim <- removeBimeraDenovo(seqtab, method="consensus", multithread=TRUE, verbose=TRUE)
# result: Identified 65 bimeras out of 767 input sequences.
dim(seqtab.nochim)
# result: [1]  67 702

# Print percentage of our seqences that were not chimeric.
100*sum(seqtab.nochim)/sum(seqtab)
# [1] 99.45533

# Track reads through the pipeline, we’ll look at the number of reads that made it through each step in the pipeline:
getN <- function(x) sum(getUniques(x))
track <- cbind(out, sapply(dadaFs, getN), sapply(mergers, getN), rowSums(seqtab), rowSums(seqtab.nochim))
# If processing a single sample, remove the sapply calls: e.g. replace sapply(dadaFs, getN) with getN(dadaFs)
colnames(track) <- c("input", "filtered", "denoised", "merged", "tabled", "nonchim")
rownames(track) <- sample.names
track

# result:
input filtered denoised merged tabled nonchim
C-1               6        6        6      3      3       0
C-2              59       57       55     32     32       0
FOODSBBG2     11188     9821     9797   9623   9623    9623
FOODSBBP3     10403     9957     9949   9662   9662    9662
FOODSBBP4     29649    28675    28603  27531  27531   27309
FOODSBSC1     18878    18313    18280  17939  17939   17826
FOODSBSC2     17412    16927    16900  16486  16486   16425
FOODSDBG1      6944     6514     6501   6227   6227    6227
FOODSDBP1     19922    19266    19224  18410  18410   18410
FOODSDBP2     53026    51546    51482  49900  49900   49339
FOODSDSC1     35401    33627    33575  32633  32633   32454
FOODSDSC2     31523    30732    30681  30042  30042   29445
FORAGERSBBG1  17845    16970    16946  16627  16627   16627
FORAGERSBBG2   5411     5051     5038   4887   4887    4887
FORAGERSBBP3  20768    19641    19602  19261  19261   19201
FORAGERSBBP4  21008    20162    20117  19756  19756   19505
FORAGERSBSC1  35114    32614    32360  31361  31361   31361
FORAGERSBSC2   9583     8876     8857   8550   8550    8518
FORAGERSDBG1  25181    23229    23126  22322  22322   22279
FORAGERSDBG2  20325    18894    18809  18337  18337   18337
FORAGERSDBP1   6333     5766     5715   5629   5629    5625
FORAGERSDBP2  23014    20265    20204  19765  19765   19765
FORAGERSDSC2  12445    11613    11596  11352  11352   11352
GUARDSBBP3     9385     8379     8312   8165   8165    8165
GUARDSBSC1    13685    11672    11619  11305  11305   11305
GUARDSBSC2     2279     1947     1921   1860   1860    1860
GUARDSDBG1    11457    10129    10071   9821   9821    9821
GUARDSDSC1     9485     8285     8171   7932   7932    7932
GUARDSDSC2    12540    10818    10756  10467  10467   10467
HONEYSBBG1    21455    20740    20665  19960  19960   19851
HONEYSBBG2    30032    29078    28979  28295  28295   27813
HONEYSBBP3    25748    24286    24191  23711  23711   23666
HONEYSBBP4    35621    34350    34127  33336  33336   33152
HONEYSBSC1    37224    35946    35840  34948  34948   34138
HONEYSBSC2    44264    42789    42655  41410  41410   41220
HONEYSDBG1    24862    23513    23462  22921  22921   22921
HONEYSDBG2    23804    23009    22897  22347  22347   22347
HONEYSDBP1    79754    77870    77763  76126  76126   74756
HONEYSDSC1   125628   121378   120873 117010 117010  116224
HONEYSDSC2     6426     6119     6109   5905   5905    5905
LARVAE1SBBP4  23832    22876    22837  22318  22318   22204
LARVAE1SDBP2   8299     8115     8106   8067   8067    8067
LARVAE1SDBP4  19856    18558    18495  17845  17845   17745
LARVAE2SBBP4  24900    24213    24189  23812  23812   23710
LARVAESBBP2   30883    29277    29218  28700  28700   28554
LARVAESBSC2    5917     5573     5570   5460   5460    5460
LARVAESDSC1    8916     8384     8343   8023   8023    7975
NURSESBBG1    25727    24155    24086  23593  23593   23436
NURSESBBG2    26211    24669    24588  23997  23997   23936
NURSESBBP3    13397    12482    12457  11942  11942   11942
NURSESBBP4    15919    15281    15252  14947  14947   14701
NURSESBSC1    34792    32210    32159  30868  30868   30811
NURSESBSC2    15761    14683    14649  14102  14102   14102
NURSESDBG1    33603    31659    31632  30693  30693   30693
NURSESDBG2    19995    18860    18802  18376  18376   18376
NURSESDBP1    27219    25336    25294  24588  24588   24588
NURSESDBP2    27631    25700    25658  24835  24835   24695
NURSESDSC1    20039    18500    18420  17698  17698   17698
NURSESDSC2    37684    36469    36422  35889  35889   35776
POLLENSBBP2    6603     6157     6137   6018   6018    5965
POLLENSBBP3   21098    19882    19796  18746  18746   18746
POLLENSDBG1   23974    22657    22614  21637  21637   21604
POLLENSDBG2   23677    22963    22902  22069  22069   21955
POLLENSDBP1   34036    32051    32004  30799  30799   30799
POLLENSDBP2   22753    22077    22009  21269  21269   21194
POLLENSDSC1   23030    21670    21632  21318  21318   21318
POLLENSDSC2   14079    13206    13179  12947  12947   12947

# no sample removed
# asign taxonomy
taxa <- assignTaxonomy(seqtab.nochim, "/path/silva_nr99_v138.1_train_set.fa.gz", multithread=TRUE)
#species level
taxa <- addSpecies(taxa, "path/silva_species_assignment_v138.1.fa.gz")

# inspect the taxonomic assignments
taxa.print <- taxa # Removing sequence rownames for display only
rownames(taxa.print) <- NULL
head(taxa.print)

# Print output in tables
# giving our seq headers more manageable names (ASV_1, ASV_2...)
asv_seqs <- colnames(seqtab.nochim) # saves the existing column names from seqtab.nochim into a variable called asv_seqs.
asv_headers <- vector(dim(seqtab.nochim)[2], mode="character") #Creates a new empty character vector called asv_headers with the same length as the number of columns in seqtab.nochim.

#Constructs a new header string for each column, prefixing it with ">ASV_" and appending the column index i.
for (i in 1:dim(seqtab.nochim)[2]) {
  asv_headers[i] <- paste(">ASV", i, sep="_")
}

# making and writing out a fasta of our final ASV seqs: Binds the asv_headers and asv_seqs together row-wise using rbind to create a matrix. Then converts that matrix into a character vector called asv_fasta. So now asv_fasta contains the headers in the first elements, followed by the sequences. This creates the proper FASTA structure.
asv_fasta <- c(rbind(asv_headers, asv_seqs))
write(asv_fasta, "ASVs.fa")

# count table:
asv_tab <- t(seqtab.nochim) #Transposes the count data matrix seqtab.nochim, saving the result into asv_tab. This makes the samples the rows rather than columns.
row.names(asv_tab) <- sub(">", "", asv_headers) #Sets the row names of asv_tab to be the ASV headers without the ">" symbol. This nicely labels each row with the corresponding ASV name.
write.table(asv_tab, "ASVs_counts.tsv", sep="\t", quote=F, col.names=NA) #Writes the transposed count data to a file called "ASVs_counts.tsv". The options tell it to separate columns with tabs rather than commas, not wrap columns in quotes, and not write an additional column for row names (since we formatted the row names directly).

# taxa table
write.csv(taxa.print, file = "ASVs_taxonomy.csv", row.names = FALSE) 
#I had to add manually ASV_1.. in the file, the taxa are in order of the ASVs.
asv_tax <- read.csv("ASVs_taxonomy.csv", header = TRUE, row.names = 1)
asv_tax


#### REMOVING CONTAMINANTS FROM CONTROLS - NO NEED HERE, NO CONTAMINANTS DETECTED
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
#BiocManager::install("decontam")
library(decontam)
packageVersion("decontam")

colnames(asv_tab) # our blanks are the first 2 samples of 52
vector_for_decontam <- c(rep(TRUE, 2), rep(FALSE, 65))

contam_df <- isContaminant(t(asv_tab), neg=vector_for_decontam)

table(contam_df$contaminant)
# I had 0 contaminants, or 0 TRUE

# getting vector holding the identified contaminant IDs
contam_asvs <- row.names(contam_df[contam_df$contaminant == TRUE, ])

asv_tax[row.names(asv_tax) %in% contam_asvs, ]
# nothing appeared because was 0

#lets say ASV_15 and 16 were contaminants
#grep -w -A1 "^>ASV_15\|^>ASV_16" ASVs.fa

# making new fasta file
contam_indices <- which(asv_fasta %in% paste0(">", contam_asvs))
dont_want <- sort(c(contam_indices, contam_indices + 1))
asv_fasta_no_contam <- asv_fasta[- dont_want]

# making new count table
asv_tab_no_contam <- asv_tab[!row.names(asv_tab) %in% contam_asvs, ]

# making new taxonomy table
asv_tax_no_contam <- asv_tax[!row.names(asv_tax) %in% contam_asvs, ]
asv_tab_no_contam
## and now writing them out to files
write(asv_fasta_no_contam, "ASVs-no-contam.fa") # didnt work! clean mannualy
write.table(asv_tab_no_contam, "ASVs_counts-no-contam.tsv", sep="\t", quote=F, col.names=NA)
write.table(asv_tax_no_contam, "ASVs_taxonomy-no-contam.tsv", sep="\t", quote=F, col.names=NA)

# delete the no_contam because its just the same as the original
# I didnt remove because the controls were 0, so I still have the same previous files


# remove mitochondria mannually from the file
ASV_164
ASV_183
ASV_206
ASV_276
ASV_404
ASV_421
ASV_650
ASV_690

# and chloroplast
ASV_77
ASV_78
ASV_114