# tests/testthat/test-calc_auc.R

# 1. 정상 작동 테스트

## 1.1 출력값의 구조 테스트
test_that("Output structure and classes are correct",{

  gt=c(0,0,1,1,0,1)
  score =c(0.1,0.4,0.35,0.8,0.2,0.6)

  result=calc_auc(actual=gt,score=score)

  ### 반환값이 리스트인지 확인
  expect_type(result,"list")

  ### 결과 리스트에 기대되어지는 값들이 모두 포함되어있는지 확인
  expect_named(result,c("auc","roc_res"))

  ### 'roc_res'가 pROC의 'roc' 객체인지 확인
  expect_s3_class(result$roc_res,"roc")

  ### 성능지표 값들이 설정한 열들을 모두 가진 데이터프레임 형태로 출력되는지 확인
  expect_s3_class(result$auc,"data.frame")
  expect_named(result$auc,c("value","lower","upper"))
})


# 2. 오류 처리 테스트
test_that("Function stops with an error for invalid inputs",{
  ##필수 인자 누락
  expect_error(
    calc_auc(score=c(0.1,0.8)),
    regexp="argument \"actual\" is missing"
  )
  expect_error(
    calc_auc(actual=c(0,1)),
    regexp="argument \"score\" is missing"
  )

  ## 이진 자료가 아닌 것을 입력
  expect_error(
    calc_auc(actual=c(0,1,2),score=c(0.1,0.8,0.5)),
    regexp="must only contain 0 and 1"
  )
})

# 3. 옵션값 처리 테스트
test_that("Function stops with an error for unsupported ci_method",{
  ## 목록에 없는 ci_method 사용
  expect_error(
    calc_auc(actual=c(0,1),score=c(0.1,0.8),ci_method="invalid_method")
  )
})
