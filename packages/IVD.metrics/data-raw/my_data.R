ex_data=data.frame(
  subjid=paste0("S-",1:10),
  gt=c(rep(1,5),rep(0,5)),
  pred=c(1,1,1,1,0,0,0,0,1,1),
  score=c(27.3,30,28.1,32,18.58,16.55,9.48,12.11,27.65,23.23)
)

usethis::use_data(ex_data,overwrite=TRUE)
