\name{EPS}
\alias{EPS}
\title{Basic Earnings Per Share}
\usage{
  EPS(ni, pd, w)
}
\arguments{
  \item{ni}{net income}

  \item{pd}{preferred dividends}

  \item{w}{weighted average number of common shares
  outstanding}
}
\description{
  Basic Earnings Per Share
}
\examples{
EPS(ni=10000,pd=1000,w=11000)
}
\seealso{
  \code{\link{diluted.EPS}}

  \code{\link{was}}
}

