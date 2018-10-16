#' Majority Imputation
#'
#' @description Fills missing values of a factor vector by using the majority
#' rule. If there are several levels with the same number of votes, samples one
#' at random  and fills the missing values
#'
#' @param x A factor vector possibly containing missing values.
#'
#' @return A factor vector of the same length as \code{x} but without missing
#' values.
#'
#' @export impute_factor
#'
#' @examples
#'
#' x <- as.factor(c(1,1,2,2,3,3,3))
#' x[3] <- NA
#' impute_factor(x)
#'
impute_factor <- function(x) {

  # check input
  test_vector(x)
  assertthat::assert_that(is.factor(x), msg = "x must be a factor vector.")

  imp_factor(x)

}
