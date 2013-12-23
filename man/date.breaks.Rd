\name{date.breaks}
\alias{date.breaks}
\title{Deciding width (days or weeks) for date_breaks in plotting}
\usage{
date.breaks(ohlc)
}
\arguments{
  \item{ohlc}{output from get.ohlc.yahoo or
  get.ohlc.google}
}
\description{
Deciding width (days or weeks) for date_breaks in plotting
}
\examples{
google <- get.ohlc.yahoo("GOOG"); date.breaks(google)
}

