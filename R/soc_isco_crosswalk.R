#' SOC to ISCO crosswalk
#'
#' @description The 2010 Standard Occupational Classification (SOC) and the
#' International Standard Classification of Occupations (ISCO-08) are compared.
#' To make the crosswalk more straightforward and hence more useful, the notion
#' of parsimony was applied. This means that while a task completed in the SOC
#' may appear in numerous ISCOs (or vice versa), the match in some of these
#' instances is just coincidental and adds unneeded complexity. This function
#' allows mapping of data from the 4 SOC groups to the 4 ISCO levels.
#'
#' @param data, data.table with mandatory columns `job` and `value`
#' @param soc_lvl, character taking values from `soc_1` to `soc_4`
#' @param isco_lvl, numeric between 1 and 4
#' @param brkd_cols, character vector with col names of stratification variables
#' @param indicator, Boolean indicating if data describe an indicator. If `TRUE`
#' the mean value is computed, otherwise the sum by each breakdown group.
#' 
#' @returns `data.table` with the estimated values for the requested ISCO
#' occupational level.
#'
#' @examples 
#' library(iscoCrosswalks)
#' library(data.table)
#' #from soc_3 group to ISCO level 1 occupations
#' path <- system.file("extdata", "soc_3_brkdwn_example.csv",
#'                     package = "iscoCrosswalks")
#' dat <- fread(path)
#' soc_isco_crosswalk(dat,
#'                    soc_lvl = "soc_3",
#'                    isco_lvl = 1,
#'                    brkd_cols = "gender")
#' @references
#' \insertRef{hardy2018educational}{iscoCrosswalks}
#'
#' @export
soc_isco_crosswalk <- function(data,
                               soc_lvl,
                               isco_lvl,
                               brkd_cols = NULL,
                               indicator = FALSE) {

  NULL -> job -> preferredLabel -> code -> isco08 ->
    isco08 -> count_leaves -> value -> soc_label -> soc10

  isco08_soc10 <- isco08_soc10
  soc_groups <- soc_groups
  soc10_isco08 <- soc10_isco08
  isco <- isco

  mandatory_cols <- c("job", "value")

  stopifnot("Unknown ISCO level" = between(isco_lvl, 1 , 3))
  stopifnot("Unknown soc level" = soc_lvl %in% paste0("soc_", 1:4))
  stopifnot("Mandatory cols missing" = all(mandatory_cols %in% names(data)))
  stopifnot(is.null(brkd_cols) || isTRUE(all(brkd_cols %in% names(data))))

  soc_lookup <- soc_groups[, list(code = get(soc_lvl), soc_label)][!is.na(code)]

  if (!all(data[, job] %in% soc_lookup[, soc_label]))
    stop(paste0("There are job labels that not exist in given SOC group"))

  dat <- merge(data, soc_lookup, by.x = "job", by.y = "soc_label")

  soc_isco <- soc10_isco08[, list(soc10, isco08)]

  switch (soc_lvl,
    soc_1 = soc_isco[, soc10 := paste0(substr(soc10, 1, 2), "0000")],
    soc_2 = soc_isco[, soc10 := paste0(substr(soc10, 1, 4), "00")],
    soc_3 = soc_isco[, soc10 := paste0(substr(soc10, 1, 5), "0")]
  )

  cross_data <- merge(
    dat,
    soc_isco,
    by.x = "code",
    by.y = "soc10",
    allow.cartesian = TRUE
  )

  if(isFALSE(indicator)) {
    cross_data[, count_leaves := .N, by = c(brkd_cols, "code")]
    cross_data[, value := value / count_leaves]
    cross_data <- cross_data[, list(value = sum(value, na.rm = TRUE)),
                             by = c(brkd_cols, "isco08")]
  } else {
    cross_data <- cross_data[, list(value = mean(value, na.rm = TRUE)),
                             by = c(brkd_cols, "isco08")]
  }

  cross_data[, isco08 := substr(isco08, 1, isco_lvl)]

  if(isFALSE(indicator)) {
    cross_data <- cross_data[, list(value = sum(value, na.rm = TRUE)),
                             by = c(brkd_cols, "isco08")]
  } else {
    cross_data <- cross_data[, list(value = mean(value, na.rm = TRUE)),
                             by = c(brkd_cols, "isco08")]
  }

  merge(cross_data, isco, by.x = "isco08", by.y = "code", all.x = TRUE)[
    , c("isco08", "preferredLabel", brkd_cols, "value"), with = FALSE][
      order(-value)]

}
