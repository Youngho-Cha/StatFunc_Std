
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
#'
#' @section Binary Classification Metrics:
#' This function calculates sensitivity, specificity, positive predictive value (PPV), negative predictive value (NPV), and accuracy. These binary performance metrics are commonly used to evaluate the performance of a classification model for binary outcomes (e.g., 0 or 1). Each metric is calculated using the components of the 2x2 confusion matrix below: True Positives (TP), True Negatives (TN), False Positives (FP), and False Negatives (FN).
#'
#' \strong{Confusion Matrix}
#'
#' \tabular{lcc}{
#'   \strong{} \tab \strong{Predicted: Positive} \tab \strong{Predicted: Negative} \cr
#'   \strong{Actual: Positive} \tab TP (True Positive) \tab FN (False Negative) \cr
#'   \strong{Actual: Negative} \tab FP (False Positive) \tab TN (True Negative) \cr
#' }
#'
#' \strong{Metric Formulas and Descriptions}
#' \describe{
#'   \item{\strong{Sensitivity (True Positive Rate):}}{The proportion of actual positives that were correctly identified by the model.}
#'   \deqn{Sensitivity = \frac{TP}{TP+FN}}
#'   \item{\strong{Specificity (True Negative Rate):}}{The proportion of actual negatives that were correctly identified by the model.}
#'   \deqn{Specificity = \frac{TN}{TN + FP}}
#'   \item{\strong{Positive Predictive Value (PPV):}}{The proportion of true positives among all positive predictions made by the model.}
#'   \deqn{PPV = \frac{TP}{TP + FP}}
#'   \item{\strong{Negative Predictive Value (NPV):}}{The proportion of true negatives among all negative predictions made by the model.}
#'   \deqn{NPV = \frac{TN}{TN + FN}}
#'   \item{\strong{Accuracy:}}{The proportion of correct predictions (both true positives and true negatives) among the total number of cases.}
#'   \deqn{Accuracy = \frac{TP + TN}{TP + TN + FP + FN}}
#' }
#'
#' @section Confidence Interval Calculation:
#' While there are numerous methods to calculate confidence intervals for binary classification metrics, this function implements three widely used approaches: the Clopper-Pearson (exact) method, the Wilson (score) method, and the Wald method.
#'
#' \describe{
#'   \item{\strong{1. Clopper-Pearson (Exact) Interval:}}{
#'   This method is based on inverting the equal-tailed binomial test. It is called an 'exact' method because it guarantees that the confidence level is at least the nominal level (e.g., 95%). The interval is derived from the Beta distribution.
#'   \deqn{(Lower, Upper) = \left( B\left(\frac{\alpha}{2}; x, n-x+1\right), B\left(1-\frac{\alpha}{2}; x+1, n-x\right) \right)}
#'   Where \eqn{x} is the number of successes, \eqn{n} is the total number of trials, and \eqn{B} is the quantile function of the Beta distribution.
#'   \itemize{
#'     \item \strong{Pros:} Guarantees nominal coverage. The interval is always within (0, 1).
#'     \item \strong{Cons:} It is often overly conservative, resulting in wider intervals than necessary.
#'     \item \strong{Use When:} You need a highly reliable, guaranteed-coverage interval, especially with small sample sizes.
#'   }}
#'
#'   \item{\strong{2. Wilson (Score) Interval:}}{
#'   The Wilson score interval is derived from inverting the score test and does not rely on the assumption of a normal approximation for the sample proportion itself. It has better performance, especially for small sample sizes or for proportions near 0 or 1.
#'   \deqn{(Lower, Upper) = \frac{1}{1 + \frac{z^2}{n}} \left( \hat{p} + \frac{z^2}{2n} \pm z\sqrt{\frac{\hat{p}(1-\hat{p})}{n} + \frac{z^2}{4n^2}} \right)}
#'   Where \eqn{\hat{p}} is the sample proportion (\eqn{x/n}) and \eqn{z} is the standard normal quantile for \eqn{1-\alpha/2}.
#'   \itemize{
#'     \item \strong{Pros:} Excellent performance even for small \eqn{n} and extreme proportions. Symmetric in terms of error rates.
#'     \item \strong{Cons:} The formula is more complex to compute manually.
#'     \item \strong{Use When:} It is often recommended as the go-to choice for its balance of accuracy and reliability across various conditions.
#'   }}
#'
#'   \item{\strong{3. Wald Interval:}}{
#'   This is the simplest and most commonly taught method, based on the normal approximation to the binomial distribution.
#'   \deqn{(Lower, Upper) = \hat{p} \pm z \sqrt{\frac{\hat{p}(1-\hat{p})}{n}}}
#'   Where \eqn{\hat{p}} is the sample proportion (\eqn{x/n}) and \eqn{z} is the standard normal quantile for \eqn{1-\alpha/2}.
#'   \itemize{
#'     \item \strong{Pros:} Very easy to understand and calculate.
#'     \item \strong{Cons:} Performs poorly with small sample sizes and when the proportion \eqn{\hat{p}} is close to 0 or 1. The interval can sometimes extend beyond (0, 1).
#'     \item \strong{Use When:} You have a large sample size and the proportion is not near the boundaries of 0 or 1. Due to its poor performance in other cases, it is often not recommended for general use.
#'   }}
#' }
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
