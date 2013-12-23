\name{r.norminal}
\alias{r.norminal}
\title{Convert a given continuous compounded rate to a norminal rate}
\usage{
r.norminal(rc, m)
}
\arguments{
  \item{rc}{continuous compounded rate}

  \item{m}{number of desired times compounded each year}
}
\description{
Convert a given continuous compounded rate to a norminal
rate
}
\examples{
r.norminal(0.03,1)

r.norminal(0.03,4)
}
\seealso{
\code{\link{r.continuous}}

\code{\link{ear.continuous}}
}

