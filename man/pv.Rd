\name{pv}
\alias{pv}
\title{Estimate present value (pv)}
\usage{
  pv(r, n, fv = 0, pmt = 0, type = 0)
}
\arguments{
  \item{r}{discount rate, or the interest rate at which the
  amount will be compounded each period}

  \item{n}{number of periods}

  \item{fv}{future value}

  \item{pmt}{payment per period}

  \item{type}{payments occur at the end of each period
  (type=0); payments occur at the beginning of each period
  (type=1)}
}
\description{
  Estimate present value (pv)
}
\examples{
pv(0.07,10,1000,10)

pv(r=0.05,n=20,fv=1000,pmt=10,type=1)
}
\seealso{
  \code{\link{pv.simple}}

  \code{\link{pv.annuity}}
}

