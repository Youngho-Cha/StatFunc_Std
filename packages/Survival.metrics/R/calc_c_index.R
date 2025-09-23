
#' Calculate C-index for the specific variables
#'
#' @param time_event The time elapsed until an event occurs
#' @param censored Whether censoring occurred(0:censored, 1:event)
#' @param var_name Variable used to calculate the C-index
#'
#' @importFrom survival coxph
#' @importFrom survcomp concordance.index
#' @importFrom stats predict
#'
#' @return Variable-specific C-index for the event and 95% confidence intervals
#' @export
calc_c_index=function(time_event,
                      censored,
                      var_name){
  cox_model=coxph(Surv(time_event,censored)~var_name)
  risk_score=predict(cox_model,type="lp")
  c_index=concordance.index(x=risk_score,
                            surv.time=time_event,
                            surv.event=censored,
                            method="noether")
  res=data.frame(C_index=c_index$c.index,lower=c_index$lower,upper=c_index$upper)

  return(res)
}
