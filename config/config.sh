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
GTF_FILE="${GENOME_GTF}/gencode.v49.primary_assembly.annotation.gtf"
FASTA_FILE="${GENOME_FASTA}/GRCh38.primary_assembly.genome.fa"

# STAR parameters
READ_LENGTH=100
STAR_THREADS=16
STAR_RAM="60000000000"

# featureCounts parameters
# unstranded
STRANDEDNESS=0
FC_THREADS=8

# Samples
SAMPLES=("Pt1" "Pt2" "Pt4" "Pt5" "Pt6" "Pt7" "Pt8" "Pt9" "Pt10" "Pt12" "Pt13" "Pt14" "Pt15" "Pt16" "Pt19" "Pt20" "Pt22" "Pt23" "Pt25" "Pt28" "Pt29")

RESPONDERS=("Pt2" "Pt4" "Pt5" "Pt6" "Pt8" "Pt9" "Pt13" "Pt15" "Pt19" "Pt28")

NON_RESPONDERS=("Pt1" "Pt7" "Pt10" "Pt12" "Pt14" "Pt16" "Pt20" "Pt22" "Pt23" "Pt25" "Pt29")

SRR_IDS=("SRR3184279" "SRR3184280" "SRR3184281" "SRR3184282" "SRR3184283" "SRR3184284" "SRR3184285" "SRR3184286" "SRR3184287" "SRR3184288" "SRR3184289" "SRR3184290" "SRR3184291" "SRR3184292" "SRR3184293" "SRR3184294" "SRR3184295" "SRR3184296" "SRR3184297" "SRR3184300" "SRR3184301")