# tests/testthat/test-calc_binary_metrics.R

# 1. 정상 작동 테스트

## 1.1 출력값의 구조 테스트
test_that("Output structure is correct with default options",{

  gt=c(1,1,0,0,1,0)
  pred=c(1,0,0,0,1,1)

  result=calc_binary_metrics(actual=gt,predicted=pred)

  ### 반환값이 리스트인지 확인
  expect_type(result,"list")

  ### 결과 리스트에 기대되어지는 값들이 모두 포함되어있는지 확인
  expected_names=c("confusion_matrix","sensitivity","specificity","ppv","npv","accuracy")
  expect_named(result,expected_names,ignore.order=TRUE)

  ### 혼동행렬이 데이터프레임 형태로 출력되는지 확인
  expect_s3_class(result$confusion_matrix,"data.frame")

  ### 성능지표 값들이 설정한 열들을 모두 가진 데이터프레임 형태로 출력되는지 확인
  expect_s3_class(result$sensitivity,"data.frame")
  expect_named(result$sensitivity,c("value","lower","upper"))
})

## 1.2 출력값이 올바른지 테스트
test_that("Calculations are correct for a known case",{
  gt=c(1,1,0,0,1,0)
  pred=c(1,0,0,0,1,1)

  result=calc_binary_metrics(actual=gt,predicted=pred)

  ### 혼동행렬이 제대로 출력되었는지 테스트
  expected_cf=data.frame(
    pred_pos=c(2,1,3),
    pred_neg=c(1,2,3),
    total=c(3,3,6),
    row.names=c("GT_pos","GT_neg","Total")
  )
  expect_equal(result$confusion_matrix,expected_cf)

  ### Sensitivity
  expect_equal(result$sensitivity$value,2/3)
  ### Specificity
  expect_equal(result$specificity$value,2/3)
  ### PPV
  expect_equal(result$ppv$value,2/3)
  ### NPV
  expect_equal(result$npv$value,2/3)
  ### Accuracy
  expect_equal(result$accuracy$value,4/6)
})

## 1.3 신뢰구간 산출 방법별 테스트
test_that("Function runs correctly with 'wilson' and 'wald' methods",{
  gt=c(1,1,0,0,1,0)
  pred=c(1,0,0,0,1,1)

  ## 'wilson' 메소드가 오류 없이 실행되고 올바른 구조를 반환하는지 확인
  result_wilson=calc_binary_metrics(actual=gt,predicted=pred,ci_method="wilson")
  expect_type(result_wilson,"list")
  expect_named(result_wilson,c("confusion_matrix","sensitivity","specificity","ppv","npv","accuracy"))
  expect_s3_class(result_wilson$sensitivity,"data.frame")

  ## 'wald' 메소드가 오류 없이 실행되고 올바른 구조를 반환하는지 확인
  result_wald=calc_binary_metrics(actual=gt,predicted=pred,ci_method="wald")
  expect_type(result_wald,"list")
  expect_named(result_wald,c("confusion_matrix","sensitivity","specificity","ppv","npv","accuracy"))
  expect_s3_class(result_wald$specificity,"data.frame")
})

# 2. 오류 처리 테스트
test_that("Function stops with an error for invalid inputs",{
  ## 필수 인자(actual/predicted) 누락
  expect_error(
    calc_binary_metrics(predicted=c(0,1)),
    regexp="argument \"actual\" is missing"
  )
  expect_error(
    calc_binary_metrics(actual=c(0,1)),
    regexp="argument \"predicted\" is missing"
  )

  ## 이진 자료가 아닌 것을 입력
  expect_error(
    calc_binary_metrics(actual=c(0,1,2),predicted=c(0,1,1)),
    regexp="must only contain 0 and 1"
  )
  expect_error(
    calc_binary_metrics(actual=c(0,1,0),predicted=c(99,0,1)),
    regexp="must only contain 0 and 1"
  )
})


# 3. 옵션값 처리 테스트
test_that("Function handles invalid option values gracefully",{
  gt=c(1,1,0,0)
  pred=c(1,0,0,1)

  ## 목록에 없는 ci_method 사용
  result_bad_ci=calc_binary_metrics(
    actual=gt,
    predicted=pred,
    ci_method="unsupported_method"
  )
  expect_length(result_bad_ci,1)
  expect_named(result_bad_ci,"confusion_matrix")

  ## 목록에 없는 metrics_to_calc 사용
  result_bad_metric=calc_binary_metrics(
    actual=gt,
    predicted=pred,
    metrics_to_calc="not_a_metric"
  )
  expect_length(result_bad_metric,1)
  expect_named(result_bad_metric,"confusion_matrix")

  ## 선택한 성능지표만 제대로 산출하는지 확인
  result_subset=calc_binary_metrics(
    actual=gt,
    predicted=pred,
    metrics_to_calc=c("accuracy","ppv")
  )
  expect_named(result_subset,c("confusion_matrix","ppv","accuracy"),ignore.order=TRUE)
  expect_length(result_subset,3)
})


# 4. 엣지 케이스 테스트 (Edge Cases)
test_that("Function works correctly with perfect or all-wrong predictions",{
  gt=c(1,1,0,0)

  ## 완벽한 예측
  perfect_pred=c(1,1,0,0)
  result_perfect=calc_binary_metrics(actual=gt,predicted=perfect_pred)
  expect_equal(result_perfect$accuracy$value,1)
  expect_equal(result_perfect$sensitivity$value,1)
  expect_equal(result_perfect$specificity$value,1)

  ## 모두 1로만 예측
  all_pos_pred=c(1,1,1,1)
  result_all_pos=calc_binary_metrics(actual=gt,predicted=all_pos_pred)
  expect_equal(result_all_pos$sensitivity$value,1)
  expect_equal(result_all_pos$specificity$value,0)

  ## 모두 0으로만 예측
  all_neg_pred=c(0,0,0,0)
  result_all_neg=calc_binary_metrics(actual=gt,predicted=all_neg_pred)
  expect_equal(result_all_neg$sensitivity$value,0)
  expect_equal(result_all_neg$specificity$value,1)
})
