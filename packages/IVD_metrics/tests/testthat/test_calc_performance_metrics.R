
test_that("calc_performance_metrics returns expected structure",{
  actual=c(1,0,1,0,1)
  predicted=c(1,0,1,0,0)
  score=c(0.9,0.2,0.8,0.1,0.4)

  res=calc_performance_metrics(actual,predicted,score)
  expect_type(res,"list")
  expect_true("sensitivity" %in% names(res))
  expect_true("specificity" %in% names(res))
  expect_true("ppv" %in% names(res))
  expect_true("npv" %in% names(res))
  expect_true("accuracy" %in% names(res))
  expect_true("auc" %in% names(res))
})

