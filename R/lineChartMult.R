#' Technical analysts - Line charts: show prices for each period as a continuous line for multiple stocks
#' 
#' @param ohlcs output from get.ohlc.yahoo.mult or get.ohlc.google.mult
#' @param y y coordinates: close, open, high, low or adjusted (yahoo data only)
#' @param main an overall title for the plot
#' @param ... Arguments to be passed to ggplot
#' @details Each series retains its own dates, including when histories have
#'   different lengths or non-overlapping trading dates.
#' @seealso \code{\link{get.ohlcs.yahoo}}
#' @seealso \code{\link{get.ohlcs.google}}
#' @seealso \code{\link{lineChart}}
#' @importFrom ggplot2 ggplot geom_line theme scale_y_continuous labs aes_string element_text element_blank
#' @importFrom reshape2 melt
#' @export
#' @examples
#' # googapple <- get.ohlcs.yahoo(c("GOOG","AAPL"),start="2013-01-01"); 
#' # lineChartMult(googapple)
#' # googapple <- get.ohlcs.google(c("GOOG","AAPL"),start="2013-01-01"); 
#' # lineChartMult(googapple)
lineChartMult <- function(ohlcs,y="close",main="",...){
  if (!is.list(ohlcs) || length(ohlcs) == 0L || is.null(names(ohlcs)) ||
      any(!nzchar(names(ohlcs)))) {
    stop("'ohlcs' must be a nonempty named list of price histories")
  }
  y <- match.arg(y, c("close", "open", "high", "low", "adjusted"))
  series <- lapply(seq_along(ohlcs), function(i) {
    history <- ohlcs[[i]]
    if (!all(c("date", y) %in% names(history))) {
      stop("Each price history must contain 'date' and the requested price column")
    }
    data.frame(Date = as.Date(history$date), variable = rep(names(ohlcs)[i], nrow(history)),
               value = history[[y]])
  })
  pdf <- do.call(rbind, series)
  ggplot(data=pdf, aes_string(x='Date', y='value', colour='variable'),...) + geom_line() +
    labs( title =main ) + labs(x="") + scale_y_continuous(name=y) +
    theme(axis.text.x=element_text(angle=90)) + theme(legend.title=element_blank())
}
