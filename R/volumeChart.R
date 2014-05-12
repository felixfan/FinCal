#' Technical analysts - Volume charts: show each period's volume as a vertical line
#' 
#' @param ohlc output from get.ohlc.yahoo or get.ohlc.google
#' @param main an overall title for the plot
#' @param breaks specifying the width between breaks. e.g. "1 day", "1 week", "2 weeks","1 month"
#' @param ... Arguments to be passed to ggplot
#' @seealso \code{\link{get.ohlc.yahoo}}
#' @seealso \code{\link{get.ohlc.google}}
#' @export
#' @examples
#' # google <- get.ohlc.yahoo("GOOG");
#' # volumeChart(google)
#' # apple <- get.ohlc.google("AAPL");
#' # volumeChart(apple)
volumeChart <- function(ohlc,main="",breaks="1 week",...){
  options(warn=-1)
  ohlc$date <- as.Date(ohlc$date,"%Y-%m-%d")
  g=ggplot(ohlc, aes_string(x='date',y='volume')) + geom_bar(stat="identity") + labs( title =main ) + labs(x="") + 
    theme(axis.text.x=element_text(angle=90)) + 
    scale_x_date(labels = date_format("%Y-%m-%d"),breaks = breaks, minor_breaks = "1 day")
  return(g)
}
