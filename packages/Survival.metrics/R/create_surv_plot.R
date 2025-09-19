
#' Create Kaplane-Meier survival plot
#'
#' @param time_event The time elapsed until an event occurs
#' @param censored Whether censoring occurred(0:censored, 1:event)
#' @param class Group separation criteria variable
#'
#' @importFrom survival survfit
#' @importFrom broom tidy
#'
#' @export
create_surv_plot=function(km_res,filepath,title,x,y){
  fit_df=tidy(km_res)

  p=ggplot(fit_df,aes(x=time,y=estimate,color=strata))+
    geom_step(linewidth=1.2)+
    geom_ribbon(aes(ymin=conf.low,ymax=conf.high,fill=strata),alpha=0.2,linetype=0)+
    labs(
      title=title,
      x=x,
      y=y
    )+
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
