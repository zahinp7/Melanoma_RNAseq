# Run this once after creating the rnaseq_r conda environment
# conda activate rnaseq_r && R < scripts/install_r_packages.R

install.packages("BiocManager", repos="https://cran.r-project.org")
BiocManager::install(c("DESeq2", "clusterProfiler", "enrichplot"))
install.packages(c("ggplot2", "pheatmap", "dplyr", "ggrepel"))