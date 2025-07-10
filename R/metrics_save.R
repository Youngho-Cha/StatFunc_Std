
#' Save performance metrics to CSV or HTML
#'
#' @param results_df A data.frame created by format_performance_output()
#' @param original_result A list created by calc_performance_metrics()
#' @param outdir Output directory (default: "results")
#' @param filename Optional filename (auto-named if NULL)
#'
#' @importFrom openxlsx createWorkbook addWorksheet writeData insertImage saveWorkbook
#' @importFrom pROC plot.roc
#' @importFrom utils capture.output
#' @importFrom grDevices dev.off png
#'
#' @return The file path where the report was saved
#' @export
save_performance_report=function(results_df,
                                 original_result,
                                 outdir="results",
                                 filename=NULL){
  if(!dir.exists(outdir))
    dir.create(outdir,recursive=TRUE)

  timestamp=format(Sys.time(),"%Y%m%d_%H%M")
  if(is.null(filename)){
    filename=paste0("performance_",timestamp,".xlsx")
  }
  filepath=file.path(outdir,filename)

  roc_img_path=file.path(outdir,paste0("roc_",timestamp,".png"))
  png(filename=roc_img_path,width=800,height=600)
  plot.roc(original_result$auc_result,
           print.auc=TRUE,
           print.auc.col="red",
           print.thres=TRUE,
           print.thres.pch=19,
           print.thres.col="red",
           grid=c(0.2,0.2))
  dev.off()

  conf_matrix_text= capture.output(original_result$confusion_matrix)

  wb=createWorkbook()

  addWorksheet(wb,"metrics")
  writeData(wb,"metrics",results_df,colNames=TRUE,rowNames=FALSE)

  addWorksheet(wb,"confusion_matrix")
  writeData(wb,"confusion_matrix",conf_matrix_text,colNames=FALSE,rowNames=FALSE)

  addWorksheet(wb,"ROC_curve")
  insertImage(wb,"ROC_curve",roc_img_path,startRow=1,startCol=1,width=12,height=7)

  saveWorkbook(wb,filepath,overwrite=TRUE)
  message("Report saved to:",filepath)

  return(filepath)
}
