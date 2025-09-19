
#' Round a numeric variable to a specified number of decimal places
#'
#' @param df A dataframe for rounding a numeric variable
#' @param digit Number of decimal places
#'
#' @return A dataframe with only the numeric variables rounded
#' @export
table_digit=function(df,digit){
  df_rounded=df
  numeric_idx=sapply(df_rounded,is.numeric)
  df_rounded[numeric_idx]=round(df_rounded[numeric_idx],digit)

  return(df_rounded)
}
