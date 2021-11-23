# This code will allow you to get the gene ids and GO terms for your data

# run install_dependencies.R file before running this script

### Libraries 

library(biomaRt)
library(dplyr)
library(tidyverse)
library(readxl)
library("DT")
ensembl <- useMart(biomart = "ensembl", dataset = "hsapiens_gene_ensembl")

### tu run this script, CTRL + A and click on RUN

# search your file
filename <- file.choose()
data <- read_excel(filename )

# gene names annotation

#make this a character, otherwise it will throw errors with left_join
data$gene_id <- data[,1]
#data$gene_id <- sub("[.][0-9]*","", data$gene_id)
mart <- useDataset("hsapiens_gene_ensembl", useMart("ensembl"))
genes <-  data$gene_id
gene_IDs <- getBM(filters = "ensembl_gene_id", attributes= c("ensembl_gene_id","hgnc_symbol","go_id"),
                  values = genes, mart= mart)

# this step can take several minutes to complete
data_new <- inner_join(data, gene_IDs, by = c("ID"="ensembl_gene_id"))

#filtering
data_new_filt <- data_new[-c(10)]

#erase duplicated 
# duplicated values in gene_ids
gene_ids <- gene_IDs[!duplicated(gene_IDs$mgi_symbol), ]

for(row in 1:nrow(data_new_filt)){
  if(rownames(data_new_filt)[row] %in% gene_ids$ensembl_gene_id) {
    if((gene_ids[which(gene_ids$ensembl_gene_id == rownames(data_new_filt)[row]),])$mgi_symbol != "") {
      rownames(data_new_filt)[row] <- (gene_ids[which(gene_ids$ensembl_gene_id == rownames(data_new_filt)[row]),])$mgi_symbol
    }
  } 
}


DT::datatable(data_new_filt, extensions = 'Buttons',
              options=list(dom = 'Bfrtip',
                           buttons = c('excel','csv','print'),
                           rowCallback=JS(
                             'function(row,data) {
     if($(row)["0"]["_DT_RowIndex"] % 2 <1) 
            $(row).css("background","#f2f9ec")
    }')))
