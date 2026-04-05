#!/bin/bash
#SBATCH --job-name=star_align
#SBATCH --time=24:00:00
#SBATCH --ntasks=16
#SBATCH --mem=64G
#SBATCH --output=logs/06_star_align_%j.log
#SBATCH --account=cis250160p
#SBATCH --qos=low

set -eo pipefail

source /opt/packages/anaconda3-2024.10-1/etc/profile.d/conda.sh
conda activate bioinfo

set -u

source /ocean/projects/cis250160p/peerzade/Melanoma_RNAseq/config/config.sh

mkdir -p "$ALIGN_PASS1"
mkdir -p "$ALIGN_PASS2"

echo "[$(date +"%H:%M:%S")] STAR Pass 1 - discovering splice junctions"

if [ -f "$ALIGN_PASS1/$SRR/SJ.out.tab" ]; then
    echo "[$(date +"%H:%M:%S")] Pass 1 already done for $SRR, skipping"
    continue
fi

for SRR in "${SRR_IDS[@]}"; do
    echo "[$(date +"%H:%M:%S")] Pass 1: $SRR"

    mkdir -p "$ALIGN_PASS1/$SRR"

    STAR \
        --runMode alignReads \
        --genomeDir "$STAR_INDEX" \
        --readFilesIn "$DATA_TRIMMED/${SRR}_1.fastq.gz" "$DATA_TRIMMED/${SRR}_2.fastq.gz" \
        --readFilesCommand zcat \
        --outSAMtype None \
        --outSJtype Standard \
        --runThreadN "$STAR_THREADS" \
        --limitBAMsortRAM "$STAR_RAM" \
        --outFileNamePrefix "$ALIGN_PASS1/$SRR/"
done

echo "[$(date +"%H:%M:%S")] Merging splice junctions"

cat "$ALIGN_PASS1"/*/SJ.out.tab | sort -u > "$ALIGN_PASS1/merged_SJ.out.tab"

echo "[$(date +"%H:%M:%S")] STAR Pass 2 - final alignment"

for SRR in "${SRR_IDS[@]}"; do
    echo "[$(date +"%H:%M:%S")] Pass 2: $SRR"

    mkdir -p "$ALIGN_PASS2/$SRR"

    STAR \
        --runMode alignReads \
        --genomeDir "$STAR_INDEX" \
        --readFilesIn "$DATA_TRIMMED/${SRR}_1.fastq.gz" "$DATA_TRIMMED/${SRR}_2.fastq.gz" \
        --readFilesCommand zcat \
        --sjdbFileChrStartEnd "$ALIGN_PASS1/merged_SJ.out.tab" \
        --limitSjdbInsertNsj 2000000 \
        --outSAMtype BAM SortedByCoordinate \
        --outSAMattributes NH HI AS NM MD \
        --runThreadN "$STAR_THREADS" \
        --limitBAMsortRAM "$STAR_RAM" \
        --outFileNamePrefix "$ALIGN_PASS2/$SRR/"

    samtools index "$ALIGN_PASS2/$SRR/Aligned.sortedByCoord.out.bam"

    echo "[$(date +"%H:%M:%S")] Done: $SRR"
done

echo "[$(date +"%H:%M:%S")] Alignment complete"