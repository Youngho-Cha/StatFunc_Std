# tests/testthat/test-calc_rmst.R

# 1. 정상 작동 테스트

test_that("Output structure is correct for valid inputs",{
  time_event_data=c(10,20,30,40,50,60)
  censored_data=c(1,0,1,1,0,1)
  class_data=c(0,1,0,1,0,1)
  time_f=45

  result=calc_rmst(
    time_event=time_event_data,
    time_follow=time_f,
    censored=censored_data,
    class=class_data
  )

  ## 반환값은 리스트인지 확인인
  expect_type(result,"list")

  ## 리스트에 2개의 기대 요소가 모두 포함되어 있는지 확인
  expect_named(result,c("class0","class1"))

  ## 각 요소의 클래스가 정확한지 확인인
  expect_s3_class(result$class0,"data.frame")

  ## 결과 데이터프레임의 컬럼이 정확한지 확인인
  expected_cols=c("group","rmst","lower","upper")
  expect_named(result$class0,expected_cols)

  ## risk 컬럼 값이 정확한지 확인인
  expect_equal(result$class0$group,"class0")
  expect_equal(result$class1$group,"class1")
})


# 2. 오류 처리 테스트

test_that("Function stops for invalid inputs as specified",{
  ## 필수 인자 누락
  expect_error(
    calc_rmst(time_event=c(1,2),censored=c(1,1),class=c(0,1))
  )

  ## 입력 벡터 길이 불일치
    expect_error(
    calc_rmst(time_event=c(1,2,3),time_follow=10,censored=c(1,1),class=c(0,1))
  )

  ## 그룹이 하나만 있는 경우
  expect_error(
    calc_rmst(time_event=c(1,2),time_follow=10,censored=c(1,1),class=c(0,0))
  )

  ### 그룹이 세 개인 경우
  expect_error(
    calc_rmst(time_event=c(1,2,3),time_follow=10,censored=c(1,1,1),class=c(0,1,2))
  )

  ### 마지막 관측치가 censored일 때 time_follow이 더 긴 경우
  time_event_cens=c(10,20,30,40)
  censored_cens=c(1,1,1,0)
  class_cens=c(0,1,0,1)
  time_f_invalid=50

  expect_error(
    calc_rmst(time_event_cens,time_f_invalid,censored_cens,class_cens)
  )
})
