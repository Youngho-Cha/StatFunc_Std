
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
#'
#' @details
#' \strong{Fundamentals of Survival Data:}
#' Survival analysis, also known as time-to-event analysis, deals with data
#' where the outcome of interest is the time until an event occurs. This data
#' has two key components:
#' \itemize{
#' \item \strong{Time:} The duration from a starting point to the event or the end of observation.
#' \item \strong{Event Status:} A binary indicator of whether the event of interest occurred (e.g., 1 = event occurred, 0 = no event).
#' }
#' A crucial feature of survival data is \strong{censoring}. An observation is
#' censored when we have partial information about its event time. For example,
#' a study might end before a subject experiences the event. These censored
#' observations are not discarded; they are used in the analysis up to the time
#' they were last observed, which is a key strength of survival analysis methods.
#'
#' @section Statistical Method:
#' \describe{
#' \item{\strong{Restricted Mean Survival Time (RMST):}}{
#' The RMST is a robust measure for summarizing and comparing survival curves.
#' It represents the average event-free survival time of a group up to a
#' pre-specified time point, \eqn{\tau} (tau).
#'
#' Conceptually, the RMST is the **area under the Kaplan-Meier survival curve**
#' from time 0 up to \eqn{\tau}.
#'
#'
#' \strong{When to Use RMST:}
#' The RMST offers a clinically intuitive interpretation (e.g., "the average
#' patient in the treatment group lived X months longer than in the control
#' group over a 5-year period"). It is an excellent alternative to the Hazard
#' Ratio (HR) from Cox regression, particularly in cases where the
#' **Proportional Hazards (PH) assumption is not met** (e.g., when survival
#' curves cross). Unlike the HR, the RMST does not assume that the treatment
#' effect is constant over time.
#' }
#'
#' \item{\strong{RMST Calculation:}}{
#' The RMST is calculated by integrating the Kaplan-Meier survival function,
#' S(t), from time 0 to the chosen time horizon \eqn{\tau}.
#' \deqn{RMST = \int_{0}^{\tau} S(t) dt}
#' Where:
#' \itemize{
#'   \item \eqn{S(t)} is the Kaplan-Meier survival probability at time t.
#'   \item \eqn{\tau} is the pre-specified time point, often chosen based on
#'   the maximum follow-up time of the study or a clinically meaningful
#'   endpoint.
#' }
#' The primary use of RMST in clinical trials is often to compare two groups
#' by calculating the **difference in RMST**, which provides a direct measure
#' of the average survival time gained or lost due to the treatment or exposure.
#' }
#' }
#'
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
