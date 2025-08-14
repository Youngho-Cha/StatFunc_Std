
test_that("save_performance_report save csv file correctly",{
  actual=c(1,0,1,0,1)
  predicted=c(1,0,1,0,0)
  score=c(0.9,0.2,0.8,0.1,0.4)

  metrics=calc_performance_metrics(actual,predicted,score)
  formatted=format_performance_output(metrics)

  tmp_dir=tempdir()
  test_filename="test_performance_report.csv"

  filepath=save_performance_report(formatted,metrics,outdir=tmp_dir,filename=test_filename)

  expect_true(file.exists(filepath))

  expect_equal(filepath,file.path(tmp_dir,test_filename))
})
