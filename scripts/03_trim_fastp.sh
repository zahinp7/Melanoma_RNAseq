#!/bin/bash
#SBATCH --job-name=trimming
#SBATCH --time=12:00:00
#SBATCH --ntasks=16
#SBATCH --mem=32G
#SBATCH --output=logs/03_trim_%j.log
#SBATCH --account=cis250160p
#SBATCH --qos=low

set -eo pipefail

source /opt/packages/anaconda3-2024.10-1/etc/profile.d/conda.sh
conda activate bioinfo

set -u

source /ocean/projects/cis250160p/peerzade/Melanoma_RNAseq/config/config.sh

mkdir -p "$DATA_TRIMMED"
mkdir -p "$QC_TRIMMED"

echo "[$(date +"%H:%M:%S")] Starting fastp trimming for 21 samples"

for SRR in "${SRR_IDS[@]}"; do
    R1="$DATA_RAW/${SRR}_1.fastq.gz"
    R2="$DATA_RAW/${SRR}_2.fastq.gz"
    OUT1="$DATA_TRIMMED/${SRR}_1.fastq.gz"
    OUT2="$DATA_TRIMMED/${SRR}_2.fastq.gz"

    echo "[$(date +"%H:%M:%S")] Trimming $SRR"

    fastp \
        --in1 "$R1" \
        --in2 "$R2" \
        --out1 "$OUT1" \
        --out2 "$OUT2" \
        --detect_adapter_for_pe \
        --qualified_quality_phred 20 \
        --length_required 36 \
        --thread 16 \
        --html "$QC_TRIMMED/${SRR}_fastp.html" \
        --json "$QC_TRIMMED/${SRR}_fastp.json"

    echo "[$(date +"%H:%M:%S")] Done: $SRR"
done

echo "[$(date +"%H:%M:%S")] Running MultiQC on trimmed QC reports"

multiqc "$QC_TRIMMED" \
    --outdir "$QC_TRIMMED" \
    --filename multiqc_trimmed_report

echo "[$(date +"%H:%M:%S")] Trimming complete"