
#' Format performance metrics output for reporting
#'
#' This function rounds the numeric output of the formatted metrics for clean reporting.
#'
#' @param df A data frame returned from format_performance_output()
#' @param digits Number of decimal places (default=3)
#'
#' @importFrom dplyr %>%
#'
#' @return A dataframe with rounded numeric values
#' @export
format_for_reporting=function(df,digits=3){
  df %>%
    dplyr::mutate(
      Estimate=round(Estimate,digits),
      Lower_95_CI=round(Lower_95_CI,digits),
      Upper_95_CI=round(Upper_95_CI,digits)
    )
}
