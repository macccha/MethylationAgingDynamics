library(magrittr)
library(data.table)
library(stringr)
library(readxl)

print("Reading files...")
wolf.data <- fread("/data/others/ciarchi/Ageing/aging.m.txt", stringsAsFactors = T)
wolf.data <- wolf.data[, .(meth, pcounts, ncounts), by = .(chr, start, age, tissue,sample.id,plate_ID)]

# print("Select random sites file...")
# ids <- sample(unique(wolf.data$start), 1000000)
# wolf.data <- wolf.data[start%in%ids]

print("Saving Rdata file...")

save(wolf.data,file="/data/others/ciarchi/Ageing/wolf.RData")
