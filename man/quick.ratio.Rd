\name{quick.ratio}
\alias{quick.ratio}
\title{quick ratio -- Liquidity ratios measure the firm's ability to satisfy its short-term obligations as they come due.}
\usage{
  quick.ratio(cash, ms, rc, cl)
}
\arguments{
  \item{cash}{cash}

  \item{ms}{marketable securities}

  \item{rc}{receivables}

  \item{cl}{current liabilities}
}
\description{
  quick ratio -- Liquidity ratios measure the firm's
  ability to satisfy its short-term obligations as they
  come due.
}
\examples{
quick.ratio(cash=3000,ms=2000,rc=1000,cl=2000)
}
\seealso{
  \code{\link{current.ratio}}

  \code{\link{cash.ratio}}
}

