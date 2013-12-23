\name{pmt}
\alias{pmt}
\title{Estimate period payment}
\usage{
pmt(r, n, pv, fv, type = 0)
}
\arguments{
  \item{r}{discount rate, or the interest rate at which the
  amount will be compounded each period}

  \item{n}{number of periods}

  \item{pv}{present value}

  \item{fv}{future value}

  \item{type}{payments occur at the end of each period
  (type=0); payments occur at the beginning of each period
  (type=1)}
}
\description{
Estimate period payment
}
\examples{
pmt(0.08,10,-1000,10)

pmt(r=0.08,n=10,pv=-1000,fv=0)

pmt(0.08,10,-1000,10,1)
}
\seealso{
\code{\link{pv}}

\code{\link{fv}}

\code{\link{n.period}}
}

