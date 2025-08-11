
#' Generate simulated test dataset for evaluation
#'
#' This function generates a realistic binary dataset for testing performance metrics
#' (Default sample size is 300 and Default prevalence is 0.5)
#'
#' @param N Sample size (defualt=300)
#' @param prevalence Prevalence of positive class (default=0.5)
#'
#' @return A list containing actual, predicted and score vectors
#'
#' @export
generate_test_data=function(N=300,prevalence=0.5){
  set.seed(123)

  actual=rbinom(N,1,prevalence)

  score=numeric(N)
  score[actual==1]=rbeta(sum(actual==1),6,2)
  score[actual==0]=rbeta(sum(actual==0),2,6)

  predicted=ifelse(score>0.5,1,0)

  list(actual=actual,predicted=predicted,score=score)
}
