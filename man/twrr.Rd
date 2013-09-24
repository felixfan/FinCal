\name{twrr}
\alias{twrr}
\title{Computing TWRR, the time-weighted rate of return}
\usage{
  twrr(ev, bv, cfr)
}
\arguments{
  \item{ev}{ordered ending value list}

  \item{bv}{ordered beginning value list}

  \item{cfr}{ordered cash flow received list}
}
\description{
  Computing TWRR, the time-weighted rate of return
}
\examples{
twrr(ev=c(120,260),bv=c(100,240),cfr=c(2,4))
}
\seealso{
  \code{\link{hpr}}
}

