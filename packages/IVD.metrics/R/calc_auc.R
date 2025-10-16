
#'Calculate diagnostic performance metrics
#'
#' @param actual Vectors of actual values(0=negative, 1=positive)
#' @param score Probability scores for AUC
#' @param ci_method Select method to calculate CI for AUC(DeLong, Bootstrap)
#' @param alpha type I error
#' @param boot_n The number of Bootstrap sampling
#'
#' @importFrom pROC roc auc ci.auc
#'
#' @return Data frame which contains calculated auc and result of pROC::roc
#'
#' @section Area Under the Curve (AUC) and ROC Curve:
#' The Area Under the Receiver Operating Characteristic Curve (AUC-ROC) is a fundamental tool for evaluating the performance of binary classification models. It provides a single, aggregate measure of performance across all possible classification thresholds.
#'
#' An AUC value represents the model's overall ability to correctly distinguish between the positive and negative classes. It can be interpreted as **the probability that the model will rank a randomly chosen positive instance higher than a randomly chosen negative instance**. A key advantage of AUC is that it is independent of the chosen classification threshold.
#'
#' \strong{The ROC Curve}
#'
#' An ROC curve is a graphical plot that illustrates the diagnostic ability of a binary classifier as its discrimination threshold is varied. It is created by plotting the **True Positive Rate (Sensitivity)** against the **False Positive Rate (1 - Specificity)**.
#'
#' To generate the curve, the model's continuous output (e.g., a probability score) is treated as a threshold. This threshold is varied from its maximum to its minimum value. At each threshold, a confusion matrix is calculated, yielding a new pair of TPR and FPR values, which are then plotted as a point on the curve.
#'
#'
#'
#' The axes are defined as:
#' \itemize{
#'   \item \strong{True Positive Rate (TPR) / Sensitivity (Y-axis):} The proportion of actual positives that are correctly identified as such.
#'   \deqn{TPR = \frac{TP}{TP + FN}}
#'   \item \strong{False Positive Rate (FPR) (X-axis):} The proportion of actual negatives that are incorrectly identified as positive.
#'   \deqn{FPR = \frac{FP}{FP + TN}}
#' }
#'
#' \strong{Calculating and Interpreting AUC}
#'
#' The AUC is the two-dimensional area underneath the entire ROC curve. Numerically, it is calculated by approximating the area using methods like the trapezoidal rule. The value of AUC ranges from 0 to 1, where:
#' \itemize{
#'   \item \strong{AUC = 1:} Represents a perfect classifier. The ROC curve would pass through the top-left corner (0,1), indicating 100% sensitivity and 100% specificity.
#'   \item \strong{AUC = 0.5:} Represents a model with no discriminative ability, equivalent to random guessing. The ROC curve for such a model is a diagonal line from (0,0) to (1,1).
#'   \item \strong{AUC < 0.5:} Represents a model that performs worse than random chance. This often implies that the model's predictions are inverted.
#' }
#' @export
#'
#' @examples
#' # Example Use
#' ## Use default method for calculating confidence interval
#' Ground_Truth=ex_data$gt
#' Score=ex_data$score
#'
#' res_default=calc_auc(actual=Ground_Truth,
#'                      score=Score)
#'
#' res_default_auc=res_default$auc
#'
#' ## Use Bootstrap method for calculating confidence interval
#' Ground_Truth=ex_data$gt
#' Score=ex_data$score
#'
#' res_bootstrap=calc_auc(actual=Ground_Truth,
#'                        score=Score,
#'                        ci_method="bootstrap",
#'                        boot_n=1000)
#'
#' res_bootstrap_auc=res_bootstrap$auc
calc_auc=function(actual,score,
                  ci_method="delong",
                  alpha=0.05,
                  boot_n=2000){

  if (missing(actual)){
    stop("argument \"actual\" is missing, with no default",call.=FALSE)
  }
  if (missing(score)){
    stop("argument \"score\" is missing, with no default",call.=FALSE)
  }

  supported_methods=c("delong","bootstrap")
  if (!(ci_method %in% supported_methods)) {
    stop(paste0("Unsupported ci_method: '",ci_method,"'. Must be one of 'delong', 'bootstrap'."),call.=FALSE)
  }

  valid_actual=all(actual %in% c(0,1))

  if(!valid_actual){
    stop("Input vectors 'actual' must only contain 0 and 1.", call. = FALSE)
  }

  result=list()

  if(ci_method=="delong") auc_result=pROC::roc(actual,score,ci=T)
  if(ci_method=="bootstrap") auc_result=pROC::roc(actual,score,ci=T,ci.method="bootstrap",boot.n=boot_n)

  auc_value=as.numeric(pROC::auc(auc_result))

  if(ci_method=="delong") auc_ci=pROC::ci.auc(auc_result)
  if(ci_method=="bootstrap") auc_ci=pROC::ci.auc(auc_result,method="bootstrap",boot.n=boot_n)

  result$auc=data.frame(value=auc_value,lower=as.numeric(auc_ci[1]),upper=as.numeric(auc_ci[3]))
  result$roc_res=auc_result

  return(result)
}


