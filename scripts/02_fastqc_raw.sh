#!/bin/bash
#SBATCH --job-name=fastqc
#SBATCH --time=24:00:00
#SBATCH --ntasks=4
#SBATCH --mem=8G
#SBATCH --output=logs/02_%j.log
#SBATCH --account=cis250160p
#SBATCH --qos=low

set -eo pipefail

source /opt/packages/anaconda3-2024.10-1/etc/profile.d/conda.sh
conda activate bioinfo

set -u

source /ocean/projects/cis250160p/peerzade/Melanoma_RNAseq/config/config.sh

mkdir -p "$QC_RAW"

echo "[$(date +"%H:%M:%S")] Running FastQC on raw reads"

fastqc "$DATA_RAW"/*.fastq.gz \
    --outdir "$QC_RAW" \
    --threads 16

echo "[$(date +"%H:%M:%S")] Running MultiQC"

multiqc "$QC_RAW" \
    --outdir "$QC_RAW" \
    --filename "multiqc_raw_report"

echo "[$(date +"%H:%M:%S")] Raw QC complete!"

