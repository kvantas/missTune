context("test-impute_univariate")


test_that("impute_univariate replace NA's", {
  x <- month.name
  x[2:4] <- NA
  expect_true(all(!is.na(impute_univariate(x))))
})
