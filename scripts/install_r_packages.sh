#!/bin/bash
#SBATCH --job-name=r_install
#SBATCH --time=02:00:00
#SBATCH --ntasks=4
#SBATCH --mem=32G
#SBATCH --output=logs/r_install_%j.log
#SBATCH --account=cis250160p
#SBATCH --qos=low

set -eo pipefail

source /opt/packages/anaconda3-2024.10-1/etc/profile.d/conda.sh
conda activate rnaseq_r

conda install -c bioconda -c conda-forge --solver=classic \
    bioconductor-deseq2 \
    bioconductor-clusterprofiler \
    bioconductor-enrichplot \
    r-ggplot2 r-pheatmap r-dplyr r-ggrepel -y