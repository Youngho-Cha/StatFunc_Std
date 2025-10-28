# tests/testthat/test-calc_freq_rate.R

# 1. 정상 작동 테스트

## 1.1 출력값 구조 확인
test_that("Output structure is correct for valid inputs",{
  time_event_data=c(10,20,30,40,50,60)
  censored_data=c(1,0,1,1,0,1)
  class_data=factor(c("A","B","A","B","A","B"))
  time_vec=c(15,35,55)

  result=calc_freq_rate(
    time_event=time_event_data,
    time_vector=time_vec,
    censored=censored_data,
    class=class_data
  )

  ### 반환값이 리스트인지 확인
  expect_type(result,"list")

  ### 리스트에 3개의 기대 요소가 모두 포함되어있는지 확인
  expect_named(result,c("class0","class1","km"))

  ### 각 요소의 클래스가 정확한지 확인
  expect_s3_class(result$class0,"data.frame")
  expect_s3_class(result$km,"survfit")

  ### 결과 데이터프레임의 컬럼이 정확한지 확인
  expect_named(result$class0,c("time","freq","rate"))
})

## 1.2 산출값 확인
test_that("Calculations are correct for a known simple case",{
  time_event_data=c(10,20,30,40)
  censored_data=c(1,1,1,1)
  class_data=factor(c("A","A","B","B"))
  time_vec=c(15,35)

  result=calc_freq_rate(time_event_data,time_vec,censored_data,class_data)

  expected_class0=data.frame(time=time_vec,freq=c(1,2),rate=c(0.5,1.0))
  expect_equal(result$class0,expected_class0)

  expected_class1=data.frame(time=time_vec,freq=c(0,1),rate=c(0.0,0.5))
  expect_equal(result$class1,expected_class1)
})


# 2. 오류 처리 테스트

test_that("Function stops for invalid inputs as specified",{
  ## 입력값 길이 다름
  expect_error(
    calc_freq_rate(c(1,2,3),c(10),c(1,1),c("A","B")),
    regexp="must have the same length"
  )
  ## 클래스가 두 개가 아님
  expect_error(
    calc_freq_rate(c(1,2),c(10),c(1,1),c("A","A")),
    regexp="must contain two distinct groups"
  )

  ## time_vector 값 누락
  expect_error(
    calc_freq_rate(c(1,2),vector("numeric"),c(1,1),c("A","B"))
  )
})


# 3. 엣지 케이스 테스트

test_that("Handles time_vector with a timepoint before the first event",{
  time_event_data=c(10,20,30,40)
  censored_data=c(1,1,1,1)
  class_data=factor(c("A","A","B","B"))

  ## time_vector에 첫 이벤트 이전의 시간이 포함된 경우
  time_vec_early=c(5,15)
  result_early=calc_freq_rate(time_event_data,time_vec_early,censored_data,class_data)

  ## time=5 시점에는 누적 이벤트가 0이어야 함
  expect_equal(result_early$class0$freq,c(0,1))
})
