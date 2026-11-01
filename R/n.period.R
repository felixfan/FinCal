#' Estimate the number of periods
#'
#' @param r discount rate, or the interest rate at which the amount will be compounded each period
#' @param pv present value
#' @param fv future value
#' @param pmt payment per period
#' @param type payments occur at the end of each period (type=0); payments occur at the beginning of each period (type=1)
#' @seealso \code{\link{pv}}
#' @seealso \code{\link{fv}}
#' @seealso \code{\link{pmt}}
#' @seealso \code{\link{discount.rate}}
#' @export
#' @examples
#' n.period(0.1,-10000,60000000,-50000,0)
#'
#' n.period(r=0.1,pv=-10000,fv=60000000,pmt=-50000,type=1)
n.period <- function(r,pv,fv,pmt,type=0){
  if(type != 0 && type !=1){
    print("Error: type should be 0 or 1!")
  }else{
    n <-  if (r == 0){
      -1 * (fv+pv) / pmt
    }else{
      payment <- pmt * (1 + r)^type
      denominator <- pv * r + payment
      change <- -r * (fv + pv) / denominator
      # log1p is accurate near a unit ratio; use the direct ratio away from
      # one so a very small positive growth factor is not rounded down to zero.
      log.growth <- log((payment - fv * r) / denominator)
      near.one <- is.finite(change) & abs(change) < 0.5
      log.growth[near.one] <- log1p(change[near.one])
      log.growth / log1p(r)
    }
    return(n)
  }
}

