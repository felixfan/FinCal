#' diluted Earnings Per Share
#'
#' @param ni     net income
#' @param pd     preferred dividends
#' @param cpd    dividends on convertible preferred stock
#' @param cdi    interest on convertible debt
#' @param tax    tax rate
#' @param w      weighted average number of common shares outstanding
#' @param cps    shares from conversion of convertible preferred stock
#' @param cds    shares from conversion of convertible debt
#' @param iss    shares issuable from stock options
#' @details The supplied option, preferred-stock and debt classes are considered
#'   in increasing order of incremental earnings per share. A class is included
#'   only if it reduces earnings per share (or increases loss per share).
#' @seealso \code{\link{EPS}}
#' @seealso \code{\link{iss}}
#' @seealso \code{\link{was}}
#' @export
#' @examples
#' diluted.EPS(ni=115600,pd=10000,cdi=42000,tax=0.4,w=200000,cds=60000)
#' 
#' diluted.EPS(ni=115600,pd=10000,cpd=10000,w=200000,cps=40000)
#' 
#' diluted.EPS(ni=115600,pd=10000,w=200000,iss=2500)
#' 
#' diluted.EPS(ni=115600,pd=10000,cpd=10000,cdi=42000,tax=0.4,w=200000,cps=40000,cds=60000,iss=2500)
diluted.EPS <- function(ni, pd, cpd=0,cdi=0,tax=0,w,cps=0,cds=0,iss=0){
  if (length(w) != 1L || !is.finite(w) || w <= 0 ||
      any(!is.finite(c(ni,pd,cpd,cdi,tax,cps,cds,iss))) ||
      any(c(cps,cds,iss) < 0)) {
    stop("Inputs must be finite, with positive 'w' and nonnegative share counts")
  }
  earnings <- ni - pd
  shares <- w
  additions <- c(0, cpd, cdi * (1 - tax))
  new.shares <- c(iss, cps, cds)
  candidates <- which(new.shares > 0)
  candidates <- candidates[order(additions[candidates] / new.shares[candidates])]
  for (i in candidates) {
    candidate <- (earnings + additions[i]) / (shares + new.shares[i])
    if (candidate < earnings / shares) {
      earnings <- earnings + additions[i]
      shares <- shares + new.shares[i]
    }
  }
  earnings / shares
}
