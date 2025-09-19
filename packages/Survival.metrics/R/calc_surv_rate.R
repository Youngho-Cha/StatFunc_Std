
#' Calculate the survival rate for the event and test difference in survival rates by group
#'
#' @param time_event The time elapsed until an event occurs
#' @param time_follow Follow-up period
#' @param censored Whether censoring occurred(0:censored, 1:event)
#' @param class Group separation criteria variable
#'
#' @importFrom survival survfit survdiff
#'
#' @return Group-specific survival rates for the event and 95% confidence intervals, the p-value of the log-rank test, and the overall results of the Kaplan-Meier method
#' @export
calc_surv_rate=function(time_event,
                        time_follow,
                        censored,
                        class){
  km_res=survfit(Surv(time_event,censored)~class)
  km=summary(km_res)

  idx_class0=max(which(km$time<=time_follow & km$strata==levels(km$strata)[1]))
  idx_class1=max(which(km$time<=time_follow & km$strata==levels(km$strata)[2]))

  res_class0=data.frame(time=time_follow,surv_rate=km$surv[idx_class0],
                        lower=km$lower[idx_class0],upper=km$upper[idx_class0])
  res_class1=data.frame(time=time_follow,surv_rate=km$surv[idx_class1],
                        lower=km$lower[idx_class1],upper=km$upper[idx_class1])

  log_rank=survdiff(Surv(time_event,censored)~class)
  log_rank_pval=data.frame(pval=log_rank$pvalue)

  return(list(class0=res_class0,class1=res_class1,p=log_rank_pval,km=km_res))
}
