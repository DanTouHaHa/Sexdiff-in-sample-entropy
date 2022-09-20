## Function: enrichment analysis of genes 
# -----------------------------------------
# -----------------------------------------

rm(list=ls())
# if (!require("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install(version = "3.15")
# BiocManager::install("clusterProfiler")  #for enrichment
# BiocManager::install("topGO")  #for plot
# BiocManager::install("Rgraphviz")
# BiocManager::install("pathview") #for KEGG pathway
# BiocManager::install("org.Hs.eg.db") #for gene annotation.

library(BiocManager)
library(clusterProfiler)
library(topGO)
library(Rgraphviz)
library(pathview)
library(org.Hs.eg.db)
library(ggplot2)
library(dplyr)

dir.root <- dirname(dirname(rstudioapi::getActiveDocumentContext()$path))
#dir.work <- paste0(dir.root,'/file_HWJ/')
dir.work <- paste0(dir.root,'E:/Fudan_Luoqiang_MDDProject/848MDD_794NC/数据分析/数据整理统计分析/富集分析基因表达/R语言富集分析/富集分析')
#out_probe_join11 <- read.csv(file.path(paste0(dir.work,'Dosen全脑第六特征PLS_out_genes_cort_PLS_variance_max.csv')))
out_probe_join11 <- read.csv(file.path(paste0('Dosen全脑第六特征PLS_out_genes_cort_PLS_variance_max.csv')))

egenes.symble <- as.character(out_probe_join11$geneSymbol[which(out_probe_join11$PLS3Z>=2.231821316)])#set a threshhood of gene-Z score
file_name <- paste0(dir.work,'DOsen全脑第六特征_cort_pos_')
# egenes.symble <- as.character(out_probe_join11$geneSymbol[which(out_probe_join11$PLS3Z<=-1.96)])#set a threshhood of gene-Z score

egenes.entrez <- mapIds(x = org.Hs.eg.db, keys = egenes.symble, keytype = "SYMBOL", column="ENTREZID")
egenes.entrez <- na.omit(egenes.entrez)

####kegg
enrich.kegg <- enrichKEGG(
			  gene = egenes.entrez,
			  organism = "hsa",
			  keyType = "kegg", # one of "kegg", 'ncbi-geneid', 'ncib-proteinid' and 'uniprot'
			  pvalueCutoff = 0.05,
			  qvalueCutoff = 0.2,
			  pAdjustMethod = "BH",
			  # universe,
			  minGSSize = 10,
			  maxGSSize = 500,
			  use_internal_data = FALSE)
enrich.kegg.y <- setReadable(enrich.kegg, OrgDb = org.Hs.eg.db, keyType="ENTREZID")

write.table(enrich.kegg.y@result, file = file.path(paste0(file_name,'kegg_Z_percent1.csv')),row.names = FALSE, quote = FALSE,sep = ',')
# barplot(enrich.kegg, showCategory = 20, title = 'KEGG Enrichment')
pic_dot <- dotplot(enrich.kegg, showCategory=20, title = 'KEGG Enrichment')
pic_dot
pdf(file = file.path(paste0(file_name,'kegg_and_GO_Z_percent1.pdf')),width=7,height=7,fonts = NULL,family="Times")
pic_dot
dev.off()

######
go <- enrichGO(gene = egenes.entrez,
               OrgDb = org.Hs.eg.db,
               keyType = "ENTREZID",
               ont = "ALL",
               pvalueCutoff = 0.05,
               pAdjustMethod = 'BH',
               qvalueCutoff = 0.2,
               readable = TRUE)

write.table(go@result, file = file.path(paste0(file_name,'go_Z_percent1.csv')),
            row.names = FALSE, quote = FALSE,sep = ',')
# barplot(go, split="ONTOLOGY")+ facet_grid(ONTOLOGY~.,scale="free")
pic_dot <- dotplot(go, split="ONTOLOGY")+ facet_grid(ONTOLOGY~.,scale="free")
pic_dot
pdf(file = file.path(paste0(file_name,'go_Z_percent1.pdf')),width=10,height=7,family="Times")
pic_dot
dev.off()
