\name{get.ohlc.yahoo}
\alias{get.ohlc.yahoo}
\title{Download stock prices from Yahoo Finance (open, high, low, close, volume, adjusted)}
\usage{
get.ohlc.yahoo(symbol, start = "firstDay", end = "today", freq = "d")
}
\arguments{
  \item{symbol}{symbol of stock, e.g. AAPL, GOOG, SPX}

  \item{start}{start date, e.g., 2013-07-31}

  \item{end}{end date, e.g., 2013-08-06}

  \item{freq}{time interval, e.g., d:daily, w:weekly,
  m:monthly}
}
\description{
Download stock prices from Yahoo Finance (open, high, low,
close, volume, adjusted)
}
\examples{
get.ohlc.yahoo(symbol="AAPL")

get.ohlc.yahoo(symbol="AAPL",start="2013-08-01",freq="d")

get.ohlc.yahoo(symbol="AAPL",start="2013-07-01",end="2013-08-01",freq="w")
}
\seealso{
\code{\link{get.ohlcs.yahoo}}

\code{\link{get.ohlc.google}}
}

