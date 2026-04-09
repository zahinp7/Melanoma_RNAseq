# load libraries
library(DESeq2)
library(dplyr)
library(ggplot2)
library(pheatmap)
library(ggrepel)

# read count matrix
counts <- read.table("data/counts/counts.txt", sep="\t", header=TRUE, comment.char="#")

# read sample metadata
metadata <- read.table("config/samples.tsv", sep="\t", header=TRUE)

# keep only Geneid and count columns, drop Chr/Start/End/Strand/Length
counts <- counts[, c(1, 7:ncol(counts))]

# set gene IDs as rownames
rownames(counts) <- counts$Geneid
counts <- counts[, -1]

# clean column names - featureCounts uses full BAM path as column name
# extract just the SRR ID from the path
colnames(counts) <- gsub(".*pass2\\.", "", colnames(counts))
colnames(counts) <- gsub("\\.Aligned.*", "", colnames(counts))

# set rownames of metadata to match count matrix column names
rownames(metadata) <- metadata$srr

# reorder metadata rows to match count matrix column order
metadata <- metadata[colnames(counts), ]

# verify they match before creating DESeq2 object
stopifnot(all(colnames(counts) == rownames(metadata)))

# create DESeq2 object
dds <- DESeqDataSetFromMatrix(
    countData = counts,
    colData = metadata,
    design = ~ condition
)

# set reference level - non_responder is the baseline
dds$condition <- relevel(dds$condition, ref="non_responder")

# filter low count genes - remove genes with fewer than 10 reads total
keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep, ]

# run DESeq2
dds <- DESeq(dds)

# extract results - responder vs non_responder
res <- results(dds, contrast=c("condition", "responder", "non_responder"))

# shrink log fold changes for visualization
res_shrunk <- lfcShrink(dds, coef="condition_responder_vs_non_responder", type="apeglm")

# save results to CSV
res_df <- as.data.frame(res_shrunk)
res_df$gene <- rownames(res_df)
write.csv(res_df, "results/deseq2/deseq2_results.csv", row.names=FALSE)

# save normalized counts
normalized_counts <- counts(dds, normalized=TRUE)
write.csv(normalized_counts, "results/deseq2/normalized_counts.csv")

cat("DESeq2 complete\n")
cat("Total genes tested:", nrow(res_df), "\n")
cat("Significant DEGs (padj<0.05):", sum(res_df$padj < 0.05, na.rm=TRUE), "\n")