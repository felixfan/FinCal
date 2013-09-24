\name{n.period}
\alias{n.period}
\title{Estimate the number of periods}
\usage{
  n.period(r, pv, fv, pmt, type = 0)
}
\arguments{
  \item{r}{discount rate, or the interest rate at which the
  amount will be compounded each period}

  \item{pv}{present value}

  \item{fv}{future value}

  \item{pmt}{payment per period}

  \item{type}{payments occur at the end of each period
  (type=0); payments occur at the beginning of each period
  (type=1)}
}
\description{
  Estimate the number of periods
}
\examples{
n.period(0.1,-10000,60000000,-50000,0)

n.period(r=0.1,pv=-10000,fv=60000000,pmt=-50000,type=1)
}
\seealso{
  \code{\link{pv}}

  \code{\link{fv}}

  \code{\link{pmt}}
}

