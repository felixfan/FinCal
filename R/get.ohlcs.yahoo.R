#' Batch download stock prices from Yahoo Finance (open, high, low, close, volume, adjusted)
#' 
#' @param symbols symbols of stock, e.g. AAPL, GOOG, SPX
#' @param start start date, e.g., 2013-07-31
#' @param end end date, e.g., 2013-08-06
#' @param freq time interval, e.g., d:daily, w:weekly, m:monthly
#' @details The end date and frequency are applied to every symbol, including
#'   when start is \code{"firstDay"}. Uses Yahoo's legacy CSV service.
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
    dat <- read.csv(.yahoo.url(symbol, start, end, freq))
    dat <- dat[order(dat$Date), , drop=FALSE]
    colnames(dat) <- c("date", "open", "high", "low", "close", "volume", "adjusted")
    ohlc[[symbol]] <- dat
  }
  ohlc
}
