# tests/testthat/test-calc_c_index.R

# 1. 정상 작동 테스트 (Happy Path)

test_that("Output structure is correct for valid inputs",{
  time_event_data=c(10,20,30,40,50,60)
  censored_data=c(1,0,1,1,0,1)
  class_data=c(2.5,1.1,3.4,0.5,1.8,2.2)

  result=calc_c_index(
    time_event=time_event_data,
    censored=censored_data,
    class=class_data
  )

  ## 반환값은 데이터 프레임인가?
  expect_s3_class(result,"data.frame")

  ## 데이터 프레임에 기대 컬럼이 모두 있는가?
  expect_named(result,c("C_index","lower","upper"))

  ## 결과는 단일 행인가?
  expect_equal(nrow(result),1)
})


# 2. 오류 처리 테스트 (Error & Exception Handling)

test_that("Function stops for invalid inputs as specified",{
  ## 필수 인자 누락
  expect_error(
    calc_c_index(time_event=c(1,2),censored=c(1,1))
  )

  ## 입력 벡터 길이 불일치
  expect_error(
    calc_c_index(time_event=c(1,2,3),censored=c(1,1),class=c(1,2,3)),
    regexp="must have the same length"
  )

  ## 이벤트가 없는 경우
  expect_error(
    calc_c_index(c(1,2,3),c(0,0,0),c(1,2,3))
  )

  ## 예측 변수의 분산이 0인 경우
  expect_error(
    calc_c_index(c(1,2,3),c(1,1,1),c(5,5,5))
  )
})


# 3. 엣지 케이스 테스트 (Edge Cases)

test_that("Handles edge cases like complete separation",{
  ## Complete Separation 케이스
  time_sep=c(10,20,100,110)
  censored_sep=c(1,1,0,0)
  class_sep=c(100,110,5,6)

  result_sep=suppressWarnings({
    calc_c_index(time_sep,censored_sep,class_sep)
  })

  expect_true(is.na(result_sep$C_index))
})
