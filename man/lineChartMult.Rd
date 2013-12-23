\name{lineChartMult}
\alias{lineChartMult}
\title{Technical analysts - Line charts: show prices for each period as a continuous line for multiple stocks}
\usage{
lineChartMult(ohlcs, y = "close", main = "", ...)
}
\arguments{
  \item{ohlcs}{output from get.ohlc.yahoo.mult or
  get.ohlc.google.mult}

  \item{y}{y coordinates: close, open, high, low or
  adjusted}

  \item{main}{an overall title for the plot}

  \item{...}{Arguments to be passed to methods}
}
\description{
Technical analysts - Line charts: show prices for each
period as a continuous line for multiple stocks
}
\examples{
googapple <- get.ohlcs.yahoo(c("GOOG","AAPL"),start="2013-01-01");
lineChartMult(googapple)

googapple <- get.ohlcs.google(c("GOOG","AAPL"),start="2013-01-01");
lineChartMult(googapple)
}
\seealso{
\code{\link{get.ohlcs.yahoo}}

\code{\link{get.ohlcs.google}}

\code{\link{lineChart}}
}

