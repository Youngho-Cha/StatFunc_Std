
test_that("format_performace_output returns a data.frame with expected columns",{
  actual=c(1,0,1,0,1)
  predicted=c(1,0,1,0,0)
  score=c(0.9,0.2,0.8,0.1,0.4)

  res=calc_performance_metrics(actual,predicted,score)
  df=format_performance_output(res)

  expect_s3_class(df,"data.frame")
  expect_true(all(c("Metric","Estimate","Lower_95_CI","Upper_95_CI") %in% names(df)))
})

