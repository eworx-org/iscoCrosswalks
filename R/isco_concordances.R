#' ISCO Concordances
#'
#' Get the concordances between a source taxonomy and a target taxonomy.
#' @param source Taxonomy of input vector.
#' @param target Taxonomy of output vector.
#' @return data.table with `source` and `target` columns.
#' @export
isco_concordances <- function(source, target) {
  esco <- data.table(esco)
  res <- esco
  unique(res[, c(source, target), with = FALSE])
}
