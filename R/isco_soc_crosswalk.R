isco_soc_crosswalk <- function(data, indicator = FALSE, soc_lvl = "soc_2") {

  stopifnot("Unknown soc level" = soc_lvl %in% paste0("soc_", 1:4))

  if (!all(data[, job] %in% isco[, preferredLabel]))
    stop(paste0("There are job labels that not exist in ISCO."))

  data <- merge(data, isco, by.x = "job", by.y = "preferredLabel")

  if (data[, uniqueN(nchar(code))] > 1)
    stop("Please provide occupations from the same hierarchical level only.")

  isco_lvl <- data[, unique(nchar(code))]

  isco_soc <- isco08_soc10[, .(isco08, soc10)]
  isco_soc[, isco08 := substr(isco08, 1, isco_lvl)]

  cross_data <- merge(
    data,
    isco_soc,
    by.x = "code",
    by.y = "isco08"
  )

  if(isFALSE(indicator)) {
    cross_data[, count_leaves := .N, by = "code"]
    cross_data[, value := value / count_leaves]
    cross_data <-
      cross_data[, .(value = sum(value, na.rm = TRUE)), by = "soc10"]
  } else {
    cross_data <-
      cross_data[, .(value = mean(value, na.rm = TRUE)), by = "soc10"]
  }

  switch (soc_lvl,
    soc_1 = cross_data[, soc10 := paste0(substr(soc10, 1, 2), "0000")],
    soc_2 = cross_data[, soc10 := paste0(substr(soc10, 1, 4), "00")],
    soc_3 = cross_data[, soc10 := paste0(substr(soc10, 1, 5), "0")]
  )

  if(isFALSE(indicator)) {
    cross_data <-
      cross_data[, .(value = sum(value, na.rm = TRUE)), by = "soc10"]
  } else {
    cross_data <-
      cross_data[, .(value = mean(value, na.rm = TRUE)), by = "soc10"]
  }

  soc_code_label <-
    soc_groups[!is.na(get(soc_lvl)), .(soc10 = get(soc_lvl), soc_label)]

  merge(cross_data, soc_code_label, all.x = TRUE)[
    , .(soc10, soc_label, value)][
      order(-value)]

}
