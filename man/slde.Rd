\name{slde}
\alias{slde}
\title{Depreciation Expense Recognition -- Straight-line depreciation (SL) allocates an equal amount of depreciation each year over the asset's useful life}
\usage{
  slde(cost, rv, t)
}
\arguments{
  \item{cost}{cost of long-lived assets}

  \item{rv}{residual value of the long-lived assets at the
  end of its useful life}

  \item{t}{length of the useful life}
}
\description{
  Depreciation Expense Recognition -- Straight-line
  depreciation (SL) allocates an equal amount of
  depreciation each year over the asset's useful life
}
\examples{
slde(cost=1200,rv=200,t=5)
}
\seealso{
  \code{\link{ddb}}
}

