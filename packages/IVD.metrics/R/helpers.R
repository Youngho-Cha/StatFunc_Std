
#' Confidence Interval(Wald method)
#'
#' This function calculate Confidence Interval using wald method
#'
#' @param alpha Type I error
#' @param n Sample size of the data
#' @param p_hat Estimated value of Evaluation Metrics
#'
#' @importFrom stats qnorm
#'
#' @return A list of confidence interval(lower/upper)
#'
calculate_wald_ci=function(alpha,n,p_hat){
  z=qnorm(1-alpha/2)

  lower=p_hat-z*sqrt(p_hat*(1-p_hat)/n)
  upper=p_hat+z*sqrt(p_hat*(1-p_hat)/n)

  return(list(lower=lower,upper=upper))
}


#' Confidence Interval(Wilson method)
#'
#' This function calculate Confidence Interval using wilson method
#'
#' @param alpha Type I error
#' @param n Sample size of the data
#' @param p_hat Estimated value of Evaluation Metrics
#'
#' @importFrom stats qnorm
#'
#' @return A list of confidence interval(lower/upper)
#'
calculate_wilson_ci=function(alpha,n,p_hat){
  z=qnorm(1-alpha/2)

  lower=p_hat+z^2/(2*n)-z*sqrt((p_hat*(1-p_hat)/n)+z^2/(4*n^2))
  lower=lower/(1+z^2/n)
  upper=p_hat+z^2/(2*n)+z*sqrt((p_hat*(1-p_hat)/n)+z^2/(4*n^2))
  upper=upper/(1+z^2/n)

  return(list(lower=lower,upper=upper))
}
