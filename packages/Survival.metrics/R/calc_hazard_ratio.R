
#' Calculate the hazard ratio for the event by group
#'
#' @param time_event The time elapsed until an event occurs
#' @param censored Whether censoring occurred(0:censored, 1:event)
#' @param class Group separation criteria variable
#'
#' @importFrom survival coxph
#'
#' @return Hazard ratio for the event by group
#' @export
calc_hazard_ratio=function(time_event,
                           censored,
                           class){
  cox_model=coxph(Surv(time_event,censored)~class)
  ratio=exp(cox_model$coefficients)

  res=data.frame(ratio=as.numeric(ratio))

  return(res)
}
