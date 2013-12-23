#' Computing the rate of return for each period
#'
#' @param n number of periods
#' @param pv present value
#' @param fv future value
#' @param pmt payment per period
#' @param type payments occur at the end of each period (type=0); payments occur at the beginning of each period (type=1)
#' @seealso \code{\link{fv.simple}}
#' @seealso \code{\link{fv.annuity}}
#' @seealso \code{\link{fv}}
#' @seealso \code{\link{pv}}
#' @seealso \code{\link{pmt}}
#' @seealso \code{\link{n.period}}
#' @export
#' @examples
#' discount.rate(n=5,pv=0,fv=600,pmt=-100,type=0)
discount.rate <- function(n,pv,fv,pmt,type=0){
r <- seq(0,1,by=0.000001)
m <- length(r)

if (fv.simple(r[2],n,pv) + fv.annuity(r[2],n,pmt,type) < fv){
flag <- 1
}else{
flag <- 0
}

for(i in 2:m){
sumfv <- fv.simple(r[i],n,pv) + fv.annuity(r[i],n,pmt,type)
error <- abs(sumfv-fv)

	if(flag == 1){
		if(error < 0.000001 || sumfv > fv){
		break
		}
	}else{
		if(error < 0.000001 || sumfv < fv){
		break
		}
	}
}
return(r[i])
}

