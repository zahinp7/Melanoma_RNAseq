# Melanoma Anti-PD1 Immunotherapy — Bulk RNA-seq Pipeline

Independent reanalysis of GSE78220 (Hugo et al., Cell 2016) characterizing transcriptional differences between anti-PD1 responders and non-responders in metastatic melanoma.

---

## Background

Anti-PD1 therapy produces durable responses in only 30-40% of metastatic melanoma patients. Hugo et al. identified a transcriptional resistance program — IPRES (Innate anti-PD1 RESistance) — present in pre-treatment tumor biopsies of non-responding patients, involving upregulation of mesenchymal transition, ECM remodeling, angiogenesis, and wound healing gene sets. This pipeline independently reanalyzes the raw sequencing data using a modern computational workflow to reproduce and extend those findings.

---

## Dataset

- **Accession:** GSE78220
- **Publication:** Hugo et al., 2016, Cell 165(1):35–44
- **Platform:** Illumina HiSeq 2000, paired-end 2×100bp
- **Samples selected:** 21 unstranded samples (10 responders, 11 non-responders)
- **Exclusions:** 7 stranded samples excluded to avoid library preparation batch effects

**Response classification:**
- Responder: Complete Response or Partial Response
- Non-responder: Progressive Disease or Stable Disease

---

## Pipeline Overview

```
Stage 0   Environment and project structure setup
Stage 1   Data acquisition and metadata validation (GEO)
Stage 2   Raw QC — FastQC + MultiQC
Stage 3   Adapter trimming — fastp (paired-end)
Stage 4   Post-trim QC — FastQC + MultiQC
Stage 5   Genome indexing — STAR (GRCh38, Gencode v45)
Stage 6   Alignment — STAR 2-pass mode
Stage 7   Quantification — featureCounts (unstranded)
Stage 8   Differential expression — DESeq2
Stage 9   Downstream — GSEA, clusterProfiler, figures
```

---

## Key Methodological Choices

**Why unstranded samples only:** The GSE78220 dataset contains a mix of stranded and unstranded libraries across samples. Including both would introduce a systematic technical batch effect that cannot be cleanly corrected at this sample size without sacrificing statistical power in DESeq2. The 21 unstranded samples provide a balanced 10v11 comparison with no batch correction required.

**Why STAR 2-pass:** 2-pass alignment uses novel splice junctions discovered in the first pass to improve alignment accuracy in the second pass. This is the current standard for publication-quality RNA-seq analysis.

**Why featureCounts over Salmon:** The original Hugo et al. analysis used alignment-based quantification (TopHat2/Cufflinks). This pipeline uses a modern alignment-based approach (STAR/featureCounts) to remain comparable to the original while using significantly improved tools. Strandedness is set to unstranded (parameter 0) to match library preparation.

**Reference genome:** GRCh38 primary assembly with Gencode v45 annotation, representing a methodological improvement over the hg19/UCSC annotation used in the original paper.

---

## Repository Structure

```
Melanoma_RNAseq/
├── config/
│   ├── config.sh               # All paths and parameters
│   ├── samples.tsv             # Sample metadata and SRR accessions
│   └── GSE78220_family.soft    # Raw GEO metadata
├── data/
│   ├── raw/                    # Downloaded FASTQs (not tracked)
│   ├── trimmed/                # fastp output (not tracked)
│   └── counts/                 # featureCounts matrix
├── genome/                     # Reference files (not tracked)
├── qc/
│   ├── raw/                    # FastQC + MultiQC on raw reads
│   ├── trimmed/                # FastQC + MultiQC post-trimming
│   └── alignment/              # samtools flagstat per sample
├── results/
│   ├── deseq2/                 # DEG tables, normalized counts
│   └── figures/                # All publication-quality plots
├── scripts/                    # Numbered pipeline scripts
├── envs/                       # Conda environment specifications
└── logs/                       # SLURM job logs (not tracked)
```

---

## Reproduction

### Requirements

- Bridges-2 HPC (PSC) or equivalent Linux cluster with SLURM
- Conda

### Environments

**Upstream (Stages 2–7):** Uses the `bioinfo` conda environment.

```bash
conda env create -f envs/rnaseq_upstream.yml
```

**Downstream (Stages 8–9):** Uses the `rnaseq_r` conda environment.

```bash
conda create -n rnaseq_r -c conda-forge r-base -y
conda activate rnaseq_r
R < scripts/install_r_packages.R
```

### Running the pipeline

Each stage is a self-contained SLURM script. Submit sequentially:

```bash
sbatch scripts/01_download.sh
sbatch scripts/02_fastqc_raw.sh
sbatch scripts/03_trim_fastp.sh
sbatch scripts/04_fastqc_trimmed.sh
sbatch scripts/05_star_index.sh
sbatch scripts/06_star_align.sh
sbatch scripts/07_featurecounts.sh
# Stages 8-9 run in R after activating rnaseq_r
```

---

## Expected Results

*(To be updated on pipeline completion)*

- Differentially expressed genes between responders and non-responders
- Recovery of published IPRES resistance signature via GSEA
- Immune cell composition differences via deconvolution
- PCA showing separation of responder and non-responder clusters

---

## Reference

Hugo W, Zaretsky JM, Sun L, et al. Genomic and Transcriptomic Features of Response to Anti-PD-1 Therapy in Metastatic Melanoma. *Cell.* 2016;165(1):35-44. doi:10.1016/j.cell.2016.02.065

---

## Author

Zahin Peerzade   
[github.com/zahinp7](https://github.com/zahinp7) | zahinp7@gmail.com