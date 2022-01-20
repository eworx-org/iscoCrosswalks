#' Crosswalk
#' 
#' Go from a source taxonomy to a target taxonomy.
#' @param dat Input data, with at least a `job` column and a `count` column. Can be of type `data.frame` or `data.table`.
#' @param source Taxonomy of input vector.
#' @param target Taxonomy of output vector.
#' @param aggr Whether or not to aggregate results by `target` taxonomy. Defaults to `TRUE`.
#' @return Table of type `data.table` with `count` values converted from `source` taxonomy to `target` taxonomy.
#' @export
crosswalk <- function(dat, source, target, aggr = TRUE) {
  # due to NSE notes in R CMD check
  NULL -> unique_target -> count -> .
  dat <- copy(dat)
  
  setnames(dat, "job", source)
  concord <- concordances(source, target)
  concord[, unique_target := .N, by = source]
  res <- merge(dat, concord, by = source, allow.cartesian = TRUE)
  res[, count := count / unique_target]
  if(aggr) {
    setnames(res, target, "job")
    res <- res[, .(count = sum(count)), by = "job"]
    return(res)
  }
  res[, c(target, names(dat)), with = FALSE]
}

#' Concordances
#' 
#' Get the concordances between a source taxonomy and a target taxonomy.
#' @param source Taxonomy of input vector.
#' @param target Taxonomy of output vector.
#' @return data.table with `source` and `target` columns.
#' @export
concordances <- function(source, target) {
  esco <- data.table(esco)
  res <- esco
  unique(res[, c(source, target), with = FALSE])
}
