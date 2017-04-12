#' Computing the rate of return for each period
#'
#' @param n number of periods
#' @param pv present value
#' @param fv future value
#' @param pmt payment per period
#' @param type payments occur at the end of each period (type=0); payments occur at the beginning of each period (type=1)
#' @param lower the lower end points of the rate of return to be searched.
#' @param upper the upper end points of the rate of return to be searched.
#' @seealso \code{\link{fv.simple}}
#' @seealso \code{\link{fv.annuity}}
#' @seealso \code{\link{fv}}
#' @seealso \code{\link{pv}}
#' @seealso \code{\link{pmt}}
#' @seealso \code{\link{n.period}}
#' @importFrom stats uniroot
#' @export
#' @examples
#' discount.rate(n=5,pv=0,fv=600,pmt=-100,type=0)
discount.rate <- function(n,pv,fv,pmt,type=0,lower=0.0001,upper=100){
        uniroot(function(r) fv.simple(r,n,pv) + fv.annuity(r,n,pmt,type)-fv, lower=lower, upper = upper)$root
}

