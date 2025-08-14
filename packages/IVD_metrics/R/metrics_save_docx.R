
#' Save performance metrics to docx
#'
#' @param results_df A data.frame created by format_performance_output()
#' @param original_result A list created by calc_performance_metrics()
#' @param outdir Output directory (default: "results")
#' @param filename Optional filename (auto-named if NULL)
#'
#' @importFrom pROC plot.roc
#' @importFrom tidyr pivot_wider
#' @importFrom flextable flextable align fontsize set_table_properties width delete_part body_add_flextable
#' @importFrom officer read_docx body_add_par body_add_img
#' @importFrom dplyr %>%
#' @importFrom utils capture.output
#' @importFrom grDevices dev.off png
#'
#' @return The file path where the report was saved
#' @export
save_performance_report_docx=function(results_df,
                                      original_result,
                                      outdir="results",
                                      filename=NULL){
  if(!dir.exists(outdir))
    dir.create(outdir,recursive=TRUE)

  timestamp=format(Sys.time(),"%Y%m%d_%H%M")
  if(is.null(filename)){
    filename=paste0("performance_",timestamp,".docx")
  }
  filepath=file.path(outdir,filename)

  if("auc" %in% results_df$Metric){
    roc_img_path=file.path(outdir,paste0("roc_",timestamp,".png"))
    png(filename=roc_img_path,width=800,height=600)
    plot.roc(original_result$auc_result,
             print.auc=TRUE,
             print.auc.col="red",
             print.thres=TRUE,
             print.thres.pch=19,
             print.thres.col="red",
             ci=TRUE,
             ci.type="bars",
             grid=c(0.2,0.2))
    dev.off()
  }

  cm=as.data.frame(original_result$confusion_matrix) %>%
    pivot_wider(names_from=Var1,values_from=Freq)
  colnames(cm)[1]=""
  cm=as.data.frame(cm)
  cm$Total=rowSums(cm[,c("Pred_pos","Pred_neg")])
  colnames(cm)[1]=paste("Actual \\ predict")

  m_df=data.frame(
    Metrics= paste(results_df$Metric,"(","%",")"),
    description="95% CI[LB,UB]",
    value=paste(results_df$Estimate*100,"[",
                results_df$Lower_95_CI*100,",",
                results_df$Upper_95_CI*100,"]")
  )

  ft_cm=flextable(cm) %>%
    align(align="center",part="all") %>%
    fontsize(size=10,part="all") %>%
    set_table_properties(layout="autofit",width=1) %>%
    width(j=1:ncol(cm),width=2)

  ft_mdf=flextable(m_df)  %>%
    delete_part(part="header") %>%
    align(align="center",part="all") %>%
    fontsize(size=10,part="all") %>%
    set_table_properties(layout="autofit",width=1) %>%
    width(j=1:ncol(m_df),width=2)

  if("auc" %in% results_df$Metric){
    doc=officer::read_docx()

    doc=body_add_par(doc,"Result table",style="heading 1")
    doc=body_add_flextable(doc,ft_cm)

    doc=body_add_par(doc,"",style="Normal")
    doc=body_add_flextable(doc,ft_mdf)

    doc=body_add_par(doc,"ROC Curve",style="heading 1")
    doc=body_add_img(doc,src=roc_img_path,width=6,height=4)

    print(doc,target=filepath)
    message("Word report saved to: ",filepath)

    return(filepath)
  }

  if(!("auc" %in% results_df$Metric)){
    doc=officer::read_docx()

    doc=body_add_par(doc,"Result table",style="heading 1")
    doc=body_add_flextable(doc,ft_cm)

    doc=body_add_par(doc,"",style="Normal")
    doc=body_add_flextable(doc,ft_mdf)

    print(doc,target=filepath)
    message("Word report saved to: ",filepath)

    return(filepath)
  }
}
