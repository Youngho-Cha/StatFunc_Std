ex_data=data.frame(
  subjid=paste0("S-",1:10),
  censored=c(rep(1,4),rep(0,6)),
  time_event=c(1.25,2.25,4.33,9.33,12.33,12.16,10.16,10.5,10.33,11.83),
  age_class=c("age2","age1","age2","age2","age2","age1","age1","age1","age1","age1")
)

usethis::use_data(ex_data,overwrite=TRUE)
