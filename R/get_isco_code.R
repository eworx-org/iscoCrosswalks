#' Get ISCO code from label
#'
#' Adds column of ISCO code for a particular job title. Job titles should be
#' given in the preferred label of the ISCO classification.
#'
#' @param data data.table with mandatory column `job`.
#' @param lvl Integer value between 1 and 4 indicating the level of the ISCO hierarchy.
#'
#' @return data.table of input data with one extra column named as `code`
#' @examples
#' library(iscoCrosswalks)
#' library(data.table)
#' 
#' # add mandatory column
#' dat <- foundation_skills[, .(job = preferredLabel, Skill, Value)]
#' res <- get_isco_code(dat, lvl = 1)
#' head(res[, .(code, Skill, Value)])
#' @export
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
