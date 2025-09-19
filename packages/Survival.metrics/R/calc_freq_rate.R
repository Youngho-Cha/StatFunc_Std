
#' Calculate event frequency and rate per group
#'
#' @param time_event The time elapsed until an event occurs
#' @param time_vector A predefined time interval
#' @param censored Whether censoring occurred(0:censored, 1:event)
#' @param class Group separation criteria variable
#'
#' @importFrom survival survfit
#'
#' @return Frequency and proportion of events by group and the overall results of the Kaplan-Meier method
#' @export
calc_freq_rate=function(time_event,
                        time_vector,
                        censored,
                        class){
  km_res=survfit(Surv(time_event,censored)~class)
  km=summary(km_res)

  event_class0=NULL
  rate_class0=NULL
  for(i in time_vector){
    event_class0[i]=sum(km$n.event[km$time<=i & km$strata==levels(km$strata)[1]])
    rate_class0[i]=event_class0[i]/km$n[1]
  }
  event_class0=event_class0[!is.na(event_class0)]
  rate_class0=rate_class0[!is.na(rate_class0)]

  event_class1=NULL
  rate_class1=NULL
  for(i in time_vector){
    event_class1[i]=sum(km$n.event[km$time<=i & km$strata==levels(km$strata)[2]])
    rate_class1[i]=event_class1[i]/km$n[2]
  }
  event_class1=event_class1[!is.na(event_class1)]
  rate_class1=rate_class1[!is.na(rate_class1)]

  res_class0=data.frame(time=time_vector,freq=event_class0,rate=rate_class0)
  res_class1=data.frame(time=time_vector,freq=event_class1,rate=rate_class1)

  return(list(class0=res_class0,class1=res_class1,km=km_res))
}
