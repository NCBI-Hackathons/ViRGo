# Calculations for hetero- and homo-zygous SNPs

dat <- m1_sub %>% filter(Cell=="delta cell") %>% select(Homozygous.SNP)
table(unlist(dat))

datFullHomo <- m1_sub %>% select(Homozygous.SNP)
table(unlist(datFullHomo)) # 175 unique homozygous (5053 total)

datFullHet <- m1_sub %>% select(Heterozygous.SNP)
table(unlist(datFullHet)) # 25 unique homozygous (299 total)
