#!/bin/bash
#SBATCH --job-name=r_install
#SBATCH --time=02:00:00
#SBATCH --ntasks=4
#SBATCH --mem=16G
#SBATCH --output=logs/r_install_%j.log
#SBATCH --account=cis250160p
#SBATCH --qos=low

set -eo pipefail

source /opt/packages/anaconda3-2024.10-1/etc/profile.d/conda.sh
conda activate rnaseq_r

set -u

R --quiet --no-save << 'EOF'
install.packages("BiocManager", repos="https://cran.r-project.org")
BiocManager::install(c("DESeq2", "clusterProfiler", "enrichplot"))
install.packages(c("ggplot2", "pheatmap", "dplyr", "ggrepel"))
cat("All packages installed successfully\n")
EOF