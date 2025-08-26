library(magrittr)
library(data.table)
library(stringr)

path.to.bulk.stubbs <- "/data/others/ciarchi/Ageing/Stubbs/GSE93957_RAW"
files.stubbs <- list.files(path = path.to.bulk.stubbs, full.names = T)

print("Reading files...")
stubbss <- lapply(files.stubbs,function(x){fread(x, col.names = c("chr","start","end","perc.methylation","pcounts","ncounts")) %>%
    
    .[,meth:=pcounts/(ncounts+pcounts)]%>%
    
    .[,end:= start + 1] %>%
    
    .[,replicate:=word(basename(x), 2,sep = "_")]%>%
    
    .[,tissue:=word(word(basename(x), 4,sep = "_"),1,sep=fixed("."))]%>%
    
    .[,Age:= word(basename(x), 3,sep = "_")]
  
}) %>% rbindlist()

stubbss[,totcounts := pcounts+ncounts]
stubbss <- stubbss[totcounts>=10]

# print("Calculatiing quantities...")
# #Calculate necessary quantities for statistical analysis
# stubbss <- stubbss[, .(avg.meth=sum(meth)/.N, avg.cov = sum(totcounts)/.N, var.meth = var(meth)), by = .(start,chr,tissue,Age)]

print("Saving file...")

save(stubbss,file="/data/others/ciarchi/Ageing/Stubbs.RData")

