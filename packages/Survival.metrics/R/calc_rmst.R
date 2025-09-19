
#' Calculate RMST for the event by group
#'
#' @param time_event The time elapsed until an event occurs
#' @param time_follow Follow-up period
#' @param censored Whether censoring occurred(0:censored, 1:event)
#' @param class Group separation criteria variable
#'
#' @importFrom survRM2 rmst2
#'
#' @return Group-specific RMST for the event and 95% confidence intervals
#' @export
calc_rmst=function(time_event,
                   time_follow,
                   censored,
                   class){
  rmst_res=rmst2(time=time_event,status=censored,arm=class,tau=time_follow)
  res_class0=data.frame(risk="class0",rbind(rmst_res$RMST.arm0$rmst[c("Est.","lower .95","upper .95")]))
  res_class1=data.frame(risk="class1",rbind(rmst_res$RMST.arm1$rmst[c("Est.","lower .95","upper .95")]))

  return(list(class0=res_class0,class1=res_class1))
}
