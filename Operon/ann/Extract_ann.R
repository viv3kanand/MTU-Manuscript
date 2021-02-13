## courtesy -> https://gist.github.com/YulongNiu/3e51804cb170b603b9633bd1fc0c611c
## Mycobacterium tuberculosis H37Rv (high GC Gram+)
## KEGG ID is 'mtu' (https://www.genome.jp/kegg-bin/show_organism?org=T00015)
## NCBI assembly ID is 'GCF_000195955.2' (https://www.ncbi.nlm.nih.gov/assembly/GCF_000195955.2)


library('ProGenome') ## version >= 0.06
library('magrittr')

## temporary folder for saving files
saveFolder <- 'mtuTemp'
## check folder
if (!dir.exists(saveFolder)) {
  dir.create(saveFolder)
} else {}

## download gff, feature_table, and fna files
download.SpeAnno('mtu', 'gff', saveFolder)
download.SpeAnno('mtu', 'feature_table', saveFolder)
download.SpeAnno('mtu', '[^from]_genomic.fna', saveFolder)
files <- dir(saveFolder, full.names = TRUE)

## extract the fna file as 'mtu.fna'
files %>%
  grepl('[^from]_genomic.fna', .) %>%
  `[`(files, .) %>%
  paste0('zcat ', ., ' > ', file.path(saveFolder, 'mtu.fna')) %>%
  system

## extract the gff file as 'mtu.gff'
files %>%
  grepl('gff', .) %>%
  `[`(files, .) %>%
  paste0('zcat ', ., ' > ', file.path(saveFolder, 'mtu.gff')) %>%
  system


## extract ptt and rnt files as 'mtu.ptt' 'mtu.rnt'

ft <- files %>%
  grepl('feature_table', .) %>%
  `[`(files, .) %>%
  read.gff

ft %>%
  ExtractPtt %>%
  write.ptt(file.path(saveFolder,'mtu.ptt'))

ft %>%
  ExtractRnt %>%
  write.rnt(file.path(saveFolder, 'mtu.rnt'))
