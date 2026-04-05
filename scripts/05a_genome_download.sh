#!/bin/bash
#SBATCH --job-name=genome_download
#SBATCH --time=12:00:00
#SBATCH --ntasks=4
#SBATCH --mem=8G
#SBATCH --output=logs/05a_genome_download_%j.log
#SBATCH --account=cis250160p
#SBATCH --qos=low

set -eo pipefail

source /opt/packages/anaconda3-2024.10-1/etc/profile.d/conda.sh
conda activate bioinfo

set -u

source /ocean/projects/cis250160p/peerzade/Melanoma_RNAseq/config/config.sh

mkdir -p "$GENOME_FASTA"
mkdir -p "$GENOME_GTF"

echo "[$(date +"%H:%M:%S")] Downloading GTF annotation"

wget -c "https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_49/gencode.v49.primary_assembly.annotation.gtf.gz" \
    -O "${GENOME_GTF}/gencode.v49.primary_assembly.annotation.gtf.gz"

echo "[$(date +"%H:%M:%S")] Downloading genome FASTA"

wget -c "https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_49/GRCh38.primary_assembly.genome.fa.gz" \
    -O "${GENOME_FASTA}/GRCh38.primary_assembly.genome.fa.gz"

echo "[$(date +"%H:%M:%S")] Decompressing files"

gunzip "${GENOME_GTF}/gencode.v49.primary_assembly.annotation.gtf.gz"
gunzip "${GENOME_FASTA}/GRCh38.primary_assembly.genome.fa.gz"

echo "[$(date +"%H:%M:%S")] Genome download complete"