\name{pv.uneven}
\alias{pv.uneven}
\title{Computing the present value of an uneven cash flow series}
\usage{
  pv.uneven(r, cf)
}
\arguments{
  \item{r}{discount rate, or the interest rate at which the
  amount will be compounded each period}

  \item{cf}{uneven cash flow}
}
\description{
  Computing the present value of an uneven cash flow series
}
\examples{
pv.uneven(r=0.1, cf=c(-1000, -500, 0, 4000, 3500, 2000))
}
\seealso{
  \code{\link{pv.simple}}

  \code{\link{npv}}
}

