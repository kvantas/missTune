context("test-impute_median")

test_that("impute_median returns error", {
  x <- month.name
  expect_error(impute_median(x))
})

test_that("impute_median replace NA with median", {
  x <- c(1, 2, 3, NA, 5)
  x_imp <- impute_median(x)
  expect_equal(x_imp[is.na(x)], median(x, na.rm = TRUE))
})
