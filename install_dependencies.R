## Prior installation of packages

### tu run this script, CTRL + A and click on RUN

## ???Install Biocmanager
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install(version = "3.13")

### Install biomaRt
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("biomaRt")

### Install dplyr
install.packages("dplyr")
install.packages("tidyverse")

# Install DT 
install.packages("DT")

#Install Excel
install.packages("readxl")
