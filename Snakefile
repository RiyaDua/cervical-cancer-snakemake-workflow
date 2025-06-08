# Snakefile for cervical cancer GEO pipeline
# Steps: data preprocessing and visualization

# Load config file
configfile: "config.yaml"

# Final output: differential expression results
rule all:
 input:
  "results/differential_expression_results.csv",
  "results/volcano_plot.pdf"

# preprocessing step:
rule preprocess:
 output:
  exprs="data/processed_expression_data.csv",
  meta="data/sample_metadata.csv"
# script:
#  "scripts/preprocessing.R"
# conda:
#  "env/environment.yaml"
 params:
  geo_id=config["geo_id"],
  min_count=config["min_count"]
 shell:
  """
  GEO_ID={params.geo_id} MIN_COUNT={params.min_count} Rscript scripts/preprocessing.R
  """

# Differential expression analysis
rule differential_expression:
 input:
  exprs="data/processed_expression_data.csv",
  meta="data/sample_metadata.csv"
 output:
  de_results="results/differential_expression_results.csv",
  volcano_plot="results/volcano_plot.pdf"
# conda:
#  "env/environment.yaml"

# script:
#  "scripts/differential_expression.R"
 shell:
  """
  Rscript scripts/differential_expression.R {input.exprs} {input.meta} {output.de_results} {output.volcano_plot}
  """
