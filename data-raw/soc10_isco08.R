library(haven)

soc_isco_10 <-
  read_dta("data-raw/stata_dset/onetsoc_to_isco_cws_ibs/soc10_isco08.dta") %>%
  data.table()

soc_isco_10[, isco08 := fifelse(nchar(isco08) == 3,
                                paste0("0", isco08),
                                as.character(isco08))]

for(j in seq_along(soc_isco_10)) {
  set(soc_isco_10, j = j, value = as.character(soc_isco_10[[j]]))
}

onet_10_19 <- readxl::read_xlsx(
  "data-raw/onet_classification/OccupationalListings/Crosswalks/2010_to_2019_Crosswalk.xlsx",
  col_names = TRUE,
  skip = 3
) %>%
  data.table()

onet_10 <- onet_10_19[, c(1, 2)] %>%
  setnames(c("code", "soc_label")) %>%
  data.table()

soc_10 <- onet_10[grep("\\.00", code), ] %>%
  unique()

soc_10[, soc10 := gsub("\\..*", "", code)]
soc_10[, soc10 := gsub("-", "", soc10)]

soc_isco_10_labs <- merge(soc_isco_10, soc_10[, .(soc10, soc_label)])

isco_4 <- esco[, .(isco08 = as.character(isco_4_key),
                   isco_label = isco_4_label)] %>%
  unique()

soc10_isco08 <- merge(soc_isco_10_labs, isco_4, by = "isco08")
soc10_isco08[nchar(isco08) == 3, isco08 := paste0("0", isco08)]
soc10_isco08 <- soc10_isco08[ , .(soc10, isco08, soc_label, isco_label)]

usethis::use_data(soc10_isco08, overwrite = TRUE)


