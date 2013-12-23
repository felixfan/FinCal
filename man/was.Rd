\name{was}
\alias{was}
\title{calculate weighted average shares -- weighted average number of common shares}
\usage{
was(ns, nm)
}
\arguments{
  \item{ns}{n x 1 vector vector of number of shares}

  \item{nm}{n x 1 vector vector of number of months relate
  to ns}
}
\description{
calculate weighted average shares -- weighted average
number of common shares
}
\examples{
s=c(10000,2000);m=c(12,6);was(ns=s,nm=m)

s=c(11000,4400,-3000);m=c(12,9,4);was(ns=s,nm=m)
}
\seealso{
\code{\link{EPS}}

\code{\link{diluted.EPS}}
}

