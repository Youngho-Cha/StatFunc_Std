
test_that("generate_test_data creates correct output structure",{
  test_data=generate_test_data(N=300,prevalence=0.5)

  expect_true(is.list(test_data))
  expect_true(all(c("actual","predicted","score") %in% names(test_data)))
  expect_equal(length(test_data$actual),300)
  expect_equal(length(test_data$predicted),300)
  expect_equal(length(test_data$score),300)
})
