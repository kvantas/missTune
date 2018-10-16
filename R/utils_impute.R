#' Impute numeric vectors with its median value
#' @noRd
imp_median <- function(x) {

  na_flag <- is.na(x)

  if (any(na_flag)) {
    x[na_flag] <- median(x, na.rm = TRUE)
  }

  x
}

#' Impute a vector univariate
#' @noRd
imp_uni <- function(x) {

    na_flag <- is.na(x)

  if (any(na_flag)) {
    x[na_flag] <- sample(x[!na_flag], sum(na_flag), replace = TRUE)
  }

  x
}

#' Impute a factor vector using the majority rule
#' @noRd
imp_factor <- function(x) {

  na_flag <- is.na(x)

  # omit NAs
  x_omit <- na.omit(x)

  # votes of maximum level exluding NAs
  count_levels <- table(x_omit)
  max_level <- max(count_levels)

  # sample level asign and impute missing values
  level_asign <- sample(names(which(count_levels == max_level)), 1)
  x[na_flag] <- level_asign
  x
}
