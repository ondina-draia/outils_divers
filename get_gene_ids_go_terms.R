# This code will allow you to get the gene ids and GO terms for your data

# run install_dependencies.R file before running this script

### Libraries 

library(biomaRt)
library(dplyr)

### tu run this script, CTRL + A and click on RUN

# search your file
filename <- file.choose()
data <- read.csv(file = filename )

# gene names annotation

#make this a character, otherwise it will throw errors with left_join
data$gene_id <- as.character(data[,1])
data$gene_id <- sub("[.][0-9]*","", data$gene_id)
mart <- useDataset("hsapiens_gene_ensembl", useMart("ensembl"))
genes <-  data$gene_id
gene_IDs <- getBM(filters = "ensembl_gene_id", attributes= c("ensembl_gene_id","hgnc_symbol","go_id"),
                  values = genes, mart= mart)

# this step can take several minutes to complete
data_new <- inner_join(data, gene_IDs, by = c("gene_id"="ensembl_gene_id"))

#filtering
data_new_filt <- data_new[-c(10)]


#export table in csv format
write.table(data_new_filt, file = "genes_rnaseq_data_names.csv", sep = "\t",
            row.names = TRUE, col.names = NA)