\name{ear}
\alias{ear}
\title{Convert stated annual rate to the effective annual rate}
\usage{
  ear(r, m)
}
\arguments{
  \item{r}{stated annual rate}

  \item{m}{number of compounding periods per year}
}
\description{
  Convert stated annual rate to the effective annual rate
}
\examples{
ear(r=0.12,m=12)

ear(0.04,365)
}
\seealso{
  \code{\link{ear.continuous}}

  \code{\link{hpr2ear}}

  \code{\link{ear2bey}}

  \code{\link{ear2hpr}}
}

