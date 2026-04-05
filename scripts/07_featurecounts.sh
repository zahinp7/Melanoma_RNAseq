#!/bin/bash
#SBATCH --job-name=featurecounts
#SBATCH --time=04:00:00
#SBATCH --ntasks=8
#SBATCH --mem=32G
#SBATCH --output=logs/07_featurecounts_%j.log
#SBATCH --account=cis250160p
#SBATCH --qos=low

set -eo pipefail

source /opt/packages/anaconda3-2024.10-1/etc/profile.d/conda.sh
conda activate bioinfo

set -u

source /ocean/projects/cis250160p/peerzade/Melanoma_RNAseq/config/config.sh

mkdir -p "$DATA_COUNTS"

echo "[$(date +"%H:%M:%S")] Running featureCounts"

featureCounts \
    -a "$GTF_FILE" \
    -o "$DATA_COUNTS/counts.txt" \
    -s "$STRANDEDNESS" \
    -p \
    --countReadPairs \
    -T "$FC_THREADS" \
    -Q 10 \
    --primary \
    "$ALIGN_PASS2"/*/Aligned.sortedByCoord.out.bam

echo "[$(date +"%H:%M:%S")] featureCounts complete"