# Calculations for hetero- and homo-zygous SNPs
m1_sub <- readRDS("m1_sub.Rds")

datFullHomo <- m1_sub %>% select(Homozygous.SNP)
table(unlist(datFullHomo)) # 175 unique homozygous (5053 total)

datFullHet <- m1_sub %>% select(Heterozygous.SNP)
table(unlist(datFullHet)) # 25 unique heterozygous (299 total)

uniqHomo <- unique(unlist(datFullHomo))
uniqHet <- unique(unlist(datFullHet))

# Check if there are any overlaps between homozygote and heterozygote SNPs
intersect(uniqHomo, uniqHet)


###########################

m1_sub <- readRDS("m1_sub.Rds")
dat <- m1_sub %>% filter(Individual=="AZ" & Cell %in% c("alpha cell", "beta cell", "gamma cell")) %>% select(-Heterozygous.SNP, Disease)

dat2 <- separate_rows(dat, Homozygous.SNP) %>% filter(Homozygous.SNP!="")

p <- ggplot(dat2, aes(Homozygous.SNP)) + geom_bar(aes(fill=Cell)) #works

ggplotly(p)
