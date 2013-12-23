\name{hpr2ear}
\alias{hpr2ear}
\title{Convert holding period return to the effective annual rate}
\usage{
hpr2ear(hpr, t)
}
\arguments{
  \item{hpr}{holding period return}

  \item{t}{number of days remaining until maturity}
}
\description{
Convert holding period return to the effective annual rate
}
\examples{
hpr2ear(hpr=0.015228,t=120)
}
\seealso{
\code{\link{ear}}

\code{\link{hpr}}

\code{\link{ear2hpr}}
}

