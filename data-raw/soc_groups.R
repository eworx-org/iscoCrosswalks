library(data.table)

soc_structure_path <- "data-raw/onet_classification/soc_structure_2010.xls"
soc_structure <- readxl::read_excel(soc_structure_path, skip = 10, col_names = TRUE)
soc_structure <- soc_structure[-1, ]

soc_structure <- data.table(soc_structure)

soc_groups <- soc_structure[, .(
  soc_1 = gsub("-", "", `Major Group`),
  soc_2 = gsub("-", "", `Minor Group`),
  soc_3 = gsub("-", "", `Broad Group`),
  soc_4 = gsub("-", "", `Detailed Occupation`),
  soc_label = `...5`
)]

usethis::use_data(soc_groups, overwrite = TRUE)
