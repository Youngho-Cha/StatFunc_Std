library(testthat)
library(openxlsx)
library(withr)

# 1. 함수 기본 기능 체크
test_that("function successfully creates an .xlsx file with data and image",{
  local_dir=withr::local_tempdir()
  local_file_path=file.path(local_dir,"test_output.xlsx")

  local_img_path=withr::local_tempfile(tmpdir=local_dir,fileext=".png")
  png(local_img_path,width=4,height=4,units="in",res=72)
  plot(1:10,main="Test Plot")
  dev.off()

  df_test=data.frame(ID=1:5,Value=letters[1:5])
  output_data=list("Sample Data"=df_test,"Sample Plot"=local_img_path)

  ## 생성 메세지가 올바르게 출력되었는지 확인
  expect_message(
    export_xlsx(output_data,local_file_path,sheet_name="MainReport"),
    regexp="성공적으로 .*test_output.xlsx.* 파일에 저장되었습니다.",
    fixed=FALSE
  )

  ## 임시 파일이 성공적으로 생성되었는지 확인
  expect_true(file.exists(local_file_path))

  wb=loadWorkbook(local_file_path)
  ## 엑셀 파일의 sheet 이름이 의도된대로 생성되었는지 확인
  expect_true("MainReport" %in% names(wb))
})

# 2. 함수 입력값 누락 시 예외 처리 확인
test_that("function stops if required arguments are missing",{
  dummy_list=list(a=data.frame(x=1))

  ## output_list 누락
  expect_error(
    export_xlsx(file_path="test.xlsx"),
    regexp="argument \"output_list\" is missing"
  )

  ## file_path 누락
  expect_error(
    export_xlsx(output_list=dummy_list),
    regexp="argument \"file_path\" is missing"
  )
})

# 3. 올바르지 않은 파일 경로일 경우
test_that("function stops if directory in file_path does not exist",{
  invalid_dir=file.path("non_existent_directory_12345","test.xlsx")
  dummy_list=list(a=data.frame(x=1))

  expect_error(
    export_xlsx(dummy_list,invalid_dir),
    regexp="Directory does not exist: 'non_existent_directory_12345'",
    fixed=TRUE
  )
})

# 4. 예외값 처리
test_that("function warns and continues for unsupported/invalid items",{
  local_dir=withr::local_tempdir()
  local_file_path=file.path(local_dir,"warning_test.xlsx")

  list_unsupported=list("BadItem"=1:10)
  expect_warning(
    export_xlsx(list_unsupported,local_file_path),
    regexp="'BadItem' 항목은 지원되지 않는 형식입니다.(건너뜀)",
    fixed=TRUE
  )

  list_bad_path=list("MissingImage"="path/does/not/exist.png")
  expect_warning(
    export_xlsx(list_bad_path,local_file_path),
    regexp="'MissingImage' 항목은 지원되지 않는 형식입니다.(건너뜀)",
    fixed=TRUE
  )

  expect_true(file.exists(local_file_path))
})

# 5. 정상 작동 확인(unnamed list)
test_that("function runs without error for unnamed lists",{
  local_dir=withr::local_tempdir()
  local_file_path=file.path(local_dir,"unnamed_list_test.xlsx")

  unnamed_list=list(
    data.frame(a=1,b=2),
    data.frame(c=3,d=4)
  )

  expect_no_error(
    expect_no_warning(
      expect_message(
        export_xlsx(unnamed_list,local_file_path),
        "성공적으로 .*unnamed_list_test.xlsx.* 파일에 저장되었습니다."
      )
    )
  )

  expect_true(file.exists(local_file_path))
})
## 6. 함수 정상 작동 확인(주요 기능들)
test_that("function correctly handles existing files and sheets",{
  local_dir=withr::local_tempdir()
  local_file_path=file.path(local_dir,"overwrite_test.xlsx")

  list1=list("Data1"=data.frame(col_A=100))
  list2=list("Data2"=data.frame(col_B=200))
  list3=list("Data1_New"=data.frame(col_C=300))

  export_xlsx(list1,local_file_path,sheet_name="Sheet1")
  wb=loadWorkbook(local_file_path)
  expect_true("Sheet1" %in% names(wb))
  expect_false("Sheet2" %in% names(wb))

  export_xlsx(list2,local_file_path,sheet_name="Sheet2")
  wb=loadWorkbook(local_file_path)
  expect_true("Sheet1" %in% names(wb))
  expect_true("Sheet2" %in% names(wb))

  export_xlsx(list3,local_file_path,sheet_name="Sheet1")
  wb=loadWorkbook(local_file_path)

  data_sheet1=openxlsx::read.xlsx(local_file_path,sheet="Sheet1",startRow=2)
  expect_equal(names(data_sheet1)[1],"col_C")
})

