\name{volumeChart}
\alias{volumeChart}
\title{Technical analysts - Volume charts: show each period's volume as a vertical line}
\usage{
  volumeChart(ohlc, main = "", ...)
}
\arguments{
  \item{ohlc}{output from get.ohlc.yahoo or
  get.ohlc.google}

  \item{main}{an overall title for the plot}

  \item{...}{Arguments to be passed to methods}
}
\description{
  Technical analysts - Volume charts: show each period's
  volume as a vertical line
}
\examples{
google <- get.ohlc.yahoo("GOOG");
volumeChart(google)

apple <- get.ohlc.google("AAPL");
volumeChart(apple)
}
\seealso{
  \code{\link{get.ohlc.yahoo}}

  \code{\link{get.ohlc.google}}
}

