#!/bin/bash
#SBATCH --job-name=download
#SBATCH --time=24:00:00
#SBATCH --ntasks=4
#SBATCH --mem=8G
#SBATCH --output=logs/01_download_%j.log
#SBATCH --account=cis250160p
#SBATCH --qos=low

set -eo pipefail

source /opt/packages/anaconda3-2024.10-1/etc/profile.d/conda.sh
conda activate bioinfo

set -u

source /ocean/projects/cis250160p/peerzade/Melanoma_RNAseq/config/config.sh

mkdir -p "$DATA_RAW"

echo "[$(date +"%H:%M:%S")] Starting FASTQ download for 21 samples"

declare -A ENA=(
    [SRR3184279]="009"
    [SRR3184280]="000"
    [SRR3184281]="001"
    [SRR3184282]="002"
    [SRR3184283]="003"
    [SRR3184284]="004"
    [SRR3184285]="005"
    [SRR3184286]="006"
    [SRR3184287]="007"
    [SRR3184288]="008"
    [SRR3184289]="009"
    [SRR3184290]="000"
    [SRR3184291]="001"
    [SRR3184292]="002"
    [SRR3184293]="003"
    [SRR3184294]="004"
    [SRR3184295]="005"
    [SRR3184296]="006"
    [SRR3184297]="007"
    [SRR3184300]="000"
    [SRR3184301]="001"
)

SRR_IDS=(
    "SRR3184279" "SRR3184280" "SRR3184281" "SRR3184282"
    "SRR3184283" "SRR3184284" "SRR3184285" "SRR3184286"
    "SRR3184287" "SRR3184288" "SRR3184289" "SRR3184290"
    "SRR3184291" "SRR3184292" "SRR3184293" "SRR3184294"
    "SRR3184295" "SRR3184296" "SRR3184297" "SRR3184300"
    "SRR3184301"
)

BASE="https://ftp.sra.ebi.ac.uk/vol1/fastq/SRR318"

for SRR in "${SRR_IDS[@]}"; do
    R1="$DATA_RAW/${SRR}_1.fastq.gz"
    R2="$DATA_RAW/${SRR}_2.fastq.gz"

    if [ -f "$R1" ] && [ -f "$R2" ]; then
        echo "[$(date +"%H:%M:%S")] $SRR already exists, skipping"
        continue
    fi

    echo "[$(date +"%H:%M:%S")] Downloading $SRR"
    SUBDIR="${ENA[$SRR]}"

    wget -c "${BASE}/${SUBDIR}/${SRR}/${SRR}_1.fastq.gz" -O "$R1"
    wget -c "${BASE}/${SUBDIR}/${SRR}/${SRR}_2.fastq.gz" -O "$R2"

    echo "[$(date +"%H:%M:%S")] Done: $SRR"
done

echo "[$(date +"%H:%M:%S")] All downloads complete"