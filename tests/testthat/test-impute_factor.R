context("test-impute_factor")

test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})

context("test-impute_median")

test_that("impute_factor returns error", {
  x <- month.name
  expect_error(impute_factor(x))
})

test_that("impute_factor replace NA with level with most votes", {
  x <- as.factor(c(1, 2, 2, 2, 3))
  x_na <- x
  x_na[2] <- NA
  x_imp <- impute_factor(x)
  expect_equal(x_imp[is.na(x_na)], x[2])
})
