# Cervical Cancer Gene Expression Analysis Pipeline

This repository contains a fully reproducible Snakemake automated workflow to analyze cervical cancer gene expression data. It automates an NGS-based pipeline I originally developed in R for differential expression analysis, including preprocessing, DE analysis, and visualization.

### What This Pipeline Does
Fetches and preprocesses data from a GEO Series (GSE ID).

- Aligns sample metadata and expression data.

- Performs differential expression analysis using limma.

- Generates a volcano plot for visualizing DE genes.

- Supports multiple cancer types (cervical, endometrial, vulvar) by grouping all cancer samples together vs. normal tissue.

- Runs seamlessly in a Snakemake workflow for reproducibility.

### Environment Setup
To ensure compatibility with Bioconductor packages on an Apple Silicon (ARM) Mac, we created a Rosetta-based Intel environment:

#### 1️ Create an Intel-based conda environment (snakemake_r_env)
```code
conda create -n snakemake_env -c conda-forge -c bioconda \
  r-base=4.2 \
  bioconductor-limma \
  bioconductor-geoquery \
  bioconductor-deseq2 \
  r-tidyr r-dplyr r-ggplot2 r-pheatmap \
  snakemake
```

#### 2️ Activate the environment
```code
conda activate snakemake_env
```

### Project Structure
```text
snakemake_gene_expr/
├── data/                      # Processed data and sample metadata
├── results/                   # Differential expression results and volcano plot
├── scripts/                   # R scripts for each analysis step
│   ├── preprocessing.R
│   └── differential_expression.R
├── Snakefile                  # Snakemake workflow
├── config.yaml                # Configurable parameters ( GEO ID, min count)
└── README.md                  # This file

```

### Configuration
Edit config.yaml to set your dataset and preprocessing thresholds:
```text
geo_id: "GSE63678"
min_count: 10
```
### How to Run
Make sure you’re in the project directory and the environment is activated:

```code
cd /path/to/snakemake_gene_expr
conda activate snakemake_env
```
## Run the entire workflow
```code
snakemake --cores 1 --use-conda
```

### This will:

- Fetch and preprocess data
- Generate processed expression data and metadata
-  Perform differential expression analysis
-   Create a volcano plot of the results

### Final results:
```code
results/differential_expression_results.csv
results/volcano_plot.pdf
```

### Key Notes
- I used an Intel-based environment (snakemake_r_env) on an ARM Mac via Rosetta to ensure Bioconductor compatibility.

- The pipeline automates my original NGS cervical cancer pipeline using Snakemake for reproducibility.

- This setup can be easily adapted to analyze other GEO datasets by updating the geo_id in config.yaml.

## Author
Riya Dua
Master’s in Bioinformatics, Johns Hopkins University
Driven to integrate clinical informatics and multi-omics pipelines for cancer research!
