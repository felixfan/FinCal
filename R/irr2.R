#' Computing IRR, the internal rate of return
#' @description This function is the same as irr but can calculate negative value. This function may take a very long time. You can use larger cutoff and larger step to get a less precision irr first. Then based on the result, change from and to, to narrow down the interval, and use a smaller step to get a more precision irr.
#' @param cf cash flow,the first cash flow is the initial outlay
#' @param cutoff threshold to take npv as zero
#' @param from smallest irr to try
#' @param to largest irr to try
#' @param step increment of the irr
#' @seealso \code{\link{irr}}
#' @export
#' @examples
#' # irr2(cf=c(-5, 1.6, 2.4, 2.8))
#' # irr2(cf=c(-200, 50, 60, -70, 30, 20))
irr2 <- function(cf,cutoff=0.1,from=-1, to=10, step=0.000001){
        r0 <- NA
        n <- length(cf)
        for(r in seq(from, to, step)){
            npv = cf[1]
            for(i in 2:n){
                npv = npv + cf[i]/(1+r)**(i-1)
            }
            if (! is.na(npv)){
                if(abs(npv) < cutoff){
                    r0 <- r
                    break
                }
            }
        }

        if(is.na(r0)){
            stop("can not find irr in the given interval, you can try smaller step, and/or larger to, and/or larger cutoff")
        }
        return(r0)
}