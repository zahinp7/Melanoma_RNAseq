#!/bin/bash
#SBATCH --job-name=fastqc_trimmed
#SBATCH --time=04:00:00
#SBATCH --ntasks=16
#SBATCH --mem=32G
#SBATCH --output=logs/04_fastqc_trimmed_%j.log
#SBATCH --account=cis250160p
#SBATCH --qos=low

set -eo pipefail

source /opt/packages/anaconda3-2024.10-1/etc/profile.d/conda.sh
conda activate bioinfo

set -u

source /ocean/projects/cis250160p/peerzade/Melanoma_RNAseq/config/config.sh

mkdir -p "$QC_TRIMMED"

echo "[$(date +"%H:%M:%S")] Running FastQC on trimmed reads"

fastqc "$DATA_TRIMMED"/*.fastq.gz \
    --outdir "$QC_TRIMMED" \
    --threads 16

echo "[$(date +"%H:%M:%S")] Running MultiQC"

multiqc "$QC_TRIMMED" \
    --outdir "$QC_TRIMMED" \
    --filename multiqc_trimmed_report

echo "[$(date +"%H:%M:%S")] Trimmed QC complete"