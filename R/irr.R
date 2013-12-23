#' Computing IRR, the internal rate of return
#' 
#' @param cf cash flow,the first cash flow is the initial outlay
#' @seealso \code{\link{pv.uneven}}
#' @seealso \code{\link{npv}}
#' @export
#' @examples
#' irr(cf=c(-5, 1.6, 2.4, 2.8))
irr <- function(cf){
  r <- seq(0,1,by=0.000001)
  m <- length(r) 
  n <- length(cf)
  subcf <- cf[2:n]
  for(i in 2:m){
    npv <- -1 * pv.uneven(r[i], subcf) + cf[1]
    if(abs(npv) < 0.000001 || npv < 0){
      break
    }
  }
  return(r[i])
}

