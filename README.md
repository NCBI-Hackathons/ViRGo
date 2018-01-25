# ViRGo: Variant Report Generator 

See our live demo from [here](https://hsiaoyi0504.shinyapps.io/virgo/) !

## Introduction   
This project is mainly based on combining result files generated from [SC3](https://github.com/NCBI-Hackathons/SC3), which is a previous product of NCBI Hackathons. SC3 is based on [PSST](https://github.com/NCBI-Hackathons/PSST), which also a product of previous NCBI Hackathon. SC3 takes bioproject and disease name as inputs and has the functionality to map each SRA experiment in that Bioproject to SNP information gathered from NCBI ClinVar. We implemented a customized version of  [SC3](https://github.com/hsiaoyi0504/SC3) to make it operate normally on Ubuntu without SLURM workload manager. We map the single cell RNA-seq data (NCBI  Bioproject accession, PRJEB15401 and EMBL-EBI ArrayExpress E-MTAB-5061) using SC3 to relate   
  
## What's the problem?
A single individual can process up to 3M SNV and up to 3000 private SNV most of which are normal variants and are benign.   Thus identifying the causal variant can be difficult.
  
## What is ViRGo?
Variant Report Generator (ViRGo) is a reporting and variant browser tools that aggregate information from an RNAseq variant calling pipeline and provide summary and statistics of attributes including individual/sample, phenotype, and variant information to aid in the assessment of biologically relevant variants. It's mainly built on top of an awesome R package [Shiny](https://shiny.rstudio.com/).
  
## How to use ViRGo
1. Download this repo: `git clone --recursive https://github.com/NCBI-Hackathons/ViRGo`
2. Collecting output files generated beforehand: `python3 collect_output.py`
3. Follow the steps in [MergeTwoFiles.Rmd](MergeTwoFiles.Rmd) to generate the [m1.Rds](m1.Rds)
4. run [Visualize.R](Visualize.R) as a shiny app.

## Dependencies
* Python 3
* R
  * packages:
    * shiny
    * tidyr
    * ggplot2
    * plotly
    * dplyr
    * DT
## Presentation
* [1/22 two page slides](./presentation/Presentation_012218.pptx)
* [1/23 four page slides](https://docs.google.com/presentation/d/1YjBH5frG3v0PLQ3x3KwyDh3pNva85L7tBzYqLTyb7h0/edit#slide=id.p)
  
## Notes
* [E-MTAB-5061.sdrf.txt](E-MTAB-5061.sdrf.txt) is from [ArrayExpress](https://www.ebi.ac.uk/arrayexpress/experiments/E-MTAB-5061/).
* Based on output files of a [customized version](https://github.com/hsiaoyi0504/SC3) of [SC3](https://github.com/NCBI-Hackathons/SC3), which is a product of previous NCBI Hackathon.
* [collect_output.py](collect_output.py) is for merging files generated from [SC3]((https://github.com/hsiaoyi0504/SC3)).
* [m1_sub.Rds](m1_sub.Rds), [m1.Rds](m1.Rds) is file genreated by [MergeTwoFiles.Rmd](MergeTwoFiles.Rmd)
