library(metafor)
library(readxl)

NonGlobal_Dosen_DMN <- read_excel("NonGlobal_Dosen_FPCN.xlsx")
View(NonGlobal_Dosen_DMN)
NG_DMN = NonGlobal_Dosen_DMN
dat_NG_DMN <- escalc(measure="SMD", m1i=m1i, sd1i=sd1i, n1i=n1i,
                     m2i=m2i, sd2i=sd2i, n2i=n2i, data = NG_DMN) 
# escalc(measure, ai, bi, ci, di, n1i, n2i, x1i, x2i, t1i, t2i,m1i, m2i, sd1i, sd2i, xi, mi, ri, ti, sdi, r2i, ni, yi, vi, sei,data, slab, subset, include,add=1/2, to="only0", drop00=FALSE, vtype="LS",var.names=c("yi","vi"), add.measure=FALSE,append=TRUE, replace=TRUE, digits, …)
#n1i,m1i,sd1i为女性，#n2i,m2i,sd2i为男性
# 其中 dat = escalc(measure = "RR", ai = tpos, bi = tneg, ci = cpos, di = cneg, data = dat.bcg,append = TRUE)
#计算RR
res1 <- rma(yi, vi, data=dat_NG_DMN)
res1
forest(res1, slab = paste(dat_NG_DMN$Site, sep = ","))
ranktest(res1) #Begg test
regtest(res1) #Egger test


######重新开始
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
