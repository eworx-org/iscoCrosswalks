#' ISCO Crosswalks
#'
#' Go from an ISCO hierarchical level to target higher level.
#' @param dat Input data, with at least a `job` column and a `value` column. Can be of type `data.frame` or `data.table`.
#' @param source Taxonomy of input vector.
#' @param target Taxonomy of output vector.
#' @param aggr Whether or not to aggregate results by `target` taxonomy. Defaults to `TRUE`.
#' @return Table of type `data.table` with `value` column converted from `source` taxonomy to `target` taxonomy.
#' @export
isco_crosswalk <- function(dat, source, target, aggr = TRUE) {
  # due to NSE notes in R CMD check
  NULL -> unique_target -> value -> .
  dat <- data.table(dat)

  setnames(dat, "job", source)
  concord <- isco_concordances(source, target)
  concord[, unique_target := .N, by = source]
  res <- merge(dat, concord, by = source, allow.cartesian = TRUE)
  res[, value := value / unique_target]
  if(aggr) {
    setnames(res, target, "job")
    res <- res[, .(value = sum(value)), by = "job"]
    return(res)
  }
  res[, c(target, names(dat)), with = FALSE]
}
