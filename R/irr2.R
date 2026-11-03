#' Computing IRR within a specified interval
#'
#' @description Finds one internal rate of return in a bounded interval. By
#'   default a bracketed solver refines the rate and checks a relative NPV
#'   residual. An explicit numeric cutoff selects the original grid search.
#' @param cf finite numeric cash flows, with the initial outlay at time zero.
#'   At least one positive and one negative cash flow are required.
#' @param cutoff NULL (default) selects scale-independent root finding. A
#'   positive number selects the legacy absolute NPV tolerance, in the same
#'   units as \code{cf}; rescale it with the cash flows. Numeric cutoffs are not
#'   tolerances on the returned rate.
#' @param from lower search bound, at least -1. The boundary -1 itself is excluded.
#' @param to finite upper search bound, greater than -1 and not less than from.
#' @param step positive rate-grid spacing. In the default mode it is used only
#'   if endpoint and coarse-grid bracketing fail; it does not set root accuracy.
#'   With a numeric cutoff it sets the legacy search grid.
#' @param tol relative NPV tolerance for the default mode, between 0 and 1.
#' @details With \code{cutoff=NULL}, searches stay above -1 and refine a
#'   sign-changing bracket rather than requiring the root to lie on the grid.
#'   The returned rate must satisfy \code{abs(NPV) / sum(abs(discounted cash
#'   flows)) <= tol}, evaluated using scaled terms to avoid overflow. Multiplying
#'   all cash flows by a nonzero constant does not change this criterion.
#'
#'   A numeric \code{cutoff} retains the original behavior: return the first
#'   rate on \code{seq(from, to, by=step)} above -1 with \code{abs(NPV) < cutoff}.
#'   A loose absolute cutoff can return a rate far from the IRR, and a tight one
#'   can miss a root between grid points. Omit cutoff to use refined root finding.
#'
#'   The default mode returns one root, not necessarily the lowest. Narrow the
#'   interval to select among multiple IRRs. Bracketing does not guarantee finding
#'   roots that touch zero without changing sign, or multiple roots between the
#'   same adjacent search points. Fallback and legacy scans can be slow for wide
#'   intervals with a tiny step. A failed search raises an error.
#' @return One finite rate strictly greater than -1 within the search bounds.
#' @seealso \code{\link{irr}}
#' @importFrom stats uniroot
#' @export
#' @examples
#' irr2(c(-1, 1.1))
#' irr2(c(-100, 110.05), from=0, to=0.2, step=0.001)
#' irr2(c(-100, 230, -132), from=0.05, to=0.15)
#' # Explicit cutoff keeps the original absolute-tolerance grid search:
#' irr2(c(-100, 110), cutoff=1e-6, from=0, to=0.2, step=0.001)
irr2 <- function(cf,cutoff=NULL,from=-1,to=10,step=0.000001,tol=1e-8){
  if (!is.numeric(cf) || is.complex(cf) || !is.null(dim(cf)) ||
      length(cf) < 2L || any(!is.finite(cf))) {
    stop("'cf' must be a finite numeric vector with at least two cash flows")
  }
  if (!any(cf > 0) || !any(cf < 0)) {
    stop("IRR requires at least one positive and one negative cash flow")
  }
  scalar <- function(x) is.numeric(x) && !is.complex(x) &&
    length(x) == 1L && is.finite(x)
  if (!scalar(from) || !scalar(to) || from < -1 || to <= -1 || to < from) {
    stop("Search bounds must be finite with -1 <= from <= to and to > -1")
  }
  if (!scalar(step) || step <= 0) stop("'step' must be finite and positive")
  if (!scalar(tol) || tol <= 0 || tol >= 1) {
    stop("'tol' must be a finite number strictly between 0 and 1")
  }
  if (!is.null(cutoff) && (!scalar(cutoff) || cutoff <= 0)) {
    stop("'cutoff' must be NULL or a finite positive absolute NPV tolerance")
  }
  lower <- max(from, -1 + .Machine$double.eps / 2)
  periods <- seq_along(cf) - 1

  if (is.null(cutoff)) {
    nonzero <- cf != 0
    times <- periods[nonzero]
    times <- times - times[1]
    logs <- log(abs(cf[nonzero]))
    signs <- sign(cf[nonzero])
    objective <- function(x) {
      weights <- logs - times * x
      terms <- signs * exp(weights - max(weights))
      sum(terms) / sum(abs(terms))
    }
    accept <- function(rate) {
      if (!is.finite(rate) || rate < lower || rate > to ||
          abs(objective(log1p(rate))) > tol) {
        stop("IRR search failed to find a rate with a sufficiently small NPV residual")
      }
      rate
    }
    refine <- function(a, b) {
      x <- uniroot(objective, interval=log1p(c(a,b)),
                   tol=min(1e-14, tol / max(1,max(times))), check.conv=TRUE)$root
      accept(min(to,max(lower,expm1(x))))
    }
    ends <- vapply(log1p(c(lower,to)),objective,numeric(1))
    if (lower == to) return(accept(lower))
    if (ends[1] == 0) return(accept(lower))
    if (ends[2] == 0) return(accept(to))
    if (sign(ends[1]) != sign(ends[2])) return(refine(lower,to))
    # A cheap first pass locates common multiple-IRR brackets.
    points <- seq(lower,to,length.out=129L)
    if (lower <= 0 && to >= 0) points <- sort(unique(c(points,0)))
    previous <- points[1]
    value <- ends[1]
    for (rate in points[-1]) {
      next.value <- objective(log1p(rate))
      if (next.value == 0) return(accept(rate))
      if (sign(value) != sign(next.value)) return(refine(previous,rate))
      previous <- rate
      value <- next.value
    }
    previous <- lower
    value <- ends[1]
  }

  # Stream bounded chunks instead of allocating a potentially huge rate vector.
  count <- floor((to-from)/step + 1e-10)
  if (!is.finite(count) || count > .Machine$integer.max ||
      (count > 0 && from + step == from)) {
    stop("The fallback grid is too large or too fine; adjust bounds or step")
  }
  for (first in seq(0,count,by=4096)) {
    grid <- pmin(to,from + seq(first,min(count,first+4095)) * step)
    for (rate in grid[grid > -1 & grid <= to]) {
      if (!is.null(cutoff)) {
        residual <- sum(cf / (1+rate)^periods)
        if (is.finite(residual) && abs(residual) < cutoff) return(rate)
      } else {
        next.value <- objective(log1p(rate))
        if (next.value == 0) return(accept(rate))
        if (sign(value) != sign(next.value)) return(refine(previous,rate))
        previous <- rate
        value <- next.value
      }
    }
  }
  if (is.null(cutoff) && previous < to && sign(value) != sign(ends[2])) {
    return(refine(previous,to))
  }
  stop("can not find irr in the given interval; adjust the bounds or step")
}
