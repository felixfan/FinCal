#' Technical analysts - Candlestick chart: show prices for each period as a continuous line. The box is clear if the closing price is higher than the opening price, or filled red if the closing is lower than the opening price.
#' 
#' @param ohlc output from get.ohlc.yahoo or get.ohlc.google
#' @param start inclusive start date to plot; if NULL, no lower date limit
#' @param end inclusive end date to plot; if NULL, no upper date limit
#' @param main an overall title for the plot
#' @param ... Arguments to be passed to ggplot
#' @seealso \code{\link{get.ohlc.yahoo}}
#' @seealso \code{\link{get.ohlc.google}}
#' @importFrom ggplot2 ggplot geom_boxplot theme theme_bw scale_fill_manual labs aes_string element_text
#' @export
#' @examples
#' # google <- get.ohlc.yahoo("GOOG",start="2013-07-01",end="2013-08-01"); candlestickChart(google)
#' # apple <- get.ohlc.google("AAPL",start="2013-07-01",end="2013-08-01"); candlestickChart(apple)
candlestickChart <- function(ohlc, start=NULL, end=NULL, main="", ...){
  date <- as.Date(ohlc$date)
  open <- as.vector(ohlc$open)
  high <- as.vector(ohlc$high)
  low <- as.vector(ohlc$low)
  close <- as.vector(ohlc$close)
  
  xSubset <-data.frame('date'=date,'open'=open,'high'= high,'low'=low,'close'=close)
   
  xSubset$candleLower <- pmin(xSubset$open, xSubset$close)
  xSubset$candleUpper <- pmax(xSubset$open, xSubset$close)
  xSubset$candleMiddle = (xSubset$candleLower+xSubset$candleUpper)/2
  xSubset$fill <- 'down'
  xSubset$fill[xSubset$open <= xSubset$close] = 'up'
  
  if(!is.null(start)){
    xSubset <- xSubset[xSubset$date >= as.Date(start), , drop=FALSE]
  }
  if(!is.null(end)){
    xSubset <- xSubset[xSubset$date <= as.Date(end), , drop=FALSE]
  }

  g <- ggplot(xSubset, aes_string(x='date', lower='candleLower', middle='candleMiddle', upper='candleUpper', ymin='low', ymax='high'),...) +
          geom_boxplot(stat='identity', aes_string(group='date', fill='fill')) + theme_bw() + 
          scale_fill_manual(name = "", values = c(up="transparent", down="red")) + labs( title =main ) + labs(x="") +
          theme(legend.position="none") + theme(axis.text.x=element_text(angle=90))
  return(g)
}
