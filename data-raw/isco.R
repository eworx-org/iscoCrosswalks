library(data.table)

isco <- fread("inst/extdata/ISCOGroups_en.csv", keepLeadingZeros = TRUE)
isco <- isco[, .(code = as.character(code),
                 preferredLabel = as.factor(preferredLabel))]

Encoding(levels(isco$preferredLabel)) <- "latin1"

levels(isco$preferredLabel) <- iconv(
  levels(isco$preferredLabel),
  "latin1",
  "UTF-8"
)
vroom::gues("inst/extdata/ISCOGroups_en.csv")

usethis::use_data(isco, overwrite = TRUE)
