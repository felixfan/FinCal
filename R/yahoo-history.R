# Private transport: callers can substitute fixtures without making live requests.
.yahoo.request <- function(endpoint) {
  connection <- base::url(endpoint,open="rb",method="libcurl",
                          headers=c("User-Agent"="Mozilla/5.0 (compatible; FinCal)"))
  on.exit(close(connection))
  jsonlite::fromJSON(paste(readLines(connection,warn=FALSE),collapse="\n"),
                     simplifyVector=FALSE)
}

.yahoo.result <- function(response) {
  chart <- response$chart
  if (!is.null(chart$error)) {
    stop("Yahoo: ",chart$error$description,call.=FALSE)
  }
  if (!is.list(chart$result) || length(chart$result) != 1L) {
    stop("Yahoo returned an invalid chart response",call.=FALSE)
  }
  chart$result[[1]]
}

.yahoo.history <- function(symbol,start,end,freq,request) {
  if (!is.character(symbol) || length(symbol) != 1L || is.na(symbol) || !nzchar(symbol)) {
    stop("'symbol' must be a nonempty string")
  }
  freq <- match.arg(freq,c("d","w","m"))
  interval <- switch(freq,d="1d",w="1wk",m="1mo")
  end.date <- if (identical(end,"today")) Sys.Date() else as.Date(end)
  first.day <- identical(start,"firstDay")
  start.date <- if (first.day) NULL else as.Date(start)
  valid.date <- function(x) length(x) == 1L && is.finite(as.numeric(x))
  if (!valid.date(end.date) || (!first.day &&
      (!valid.date(start.date) || start.date > end.date))) {
    stop("Search dates must be valid with start no later than end")
  }
  endpoint <- paste0("https://query1.finance.yahoo.com/v8/finance/chart/",
                      utils::URLencode(symbol,reserved=TRUE))
  meta <- .yahoo.result(request(paste0(endpoint,"?range=5d&interval=1d")))$meta
  zone <- meta$exchangeTimezoneName
  if (is.null(zone) || length(zone) != 1L || !zone %in% OlsonNames()) {
    stop("Yahoo did not provide a supported exchange time zone")
  }
  midnight <- function(date) as.numeric(as.POSIXct(paste(date,"00:00:00"),tz=zone))
  upper <- midnight(end.date+1)
  lower <- if (first.day) meta$firstTradeDate else midnight(start.date)
  empty <- data.frame(date=character(),open=numeric(),high=numeric(),low=numeric(),
                       close=numeric(),volume=numeric(),adjusted=numeric())
  if (!is.finite(upper)) stop("End date is outside the supported range")
  if (first.day && (is.null(lower) || length(lower) != 1L || !is.finite(lower))) {
    query <- paste0("?range=max&interval=",interval)
  } else {
    if (!is.finite(lower)) stop("Start date is outside the supported range")
    if (lower >= upper) return(empty)
    query <- paste0("?period1=",format(lower,scientific=FALSE,trim=TRUE),
                    "&period2=",format(upper,scientific=FALSE,trim=TRUE),
                    "&interval=",interval)
  }
  chart <- .yahoo.result(request(paste0(endpoint,query,"&includeAdjustedClose=true")))
  n <- length(chart$timestamp)
  if (n == 0L) return(empty)
  column <- function(values) {
    if (is.null(values)) return(rep(NA_real_,n))
    if (length(values) != n) stop("Yahoo returned inconsistent column lengths")
    vapply(values,function(value) {
      if (is.null(value)) return(NA_real_)
      if (!is.numeric(value) || length(value) != 1L) {
        stop("Yahoo returned a nonnumeric price or timestamp")
      }
      as.numeric(value)
    },numeric(1))
  }
  timestamps <- column(chart$timestamp)
  if (any(!is.finite(timestamps))) stop("Yahoo returned invalid timestamps")
  quote <- chart$indicators$quote
  if (length(quote) != 1L) stop("Yahoo returned no OHLC quote data")
  quote <- quote[[1]]
  adjusted <- chart$indicators$adjclose
  if (length(adjusted) == 1L) adjusted <- adjusted[[1]]$adjclose else adjusted <- NULL
  dates <- as.Date(as.POSIXct(timestamps,origin="1970-01-01",tz=zone),tz=zone)
  result <- data.frame(date=as.character(dates),open=column(quote$open),
    high=column(quote$high),low=column(quote$low),close=column(quote$close),
    volume=column(quote$volume),adjusted=column(adjusted))
  keep <- dates <= end.date
  if (!first.day) keep <- keep & dates >= start.date
  result <- result[keep,,drop=FALSE]
  result[order(result$date),,drop=FALSE]
}
