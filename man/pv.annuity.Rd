\name{pv.annuity}
\alias{pv.annuity}
\title{Estimate present value (pv) of an annuity}
\usage{
pv.annuity(r, n, pmt, type = 0)
}
\arguments{
  \item{r}{discount rate, or the interest rate at which the
  amount will be compounded each period}

  \item{n}{number of periods}

  \item{pmt}{payment per period}

  \item{type}{payments occur at the end of each period
  (type=0); payments occur at the beginning of each period
  (type=1)}
}
\description{
Estimate present value (pv) of an annuity
}
\examples{
pv.annuity(0.03,12,1000)

pv.annuity(r=0.0425,n=3,pmt=30000)
}
\seealso{
\code{\link{pv}}
}

