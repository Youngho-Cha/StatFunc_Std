
#' Outputs basic statistics for categorical variables
#'
#' @param data The input data
#' @param var The categorical variable
#' @param digit The number of decimal places
#'
#' @return A data frame containing the mean, standard deviation, median, minimum, maximum values for the categorical variable
#' @export
character_dm_table=function(data,var,digit){
  df=data[,var]
  df_table=table(df)
  var_name=names(df_table)
  freq=as.numeric(df_table)
  rate=as.numeric(df_table/sum(df_table))
  rate_100=rate*100
  res=data.frame(Variable=c(var,rep("",length(var_name)-1)),
                 elements=var_name,
                 frequency_rate=paste0(round(freq,digit)," ","(",round(rate_100,digit),"%",")"))

  return(res)
}
