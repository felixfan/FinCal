library(FinCal)

equal <- function(x,y) stopifnot(isTRUE(all.equal(x,y,check.attributes=FALSE)))
fails <- function(expr) stopifnot(inherits(tryCatch({ force(expr); NULL },error=identity),"error"))

# Deterministic fixtures keep all automated tests independent of Yahoo uptime.
fixture <- function(zone="UTC") {
  timestamps <- as.numeric(as.POSIXct(paste(c("2025-01-03","2025-01-02","2025-01-01"),
                                           "00:30:00"),tz=zone))
  list(chart=list(error=NULL,result=list(list(
    meta=list(exchangeTimezoneName=zone,firstTradeDate=0),timestamp=as.list(timestamps),
    indicators=list(quote=list(list(open=list(3,2,1),high=list(4,3,2),low=list(2,1,0),
      close=list(3,2,1),volume=list(30,20,10))),adjclose=list(list(adjclose=list(3,2,1))))))))
}
transport <- new.env(parent=environment(get.ohlc.yahoo))
transport$requests <- character()
transport$response <- fixture()
transport$.yahoo.request <- function(url) {
  transport$requests <- c(transport$requests,url)
  transport$response
}
single <- get.ohlc.yahoo; environment(single) <- transport
batch <- get.ohlcs.yahoo; environment(batch) <- transport

for (frequency in c(d="1d",w="1wk",m="1mo")) {
  code <- names(c(d="1d",w="1wk",m="1mo"))[match(frequency,c("1d","1wk","1mo"))]
  for (start in c("firstDay","2025-01-01")) {
    transport$requests <- character()
    result <- single("AAPL",start=start,end="2025-01-02",freq=code)
    equal(names(result),c("date","open","high","low","close","volume","adjusted"))
    equal(result$date,c("2025-01-01","2025-01-02"))
    equal(result$close,c(1,2))
    stopifnot(length(transport$requests)==2L,
      grepl("^https://query1[.]finance[.]yahoo[.]com/v8/finance/chart/AAPL",transport$requests[1]),
      grepl(paste0("interval=",frequency),transport$requests[2],fixed=TRUE),
      grepl("period2=1735862400",transport$requests[2],fixed=TRUE))
    if (start=="firstDay") stopifnot(grepl("period1=0&",transport$requests[2],fixed=TRUE))
  }
}

# The exchange calendar date can differ from UTC, including before 1970.
transport$response <- fixture("Asia/Tokyo")
result <- single("TEST",start="2025-01-02",end="2025-01-02")
equal(result$date,"2025-01-02")
equal(result$close,2)
transport$response <- fixture()
result <- batch(c("AAPL","MSFT"),start="2025-01-02",end="2025-01-03",freq="m")
equal(names(result),c("AAPL","MSFT"))
equal(result$MSFT$date,c("2025-01-02","2025-01-03"))
equal(batch(character()),list())
fails(single("AAPL",start="2026-01-01",end="2025-01-01"))
fails(single("",end="2025-01-01"))
fails(single("AAPL",freq="x"))
transport$requests <- character()
equal(nrow(single("AAPL",end="1960-01-01")),0L)
stopifnot(length(transport$requests)==1L)

# Missing data remains missing instead of fabricating adjusted prices.
transport$response <- fixture()
transport$response$chart$result[[1]]$indicators$quote[[1]]$open[2] <- list(NULL)
transport$response$chart$result[[1]]$indicators$adjclose <- NULL
result <- single("AAPL",end="2025-01-03")
stopifnot(is.na(result$open[2]),all(is.na(result$adjusted)))
transport$response <- fixture()
transport$response$chart$result[[1]]$meta$firstTradeDate <- NULL
single("AAPL",end="2025-01-02")
stopifnot(grepl("range=max&interval=1d",tail(transport$requests,1),fixed=TRUE))
transport$response <- list(chart=list(result=NULL,error=list(description="No such symbol")))
fails(single("UNKNOWN"))
transport$response <- fixture()
transport$response$chart$result[[1]]$indicators$quote[[1]]$close <- list(1)
fails(single("AAPL"))
