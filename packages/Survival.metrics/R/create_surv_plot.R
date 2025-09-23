
#' Create Kaplane-Meier survival plot
#'
#' @param km_res Results of Kaplan-Meier method
#' @param filepath The file location where the survival curve will be saved
#' @param title The title of the survival curve
#' @param x The name of the x-axis
#' @param y The name of the y-axis
#'
#' @importFrom ggplot2 ggplot geom_step geom_ribbon labs theme_minimal ggsave
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
