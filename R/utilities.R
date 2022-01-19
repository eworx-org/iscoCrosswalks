#' Crosswalk
#' 
#' Go from a source taxonomy to a target taxonomy.
#' @param dat Input data, with at least a `job` column and a `count` column. Can be of type data.frame or data.table.
#' @param source Taxonomy of input vector.
#' @param target Taxonomy of output vector.
#' @return data.table with `job` column converted to target taxonomy and `count` column.
#' @export
crosswalk <- function(dat, source, target) {
  concord <- concordances(source, target)
  concord[, unique_target := .N, by = source]
  res <- merge(dat, concord, by.x = "job", by.y = source,
               allow.cartesian = TRUE)
  res[, count := count / unique_target]
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
  res <- fread("data/esco.csv")
  unique(res[, c(source, target), with = FALSE])
}
