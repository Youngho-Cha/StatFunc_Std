
#' Write analysis results to a blank SAR template(.xlsx)
#'
#' @param file_path A file path to the blank SAR template
#' @param sheet_name The name of the sheet containing the table to populate
#' @param startcol The starting column letter (e.g., "A", "B") to begin filling values
#' @param startrow The starting row letter (e.g., 1, 2) to begin filling values
#' @param result The analysis result values to be filled
#'
#' @importFrom openxlsx loadWorkbook writeData saveWorkbook
#'
#' @return Invisibly returns the file path to the populated SAR file
#'
#' @export
#'
#' @examples
#' # example code
#'
#' ## 1. Create temporary excel file
#' temp_file=tempfile(fileext=".xlsx")
#' wb=openxlsx::createWorkbook()
#' openxlsx::addWorksheet(wb,"Table1")
#' openxlsx::saveWorkbook(wb,temp_file)
#'
#' ## 2. Example data
#' example_data=data.frame(
#'   value=c(1.7,2.6,3.4),
#'   lower=c(1.3,2.1,2.9),
#'   upper=c(2.4,3.1,4.2)
#' )
#'
#' ## 3. Fill Example data to temporary excel file
#' push_result(
#'   file_path=temp_file,
#'   sheet_name="Table1",
#'   startcol="B",
#'   startrow=3,
#'   result=example_data
#' )
push_result=function(file_path,
                     sheet_name,
                     startcol,
                     startrow,
                     result){
  wb=loadWorkbook(file_path)

  writeData(wb,
            sheet=sheet_name,
            x=result,
            startCol=startcol,
            startRow=startrow,
            colNames=FALSE,
            rowNames=FALSE)

  saveWorkbook(wb,file_path,overwrite=TRUE)

  invisible(file_path)
}
