# Calculations for hetero- and homo-zygous SNPs
m1_sub <- readRDS("m1_sub.Rds")

datFullHomo <- m1_sub %>% select(Homozygous.SNP)
table(unlist(datFullHomo)) # 175 unique homozygous (5053 total)

datFullHet <- m1_sub %>% select(Heterozygous.SNP)
table(unlist(datFullHet)) # 25 unique homozygous (299 total)

uniqHomo <- unique(unlist(datFullHomo))
uniqHet <- unique(unlist(datFullHet))

# Check if there are any overlaps between homozygote and heterozygote SNPs
intersect(uniqHomo, uniqHet)



m1_sub <- readRDS("m1_sub.Rds")
dat <- m1_sub %>% filter(Cell=="acinar cell") %>% select(Homozygous.SNP, Disease)

dat2 <- separate_rows(dat, Homozygous.SNP)

# Remove rows with no SNP information
dat2 <- dat2 %>% filter(Homozygous.SNP!="")

#dat2 <- as.data.frame(table(unlist(dat)))
#dat2 <- dat2 %>% arrange(desc(Freq))
#colnames(dat2) <- c("SNP", "Freq")

# Plot it out
# p <- ggplot(data = dat2, aes(x = reorder(Homozygous.SNP, -Freq), y=Freq), fill=Disease) + geom_bar(stat="identity") + labs(x = "SNP") # Can do fill=variable


p <- ggplot(dat2, aes(Homozygous.SNP)) + geom_bar(aes(fill=Disease)) #works

ggplotly(p)
