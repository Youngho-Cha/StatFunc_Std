
#'Calculate diagnostic performance metrics
#'
#' @param actual Vectors of actual values(0=negative, 1=positive)
#' @param predicted Vector of predicted binary labels
#' @param score Optional probability scores for AUC
#' @param ci_method Select method to calculate CI for AUC
#' @param alpha type I error
#' @param boot_n The number of Bootstrap sampling
#'
#' @importFrom pROC roc auc ci.auc
#'
#' @return Data frame which contains calculated auc and result of pROC::roc
#' @export
calc_auc=function(actual,predicted,score=NULL,
                  ci_method_auc="delong",
                  alpha=0.05,
                  boot_n=2000){
  result=list()

  if(ci_method_auc=="delong") auc_result=pROC::roc(actual,score,ci=T)
  if(ci_method_auc=="bootstrap") auc_result=pROC::roc(actual,score,ci=T,ci.method="bootstrap",boot.n=boot_n)

  auc_value=as.numeric(pROC::auc(auc_result))

  if(ci_method_auc=="delong") auc_ci=pROC::ci.auc(auc_result)
  if(ci_method_auc=="bootstrap") auc_ci=pROC::ci.auc(auc_result,method="bootstrap",boot.n=boot_n)

  result$auc=data.frame(value=auc_value,lower=as.numeric(auc_ci[1]),upper=as.numeric(auc_ci[3]))
  result$roc_res=auc_result

  return(result)
}


