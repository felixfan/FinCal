\name{lineChart}
\alias{lineChart}
\title{Technical analysts - Line charts: show prices for each period as a continuous line}
\usage{
  lineChart(ohlc, y = "close", main = "", ...)
}
\arguments{
  \item{ohlc}{output from get.ohlc.yahoo or
  get.ohlc.google}

  \item{y}{y coordinates: close, open, high, low or
  adjusted}

  \item{main}{an overall title for the plot}

  \item{...}{Arguments to be passed to methods}
}
\description{
  Technical analysts - Line charts: show prices for each
  period as a continuous line
}
\examples{
google <- get.ohlc.yahoo("GOOG"); lineChart(google)

apple <- get.ohlc.google("AAPL"); lineChart(apple)
}
\seealso{
  \code{\link{get.ohlc.yahoo}}

  \code{\link{get.ohlc.google}}
}

