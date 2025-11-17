library(testthat)
library(openxlsx)
library(withr)

# 1. 함수 기본 기능 체크
test_that("function successfully writes data and returns path invisibly",{
  local_dir=withr::local_tempdir()
  local_file=file.path(local_dir,"test_file.xlsx")

  wb=createWorkbook()
  addWorksheet(wb,"Sheet1")
  writeData(wb,"Sheet1",x="Original Data",startCol=1,startRow=1)
  saveWorkbook(wb,local_file,overwrite=TRUE)

  data_to_push="NEW DATA"

  ## Invisible Return 검증
  returned_val=expect_invisible(
    push_result(file_path=local_file,
                sheet_name="Sheet1",
                startcol=5,
                startrow=10,
                result=data_to_push)
  )
  expect_equal(returned_val,local_file)

  read_new_data=openxlsx::read.xlsx(local_file,
                                    sheet="Sheet1",
                                    colNames=FALSE,
                                    rows=10,
                                    cols=5)

  ## 데이터 입력 기능
  expect_equal(read_new_data[1,1],data_to_push)

  read_old_data=openxlsx::read.xlsx(local_file,
                                    sheet="Sheet1",
                                    colNames=FALSE,
                                    rows=1,
                                    cols=1)
  ## 기존 데이터 유지
  expect_equal(read_old_data[1,1],"Original Data")
})

# 2. 함수 입력값 누락 시 예외 처리 확인
test_that("function stops if required arguments are missing",{
  ## file_path 누락
  expect_error(push_result(),regexp="argument \"file_path\" is missing")

  local_dir=withr::local_tempdir()
  local_file=file.path(local_dir,"temp_for_arg_test.xlsx")
  wb=createWorkbook()
  addWorksheet(wb,"Sheet1")
  saveWorkbook(wb,local_file)

  ## sheet_name 누락
  expect_error(
    push_result(file_path=local_file,startcol=1,startrow=1,result="test"),
    regexp="argument \"sheet_name\" is missing"
  )

  ## startcol 누락
  expect_error(
    push_result(file_path=local_file,sheet_name="Sheet1",startrow=1,result="test"),
    regexp="argument \"startcol\" is missing"
  )

  ## startrow 누락
  expect_error(
    push_result(file_path=local_file,sheet_name="Sheet1",startcol=1,result="test"),
    regexp="argument \"startrow\" is missing"
  )

  ## result 누락
  expect_error(
    push_result(file_path=local_file,sheet_name="Sheet1",startcol=1,startrow=1),
    regexp="argument \"result\" is missing"
  )
})

# 3. 올바르지 않은 파일 경로일 경우
test_that("function stops if file_path does not exist",{
  non_existent_file=file.path("fake_dir_12345","fake_file.xlsx")

  expect_error(
    push_result(file_path=non_existent_file,
                sheet_name="Sheet1",
                startcol=1,
                startrow=1,
                result="test"),
    regexp="File does not exist.",
    fixed=TRUE
  )
})

## 4. 올바르지 않은 sheet 이름일 경우
test_that("function stops if sheet_name does not exist",{
  local_dir=withr::local_tempdir()
  local_file=file.path(local_dir,"base_file.xlsx")

  wb=createWorkbook()
  addWorksheet(wb,"CorrectSheet")
  saveWorkbook(wb,local_file)

  expect_error(
    push_result(file_path=local_file,
                sheet_name="WrongSheet",
                startcol=1,
                startrow=1,
                result="test"),
    regexp="Sheet 'WrongSheet' does not exist.",
    fixed=TRUE
  )
})
