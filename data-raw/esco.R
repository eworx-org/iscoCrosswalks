## code to prepare `esco` dataset goes here
library(data.table)

esco <- fread("inst/extdata/esco.csv",
              colClasses = rep("character", 10),
              keepLeadingZeros = TRUE)
esco[nchar(isco_4_key) == 3, isco_4_key := paste0("0", isco_4_key)]
esco[nchar(isco_3_key) == 2, isco_3_key := paste0("0", isco_3_key)]

usethis::use_data(esco, overwrite = TRUE)
