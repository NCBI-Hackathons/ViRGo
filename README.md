## Please cite our work -- here is the ICMJE Standard Citation:

### ...and a link to the DOI:

## SCRVV  

### You can make a free DOI with zenodo <link>

## Intro statement

## What's the problem?
A single individual can process up to 3M SNV and up to 3000 private SNV most of which are normal variants and are benign.   Thus identifying the causal variant can be difficult.
## Why should we solve it?

# What is SCRVV?
Single Cell RNA Variant Viewer

Overview Diagram

# How to use SCRVV

## Installation options:

We provide two options for installing SCRVV: Docker or directly from Github.

### Docker

The Docker image contains <this software> as well as a webserver and FTP server in case you want to deploy the FTP server. It does also contain a web server for testing the <this software> main website (but should only be used for debug purposes).

1. `docker pull ncbihackathons/<this software>` command to pull the image from the DockerHub
2. `docker run ncbihackathons/<this software>` Run the docker image from the master shell script
3. Edit the configuration files as below

### Installing SCRVV from Github

  1. Download this repo: `git clone https://github.com/NCBI-Hackathons/<this software>.git`
  2. Collecting output files generated beforehand: `python3 collect_output.py`
  3. Follow the steps in [MergeTwoFiles.Rmd](MergeTwoFiles.Rmd) to generate the [m1.Rds](m1.Rds)
  4. run [app.R](app.R)

### Configuration

```Examples here```

# Testing

We tested four different tools with <this software>. They can be found in [server/tools/](server/tools/) . 

# Additional Functionality

### DockerFile

<this software> comes with a Dockerfile which can be used to build the Docker image.

  1. `git clone https://github.com/NCBI-Hackathons/<this software>.git`
  2. `cd server`
  3. `docker build --rm -t <this software>/<this software> .`
  4. `docker run -t -i <this software>/<this software>`
  
### Website

There is also a Docker image for hosting the main website. This should only be used for debug purposes.

  1. `git clone https://github.com/NCBI-Hackathons/<this software>.git`
  2. `cd Website`
  3. `docker build --rm -t <this software>/website .`
  4. `docker run -t -i <this software>/website`
  
## Presentation
* [1/22 two page slides](./presentation/Presentation_012218.pptx)
* [1/23 four page slides](https://docs.google.com/presentation/d/1YjBH5frG3v0PLQ3x3KwyDh3pNva85L7tBzYqLTyb7h0/edit#slide=id.p)

## Notes
* [E-MTAB-5061.sdrf.txt](E-MTAB-5061.sdrf.txt) is from [ArrayExpress](https://www.ebi.ac.uk/arrayexpress/experiments/E-MTAB-5061/).
* Based on output files of a [customized version](https://github.com/hsiaoyi0504/SC3) of [SC3](https://github.com/NCBI-Hackathons/SC3), which is a product of previous NCBI Hackathon.
* [collect_output.py](collect_output.py) is for merging files generated from [SC3]((https://github.com/hsiaoyi0504/SC3)).
* [m1.Rds](m1.Rds) is file genreated by [MergeTwoFiles.Rmd](MergeTwoFiles.Rmd)
