#' Get ISCO code
#'
#' Adds column of ISCO code for a particular job title.
#'
#' @param data, data.frame or data.table with a column named as `job`
#' @param lvl, numeric value indicating the ISCO taxonomy
#'
#' @return data.frame of input data with one extra column named as `code`
#'
get_isco_code <- function(data, lvl = 3) {

  code <- NULL
  isco <- isco

  stopifnot("job" %in% names(data))
  stopifnot(is.data.table(data))
  stopifnot(between(lvl, 1, 4))

  isco_lookup <- isco[nchar(code) == lvl]
  setnames(isco_lookup, c("code", "job"))
  merge(data, isco_lookup, all.x = TRUE)

}
