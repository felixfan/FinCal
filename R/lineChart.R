#' Technical analysts - Line charts: show prices for each period as a continuous line
#' 
#' @param ohlc output from get.ohlc.yahoo or get.ohlc.google
#' @param y y coordinates: close, open, high, low or adjusted
#' @param main an overall title for the plot
#' @param ... Arguments to be passed to methods
#' @seealso \code{\link{get.ohlc.yahoo}}
#' @seealso \code{\link{get.ohlc.google}}
#' @export
#' @examples
#' google <- get.ohlc.yahoo("GOOG"); lineChart(google)
#'
#' apple <- get.ohlc.google("AAPL"); lineChart(apple)
lineChart <- function(ohlc,y="close",main="",...){
  options(warn=-1)
  ohlc$date <- as.Date(ohlc$date,"%Y-%m-%d")
  myBreak=date.breaks(ohlc)
  if(y == "close"){
    ggplot(ohlc, aes_string(x='date',y='close')) + geom_line() + labs( title =main ) + labs(x="") + 
      theme(axis.text.x=element_text(angle=90)) + 
      scale_x_date(labels = date_format("%Y-%m-%d"),breaks=date_breaks(myBreak))
  }else if(y == "open"){
    ggplot(ohlc, aes_string(x='date',y='open')) + geom_line() + labs( title =main ) + labs(x="") + 
      theme(axis.text.x=element_text(angle=90)) + 
      scale_x_date(labels = date_format("%Y-%m-%d"),breaks=date_breaks(myBreak))
  }else if(y == "high"){
    ggplot(ohlc, aes_string(x='date',y='high')) + geom_line() + labs( title =main ) + labs(x="") + 
      theme(axis.text.x=element_text(angle=90)) + 
      scale_x_date(labels = date_format("%Y-%m-%d"),breaks=date_breaks(myBreak))
  }else if(y == "low"){
    ggplot(ohlc, aes_string(x='date','y=low')) + geom_line() + labs( title =main ) + labs(x="") + 
      theme(axis.text.x=element_text(angle=90)) + 
      scale_x_date(labels = date_format("%Y-%m-%d"),breaks=date_breaks(myBreak))
  }else if(y == "adjusted"){
    ggplot(ohlc, aes_string(x='date',y='adjusted')) + geom_line() + labs( title =main ) + labs(x="") + 
      theme(axis.text.x=element_text(angle=90)) + 
      scale_x_date(labels = date_format("%Y-%m-%d"),breaks=date_breaks(myBreak))
  }
}
