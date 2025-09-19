
#'Calculate binary performance metrics
#'
#' @param actual Vectors of actual values(0=negative, 1=positive)
#' @param predicted Vector of predicted binary labels
#' @param metrics_to_calc Character vector of metrics to calculate
#' @param ci_method Select method to calculate CI
#' @param alpha type I error
#'
#' @importFrom epiR epi.tests
#'
#' @return A named list of data frame which contains calculated performance metrics and 2X2 confusion matrix
#' @export
calc_binary_metrics=function(actual,predicted,
                             metrics_to_calc=c("sensitivity","specificity",
                                               "ppv","npv","accuracy"),
                             ci_method="cp",
                             alpha=0.05){
  result=list()

  tab=table(factor(predicted,levels=c(1,0)),
            factor(actual,levels=c(1,0)))
  TP=tab[1,1]
  TN=tab[2,2]
  FP=tab[1,2]
  FN=tab[2,1]
  pred_pos=c(TP,FP,sum(TP+FP))
  pred_neg=c(FN,TN,sum(FN+TN))
  total=c(sum(TP+FN),sum(FP+TN),sum(TP+FP+TN+FN))
  cf=data.frame(pred_pos,pred_neg,total)
  rownames(cf)=c("GT_pos","GT_neg","Total")
  result$confusion_matrix=cf

  if(ci_method=="cp"){
    epi_result=epiR::epi.tests(tab,conf.level=0.95)
    epi_result=summary(epi_result)

    if("sensitivity" %in% metrics_to_calc)
      result$sensitivity=data.frame(value=epi_result[epi_result$statistic=="se","est"],
                                    lower=epi_result[epi_result$statistic=="se","lower"],
                                    upper=epi_result[epi_result$statistic=="se","upper"])
    if("specificity" %in% metrics_to_calc)
      result$specificity=data.frame(value=epi_result[epi_result$statistic=="sp","est"],
                                    lower=epi_result[epi_result$statistic=="sp","lower"],
                                    upper=epi_result[epi_result$statistic=="sp","upper"])
    if("ppv" %in% metrics_to_calc)
      result$ppv=data.frame(value=epi_result[epi_result$statistic=="pv.pos","est"],
                            lower=epi_result[epi_result$statistic=="pv.pos","lower"],
                            upper=epi_result[epi_result$statistic=="pv.pos","upper"])
    if("npv" %in% metrics_to_calc)
      result$npv=data.frame(value=epi_result[epi_result$statistic=="pv.neg","est"],
                            lower=epi_result[epi_result$statistic=="pv.neg","lower"],
                            upper=epi_result[epi_result$statistic=="pv.neg","upper"])
    if("accuracy" %in% metrics_to_calc)
      result$accuracy=data.frame(value=epi_result[epi_result$statistic=="diag.ac","est"],
                                 lower=epi_result[epi_result$statistic=="diag.ac","lower"],
                                 upper=epi_result[epi_result$statistic=="diag.ac","upper"])
  }

  if(ci_method=="wilson"){
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

      result$sensitivity=data.frame(value=se_val,lower=se_lower,upper=se_upper)
    }
    if("specificity" %in% metrics_to_calc){
      sp_val=epi_result[epi_result$statistic=="sp","est"]
      sp_ci=calculate_wilson_ci(alpha,(epi_tn+epi_fp),sp_val)
      sp_lower=sp_ci$lower
      sp_upper=sp_ci$upper

      result$specificity=data.frame(value=sp_val,lower=sp_lower,upper=sp_upper)
    }
    if("ppv" %in% metrics_to_calc){
      ppv_val=epi_result[epi_result$statistic=="pv.pos","est"]
      ppv_ci=calculate_wilson_ci(alpha,(epi_tp+epi_fp),ppv_val)
      ppv_lower=ppv_ci$lower
      ppv_upper=ppv_ci$upper

      result$ppv=data.frame(value=ppv_val,lower=ppv_lower,upper=ppv_upper)
    }
    if("npv" %in% metrics_to_calc){
      npv_val=epi_result[epi_result$statistic=="pv.neg","est"]
      npv_ci=calculate_wilson_ci(alpha,(epi_tn+epi_fn),npv_val)
      npv_lower=npv_ci$lower
      npv_upper=npv_ci$upper

      result$npv=data.frame(value=npv_val,lower=npv_lower,upper=npv_upper)
    }
    if("accuracy" %in% metrics_to_calc){
      accuracy_val=epi_result[epi_result$statistic=="diag.ac","est"]
      accuracy_ci=calculate_wilson_ci(alpha,length(actual),accuracy_val)
      accuracy_lower=accuracy_ci$lower
      accuracy_upper=accuracy_ci$upper

      result$accuracy=data.frame(value=accuracy_val,lower=accuracy_lower,upper=accuracy_upper)
    }
  }

  if(ci_method=="wald"){
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

      result$sensitivity=data.frame(value=se_val,lower=se_lower,upper=se_upper)
    }
    if("specificity" %in% metrics_to_calc){
      sp_val=epi_result[epi_result$statistic=="sp","est"]
      sp_ci=calculate_wald_ci(alpha,(epi_tn+epi_fp),sp_val)
      sp_lower=sp_ci$lower
      sp_upper=sp_ci$upper

      result$specificity=data.frame(value=sp_val,lower=sp_lower,upper=sp_upper)
    }
    if("ppv" %in% metrics_to_calc){
      ppv_val=epi_result[epi_result$statistic=="pv.pos","est"]
      ppv_ci=calculate_wald_ci(alpha,(epi_tp+epi_fp),ppv_val)
      ppv_lower=ppv_ci$lower
      ppv_upper=ppv_ci$upper

      result$ppv=data.frame(value=ppv_val,lower=ppv_lower,upper=ppv_upper)
    }
    if("npv" %in% metrics_to_calc){
      npv_val=epi_result[epi_result$statistic=="pv.neg","est"]
      npv_ci=calculate_wald_ci(alpha,(epi_tn+epi_fn),npv_val)
      npv_lower=npv_ci$lower
      npv_upper=npv_ci$upper

      result$npv=data.frame(value=npv_val,lower=npv_lower,upper=npv_upper)
    }
    if("accuracy" %in% metrics_to_calc){
      accuracy_val=epi_result[epi_result$statistic=="diag.ac","est"]
      accuracy_ci=calculate_wald_ci(alpha,length(actual),accuracy_val)
      accuracy_lower=accuracy_ci$lower
      accuracy_upper=accuracy_ci$upper

      result$accuracy=data.frame(value=accuracy_val,lower=accuracy_lower,upper=accuracy_upper)
    }
  }
  return(result)
}
