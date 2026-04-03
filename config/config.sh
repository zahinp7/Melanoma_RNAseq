# Project root
PROJECT_DIR="/ocean/projects/cis250160p/peerzade/Melanoma_RNAseq"

# Directories
DATA_RAW="${PROJECT_DIR}/data/raw"
DATA_TRIMMED="${PROJECT_DIR}/data/trimmed"
DATA_COUNTS="${PROJECT_DIR}/data/counts"
GENOME_FASTA="${PROJECT_DIR}/genome/fasta"
GENOME_GTF="${PROJECT_DIR}/genome/gtf"
STAR_INDEX="${PROJECT_DIR}/genome/star_index"
QC_RAW="${PROJECT_DIR}/qc/raw"
QC_TRIMMED="${PROJECT_DIR}/qc/trimmed"
QC_ALIGN="${PROJECT_DIR}/qc/alignment"
RESULTS_DESEQ2="${PROJECT_DIR}/results/deseq2"
RESULTS_FIGURES="${PROJECT_DIR}/results/figures"
LOGS="${PROJECT_DIR}/logs"

# Reference genome
GTF_FILE="${GENOME_GTF}/gencode.v45.primary_assembly.annotation.gtf"
FASTA_FILE="${GENOME_FASTA}/GRCh38.primary_assembly.genome.fa"

# STAR parameters
READ_LENGTH=100
STAR_THREADS=16
STAR_RAM="60000000000"

# featureCounts parameters
# unstranded
STRANDEDNESS=0
FC_THREADS=8

# Samples - fill in after GEO metadata review
SAMPLES=()
TUMOR_SAMPLES=()
NORMAL_SAMPLES=()