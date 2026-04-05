#!/bin/bash
#SBATCH --job-name=star_index
#SBATCH --time=06:00:00
#SBATCH --ntasks=16
#SBATCH --mem=64G
#SBATCH --output=logs/05b_star_index_%j.log
#SBATCH --account=cis250160p
#SBATCH --qos=low

set -eo pipefail

source /opt/packages/anaconda3-2024.10-1/etc/profile.d/conda.sh
conda activate bioinfo

set -u

source /ocean/projects/cis250160p/peerzade/Melanoma_RNAseq/config/config.sh

mkdir -p "$STAR_INDEX"

echo "[$(date +"%H:%M:%S")] Building STAR genome index"

STAR \
    --runMode genomeGenerate \
    --genomeDir "$STAR_INDEX" \
    --genomeFastaFiles "$FASTA_FILE" \
    --sjdbGTFfile "$GTF_FILE" \
    --sjdbOverhang 99 \
    --runThreadN "$STAR_THREADS" \
    --limitGenomeGenerateRAM "$STAR_RAM"

echo "[$(date +"%H:%M:%S")] STAR index complete"