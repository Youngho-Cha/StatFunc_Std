
#' Format performance metrics into a data frame
#'
#' @param metrics A list of metric results returned by calc_performance_metrics
#'
#' @importFrom dplyr bind_rows
#'
#' @return A data.frame with columns: Metric, Estimate, Lower_95_CI, Upper_95_CI
#' @export
format_performance_output=function(metrics){
  metric_names=setdiff(names(metrics),c("confusion_matrix","auc_result"))

  rows=list()

  for(m in metric_names){
    values=metrics[[m]]
    est_val=values["est"]
    lower_val=values["lower"]
    upper_val=values["upper"]

    row=as.data.frame(list(
      Metric=as.character(m),
      Estimate=as.numeric(est_val),
      Lower_95_CI=as.numeric(lower_val),
      Upper_95_CI=as.numeric(upper_val)
    ),stringAsFactors=FALSE) # 4.0.0 버전 이하의 R을 사용할 때를 대비

    rows[[m]]=row
  }
  df=bind_rows(rows)
  rownames(df)=NULL
  return(df)
}

