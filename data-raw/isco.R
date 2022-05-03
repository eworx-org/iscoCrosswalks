library(data.table)

isco <- fread("inst/extdata/ISCOGroups_en.csv", keepLeadingZeros = TRUE)
isco <- isco[, .(code = as.character(code),
                 preferredLabel = as.character(preferredLabel))]

Encoding(levels(isco$preferredLabel)) <- "latin1"

levels(isco$preferredLabel) <- iconv(
  levels(isco$preferredLabel),
  "latin1",
  "UTF-8"
)
usethis::use_data(isco, overwrite = TRUE)
