#' ISCO to SOC crosswalk
#'
#' @description The 2010 Standard Occupational Classification (SOC) and the
#' International Standard Classification of Occupations (ISCO-08) are compared.
#' To make the crosswalk more straightforward and hence more useful, the notion
#' of parsimony was applied. This means that while a task completed in the SOC
#' may appear in numerous ISCOs (or vice versa), the match in some of these
#' instances is just coincidental and adds unneeded complexity. This function
#' allows mapping of data from the top 3 ISCO levels to the 4 SOC groups.
#'
#' @param data, data.table with mandatory columns `job` and `value`
#' @param soc_lvl, character taking values from `soc_1` to `soc_4`
#' @param isco_lvl, numeric between 1 and 3
#' @param brkd_cols, character vector with col names of stratification variables
#' @param indicator, Boolean indicating if data describe an indicator. If `TRUE`
#' the mean value is computed, otherwise the sum by each breakdown group.
#'
#' @export
isco_soc_crosswalk <- function(data,
                               isco_lvl = 3,
                               soc_lvl = "soc_2",
                               brkd_cols = NULL,
                               indicator = FALSE) {

  NULL -> job -> preferredLabel -> code -> isco08 ->
    isco08 -> count_leaves -> value -> soc_label -> soc10

  isco08_soc10 <- isco08_soc10
  soc_groups <- soc_groups

  mandatory_cols <- c("job", "value")

  stopifnot("Unknown soc level" = soc_lvl %in% paste0("soc_", 1:4))
  stopifnot("Mandatory cols job and value are missing" = all(mandatory_cols %in% names(data)))
  stopifnot(is.null(brkd_cols) || isTRUE(all(brkd_cols %in% names(data))))
  stopifnot(between(isco_lvl, 1, 3))

  if (!all(data[, job] %in% isco[, preferredLabel]))
    stop(paste0("There are job labels that not exist in this ISCO lvl."))

  isco <- isco[nchar(code) == isco_lvl]
  data <- merge(data, isco, by.x = "job", by.y = "preferredLabel")

  if (data[, uniqueN(nchar(code))] > 1)
    stop("Please provide occupations from the same hierarchical level only.")

  isco_lvl <- data[, unique(nchar(code))]

  isco_soc <- isco08_soc10[, list(isco08, soc10)]
  isco_soc[, isco08 := substr(isco08, 1, isco_lvl)]

  cross_data <- merge(
    data,
    isco_soc,
    by.x = "code",
    by.y = "isco08",
    allow.cartesian = TRUE
  )

  if(isFALSE(indicator)) {
    cross_data[, count_leaves := .N, by = c(brkd_cols, "code")]
    cross_data[, value := value / count_leaves]
    cross_data <- cross_data[, list(value = sum(value, na.rm = TRUE)),
                             by = c(brkd_cols, "soc10")]
  } else {
    cross_data <- cross_data[, list(value = mean(value, na.rm = TRUE)),
                             by = c(brkd_cols, "soc10")]
  }

  switch (soc_lvl,
    soc_1 = cross_data[, soc10 := paste0(substr(soc10, 1, 2), "0000")],
    soc_2 = cross_data[, soc10 := paste0(substr(soc10, 1, 4), "00")],
    soc_3 = cross_data[, soc10 := paste0(substr(soc10, 1, 5), "0")]
  )

  if(isFALSE(indicator)) {
    cross_data <- cross_data[, list(value = sum(value, na.rm = TRUE)),
                             by = c(brkd_cols, "soc10")]
  } else {
    cross_data <- cross_data[, list(value = mean(value, na.rm = TRUE)),
                             by = c(brkd_cols, "soc10")]
  }

  soc_code_label <-
    soc_groups[!is.na(get(soc_lvl)), list(soc10 = get(soc_lvl), soc_label)]

  merge(cross_data, soc_code_label, all.x = TRUE)[
    , c("soc10", "soc_label", brkd_cols, "value"), with = FALSE][
      order(-value)]

}
