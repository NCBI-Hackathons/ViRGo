# SCRVV
Single Cell RNA Variant Viewer

## Dependencies
* Python 3

## Qucik Start
* Download this repo: `git clone --recursive https://github.com/NCBI-Hackathons/SCRVV`
* Collecting output files generated beforehand: `python3 collect_output.py`
* Follow the steps in [MergeTwoFiles.Rmd](MergeTwoFiles.Rmd) to generate the [m1.Rds](m1.Rds)
* run [app.R](app.R)
* Visualization part: ....

## Presentation
* [1/22 two page slides](./presentation/Presentation_012218.pptx)
* [1/23 four page slides](https://docs.google.com/presentation/d/1YjBH5frG3v0PLQ3x3KwyDh3pNva85L7tBzYqLTyb7h0/edit#slide=id.p)

## Notes
* [E-MTAB-5061.sdrf.txt](E-MTAB-5061.sdrf.txt) is from [ArrayExpress](https://www.ebi.ac.uk/arrayexpress/experiments/E-MTAB-5061/).
* Based on output files of a [customized version](https://github.com/hsiaoyi0504/SC3) of [SC3](https://github.com/NCBI-Hackathons/SC3), which is a product of previous NCBI Hackathon.
* [collect_output.py](collect_output.py) is for merging files generated from [SC3]((https://github.com/hsiaoyi0504/SC3)).
* [m1.Rds](m1.Rds) is file genreated by [MergeTwoFiles.Rmd](MergeTwoFiles.Rmd)
