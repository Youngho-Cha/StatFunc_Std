
#' Create Kaplane-Meier survival plot
#'
#' @param km_res Results of Kaplan-Meier method
#' @param filepath The file location where the survival curve will be saved
#' @param title The title of the survival curve
#' @param x The name of the x-axis
#' @param y The name of the y-axis
#' @param legend_title The title of the legend
#' @param legend_labels The names of legend labels
#'
#' @importFrom ggplot2 ggplot geom_step geom_ribbon labs theme_minimal ggsave scale_color_discrete scale_fill_discrete
#' @importFrom broom tidy
#' @importFrom dplyr bind_rows arrange
#'
#' @details
#' \strong{Fundamentals of Survival Data:}
#' Survival analysis, also known as time-to-event analysis, deals with data
#' where the outcome of interest is the time until an event occurs. This data
#' has two key components:
#' \itemize{
#'   \item \strong{Time:} The duration from a starting point to the event or the end of observation.
#'   \item \strong{Event Status:} A binary indicator of whether the event of interest occurred (e.g., 1 = event occurred, 0 = no event).
#' }
#' A crucial feature of survival data is \strong{censoring}. An observation is
#' censored when we have partial information about its event time. For example,
#' a study might end before a subject experiences the event, or a subject might
#' withdraw. These censored observations are not discarded; they are used in the
#' analysis up to the time they were last observed, which is a key strength of
#' survival analysis methods.
#'
#' @section Statistical Method:
#'  \describe{
#'   \item{\strong{Kaplan-Meier (K-M) Method:}}{
#'   The Kaplan-Meier estimator is a non-parametric statistic used to estimate
#'   the survival function, S(t), from time-to-event data. Instead of a single
#'   formula, it is an iterative process calculated at each event time. The
#'   survival probability at any given time is the cumulative product of the
#'   conditional probabilities of surviving each preceding time interval.
#' }
#'
#' \describe{
#'   \item{\strong{Kaplan-Meier (K-M) Curve Visualization:}}{
#'   The Kaplan-Meier survival curve is the graphical representation of the K-M
#'   estimate of the survival function, S(t). This function visualizes how the
#'   estimated survival probability changes over time.
#'
#'   The curve is plotted as a **step function**, where the y-axis represents the
#'   survival probability and the x-axis represents time. The key features of
#'   the plot are:
#'   \itemize{
#'     \item A horizontal line indicates a period where no events occurred.
#'     \item A vertical drop in the curve occurs at each time an event is observed.
#'     The height of the drop reflects the decrease in survival probability at that moment.
#'     \item Small vertical ticks or crosses on the curve often represent
#'     \strong{censored observations}, showing the time at which those subjects
#'     were last known to be event-free.
#'   }
#'   By visualizing the K-M estimate, one can intuitively compare the survival
#'   experience between different groups, identifying which group has a better
#'   or worse prognosis over the follow-up period.
#'   }
#' }
#'}
#'
#' @export
create_surv_plot=function(km_res,filepath,title,x,y,legend_title,legend_labels){
  fit_df=tidy(km_res)
  start_points=data.frame(
    time=0,
    estimate=1,
    conf.high=1,
    conf.low=1,
    strata=unique(fit_df$strata)
  )
  fit_df=bind_rows(strata_points,fit_df) %>%
    arrange(strata,time)

  p=ggplot(fit_df,aes(x=time,y=estimate,color=strata))+
    geom_step(linewidth=1.2)+
    geom_ribbon(aes(ymin=conf.low,ymax=conf.high,fill=strata),alpha=0.2,linetype=0)+
    labs(
      title=title,
      x=x,
      y=y,
      color=legend_title,
      fill=legend_title
    )+
    scale_color_discrete(labels=legend_labels)+
    scale_fill_discrete(labels=legend_labels)+
    theme_minimal()

  ggsave(
    filename=filepath,
    plot=p,
    width=5.33,
    height=4,
    units="in",
    dpi=150
  )
}
