data <- readRDS("m1_sub.Rds")
data2 <- separate_rows(data, Homozygous.SNP) %>% filter(Homozygous.SNP!="")
homoSNP <- unique(data2$Homozygous.SNP) #175 unique

data3 <- separate_rows(data, Heterozygous.SNP) %>% filter(Heterozygous.SNP!="")
heterSNP <- unique(data3$Heterozygous.SNP) # 25 unique

uniqSNP <- unique(c(homoSNP, heterSNP)) # 189 unique
