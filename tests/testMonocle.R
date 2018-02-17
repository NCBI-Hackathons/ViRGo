
library("HSMMSingleCell")
library("monocle")

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



