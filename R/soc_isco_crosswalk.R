soc_isco_crosswalk <- function(data,
                               soc_lvl,
                               isco_lvl,
                               brkd_col = NULL,
                               indicator = FALSE) {

  mandatory_cols <- c("job", "value")

  stopifnot("Unknown ISCO level" = between(isco_lvl, 1 , 3))
  stopifnot("Unknown soc level" = soc_lvl %in% paste0("soc_", 1:4))
  stopifnot(all(mandatory_cols %in% names(data)))
  stopifnot(is.null(brkd_col) || isTRUE(brkd_col %in% names(data)))

  soc_lookup <- soc_groups[, .(code = get(soc_lvl), soc_label)][!is.na(code)]

  if (!all(data[, job] %in% soc_lookup[, soc_label]))
    stop(paste0("There are job labels that not exist in given SOC group"))

  dat <- merge(data, soc_lookup, by.x = "job", by.y = "soc_label")

  soc_isco <- soc10_isco08[, .(soc10, isco08)]

  switch (soc_lvl,
    soc_1 = soc_isco[, soc10 := paste0(substr(soc10, 1, 2), "0000")],
    soc_2 = soc_isco[, soc10 := paste0(substr(soc10, 1, 4), "00")],
    soc_3 = soc_isco[, soc10 := paste0(substr(soc10, 1, 5), "0")]
  )

  cross_data <- merge(
    dat,
    soc_isco,
    by.x = "code",
    by.y = "soc10"
  )

  if(isFALSE(indicator)) {
    cross_data[, count_leaves := .N, by = c(brkd_col, "code")]
    cross_data[, value := value / count_leaves]
    cross_data <- cross_data[, .(value = sum(value, na.rm = TRUE)),
                             by = c(brkd_col, "isco08")]
  } else {
    cross_data <- cross_data[, .(value = mean(value, na.rm = TRUE)),
                             by = c(brkd_col, "isco08")]
  }

  cross_data[, isco08 := substr(isco08, 1, isco_lvl)]

  if(isFALSE(indicator)) {
    cross_data <- cross_data[, .(value = sum(value, na.rm = TRUE)),
                             by = c(brkd_col, "isco08")]
  } else {
    cross_data <- cross_data[, .(value = mean(value, na.rm = TRUE)),
                             by = c(brkd_col, "isco08")]
  }

  merge(cross_data, isco, by.x = "isco08", by.y = "code", all.x = TRUE)[
    , c("isco08", "preferredLabel", brkd_col, "value"), with = FALSE][
      order(-value)]

}