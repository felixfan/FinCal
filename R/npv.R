#' Computing NPV, the PV of the cash flows less the initial (time = 0) outlay
#'
#' @param r discount rate, or the interest rate at which the amount will be compounded each period
#' @param cf nonempty cash flow vector; the first cash flow is at time zero
#' @details A single cash flow is returned unchanged because it occurs at time
#'   zero. Appending zero payments does not change its value.
#' @seealso \code{\link{pv.simple}}
#' @seealso \code{\link{pv.uneven}}
#' @seealso \code{\link{irr}}
#' @export
#' @examples
#' npv(r=0.12, cf=c(-5, 1.6, 2.4, 2.8))
#' npv(r=0.1, cf=-100)
npv <- function(r,cf){
  n <- length(cf)
  if (n == 0L) stop("'cf' must contain at least one cash flow")
  if (n == 1L) return(cf[1])
  subcf <- cf[2:n]
  return(-1 * pv.uneven(r, subcf) + cf[1])
}

