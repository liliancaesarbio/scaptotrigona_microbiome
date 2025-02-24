
#### ITS with DADA2 in RSSTUDIO

# ORGANIZING FILES FOR THE ANALYSES, OUTSIDE RSTUDIO

# samples
C-1_R1.fastq
C-2_R1.fastq
C-3_R1.fastq
FOODSBBG2_R1.fastq
FOODSBBP3_R1.fastq
FOODSBBP4_R1.fastq
FOODSBSC1_R1.fastq
FOODSBSC2_R1.fastq
FOODSDBP1_R1.fastq
FOODSDBP2_R1.fastq
FOODSDSC1_R1.fastq
FOODSDSC2_R1.fastq
FORAGERSBBP3_R1.fastq
FORAGERSBBP4_R1.fastq
FORAGERSBSC1_R1.fastq
FORAGERSDBG1_R1.fastq
FORAGERSDSC2_R1.fastq
GUARDSBBP3_R1.fastq
GUARDSBSC2_R1.fastq
GUARDSDBG1_R1.fastq
GUARDSDSC2_R1.fastq
HONEYSBBP3_R1.fastq
HONEYSBBP4_R1.fastq
HONEYSBSC1_R1.fastq
HONEYSDBG1_R1.fastq
HONEYSDBP1_R1.fastq
HONEYSDBP3_R1.fastq
HONEYSDSC1_R1.fastq
LARVAE1SBBP4_R1.fastq
LARVAE1SDBP4_R1.fastq
LARVAE2SBBP3_R1.fastq
LARVAE2SBBP4_R1.fastq
LARVAE3SBBP4_R1.fastq
LARVAESBBG2_R1.fastq
LARVAESBBP1_R1.fastq
LARVAESBBP2_R1.fastq
LARVAESBSC1_R1.fastq
LARVAESBSC2_R1.fastq
NURSESBBG1_R1.fastq
NURSESBBP3_R1.fastq
NURSESBBP4_R1.fastq
NURSESBSC1_R1.fastq
NURSESBSC2_R1.fastq
NURSESDBG2_R1.fastq
NURSESDSC2_R1.fastq
POLLENSBBP2_R1.fastq
POLLENSBBP3_R1.fastq
POLLENSDBG1_R1.fastq
POLLENSDBG2_R1.fastq
POLLENSDBP1_R1.fastq
POLLENSDBP2_R1.fastq
POLLENSDSC1_R1.fastq
POLLENSDSC2_R1.fastq


##### ANALYSES IN RSTUDIO WITH DADA2
#sequencing came demultiplexed, without adaptors and primers, ready to use

# ORGANIZING FILES
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
plotQualityProfile(fnFs)

# plot all samples per quality of bases, reverse
plotQualityProfile(fnRs)

# assign names for the filtered files, but first create folder, using the terminal, named "filtered"
filt_path <- file.path(path, "filtered") # Place filtered files in filtered/ subdirectory
filtFs <- file.path(filt_path, paste0(sample.names, "_F_filt.fastq.gz"))
filtRs <- file.path(filt_path, paste0(sample.names, "_R_filt.fastq.gz"))

# filtering
out <- filterAndTrim(fnFs, filtFs, fnRs, filtRs, truncLen=c(190,140),
                     maxN=0, maxEE=c(2,2), truncQ=2, rm.phix=TRUE, minLen=100,
                     compress=TRUE, multithread=TRUE) # On Windows set multithread=FALSE
head(out)

# plot all samples per quality of bases
plotQualityProfile(filtFs)

# plot all samples per quality of bases
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
length(mergers) # 52 elements in this list, one for each of our samples
names(mergers) # the names() function gives us the name of each element of the list 


# MAKE TABLES AND REMOVE BAD ASVS
# construct sequencing table
seqtab <- makeSequenceTable(mergers)

# The sequences being tabled vary in length, just checking
dim(seqtab)

# Inspect distribution of sequence lengths
table(nchar(getSequences(seqtab)))
#190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 
#232   8   2   2   5   7   6   4   2   3  24  11  19  10   4  11   8  51   7   8  23  12  53   7   4   9  53  28  50   9 
#220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 248 249 250 
#7  10   7  41   8  30   8   7  11   1   4   6   9   4   6   1   4   9   7   7   6   7   3   1   6   5   4   2   4   2 
#252 253 254 255 256 257 259 260 261 262 263 264 265 266 267 270 273 274 276 277 278 
#1   2   2   3   5   2   1   1   1   1   1   3   5   1   1   1   1   1   2   1   1 


# remove chimeras
seqtab.nochim <- removeBimeraDenovo(seqtab, method="consensus", multithread=TRUE, verbose=TRUE)
# Identified 26 bimeras out of 936 input sequences.
dim(seqtab.nochim)
# result: 52 910

