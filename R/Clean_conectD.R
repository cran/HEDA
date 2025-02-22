#' @import dplyr ggplot2 lubridate zoo

#' @export
Clean_conectD <- function(df, alpha3 = 0.7, alpha4 = 0.5){

  ## get the dynamic threshold
  Q24.max <- rollapply(df$parameter_value, 24, max, align="right", by=24)

  Q24.min <- rollapply(df$parameter_value, 24, min, align="right", by=24)

  Q24.delta <- Q24.max-Q24.min

  ## when nrow(df)/24 is not integer
  l_Q24 <- length(Q24.delta)

  if(nrow(df)/24 > nrow(df)%/%24){
    Q24.delta[l_Q24+1] <- Q24.delta[l_Q24]
    Q24.max[l_Q24+1] <- Q24.max[l_Q24]
    Q24.min[l_Q24+1] <- Q24.min[l_Q24]}


  # update the locataion of the reversal pts
  index_lt <- which(df$dgtag %in% c(1,2,3,4))
  n <- length(index_lt)-2
  a=1

  if (length(index_lt)>3) {
    for(i in 2:n){
      x1 = index_lt[i-1]
      x2 = index_lt[i]
      x3 = index_lt[i+1]
      x4 = index_lt[i+2]

      if(x2 > 24*a){
        a=a+1}

      #pt#1 -- pt#23
      if(df$dgtag[x1] ==1 & df$dgtag[x2]==2 & df$dgtag[x3]==3 & abs(df$parameter_value[x1]-df$parameter_value[x3]) < max(Q24.delta[a]*alpha4,df$ann_thre[1]*alpha3) &
         df$parameter_value[x3]<0.9*Q24.max[a] & df$parameter_value[x1]>1.1*Q24.min[a]){
        df$dgtag[x1] <- 0
        df$dgtag[x2] <- 0
        df$dgtag[x3] <- 0}

      #pt#1 -- pt#3
      if(df$dgtag[x1] ==1 & df$dgtag[x2]==3 & abs(df$parameter_value[x1]-df$parameter_value[x2]) < max(Q24.delta[a]*alpha4,df$ann_thre[1]*alpha3) &
         df$parameter_value[x2]<0.9*Q24.max[a] & df$parameter_value[x1]>1.1*Q24.min[a]){
        df$dgtag[x1] <- 0
        df$dgtag[x2] <- 0}

      #pt#3 --pt#1
      if(df$dgtag[x1] !=2  & df$dgtag[x2]==3 & df$dgtag[x3]==1 & abs(df$parameter_value[x2]-df$parameter_value[x3]) < max(Q24.delta[a]*alpha4,df$ann_thre[1]*alpha3) &
         df$parameter_value[x2]<0.9*Q24.max[a] & df$parameter_value[x3]>1.1*Q24.min[a]){
        df$dgtag[x2] <- 0
        df$dgtag[x3] <- 0}

      #pt#3 -- pt24
      if(df$dgtag[x1]!=2 & df$dgtag[x2] ==3 & df$dgtag[x3]==2 & df$dgtag[x4]==4 & abs(df$parameter_value[x2]-df$parameter_value[x3]) < max(Q24.delta[a]*alpha4,df$ann_thre[1]*alpha3) &
         df$parameter_value[x2]<0.9*Q24.max[a] & df$parameter_value[x3]>1.1*Q24.min[a]){
        df$dgtag[x2] <- 0
        df$dgtag[x3] <- 0
        df$dgtag[x4] <- 0}

      #pt23---pt#1
      if(df$dgtag[x1] ==2 & df$dgtag[x2]==3 & df$dgtag[x3]==1 & abs(df$parameter_value[x2]-df$parameter_value[x3]) < max(Q24.delta[a]*alpha4,df$ann_thre[1]*alpha3) &
         df$parameter_value[x2]<0.9*Q24.max[a] & df$parameter_value[x3]>1.1*Q24.min[a]){
        df$dgtag[x1] <- 0
        df$dgtag[x2] <- 0
        df$dgtag[x3] <- 0}

      #pt23--pt24
      if(df$dgtag[x1] ==2 & df$dgtag[x2]==3 & df$dgtag[x3]==2 & df$dgtag[x4]==4 & abs(df$parameter_value[x2]-df$parameter_value[x3]) < max(Q24.delta[a]*alpha4,df$ann_thre[1]*alpha3) &
         df$parameter_value[x2]<0.9*Q24.max[a] & df$parameter_value[x3]>1.1*Q24.min[a]){
        df$dgtag[x1] <- 0
        df$dgtag[x2] <- 0
        df$dgtag[x3] <- 0
        df$dgtag[x4] <- 0}

      #pt24--pt23
      if(df$dgtag[x1] ==2 & df$dgtag[x2]==4 & df$dgtag[x3]==2 & df$dgtag[x4]==3 & abs(df$parameter_value[x2]-df$parameter_value[x3]) < max(Q24.delta[a]*alpha4,df$ann_thre[1]*alpha3) &
         df$parameter_value[x3]<0.9*Q24.max[a] & df$parameter_value[x2]>1.1*Q24.min[a]){
        df$dgtag[x1] <- 0
        df$dgtag[x2] <- 0
        df$dgtag[x3] <- 0
        df$dgtag[x4] <- 0}

      #pt24--pt#3
      if(df$dgtag[x1]==2 & df$dgtag[x2] ==4 & df$dgtag[x3]==3 & abs(df$parameter_value[x2]-df$parameter_value[x3]) < max(Q24.delta[a]*alpha4,df$ann_thre[1]*alpha3) &
         df$parameter_value[x3]<0.9*Q24.max[a] & df$parameter_value[x1]>1.1*Q24.min[a]){
        df$dgtag[x1] <- 0
        df$dgtag[x2] <- 0
        df$dgtag[x3] <- 0}}}

  return(df)}
