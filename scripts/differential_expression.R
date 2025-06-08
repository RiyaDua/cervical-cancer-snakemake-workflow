#!/usr/bin/env Rscript

### differential_expression.R
# Perform differential gene expression analysis

library(DESeq2)
library(limma)
library(ggplot2)
library(pheatmap)


# getting command line arguments for input and output
args <- commandArgs(trailingOnly = TRUE)
input_file<-args[1]
metadata_file<-args[2]
output_file<-args[3]
volcano_plot<-args[4]


# Loading processed data
exprs_data <- read.csv(input_file, row.names=1)
sample_info <- read.csv(metadata_file, row.names=1)

# Defining experimental groups
# Create 'group' column based on source_name_ch1

group<-factor(sample_info$group)
design <- model.matrix(~0 + group)
colnames(design) <- levels(group)



# Applying limma for differential expression
fit <- lmFit(exprs_data, design)
contrasts <- makeContrasts(cancer - normal, levels=design)
fit2 <- contrasts.fit(fit, contrasts)
fit2 <- eBayes(fit2)

deg_results <- topTable(fit2, adjust="fdr", number=250)


# Saving results
write.csv(deg_results, output_file)

# Plot volcano plot
#ggplot(deg_results, aes(x=logFC, y=-log10(P.Value))) + geom_point()
# Volcano plot
if (!is.na(volcano_plot)) {
  p <- ggplot(deg_results, aes(x=logFC, y=-log10(P.Value))) +
    geom_point(alpha=0.6) +
    theme_minimal() +
    labs(title="Volcano Plot", x="Log2 Fold Change", y="-Log10 P-value")
  ggsave(volcano_plot, plot=p)
}
