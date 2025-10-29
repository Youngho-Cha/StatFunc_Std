# tests/testthat/test-calc_hazard_ratio.R

# 1. 정상 작동 테스트

## 1.1 출력값 구조
test_that("Output structure is correct for valid inputs",{
  time_event_data=c(10,20,30,40,50,60)
  censored_data=c(1,0,1,1,0,1)
  class_data=c("A","B","A","B","A","B")

  result=calc_hazard_ratio(
    time_event=time_event_data,
    censored=censored_data,
    class=class_data
  )

  ### 반환값은 데이터 프레임인가?
  expect_s3_class(result,"data.frame")

  ### 데이터 프레임에 'ratio' 컬럼이 있는가?
  expect_named(result,"ratio")
})

## 1.2 올바른 산출값이 나오는지 확인
test_that("Calculation is correct for a known simple case",{
  lung_subset=survival::lung[1:10,]
  lung_subset$sex=factor(lung_subset$sex)

  expected_cox=survival::coxph(survival::Surv(time,status-1)~sex,data=lung_subset)
  expected_hr=exp(coef(expected_cox))

  result=calc_hazard_ratio(
    time_event=lung_subset$time,
    censored=lung_subset$status-1,
    class=lung_subset$sex
  )

  expect_equal(result$ratio,as.numeric(expected_hr))
})


# 2. 오류 처리 테스트

test_that("Function stops for invalid inputs as specified",{
  ## 입력값 길이
  expect_error(
    calc_hazard_ratio(c(1,2,3),c(1,1),c("A","B")),
    regexp="must have the same length"
  )
  ## 클래스 하나
  expect_error(
    calc_hazard_ratio(c(1,2),c(1,1),c("A","A")),
    regexp="must contain two distinct groups"
  )
  ## 클래스 2개 초과
  expect_error(
    calc_hazard_ratio(c(1,2,3),c(1,1,1),c("A","B","C")),
    regexp="must contain two distinct groups"
  )

  ### 이벤트 발생 x
  expect_error(
    calc_hazard_ratio(c(1,2,3),c(0,0,0),c("A","B","A"))
  )
})


# 3. 엣지 케이스 테스트

test_that("Handles edge cases like complete separation",{
  ## Complete Separation 케이스
  time_sep=c(10,20,30,40)
  censored_sep=c(1,1,1,1)
  class_sep=c("A","A","B","B")

  result_sep=suppressWarnings({
    calc_hazard_ratio(time_sep,censored_sep,class_sep)
  })

  ## Hazard Ratio가 무한대(Inf)로 발산하는지 확인
  expect_equal(result_sep$ratio,0)
})
