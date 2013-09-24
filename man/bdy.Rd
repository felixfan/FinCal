\name{bdy}
\alias{bdy}
\title{Computing bank discount yield (BDY) for a T-bill}
\usage{
  bdy(d, f, t)
}
\arguments{
  \item{d}{the dollar discount, which is equal to the
  difference between the face value of the bill and the
  purchase price}

  \item{f}{the face value (par value) of the bill}

  \item{t}{number of days remaining until maturity}
}
\description{
  Computing bank discount yield (BDY) for a T-bill
}
\examples{
bdy(d=1500,f=100000,t=120)
}
\seealso{
  \code{\link{bdy2mmy}}
}

