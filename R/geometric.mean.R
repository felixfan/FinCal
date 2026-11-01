#' Geometric mean return
#' 
#' @param r returns over multiple periods
#' @details Returns must be finite, nonempty, and at least -1. A total loss
#'   in any period gives a geometric mean return of -1.
#' @export
#' @examples
#' geometric.mean(r=c(-0.0934, 0.2345, 0.0892))
geometric.mean <- function(r){
  if (!is.numeric(r) || is.complex(r) || length(r) == 0L ||
      any(!is.finite(r)) || any(r < -1)) {
    stop("'r' must contain finite returns greater than or equal to -1")
  }
  expm1(mean(log1p(r)))
}
