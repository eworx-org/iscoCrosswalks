#' Get ISCO code from label
#'
#' Adds ISCO code for a particular job title
#' @param data, data.frame or data.table with two columns `job` and `value`
#' @param lvl, numeric value indicating the ISCO taxonomy
#'
get_isco_code <- function(data, lvl = 3) {

  stopifnot("job" %in% names(data))
  stopifnot(is.data.table(data))
  stopifnot(between(lvl, 1, 4))

  isco_lookup <- esco[, grepl(lvl, names(esco)), with = FALSE]
  isclabel <- names(isco_lookup)[grep("label", names(isco_lookup))]
  key <- names(isco_lookup)[grep("key", names(isco_lookup))]

  isco_lookup <- isco_lookup[, .(
    job = get(names(isco_lookup)[grep("label", names(isco_lookup))]),
    code = get(names(isco_lookup)[grep("key", names(isco_lookup))])
  )]
  isco_lookup <- unique(isco_lookup)
  merge(data, isco_lookup, all.x = TRUE)

}
