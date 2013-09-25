\name{ddb}
\alias{ddb}
\title{Depreciation Expense Recognition -- double-declining balance (DDB), the most common declining balance method, which applies two times the straight-line rate to the declining balance.}
\usage{
  ddb(cost, rv, t)
}
\arguments{
  \item{cost}{cost of long-lived assets}

  \item{rv}{residual value of the long-lived assets at the
  end of its useful life. DDB does not explicitly use the
  asset's residual value in the calculations, but
  depreciation ends once the estimated residual value has
  been reached. If the asset is expected to have no
  residual value, the DB method will never fully depreciate
  it, so the DB method is typically changed to
  straight-line at some point in the asset's life.}

  \item{t}{length of the useful life}
}
\description{
  Depreciation Expense Recognition -- double-declining
  balance (DDB), the most common declining balance method,
  which applies two times the straight-line rate to the
  declining balance.
}
\examples{
ddb(cost=1200,rv=200,t=5)
}
\seealso{
  \code{\link{slde}}
}

