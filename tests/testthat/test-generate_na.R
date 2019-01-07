context("test-generate_na")

test_that("generate_na return errors", {
  x <- 1:10
  expect_error(generate_na(x))
})

test_that("generate_na create na values", {
  x <- 1:100
  x_na <- generate_na(as.data.frame(x))
  expect_true(any(is.na(x_na$x)))

})
