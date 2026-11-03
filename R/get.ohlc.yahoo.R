#' Download stock prices from Yahoo Finance (open, high, low, close, volume, adjusted)
#' 
#' @param symbol symbol of stock, e.g. AAPL, GOOG, SPX
#' @param start start date, e.g., 2013-07-31
#' @param end end date, e.g., 2013-08-06
#' @param freq time interval, e.g., d:daily, w:weekly, m:monthly
#' @details Uses Yahoo's HTTPS chart service. Dates are inclusive and interpreted
#'   in the exchange's time zone. \code{"firstDay"} starts at the first trade
#'   reported by Yahoo. Frequencies d, w and m request daily, weekly and monthly
#'   bars. The external service can impose rate limits or change availability.
#' @seealso \code{\link{get.ohlcs.yahoo}}
#' @seealso \code{\link{get.ohlc.google}}
#' @importFrom utils read.csv
#' @export
#' @examples
#' # get.ohlc.yahoo(symbol="AAPL")
#' # get.ohlc.yahoo(symbol="AAPL",start="2013-08-01",freq="d")
#' # get.ohlc.yahoo(symbol="AAPL",start="2013-07-01",end="2013-08-01",freq="w")
get.ohlc.yahoo <- function(symbol,start="firstDay",end="today",freq="d"){
  .yahoo.history(symbol,start,end,freq,request=.yahoo.request)
}
