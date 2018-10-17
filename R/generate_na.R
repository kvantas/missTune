#' Adds Missing Values to a Data Set
#'
#' @description Takes a \code{data.frame} or a \code{tibble} and replaces
#' randomly part of the values by missing values.
#'
#' @param x \code{data.frame} or \code{tibble}.
#' @param p Proportion of missing values to approximately add to each column of
#' \code{x}. Default value is 0.1.
#' @param seed An integer seed.
#'
#' @return \code{x} with missing values.
#'
#' @export generate_na
#'
#' @examples
#'
#' head(generate_na(iris))
#'
generate_na <- function(x, p = 0.1, seed = NULL) {
  assertthat::assert_that(assertthat::is.number(p), p > 0 & p < 1,
                          msg = "p must in (0, 1)")
  assertthat::assert_that(is.data.frame(x))

  variables <- names(x)
  n <- NROW(x)
  for (v in variables) {
    na_index <- sample(1:n, round(n * p))
    x[na_index, v] <- NA
  }
  x

}
