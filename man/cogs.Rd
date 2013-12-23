\name{cogs}
\alias{cogs}
\title{Cost of goods sold and ending inventory under three methods (FIFO,LIFO,Weighted average)}
\usage{
cogs(uinv, pinv, units, price, sinv, method = "FIFO")
}
\arguments{
  \item{uinv}{units of beginning inventory}

  \item{pinv}{prince of beginning inventory}

  \item{units}{nx1 vector of inventory units. inventory
  purchased ordered by time (from first to last)}

  \item{price}{nx1 vector of inventory price. same order as
  units}

  \item{sinv}{units of sold inventory}

  \item{method}{inventory methods: FIFO (first in first
  out, permitted under both US and IFRS), LIFO (late in
  first out, US only), WAC (weighted average cost,US and
  IFRS)}
}
\description{
Cost of goods sold and ending inventory under three methods
(FIFO,LIFO,Weighted average)
}
\examples{
cogs(uinv=2,pinv=2,units=c(3,5),price=c(3,5),sinv=7,method="FIFO")

cogs(uinv=2,pinv=2,units=c(3,5),price=c(3,5),sinv=7,method="LIFO")

cogs(uinv=2,pinv=2,units=c(3,5),price=c(3,5),sinv=7,method="WAC")
}

