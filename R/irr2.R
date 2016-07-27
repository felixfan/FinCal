#' Computing IRR, the internal rate of return
#' 
#' @param cf cash flow,the first cash flow is the initial outlay
#' @seealso \code{\link{pv.uneven}}
#' @seealso \code{\link{npv}}
#' @importFrom stats uniroot
#' @export
#' @examples
#' # irr(cf=c(-5, 1.6, 2.4, 2.8))
irr2 <- function(cf,cutoff=1e-3,from=-1, to=1, step=0.0001){
        n <- length(cf)
        subcf <- cf[2:n]
        r0 <- NA
        for(r in seq(from, to, step)){
            npv = cf[1] + pv.uneven(r, subcf)
            if (! is.na(npv)){
                if(abs(npv) < cutoff){
                    r0 <- r
                    break
                }
            }
        }

        if(is.na(r0)){
            stop("can not find irr in the given interval, please try smaller from and/or larger to")
        }
        return(r0)
}