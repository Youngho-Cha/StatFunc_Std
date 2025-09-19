
#' Outputs basic statistics for continuous variables
#'
#' @param data The input data
#' @param var The continuous variable
#' @param digit The number of decimal places
#'
#' @return A data frame containing the mean, standard deviation, median, minimum, maximum values for the continuous variable
#' @export
num_dm_table=function(data,var,digit){
  df=data[,var]
  mu=mean(df)
  sdv=sd(df)
  med=median(df)
  minimum=min(df)
  maximum=max(df)
  res=data.frame(Variable=var,
                 Mean_SD=paste0(round(mu,digit)," ","(",round(sdv,digit),")"),
                 Median_Min_Max=paste0(round(med,digit)," ","(",round(minimum,digit),",",round(maximum,digit),")"))

  return(res)
}
