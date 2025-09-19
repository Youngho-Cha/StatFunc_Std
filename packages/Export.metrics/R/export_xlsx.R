
#' Output the results as a excel file
#'
#' @param output_list A list containing the results to be outputted
#' @param file_path The location and file name to save the file
#' @param sheet_name Sheet name
#'
#' @importFrom openxlsx loadWorkbook createWorkbook removeWorksheet addWorksheet createStyle writeData setColWidths insertImage saveWorkbook
#'
#' @return An Excel file containing the output lists
#' @export
export_xlsx=function(output_list,file_path,sheet_name="Report"){
  if(file.exists(file_path)){
    wb=loadWorkbook(file_path)

    if(sheet_name %in% names(wb)){
      removeWorksheet(wb,sheet_name)
    }
  }else{
    wb=createWorkbook()
  }
  addWorksheet(wb,sheet_name)
  current_row=1

  for(i in 1:length(output_list)){
    item_name=names(output_list)[i]
    item_content=output_list[[i]]

    title_style=createStyle(textDecoration="bold",fontSize=14)
    writeData(wb,sheet=sheet_name,x=item_name,startCol=1,startRow=current_row,headerStyle=title_style)
    current_row=current_row+1

    if(is.data.frame(item_content)){
      writeData(wb,sheet=sheet_name,x=item_content,startCol=1,startRow=current_row,borders="all")
      setColWidths(wb,sheet=sheet_name,cols=1:ncol(item_content),widths="auto")

      current_row=current_row+nrow(item_content)+3

    } else if(is.character(item_content) && file.exists(item_content)){
      insertImage(wb,sheet=sheet_name,file=item_content,startRow=current_row,startCol=1,width=6,height=4,units="in")

      current_row=current_row+22

    } else {
      warning(paste("'",item_name,"' 항목은 지원되지 않는 형식입니다.(건너뜀)",sep=""))
    }
  }
  saveWorkbook(wb,file_path,overwrite=TRUE)
  message(paste("성공적으로 '",file_path,"' 파일에 저장되었습니다.",sep=""))
}
