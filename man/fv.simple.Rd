\name{fv.simple}
\alias{fv.simple}
\title{Estimate future value (fv) of a single sum}
\usage{
  fv.simple(r, n, pv)
}
\arguments{
  \item{r}{discount rate, or the interest rate at which the
  amount will be compounded each period}

  \item{n}{number of periods}

  \item{pv}{present value}
}
\description{
  Estimate future value (fv) of a single sum
}
\examples{
fv.simple(0.08,10,-300)

fv.simple(r=0.04,n=20,pv=-50000)
}
\seealso{
  \code{\link{fv}}
}

