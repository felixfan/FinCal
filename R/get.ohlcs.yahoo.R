#' Batch download stock prices from Yahoo Finance (open, high, low, close, volume, adjusted)
#' 
#' @param symbols symbols of stock, e.g. AAPL, GOOG, SPX
#' @param start start date, e.g., 2013-07-31
#' @param end end date, e.g., 2013-08-06
#' @param freq time interval, e.g., d:daily, w:weekly, m:monthly
#' @details Uses the same HTTPS chart service, inclusive dates and exchange
#'   time-zone handling as \code{get.ohlc.yahoo} for each symbol.
#' @seealso \code{\link{get.ohlc.yahoo}}
#' @seealso \code{\link{get.ohlcs.google}}
#' @importFrom utils read.csv
#' @export
#' @examples
#' # get.ohlcs.yahoo(symbols=c("AAPL","GOOG","SPY"),freq="d")
#' # get.ohlcs.yahoo(symbols=c("AAPL","GOOG","SPY"),start="2013-01-01",freq="m")
get.ohlcs.yahoo <- function(symbols,start="firstDay",end="today",freq="d"){
  ohlc <- list()
  for (symbol in symbols) {
    ohlc[[symbol]] <- .yahoo.history(symbol,start,end,freq,request=.yahoo.request)
  }
  ohlc
}
