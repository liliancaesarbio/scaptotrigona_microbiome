# ALPHA DIV
ibrary(vegan)data <- read.csv("16S_ASVs_beta_alpha.csv", header = TRUE, sep = ",", row.names = 1)data#input need to be a matrix, rows sample, columns taxadata_richness <- estimateR(data)   data_richness# evenessdata_evenness <- diversity(data) / log(specnumber(data))data_evenness# diversitydata_shannon <- diversity(data, index = "shannon")data_shannon#combinedata_alphadiv <- cbind(t(data_richness), data_shannon, data_evenness)rm(data_richness, data_evenness, data_shannon)  data_alphadiv# transpose and save out, then manually substitute NA by 0write.table(data_alphadiv, file = "16S_alphadiv.csv", row.names = TRUE, sep = ",", quote = FALSE)

# edit adding sample info to it

data = read.table("16S_alphadiv.csv", header=TRUE, sep = ",")
data

# order
data$species <- factor(data$species, levels=c("SD", "SB"))
data$local <- factor(data$local, levels=c("BP", "BG", "SC"))
data$type <- factor(data$type, levels=c("POLLEN", "HONEY", "FOOD", "LARVAE", "NURSE", "FORAGER", "GUARD"))

ggplot(data, aes(x=type, y= richness, fill = type)) + 
  geom_boxplot(position = position_dodge2(preserve = "single")) +
  theme_classic()+
  scale_fill_manual(values = c("#226160", "#a95f4d", "#d0a465", "#80a5cc", "#c1cfbb", "#8571b8", "#CC99BC")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("16S_rich.pdf", width = 10, height = 10, units = "cm", limitsize = FALSE)
dev.off()

ggplot(data, aes(x=type, y= shannon_index, fill = type)) + 
  geom_boxplot(position = position_dodge2(preserve = "single")) +
  theme_classic()+
  scale_fill_manual(values = c("#226160", "#a95f4d", "#d0a465", "#80a5cc", "#c1cfbb", "#8571b8", "#CC99BC")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("16S_shan.pdf", width = 10, height = 10, units = "cm", limitsize = FALSE)
dev.off()

ggplot(data, aes(x = type, y = evenness, fill = type)) + 
  geom_boxplot(position = position_dodge2(preserve = "single")) +
  theme_classic() +
  scale_fill_manual(values = c("#226160", "#a95f4d", "#d0a465", "#80a5cc", "#c1cfbb", "#8571b8", "#CC99BC")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("16S_even.pdf", width = 10, height = 10, units = "cm", limitsize = FALSE)
dev.off()


data = read.table("ITS_alphadiv.csv", header=TRUE, sep = ",")
data

# order
data$species <- factor(data$species, levels=c("SD", "SB"))
data$local <- factor(data$local, levels=c("BP", "BG", "SC"))
data$type <- factor(data$type, levels=c("POLLEN", "HONEY", "FOOD", "LARVAE", "NURSE", "FORAGER", "GUARD"))

ggplot(data, aes(x=type, y= richness, fill = type)) + 
  geom_boxplot(position = position_dodge2(preserve = "single")) +
  theme_classic()+
  scale_fill_manual(values = c("#226160", "#a95f4d", "#d0a465", "#80a5cc", "#c1cfbb", "#8571b8", "#CC99BC")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("ITS_rich.pdf", width = 10, height = 10, units = "cm", limitsize = FALSE)
dev.off()

ggplot(data, aes(x=type, y= shannon_index, fill = type)) + 
  geom_boxplot(position = position_dodge2(preserve = "single")) +
  theme_classic()+
  scale_fill_manual(values = c("#226160", "#a95f4d", "#d0a465", "#80a5cc", "#c1cfbb", "#8571b8", "#CC99BC")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("ITS_shan.pdf", width = 10, height = 10, units = "cm", limitsize = FALSE)
dev.off()

ggplot(data, aes(x = type, y = evenness, fill = type)) + 
  geom_boxplot(position = position_dodge2(preserve = "single")) +
  theme_classic() +
  scale_fill_manual(values = c("#226160", "#a95f4d", "#d0a465", "#80a5cc", "#c1cfbb", "#8571b8", "#CC99BC")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("ITS_even.pdf", width = 10, height = 10, units = "cm", limitsize = FALSE)
dev.off()







# BETA DIV
# NMDS
# Read the input CSV file
species_data <- read.csv("16S_perman_nmds.csv", header = TRUE)
species_data
numeric_species_data <- species_data[, -1]
numeric_species_data
sample_info <- read.csv("16S_sample_info.csv", header = TRUE)
sample_info

# bray-curtys matrix
distance_matrix <- vegdist(numeric_species_data, method = "bray")

library(ggplot2)
library(vegan)
nmds = metaMDS(numeric_species_data, distance = "bray")
nmds
plot(nmds)

#extract NMDS scores (x and y coordinates) for sites from newer versions of vegan package
data.scores = as.data.frame(scores(nmds)$sites)
data.scores

#add columns to data frame 
data.scores$type = sample_info$type
data.scores$species = sample_info$species
data.scores$local = sample_info$local
data.scores$sample = sample_info$sample
head(data.scores)

# plot
data.scores$type <- factor(data.scores$type, levels=c("POLLEN", "HONEY", "FOOD", "LARVAE", "NURSE", "FORAGER", "GUARD"))

# plot
ggplot(data.scores, aes(x = NMDS1, y = NMDS2)) + 
  geom_point(size = 4, aes( shape = species, colour = type))+ 
  theme(axis.text.y = element_text(colour = "black", size = 12), 
        axis.text.x = element_text(colour = "black", size = 12), 
        legend.text = element_text(size = 12, colour ="black"), 
        legend.position = "right", axis.title.y = element_text(size = 14), 
        axis.title.x = element_text(size = 14, colour = "black"), 
        legend.title = element_text(size = 14, colour = "black"), 
        panel.background = element_blank(), panel.border = element_rect(colour = "black", fill = NA, size = 1.2),
        legend.key=element_blank()) + 
  labs(x = "NMDS1", colour = "Part", y = "NMDS2", shape = "Species")+
  scale_colour_manual(values = c("#226160","#a95f4d", "#d0a465", "#80a5cc", "#c1cfbb","#8571b8","#CC99BC"))
ggsave("16S_bray_nmds.pdf", width = 18, height = 12, units = "cm", limitsize = FALSE)
dev.off()


# Read the input CSV file
species_data <- read.csv("ITS_perman_nmds.csv", header = TRUE)
species_data
numeric_species_data <- species_data[, -1]
numeric_species_data
sample_info <- read.csv("ITS_sample_info.csv", header = TRUE)
sample_info

# bray-curtys matrix
distance_matrix <- vegdist(numeric_species_data, method = "bray")

library(ggplot2)
library(vegan)
nmds = metaMDS(numeric_species_data, distance = "bray")
nmds
plot(nmds)

#extract NMDS scores (x and y coordinates) for sites from newer versions of vegan package
data.scores = as.data.frame(scores(nmds)$sites)
data.scores

#add columns to data frame 
data.scores$type = sample_info$type
data.scores$species = sample_info$species
data.scores$local = sample_info$local
data.scores$sample = sample_info$sample
head(data.scores)

# plot
data.scores$type <- factor(data.scores$type, levels=c("POLLEN", "HONEY", "FOOD", "LARVAE", "NURSE", "FORAGER", "GUARD"))

# plot
ggplot(data.scores, aes(x = NMDS1, y = NMDS2)) + 
  geom_point(size = 4, aes( shape = species, colour = type))+ 
  theme(axis.text.y = element_text(colour = "black", size = 12), 
        axis.text.x = element_text(colour = "black", size = 12), 
        legend.text = element_text(size = 12, colour ="black"), 
        legend.position = "right", axis.title.y = element_text(size = 14), 
        axis.title.x = element_text(size = 14, colour = "black"), 
        legend.title = element_text(size = 14, colour = "black"), 
        panel.background = element_blank(), panel.border = element_rect(colour = "black", fill = NA, size = 1.2),
        legend.key=element_blank()) + 
  labs(x = "NMDS1", colour = "Part", y = "NMDS2", shape = "Species")+
  scale_colour_manual(values = c("#226160","#a95f4d", "#d0a465", "#80a5cc", "#c1cfbb","#8571b8","#CC99BC"))
ggsave("ITS_bray_nmds.pdf", width = 18, height = 12, units = "cm", limitsize = FALSE)
dev.off()




# BARPLOT
library(ggplot2)

#import
data <- read.csv("16S_barplot.csv",  header = TRUE)
data

# order
data$species <- factor(data$species, levels=c("SD", "SB"))
data$type <- factor(data$type, levels=c("POLLEN", "HONEY", "FOOD", "LARVAE", "NURSE", "FORAGER", "GUARD"))

# create pallete
colours = c("white", "#4b86b4","#63ace5","#1919b9","#80a5cc","#b04c15", "#d0a465","#f8ae36", "#a95f4d","#f3c68f", "#272945", "#d49cb4","#8571b8","#ce4993","#6a0d83","#36802d","#798e72","#c1cfbb", "#226160","#84b369")

# plot  
ggplot() + geom_bar(aes(y = counts, x = sample, fill = taxa), data = data, stat="identity", position = "fill")+
  theme_classic() + scale_fill_manual(values = colours)+
  facet_grid(. ~ type, scales="free", space = "free")+
  theme(axis.text.x = element_text(angle = 60, hjust = 1, colour = "black"), axis.text.y = element_text(colour = "black") )+
  labs(y = "Relative abundance")
ggsave("16s_barplot.pdf", width = 20, height = 10, units = "cm", limitsize = FALSE)

dev.off()

library(ggplot2)

#import
data <- read.csv("ITS_barplot.csv",  header = TRUE)
data

# order
data$species <- factor(data$species, levels=c("SD", "SB"))
data$type <- factor(data$type, levels=c("POLLEN", "HONEY", "FOOD", "LARVAE", "NURSE", "FORAGER", "GUARD"))

# create pallete
colours = c("white","#63ace5","#4b86b4","#80a5cc","#b04c15", "#d0a465","#f8ae36", "#a95f4d","#f3c68f", "#d49cb4","#8571b8","#ce4993","#6a0d83","#272945","#798e72","#c1cfbb", "#226160","#84b369")

# plot  
ggplot() + geom_bar(aes(y = counts, x = sample, fill = taxa), data = data, stat="identity", position = "fill")+
  theme_classic() + scale_fill_manual(values = colours)+
  facet_grid(. ~ type, scales="free", space = "free")+
  theme(axis.text.x = element_text(angle = 60, hjust = 1, colour = "black"), axis.text.y = element_text(colour = "black") )+
  labs(y = "Relative abundance")
ggsave("ITs_barplot.pdf", width = 20, height = 10, units = "cm", limitsize = FALSE)

dev.off()





# BASIC STATS, change factors to be testeddata = read.table("16S_alphadiv.csv", header=TRUE, sep = ",")data### normality test (significant < 0.05 need to be normalized or run non-parametric test)(shapiro.test(data$evenness))# parametric### t test (2 variables)t.test(shannon_index ~ species, var.equal=T, data = data)### ANOVA (>2 variables)aov_model <- aov(shannon_index ~ type*local, data = data)summary(aov_model)# non parametric#### Wilcoxon (2 variables)wilcox.test(evenness ~ species, data = data)### Kruskal-Wallis (> 2 variables)kruskal.test(evenness ~ type, data = data)kruskal.test(evenness ~ local, data = data)# parwise testpairwise.wilcox.test(data$shannon_index, data$type, p.adjust.method = "BH")



# PERMANOVA, change factors to be tested
# Read the input CSV filespecies_data <- read.csv("16S_perman_nmds.csv", header = TRUE)species_datanumeric_species_data <- species_data[, -1]numeric_species_datasample_info <- read.csv("16S_sample_info.csv", header = TRUE)sample_info# bray-curtys matrixdistance_matrix <- vegdist(numeric_species_data, method = "bray")# Run PERMANOVAresult <- adonis2(distance_matrix ~ species * local, data = sample_info, permutations = 999)# View the resultprint(result)
