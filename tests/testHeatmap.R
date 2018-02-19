################ With real data ################ 
nInd=10
data <- readRDS("../data/merged_sub.Rds")

# Find disease for each person
dataDisease <- data %>% select(Individual, Disease) %>% unique()
dataDisease$Order = 1:nrow(dataDisease)
dataOrder <- dataDisease %>% arrange(Disease)
diseaseOrder = dataOrder$Order

data <- data %>% select(Individual, Heterozygous.SNP)
data <- separate_rows(data, Heterozygous.SNP) %>% filter(Heterozygous.SNP!="")
data2 <- data %>% group_by(Individual, Heterozygous.SNP) %>% mutate(count = n()) %>% arrange(Heterozygous.SNP)
data3 <- data2 %>% unique()

un <- unique(data3$Heterozygous.SNP)

dataAdd <- data.frame(Individual = paste0("Individual",rep(1:nInd, each=length(un))), Heterozygous.SNP = unique(data3$Heterozygous.SNP), count = rep(0, nInd*length(un)))
dataFull = rbind(as.data.frame(data3), as.data.frame(dataAdd))
dataFinal <- as.data.frame(table(data)) %>% arrange(Heterozygous.SNP) %>% filter(Individual!="Characteristics[individual]")

dataBox = dcast(data = dataFinal,formula = Heterozygous.SNP~Individual,fun.aggregate = sum,value.var = "Freq")

# Make Heatmap with SNPs on y-axis, individual on x-axis, and SNP count as color
# X-axis is ordered with 6 normal individuals first, then 4 individuals with disease
heatData = dataBox
rownames(heatData) = dataBox$Heterozygous.SNP
heatData = heatData[2:ncol(heatData)]
heatData = heatData[diseaseOrder]
heatData <- data.matrix(heatData)

conditions.text <- paste0("Individual: ", rep(colnames(heatData),nrow(heatData)),  " | SNP: ", rep(rownames(heatData),each=ncol(heatData)), " | Count: ", t(heatData))
conditions.text <- matrix(unlist(conditions.text), ncol = 10, byrow = TRUE)

plot_ly(x = colnames(heatData), y = paste0("SNP", rownames(heatData)), z = heatData, type = "heatmap", hoverinfo='text', text=conditions.text)

# Make log Heatmap
plot_ly(x = colnames(heatData), y = paste0("SNP", rownames(heatData)), z = log(heatData+1), type = "heatmap", hoverinfo='text', text=conditions.text)

#################################################################
############ Make boxplots and parallel coordinate plots ########
dataBox2 = dataBox
# Choose log, normalize (divide by column sums), or standardize
# Log
dataBox2[,-1] = log(dataBox[,-1]+1)

# Divide by column sums
#dataBox2[2:11] = dataBox[2:11]/colSums(dataBox[2:11])

#Standardize
#dataBox2 = t(apply(as.matrix(dataBox[,2:ncol(dataBox)]), 1, scale))
#dataBox2 <- as.data.frame(dataBox2)
#colnames(dataBox2) <- colnames(dataBox[2:ncol(dataBox)])
#dataBox2$Heterozygous.SNP <- dataBox$Heterozygous.SNP

pcpDat <- melt(dataBox2, id.vars="Heterozygous.SNP")
colnames(pcpDat) <- c("Heterozygous.SNP", "Individual", "Freq")
pcpDat$Individual <- as.character(pcpDat$Individual)

ggplot(pcpDat, aes_string(x = 'Individual', y = 'Freq')) + geom_boxplot() + geom_line(data=pcpDat, aes_string(x = 'Individual', y = 'Freq', group = 'Heterozygous.SNP'), alpha=0.2) + xlab(paste("Individual")) + ylab("Freq")

################################################
################ With fake data ################
set.seed(1)
nInd = 10
nVal = 50

data <- data.frame(Individual = paste0("Individual",rep(1:nInd, each=nVal)), Element = sample(letters, nInd*nVal, replace = TRUE))
data2 <- data %>% group_by(Individual, Element) %>% mutate(count = n()) %>% arrange(Element)
data3 <- data2 %>% unique()

un <- unique(data3$Element)

dataAdd <- data.frame(Individual = paste0("Individual",rep(1:nInd, each=length(un))), Element = unique(data3$Element), count = rep(0, nInd*length(un)))
dataFull = rbind(as.data.frame(data3), as.data.frame(dataAdd))
dataFinal <- as.data.frame(table(data)) %>% arrange(Element)