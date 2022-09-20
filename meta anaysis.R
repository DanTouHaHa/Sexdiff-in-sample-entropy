
library(readxl)

library(forestplot)
Global_Dosen_OCCPI <- read_excel("Global_Dosen_OCCPI.xlsx")
View(Global_Dosen_OCCPI)
#data <- Global_Dosen_OCCPI
library(Matrix)
library(meta)
metawsd=metacont(n1i,m1i,sd1i,n2i,m2i,sd2i,data=Global_Dosen_OCCPI,sm="MD",comb.fixed = TRUE,comb.random = TRUE,studlab = Site)
forest(metawsd,family = "Times New Roman", fontsize = 12, lwd = 4)
pdf('G_Dosen_OCCPI.pdf',height = 7,width = 12)
forest(metawsd)
dev.off()
