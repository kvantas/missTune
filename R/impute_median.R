#' Median Imputation
#'
#' @description Fills missing values of a numeric vector by using its median
#' value.
#'
#' @param x A numeric vector possibly containing missing values.
#'
#' @return A numeric vector of the same length as \code{x} but without missing
#' values.
#'
#' @export impute_median
#'
#' @examples
#'
#' impute_median(c(NA, 0, 1, 0, 1))
#'
impute_median <- function(x) {

  # check input vector
  test_vector(x)
  assertthat::assert_that(is.numeric(x), msg = "x must be a numeric vector.")

  imp_median(x)
}
