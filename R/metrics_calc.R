
#'Calculate diagnostic performance metrics
#'
#' @param actual Vectors of actual values(0=negative, 1=positive)
#' @param predicted Vector of predicted binary labels
#' @param score Optional probability scores for AUC
#' @param metrics_to_calc Character vector of metrics to calculate
#' @param ci_method_binary Select method to calculate CI for sn,sp,ppv,npv,acc
#' @param ci_method_auc Select method to calculate CI for AUC
#' @param alpha type I error
#' @param boot_n The number of Bootstrap sampling
#'
#' @importFrom epiR epi.tests
#' @importFrom pROC roc auc ci.auc
#'
#' @return A named list of calculated performance metrics, confusion matrix, result of pROC::roc
#' @export
calc_performance_metrics=function(actual,predicted,score=NULL,
                                  metrics_to_calc=c("sensitivity","specificity",
                                                    "ppv","npv","accuracy","auc"),
                                  ci_method_binary="cp",
                                  ci_method_auc="delong",
                                  alpha=0.05,
                                  boot_n=2000){
  result=list()

  tab=table(factor(predicted,levels=c(1,0)),
            factor(actual,levels=c(1,0)))
  colnames(tab)=c("Actual_pos","Actual_neg")
  rownames(tab)=c("Pred_pos","Pred_neg")
  result$confusion_matrix=tab

  if(ci_method_binary=="cp"){
    epi_result=epiR::epi.tests(tab,conf.level=0.95)
    epi_result=summary(epi_result)

    if("sensitivity" %in% metrics_to_calc)
      result$sensitivity=epi_result[epi_result$statistic=="se",-1]
    if("specificity" %in% metrics_to_calc)
      result$specificity=epi_result[epi_result$statistic=="sp",-1]
    if("ppv" %in% metrics_to_calc)
      result$ppv=epi_result[epi_result$statistic=="pv.pos",-1]
    if("npv" %in% metrics_to_calc)
      result$npv=epi_result[epi_result$statistic=="pv.neg",-1]
    if("accuracy" %in% metrics_to_calc)
      result$accuracy=epi_result[epi_result$statistic=="diag.ac",-1]
  }

  if(ci_method_binary=="wilson"){
    epi_result=epiR::epi.tests(tab,conf.level=0.95)
    epi_tp=as.numeric(epi_result$tab[1,1])
    epi_fp=as.numeric(epi_result$tab[1,2])
    epi_fn=as.numeric(epi_result$tab[2,1])
    epi_tn=as.numeric(epi_result$tab[2,2])

    epi_result=summary(epi_result)

    if("sensitivity" %in% metrics_to_calc){
      se_val=epi_result[epi_result$statistic=="se","est"]
      se_ci=calculate_wilson_ci(alpha,(epi_tp+epi_fn),se_val)
      se_lower=se_ci$lower
      se_upper=se_ci$upper

      result$sensitivity=c(est=se_val,lower=se_lower,upper=se_upper)
    }
    if("specificity" %in% metrics_to_calc){
      sp_val=epi_result[epi_result$statistic=="sp","est"]
      sp_ci=calculate_wilson_ci(alpha,(epi_tn+epi_fp),sp_val)
      sp_lower=sp_ci$lower
      sp_upper=sp_ci$upper

      result$specificity=c(est=sp_val,lower=sp_lower,upper=sp_upper)
    }
    if("ppv" %in% metrics_to_calc){
      ppv_val=epi_result[epi_result$statistic=="pv.pos","est"]
      ppv_ci=calculate_wilson_ci(alpha,(epi_tp+epi_fp),ppv_val)
      ppv_lower=ppv_ci$lower
      ppv_upper=ppv_ci$upper

      result$ppv=c(est=ppv_val,lower=ppv_lower,upper=ppv_upper)
    }
    if("npv" %in% metrics_to_calc){
      npv_val=epi_result[epi_result$statistic=="pv.neg","est"]
      npv_ci=calculate_wilson_ci(alpha,(epi_tn+epi_fn),npv_val)
      npv_lower=npv_ci$lower
      npv_upper=npv_ci$upper

      result$npv=c(est=npv_val,lower=npv_lower,upper=npv_upper)
    }
    if("accuracy" %in% metrics_to_calc){
      accuracy_val=epi_result[epi_result$statistic=="diag.ac","est"]
      accuracy_ci=calculate_wilson_ci(alpha,length(actual),accuracy_val)
      accuracy_lower=accuracy_ci$lower
      accuracy_upper=accuracy_ci$upper

      result$accuracy=c(est=accuracy_val,lower=accuracy_lower,upper=accuracy_upper)
    }
  }

  if(ci_method_binary=="wald"){
    epi_result=epiR::epi.tests(tab,conf.level=0.95)
    epi_tp=as.numeric(epi_result$tab[1,1])
    epi_fp=as.numeric(epi_result$tab[1,2])
    epi_fn=as.numeric(epi_result$tab[2,1])
    epi_tn=as.numeric(epi_result$tab[2,2])

    epi_result=summary(epi_result)

    if("sensitivity" %in% metrics_to_calc){
      se_val=epi_result[epi_result$statistic=="se","est"]
      se_ci=calculate_wald_ci(alpha,(epi_tp+epi_fn),se_val)
      se_lower=se_ci$lower
      se_upper=se_ci$upper

      result$sensitivity=c(est=se_val,lower=se_lower,upper=se_upper)
    }
    if("specificity" %in% metrics_to_calc){
      sp_val=epi_result[epi_result$statistic=="sp","est"]
      sp_ci=calculate_wald_ci(alpha,(epi_tn+epi_fp),sp_val)
      sp_lower=sp_ci$lower
      sp_upper=sp_ci$upper

      result$specificity=c(est=sp_val,lower=sp_lower,upper=sp_upper)
    }
    if("ppv" %in% metrics_to_calc){
      ppv_val=epi_result[epi_result$statistic=="pv.pos","est"]
      ppv_ci=calculate_wald_ci(alpha,(epi_tp+epi_fp),ppv_val)
      ppv_lower=ppv_ci$lower
      ppv_upper=ppv_ci$upper

      result$ppv=c(est=ppv_val,lower=ppv_lower,upper=ppv_upper)
    }
    if("npv" %in% metrics_to_calc){
      npv_val=epi_result[epi_result$statistic=="pv.neg","est"]
      npv_ci=calculate_wald_ci(alpha,(epi_tn+epi_fn),npv_val)
      npv_lower=npv_ci$lower
      npv_upper=npv_ci$upper

      result$npv=c(est=npv_val,lower=npv_lower,upper=npv_upper)
    }
    if("accuracy" %in% metrics_to_calc){
      accuracy_val=epi_result[epi_result$statistic=="diag.ac","est"]
      accuracy_ci=calculate_wald_ci(alpha,length(actual),accuracy_val)
      accuracy_lower=accuracy_ci$lower
      accuracy_upper=accuracy_ci$upper

      result$accuracy=c(est=accuracy_val,lower=accuracy_lower,upper=accuracy_upper)
    }
  }

  if("auc" %in% metrics_to_calc){
    if(!is.null(score)){
      auc_result=pROC::roc(actual,score)
    }
    else{
      auc_result=pROC::roc(actual,predicted)
    }

    auc_value=as.numeric(pROC::auc(auc_result))

    if(ci_method_auc=="delong")
      auc_ci=pROC::ci.auc(auc_result)
    if(ci_method_auc=="bootstrap")
      auc_ci=pROC::ci.auc(auc_result,method="bootstrap",boot.n=boot_n)

    result$auc=c(est=auc_value,lower=as.numeric(auc_ci[1]),upper=as.numeric(auc_ci[3]))
    result$auc_result=auc_result
  }
  return(result)
}

