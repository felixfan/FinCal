#' Download stock prices from Yahoo Finance (open, high, low, close, volume, adjusted)
#' 
#' @param symbol symbol of stock, e.g. AAPL, GOOG, SPX
#' @param start start date, e.g., 2013-07-31
#' @param end end date, e.g., 2013-08-06
#' @param freq time interval, e.g., d:daily, w:weekly, m:monthly
#' @details The end date and frequency are applied even when start is
#'   \code{"firstDay"}. This function uses Yahoo's legacy CSV service;
#'   availability of that external service is outside the package's control.
#' @seealso \code{\link{get.ohlcs.yahoo}}
#' @seealso \code{\link{get.ohlc.google}}
#' @importFrom utils read.csv
#' @export
#' @examples
#' # get.ohlc.yahoo(symbol="AAPL")
#' # get.ohlc.yahoo(symbol="AAPL",start="2013-08-01",freq="d")
#' # get.ohlc.yahoo(symbol="AAPL",start="2013-07-01",end="2013-08-01",freq="w")
get.ohlc.yahoo <- function(symbol,start="firstDay",end="today",freq="d"){
  dat <- read.csv(.yahoo.url(symbol, start, end, freq))
  dat <- dat[order(dat$Date), , drop=FALSE]
  colnames(dat) <- c("date", "open", "high", "low", "close", "volume", "adjusted")
  dat
}

.yahoo.url <- function(symbol, start, end, freq) {
  freq <- match.arg(freq, c("d", "w", "m"))
  end.date <- if (end == "today") Sys.Date() else as.Date(end)
  if (length(end.date) != 1L || !is.finite(as.numeric(end.date))) {
    stop("'end' must be a valid date or 'today'")
  }
  url <- paste0("http://ichart.finance.yahoo.com/table.csv?s=",
                utils::URLencode(symbol, reserved=TRUE))
  if (start != "firstDay") {
    start.date <- as.Date(start)
    if (length(start.date) != 1L || !is.finite(as.numeric(start.date)) ||
        start.date > end.date) {
      stop("'start' must be a valid date no later than 'end'")
    }
    url <- paste0(url, "&a=", as.integer(format(start.date, "%m")) - 1,
                  "&b=", format(start.date, "%d"), "&c=", format(start.date, "%Y"))
  }
  paste0(url, "&d=", as.integer(format(end.date, "%m")) - 1,
         "&e=", format(end.date, "%d"), "&f=", format(end.date, "%Y"), "&g=", freq)
}