# Print percentage of our seqences that were not chimeric.
100*sum(seqtab.nochim)/sum(seqtab)
# 98.83334

# Track reads through the pipeline, we’ll look at the number of reads that made it through each step in the pipeline:
getN <- function(x) sum(getUniques(x))
track <- cbind(out, sapply(dadaFs, getN), sapply(mergers, getN), rowSums(seqtab), rowSums(seqtab.nochim))
# If processing a single sample, remove the sapply calls: e.g. replace sapply(dadaFs, getN) with getN(dadaFs)
colnames(track) <- c("input", "filtered", "denoised", "merged", "tabled", "nonchim")
rownames(track) <- sample.names
track

# result:
input filtered denoised merged tabled nonchim
C-1             93        3        3      0      0       0
C-2             85       38       31      5      5       5
FOODSBBG2    24719     9949     9918   7447   7447    7284
FOODSBBP3     2328     1816     1773   1350   1350    1350
FOODSBBP4    13201    11686    11596   9313   9313    9313
FOODSBSC1    15227    11722    11626   8406   8406    8406
FOODSBSC2    22897    20888    20841  15646  15646   15602
FOODSDBP1    30970    28513    28446  21934  21934   19126
FOODSDBP2     7693     5745     5667   4382   4382    4382
FOODSDSC1    24212    21638    21525  17239  17239   16356
FOODSDSC2    12700    10376    10287   8373   8373    8373
FORAGERSBBP3  2502     1716     1679   1413   1413    1413
FORAGERSBBP4  6246     5009     4964   3698   3698    3698
FORAGERSBSC1  7141     4074     4019   3292   3292    3292
FORAGERSDBG1  4172     2967     2913   2328   2328    2328
FORAGERSDSC2  4170     2445     2410   2082   2082    2082
GUARDSBBP3    9757     7302     7244   5327   5327    5327
GUARDSBSC2    3949     2664     2641   2213   2213    2213
GUARDSDBG1   13579    11387    11335  10749  10749   10749
GUARDSDSC2   28568    26165    26050  21885  21885   21885
HONEYSBBP3   27348    25027    24932  23077  23077   23077
HONEYSBBP4   15295    10243    10062   7232   7232    7232
HONEYSBSC1   25671    23543    23484  23262  23262   23262
HONEYSDBG1    8504     7166     7053   4568   4568    4568
HONEYSDBP1   19701    17107    16963  14327  14327   14327
HONEYSDBP3   14284    11534    11341   9640   9640    9640
HONEYSDSC1   20007    14536    14348  12681  12681   12681
LARVAE1SBBP4 38187    34201    34049  32003  32003   31689
LARVAE1SDBP4  3552     2798     2794   2557   2557    2557
LARVAE2SBBP3 10100     7516     7468   6231   6231    6231
LARVAE2SBBP4 31065    28300    28240  27212  27212   26863
LARVAE3SBBP4 20896    18999    18975  14519  14519   14451
LARVAESBBG2  13266    12030    12015  10193  10193    9915
LARVAESBBP1  13915     9724     9709   7908   7908    7908
LARVAESBBP2  23366    21782    21759  20213  20213   19927
LARVAESBSC1  19819     6719     6692   4832   4832    4832
LARVAESBSC2  23150    20106    20063  15271  15271   15231
NURSESBBG1    3985     1302     1268    943    943     943
NURSESBBP3    6991     5535     5496   4315   4315    4315
NURSESBBP4    5516     2382     2345   1907   1907    1907
NURSESBSC1    5738     2451     2411   1881   1881    1881
NURSESBSC2    2126     1265     1240   1125   1125    1125
NURSESDBG2    7117     4133     4111   2252   2252    2252
NURSESDSC2    3311     1339     1321    898    898     898
POLLENSBBP2   1289      749      734    588    588     588
POLLENSBBP3   9723     4803     4682   3553   3553    3553
POLLENSDBG1  12753    10561    10466   9916   9916    9916
POLLENSDBG2  15217    10998    10841   9670   9670    9670
POLLENSDBP1  16643    13888    13677  12839  12839   12839
POLLENSDBP2   1895     1453     1442   1306   1306    1306
POLLENSDSC1  10204     7038     6955   5884   5884    5884
POLLENSDSC2  14659    12496    12407   8660   8660    8660

# asign taxonomy
# download UNITE, had to be with red becase need to add email to download
https://doi.plutof.ut.ee/doi/10.15156/BIO/2938067
# assign
taxa <- assignTaxonomy(seqtab.nochim, "path/sh_general_release_dynamic_25.07.2023.fasta.gz", multithread=TRUE)

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