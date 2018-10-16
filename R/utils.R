#' Check if a variable is a vector with at least one non-NA value
#' @noRd
test_vector <- function(x) {
  # check input
  assertthat::assert_that(
    is.atomic(x),
    msg = "x must be a vector possibly containing missing values."
  )
  assertthat::assert_that(
    !all(is.na(x)),
    msg = "x must have at least one non-missing value to run."
  )
}

#' Find applicable variables for imputation
#' @noRd
imputable_variables <- function(data) {

  # fin which vars are numeric or factor and dont have all vulues NA
  tmp <- lapply(data, function(x) {
    (is.numeric(x) | is.factor(x)) & !all(is.na(x))
  })

  # return results as a vector of characters
  tmp <- unlist(tmp)
  names(tmp)[tmp]
}
