library(data.table)

isco <- fread("inst/extdata/ISCOGroups_en.csv", keepLeadingZeros = TRUE)
isco <- isco[, .(code, preferredLabel)]

usethis::use_data(isco, overwrite = TRUE)
