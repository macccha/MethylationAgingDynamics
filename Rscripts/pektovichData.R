library(magrittr)
library(data.table)
library(stringr)
library(readxl)

files.path <- "/data/others/ciarchi/Ageing/GSE80672_RAW"
file.list.ageing <- list.files(path = files.path)

print("Reading files...")
meta_data_petko<- readxl::read_excel("/data/others/ciarchi/Ageing/supplement-2.xlsx", sheet = 1) %>%
  as.data.table%>% setnames(c("Strain/Condition","Sample Name"), c("strain","sample.id"))
con<- fread("/data/others/ciarchi/Ageing/convert_chr.txt")
files.bs <- list.files(path = files.path, full.names = T)
l.bulk<- lapply(files.bs,function(x){fread(x, col.names = c("index", "meth.percentage", "cov")) %>%
    .[,sample.id:= word(word(basename(x), 2,sep = "_"),1,sep = fixed("."))]%>%
    .[,chr:= word(index, 4, sep=fixed("|")) ]%>%
    .[,start:=word(index, 2, sep=fixed("|:"))]%>%
    .[,meth:=meth.percentage/100]
}) %>% rbindlist()

print("Merging with metadata...")


b<-merge(l.bulk, con, by="chr")%>%
  merge(meta_data_petko, by="sample.id")%>%
  setnames(c("chr", "Assigned-Molecule"), c("chr.accession", "chr"))
rm(l.bulk)

meth.data <- b[, .(avg.meth=sum(meth)/.N, var.meth = var(meth), cov = as.double(sum(cov))/.N), by = .(chr, start, Age, strain)]
rm(b)

print("Saving Rdata file...")

save(meth.data,file="/data/others/ciarchi/Ageing/pektovich.RData")