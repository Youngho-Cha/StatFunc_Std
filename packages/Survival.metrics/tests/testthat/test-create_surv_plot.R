# tests/testthat/test-create_surv_plot.R

# 1. 정상 작동 테스트 (Happy Path)

test_that("Plot is created successfully at the specified file path",{
  km_fit=survfit(Surv(time,status)~sex,data=survival::lung)

  temp_path=tempfile(fileext=".png")

  create_surv_plot(
    km_res=km_fit,
    filepath=temp_path,
    title="Survival Curve",
    x="Time",
    y="Survival Probability",
    legend_title="Sex",
    legend_labels=c("Male","Female")
  )

  ## 지정된 경로에 파일이 실제로 생성되었는지 확인
  expect_true(file.exists(temp_path))
})


# 2. 오류 처리 테스트 (Error & Exception Handling)

test_that("Function stops for invalid inputs as specified",{
  km_fit=survfit(Surv(time,status)~sex,data=survival::lung)

  ## 유효하지 않은 km_res 객체 (survfit이 아닌 경우)
  expect_error(
    create_surv_plot(km_res=data.frame(a=1),filepath="a.png","t","x","y","l","l")
  )

  ## strata 정보가 없는 km_res 객체
  km_fit_no_strata=survfit(Surv(time,status)~1,data=survival::lung)
  expect_error(
    create_surv_plot(km_res=km_fit_no_strata,filepath="a.png","t","x","y","l","l")
  )

  ## legend_labels 개수가 맞지 않는 경우
  expect_error(
    create_surv_plot(km_res=km_fit,filepath="a.png","t","x","y","l",legend_labels="OneLabelOnly")
  )

  ## 존재하지 않는 디렉토리 경로
  expect_error(
    create_surv_plot(km_res=km_fit,filepath="non_existent_dir/plot.png","t","x","y","l",c("M","F"))
  )
})
