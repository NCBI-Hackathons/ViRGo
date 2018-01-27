#This script will merge the SRA files from the diabetes.data and add.samp.meta dataframes.
# Read in add.samp.meta file
library(dplyr)

# E-MTAB-5061.sdrf.txt is created in SC3 pipeline
add.samp.meta.read <- read.table(file = "E-MTAB-5061.sdrf.txt", sep = "\t")
add.samp.meta <- add.samp.meta.read[2:dim(add.samp.meta.read)[1],]
for (i in 1:39){
  colnames(add.samp.meta)[i] <- as.character(add.samp.meta.read[1,i])
}
rownames(add.samp.meta) <- add.samp.meta$`Comment[ENA_RUN]`
add.samp.meta <- data.frame(add.samp.meta, 'name' = rownames(add.samp.meta))

# Read in diabetes.data file
diabetes.data <- read.csv("diabetes.csv")

# Check merging columns on SRA are identical 
identical(labels(diabetes.data$SRA), labels(add.samp.meta$Comment.ENA_RUN.))

# Merge the two files together by SRA
merged <- merge(add.samp.meta, diabetes.data, by.x = "Comment.ENA_RUN.", by.y = "SRA")

# Save merged data
saveRDS(merged,"merged.Rds")

# Take subset of columns from merged data frame
merged_sub <- merged %>% select(Characteristics.organism., Characteristics.organism.part., Characteristics.individual., Characteristics.single.cell.well.quality., Factor.Value.cell.type., Characteristics.sex., Characteristics.age., Characteristics.body.mass.index., Factor.Value.disease., Heterozygous.SNPs, Homozygous.SNPs)
colnames(merged_sub) <- c("Organism", "OrganismPart", "Individual", "Quality", "Cell", "Sex", "Age", "BMI", "Disease", "Heterozygous.SNP", "Homozygous.SNP")

# Saved merged and subsetted data
saveRDS(merged_sub, "merged_sub.Rds")
