#!/usr/bin/env Rscript

### preprocessing.R
# This script downloads and preprocesses GEO data for analysis

geo_id<-Sys.getenv("GEO_ID", "GSE63678")    # Default fallback
min_count<-as.numeric(Sys.getenv("MIN_COUNT", "10"))

# load necessary packages
library(GEOquery)
library(dplyr)
library(tidyr)

# Loading dataset from GEO
#gse_id <- "GSE63678"
gse <- getGEO(geo_id)[[1]]

# Viewing sample information
sampleInfo <- pData(gse)

# Creating 'group' column based on cervical samples
sampleInfo$group <- ifelse(grepl("normal", sampleInfo$source_name_ch1, ignore.case=TRUE),
                           "normal",
                           "cancer")



# Extracting expression data
exprs_data <- exprs(gse)

# Log2 transformation
exprs_data <- log2(exprs_data +1)
#boxplot(exprs_data, outline=FALSE)

# Filter genes
filtered <- exprs_data[rowSums(exprs_data) > min_count, ]

# Saving cleaned dataset
write.csv(exprs_data, "data/processed_expression_data.csv", row.names=TRUE)

# Saving the sampleInfo data frame
write.csv(sampleInfo, "data/sample_metadata.csv", row.names=TRUE)

