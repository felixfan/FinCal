#' Computing IRR, the internal rate of return
#'
#' @param cf finite numeric cash flows, with the initial outlay at time zero.
#'   At least one positive and one negative cash flow are required.
#' @details The search expands in log(1 + r), within the range of finite rates
#'   strictly greater than -1. The returned rate must have an absolute NPV no
#'   larger than 1e-8 times the sum of the absolute discounted cash flows.
#'   This relative residual is evaluated using scaled discounted cash flows to
#'   avoid overflow and underflow. An error is raised if no sign-changing bracket
#'   is found or the residual check fails. Cash flows with multiple sign changes
#'   can have multiple IRRs; this search is not guaranteed to find any or all of
#'   them, and does not establish uniqueness.
#' @return A finite internal rate of return strictly greater than -1.
#' @seealso \code{\link{pv.uneven}}
#' @seealso \code{\link{npv}}
#' @importFrom stats uniroot
#' @export
#' @examples
#' irr(cf=c(-5, 1.6, 2.4, 2.8))
#' irr(cf=c(-100, 40))
irr <- function(cf){
  if (!is.numeric(cf) || is.complex(cf) || !is.null(dim(cf)) ||
      length(cf) < 2L || any(!is.finite(cf))) {
    stop("'cf' must be a finite numeric vector with at least two cash flows")
  }
  if (!any(cf > 0) || !any(cf < 0)) {
    stop("IRR requires at least one positive and one negative cash flow")
  }

  nonzero <- cf != 0
  periods <- (seq_along(cf) - 1)[nonzero]
  periods <- periods - periods[1]
  log.cf <- log(abs(cf[nonzero]))
  signs <- sign(cf[nonzero])

  # NPV / sum(abs(discounted cash flows)); common positive scaling preserves
  # roots and signs without overflowing near -1 or underflowing at large rates.
  relative.npv <- function(x) {
    log.terms <- log.cf - periods * x
    terms <- signs * exp(log.terms - max(log.terms))
    sum(terms) / sum(abs(terms))
  }

  if (relative.npv(0) == 0) {
    return(0)
  }

  # expm1(lower) is the closest representable rate above -1. Expanding in
  # log gross returns cannot cross the NPV discontinuity at r = -1.
  limits <- c(log(.Machine$double.eps / 2), log(.Machine$double.xmax))
  interval <- c(-1, 1)
  values <- vapply(interval, relative.npv, numeric(1))
  while (sign(values[1]) == sign(values[2]) && all(values != 0)) {
    expanded <- pmax(limits[1], pmin(limits[2], 2 * interval))
    if (identical(expanded, interval)) {
      stop("No sign change found for a finite IRR greater than -1")
    }
    interval <- expanded
    values <- vapply(interval, relative.npv, numeric(1))
  }

  root <- uniroot(relative.npv, interval = interval,
                  f.lower = values[1], f.upper = values[2],
                  tol = 1e-12, check.conv = TRUE)$root
  rate <- expm1(root)
  # Check the rate after conversion, since rounding near -1 can increase NPV.
  if (!is.finite(rate) || rate <= -1 ||
      abs(relative.npv(log1p(rate))) > 1e-8) {
    stop("IRR search failed to find a rate with a sufficiently small NPV residual")
  }
  rate
}
