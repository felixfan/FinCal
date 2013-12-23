\name{pv.simple}
\alias{pv.simple}
\title{Estimate present value (pv) of a single sum}
\usage{
pv.simple(r, n, fv)
}
\arguments{
  \item{r}{discount rate, or the interest rate at which the
  amount will be compounded each period}

  \item{n}{number of periods}

  \item{fv}{future value}
}
\description{
Estimate present value (pv) of a single sum
}
\examples{
pv.simple(0.07,10,100)

pv.simple(r=0.03,n=3,fv=1000)
}
\seealso{
\code{\link{pv}}
}

