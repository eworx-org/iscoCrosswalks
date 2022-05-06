#' Get SOC code from label
#'
#' Adds column of SOC code for a particular job title. Job titles should be
#' given with the labels defined by SOC.
#'
#' @param data data.table with mandatory column `job`.
#' @param lvl Character string taking values between `soc_1` and `soc_4`.
#'
#' @return data.frame of input data with one extra column named as `code`
#' 
#' @export
get_soc_code <- function(data, lvl = "soc_3") {

  soc_groups <- soc_groups
  soc_label <- code <- NULL

  stopifnot("job" %in% names(data))
  stopifnot(is.data.table(data))
  stopifnot(lvl %in% paste0("soc_", 1:4))

  soc_lookup <- soc_groups[, list(
    code = get(lvl),
    job = soc_label
  )]

  soc_lookup <- unique(soc_lookup[!is.na(code)])
  merge(data, soc_lookup, all.x = TRUE)

}
