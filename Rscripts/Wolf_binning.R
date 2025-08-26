library(magrittr)
library(data.table)
library(stringr)

print("Loading files files...")
load("/data/others/ciarchi/Ageing/wolf.RData")
load("/data/others/ciarchi/Ageing/bins_mm10.RData")

print("Overlapping with bins...")
#Rename seqnames column
wolf.data[,seqnames:= paste("chr",chr,sep="")]
#Create end column
wolf.data[,end:=start]
setkey(bins, "seqnames", "start", "end")
setkey(wolf.data, "seqnames", "start", "end")
sel.data <- as.data.table(foverlaps(bins, wolf.data, nomatch = NULL)) %>% .[, .(meth = sum(meth)/.N,avg.cov = sum(pcounts+ncounts)/.N), by=.(i.start,i.end,seqnames,sample.id,age)] %>% .[,start:=i.start] %>% .[,end:=i.end] %>% .[,i.start:=NULL] %>% .[,i.end:=NULL]
sel.data <- unique(sel.data)
#Calculate aggeraget statistics over cells
sel.data[,.(avg.meth=sum(meth)/.N,var.meth=var(meth),avg.cov),by=.(start,end,seqnames,age)]

print("Saving file...")
save(sel.data,file="/data/others/ciarchi/Ageing/wolf_bin.RData")