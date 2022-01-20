## code to prepare `esco` dataset goes here

esco <- fread("inst/extdata/esco.csv", colClasses = "character")
usethis::use_data(esco, overwrite = TRUE)
