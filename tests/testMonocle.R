# First download from biocLite
library(HSMMSingleCell)
library(monocle)
library(reshape2)
library(dplyr)

# Three file types are needed.
# Examples are hosted as .rda files in HSMMSingleCell package
# Example has 271 cells, 47192 genes, 7 cell attributes (library, well, hours, media, mapped fragments, pseudotime, state), 4 gene attributes (gene short name, biotype, number of cells expressed, use for ordering)

#1 - Expression values with rows as genes and columns as cells
data("HSMM_expr_matrix")
#2 - Rows as cells, columns as cell attributes (cell type, day captured, etc.)
data("HSMM_sample_sheet")
#3 - Rows as genes, columns as gene attributes (biotype, gc content, etc.)
data("HSMM_gene_annotation")

# Once these three tables are loaded, can create CellDataSet object
pd <- new("AnnotatedDataFrame", data = HSMM_sample_sheet)
fd <- new("AnnotatedDataFrame", data = HSMM_gene_annotation)

# If have FPKM/TPM values use log-normally distributed; if have UMIs or read counts use negative binomial. Recommend making the matrix sparse.
HSMM <- newCellDataSet(as(HSMM_expr_matrix, "sparseMatrix"),
                       phenoData = pd,
                       featureData = fd,
                       expressionFamily=negbinomial.size())

HSMM <- estimateSizeFactors(HSMM)
HSMM <- estimateDispersions(HSMM)

# Filter low quality genes
HSMM <- detectGenes(HSMM, min_expr = 0.1)
print(head(fData(HSMM)))
# Reduces number of genes from 47192 to 16725
expressed_genes <- row.names(subset(fData(HSMM), num_cells_expressed >= 10))
# CellDataSet objects provide a convenient place to store per-cell scoring data: the phenoData slot. You can include scoring attributes as columns in the data frome you used to create your CellDataSet container. The HSMM dataset included with this package has scoring columns built in.
print(head(pData(HSMM)))

# If you are using RPC values to measure expresion, as we are in this vignette, it’s also good to look at the distribution of mRNA totals across the cells.
pData(HSMM)$Total_mRNAs <- Matrix::colSums(exprs(HSMM))
HSMM <- HSMM[,pData(HSMM)$Total_mRNAs < 1e6]
upper_bound <- 10^(mean(log10(pData(HSMM)$Total_mRNAs)) + 2*sd(log10(pData(HSMM)$Total_mRNAs)))
lower_bound <- 10^(mean(log10(pData(HSMM)$Total_mRNAs)) - 2*sd(log10(pData(HSMM)$Total_mRNAs)))
qplot(Total_mRNAs, data=pData(HSMM), color=Hours, geom="density") +
  geom_vline(xintercept=lower_bound) +
  geom_vline(xintercept=upper_bound)

# Classify and count cells of different types
MYF5_id <- row.names(subset(fData(HSMM), gene_short_name == "MYF5"))
ANPEP_id <- row.names(subset(fData(HSMM), gene_short_name == "ANPEP"))
cth <- newCellTypeHierarchy()
cth <- addCellType(cth, "Myoblast", classify_func=function(x) {x[MYF5_id,] >= 1})
cth <- addCellType(cth, "Fibroblast", classify_func=function(x) {x[MYF5_id,] < 1 & x[ANPEP_id,] > 1})
HSMM <- classifyCells(HSMM, cth, 0.1)
table(pData(HSMM)$CellType)

pie <- ggplot(pData(HSMM), aes(x = factor(1), fill = factor(CellType))) + geom_bar(width = 1)
pie + coord_polar(theta = "y") + theme(axis.title.x=element_blank(), axis.title.y=element_blank())

# Remove the few cells with either very low mRNA recovery or far more mRNA that the typical cell. Often, doublets or triplets have roughly twice the mRNA recovered as true single cells, so the latter filter is another means of excluding all but single cells from the analysis. Such filtering is handy if your protocol doesn’t allow directly visualization of cell after they’ve been captured
HSMM <- HSMM[,pData(HSMM)$Total_mRNAs > lower_bound & pData(HSMM)$Total_mRNAs < upper_bound]
HSMM <- detectGenes(HSMM, min_expr = 0.1)

# Check that expression values in CellDataSet are roughly lognormal
L <- log(exprs(HSMM[expressed_genes,]))
# Standardize each gene, so that they are all on the same scale
melted_dens_df <- melt(Matrix::t(scale(Matrix::t(L))))
qplot(value, geom="density", data=melted_dens_df) +
  stat_function(fun = dnorm, size=0.5, color='red') +
  xlab("Standardized log(FPKM)") +
  ylab("Density")

# Unsupervised cell clustering
# Only used genes with high expression to avoid too much noise
disp_table <- dispersionTable(HSMM)
unsup_clustering_genes <- subset(disp_table, mean_expression >= 0.1)
HSMM <- setOrderingFilter(HSMM, unsup_clustering_genes$gene_id)
plot_ordering_genes(HSMM)
plot_pc_variance_explained(HSMM, return_all = F)

# Cluster by cell type
HSMM <- reduceDimension(HSMM, max_components=2, num_dim = 6, reduction_method = 'tSNE', verbose = T)
HSMM <- clusterCells(HSMM, num_clusters=2)
plot_cell_clusters(HSMM, 1, 2, color="CellType", markers=c("MYF5", "ANPEP"))

# Cluster by culture
plot_cell_clusters(HSMM, 1, 2, color="Media")

# Keep onlyi myoblasts
HSMM_myo <- HSMM[,pData(HSMM)$CellType == "Myoblast"]
HSMM_myo <- estimateDispersions(HSMM_myo)

# Find all genes that are differentially expressed in response to the switch from growth medium to differentiation medium
diff_test_res <- differentialGeneTest(HSMM_myo[expressed_genes,], fullModelFormulaStr="~Media")
ordering_genes <- row.names(subset(diff_test_res, qval < 0.01))

# Select genes with high dispersion
disp_table <- dispersionTable(HSMM_myo)
ordering_genes <- subset(disp_table,
                         mean_expression >= 0.5 &
                           dispersion_empirical >= 1 * dispersion_fit)$gene_id

HSMM_myo <- setOrderingFilter(HSMM_myo, ordering_genes)
plot_ordering_genes(HSMM_myo)

HSMM_myo <- reduceDimension(HSMM_myo, max_components=2)
HSMM_myo <- orderCells(HSMM_myo)
plot_cell_trajectory(HSMM_myo, color_by="Hours")
plot_cell_trajectory(HSMM_myo, color_by="State")











