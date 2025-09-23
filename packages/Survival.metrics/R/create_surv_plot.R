
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
