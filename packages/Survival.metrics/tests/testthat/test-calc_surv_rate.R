# tests/testthat/test-calc_surv_rate.R

# 1. 정상 작동 테스트

## 1.1 출력값 구조 확인
test_that("Output structure and classes are correct for valid inputs",{
  time_event_data=c(10,20,30,40,50,60)
  censored_data=c(1,0,1,1,0,1)
  class_data=factor(c("A","B","A","B","A","B"))

  result=calc_surv_rate(
    time_event=time_event_data,
    time_follow=35,
    censored=censored_data,
    class=class_data
  )

  ### 반환값이 리스트인지 확인
  expect_type(result,"list")

  ### 리스트 구성요소 확인
  expect_named(result,c("class0","class1","p","km"))

  ### 리스트 구성요소별 구조 확인
  expect_s3_class(result$class0,"data.frame")
  expect_s3_class(result$class1,"data.frame")
  expect_s3_class(result$p,"data.frame")
  expect_s3_class(result$km,"survfit")

  ### 결과 데이터프레임 구조 확인
  expect_named(result$class0,c("time","surv_rate","lower","upper"))
  expect_named(result$p,"pval")
})

## 1.2 올바른 값이 산출되는지 확인
test_that("Calculations are correct for a known simple case",{
  time_event_data=c(10,20,30,40)
  censored_data=c(1,1,1,1)
  class_data=factor(c("A","A","B","B"))

  result=calc_surv_rate(
    time_event=time_event_data,
    time_follow=25,
    censored=censored_data,
    class=class_data
  )

  expect_equal(result$class0$surv_rate,0)
  expect_equal(result$class1$surv_rate,1.0)
})

test_that("Calculations are correct for a known simple case",{
  time_event_data=c(10,20,30,40)
  censored_data=c(1,1,1,1)
  class_data=factor(c("B","B","A","A"))

  result=calc_surv_rate(
    time_event=time_event_data,
    time_follow=25,
    censored=censored_data,
    class=class_data
  )

  expect_equal(result$class0$surv_rate,1.0)
  expect_equal(result$class1$surv_rate,0)
})

# 2. 오류 및 예외 처리 테스트

test_that("Function stops for missing or invalid arguments",{
  time_event_data=c(10,20)
  censored_data=c(1,1)
  class_data=factor(c("A","B"))

  ### 필수 인자 누락
  expect_error(calc_surv_rate(time_event=time_event_data,censored=censored_data,time_follow=15))

  ### 입력 벡터 길이 불일치
  expect_error(
    calc_surv_rate(c(10,20,30),25,c(1,1),factor(c("A","B")))
  )

  ### 그룹이 하나만 있는 경우
  expect_error(
    calc_surv_rate(time_event_data,15,censored_data,class=factor(c("A","A")))
  )
  ### 그룹이 2개보다 많은 경우
  expect_error(
    calc_surv_rate(c(10,20,30),15,c(1,1,1),class=factor(c("A","B","C")))
  )
})





