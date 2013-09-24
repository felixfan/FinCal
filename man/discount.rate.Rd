\name{discount.rate}
\alias{discount.rate}
\title{Computing the rate of return for each period}
\usage{
  discount.rate(n, pv, fv, pmt, type = 0)
}
\arguments{
  \item{n}{number of periods}

  \item{pv}{present value}

  \item{fv}{future value}

  \item{pmt}{payment per period}

  \item{type}{payments occur at the end of each period
  (type=0); payments occur at the beginning of each period
  (type=1)}
}
\description{
  Computing the rate of return for each period
}
\examples{
discount.rate(n=5,pv=0,fv=600,pmt=-100,type=0)
}
\seealso{
  \code{\link{fv.simple}}

  \code{\link{fv.annuity}}
}

