
soc_structure_path <- "data-raw/onet_classification/OccupationalListings/2019_Structure/SOC_Structure.xlsx"
soc_structure <- readxl::read_xlsx(soc_structure_path, skip = 3, col_names = TRUE)

soc_structure <- soc_structure %>%
  data.table()

soc_groups <- soc_structure[, .(
  soc_1 = gsub("-", "", `Major Group`),
  soc_2 = gsub("-", "", `Minor Group`),
  soc_3 = gsub("-", "", `Broad Occupation`),
  soc_4 = gsub("-", "", `Detailed Occupation`),
  soc_label = `SOC or O*NET-SOC 2019 Title`
)]

usethis::use_data(soc_groups, overwrite = TRUE)
