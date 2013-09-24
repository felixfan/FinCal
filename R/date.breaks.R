#' Deciding width (days or weeks) for date_breaks in plotting
#' 
#' @param ohlc output from get.ohlc.yahoo or get.ohlc.google
#' @export
#' @examples
#' google <- get.ohlc.yahoo("GOOG"); date.breaks(google)
date.breaks <- function(ohlc){
  n=length(ohlc$date)
  myBreak="1 day"
  if(n<30){
    myBreak="1 day"
  }else if(n < 90){
    myBreak="3 days"
  }else if(n < 140){
    myBreak="1 week"
  }else{
    m=n/140
    myBreak=paste(m, "weeks", sep=" ")
  }
  return(myBreak)
}
