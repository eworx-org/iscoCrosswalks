#' Get SOC code from label
#'
#' Adds SOC code for a particular job title
#' @param data, data.frame or data.table with two columns `job` and `value`
#' @param lvl, string that can take values from `soc_1` up to `soc_4`
#' @return data.frame of input data with one extra column named as `code`
#'
get_soc_code <- function(data, lvl = "soc_3") {

  stopifnot("job" %in% names(data))
  stopifnot(is.data.table(data))
  stopifnot(lvl %in% paste0("soc_", 1:4))

  soc_lookup <- soc_groups[, .(
    code = get(lvl),
    job = soc_label
  )]

  soc_lookup <- unique(soc_lookup[!is.na(code)])
  merge(data, soc_lookup, all.x = TRUE)

}
