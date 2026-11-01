#' Calculate Yield (IRR) Using Actual Calendar Dates
#'
#' Calculates the internal rate of return for a series of cash flows using
#' actual calendar dates and specified compounding convention. This is equivalent
#' to yield-to-maturity for bonds and effective yield for loan participations.
#'
#' @param cf Data frame with 'date' and 'amount' columns, or a named vector
#'   with dates as names and amounts as values
#' @param pv Present value (initial investment or purchase price). Should be positive.
#' @param start_date Date of investment. If NULL, uses the first cash flow date.
#'   Can be Date object or string in format "YYYY-MM-DD".
#' @param compounding Compounding frequency: "monthly" (12x/year), "semiannual" (2x/year),
#'   "quarterly" (4x/year), "annual" (1x/year), or "continuous"
#' @param max_iter Maximum iterations for root finding (default: 100)
#' @param tol Convergence tolerance (default: 1e-8)
#'
#' @return Annual yield as decimal (e.g., 0.0564 = 5.64%), or NA with a warning
#'   when a valid, converged solution cannot be found.
#' 
#' @details
#' The 'amount' column in cf should represent cash flows received by the investor
#' (positive values). The initial investment (pv) is specified separately as a
#' positive number and should not be included in the cf data frame.
#' 
#' **Choosing the compounding convention:**
#' The compounding frequency should match the market convention for quoting yields
#' on similar instruments, not necessarily the frequency of cash flows:
#' \itemize{
#'   \item Use "monthly" for mortgages, auto loans, and most consumer/commercial loans
#'   \item Use "semiannual" for US Treasury bonds and most corporate bonds
#'   \item Use "annual" for a simple effective annual rate
#'   \item The cash flows themselves can be irregular regardless of compounding choice
#' }
#' 
#' This function solves for the yield y that satisfies:
#' \deqn{PV = \sum_{i=1}^{n} \frac{CF_i}{(1 + y/m)^{m \times t_i}}}
#' where m is the compounding frequency and t_i is the time in years to cash flow i.
#' 
#' For continuous compounding:
#' \deqn{PV = \sum_{i=1}^{n} CF_i \times e^{-y \times t_i}}
#' 
#' Time periods are calculated using actual calendar days divided by 365.25.
#' Cash flows on the investment date have time zero. Cash flows before the
#' investment date are rejected. At least one later cash flow is required.
#' The search expands in continuously compounded yield, preserving the valid
#' discrete-yield domain y > -m. A result is accepted only after convergence and
#' a relative present-value residual check with tolerance \code{tol}. Failed
#' searches warn and return NA. Mixed-sign cash flows can have multiple yields;
#' the search does not guarantee finding all or any of them.
#' 
#' @seealso \code{\link{irr}} for period-based IRR without dates
#' @seealso \code{\link{npv}} for net present value calculation
#' 
#' @export
#' @examples
#' # Example 1: Loan participation with monthly cash flows
#' # Investor pays $100,000 and receives $8,500/month for 12 months
#' cash_flows <- data.frame(
#'   date = seq(as.Date("2025-02-01"), by = "month", length.out = 12),
#'   amount = rep(8500, 12)  # Cash received each month
#' )
#' yield.actual(cash_flows, pv = 100000, start_date = "2025-01-01")
#' 
#' # Example 2: Bond with semiannual coupons
#' # Purchase price $98,000, receive $2,500 coupons + $100,000 at maturity
#' bond_cfs <- data.frame(
#'   date = as.Date(c("2025-07-01", "2026-01-01", "2026-07-01")),
#'   amount = c(2500, 2500, 102500)  # Coupons received + final principal
#' )
#' yield.actual(bond_cfs, pv = 98000, compounding = "semiannual")
#' 
#' # Example 3: Irregular cash flows
#' irregular_cfs <- data.frame(
#'   date = as.Date(c("2025-03-15", "2025-06-30", "2025-12-31")),
#'   amount = c(5000, 5000, 95000)  # Payments received on various dates
#' )
#' yield.actual(irregular_cfs, pv = 100000, start_date = "2025-01-01",
#'              compounding = "monthly")
#' 
#' # Example 4: Using named vector format
#' # Same as Example 1 but more compact
#' cf_vector <- setNames(
#'   rep(8500, 12),
#'   seq(as.Date("2025-02-01"), by = "month", length.out = 12)
#' )
#' yield.actual(cf_vector, pv = 100000, start_date = "2025-01-01")
yield.actual <- function(cf, 
                         pv,
                         start_date = NULL,
                         compounding = c("monthly", "semiannual", "quarterly", 
                                         "annual", "continuous"),
                         max_iter = 100, 
                         tol = 1e-8) {
  
  # Match compounding argument
  compounding <- match.arg(compounding)
  
  # Set compounding frequency
  comp_freq <- switch(compounding,
                      monthly = 12,
                      quarterly = 4,
                      semiannual = 2,
                      annual = 1,
                      continuous = Inf)
  
  # Input validation
  if (missing(pv) || is.null(pv)) {
    stop("pv (present value) is required")
  }
  
  if (!is.numeric(pv) || is.complex(pv) || length(pv) != 1L ||
      !is.finite(pv) || pv <= 0) {
    stop("pv must be a finite positive number")
  }
  if (!is.numeric(max_iter) || length(max_iter) != 1L ||
      !is.finite(max_iter) || max_iter < 1 || max_iter > .Machine$integer.max ||
      max_iter != floor(max_iter)) {
    stop("max_iter must be a positive integer")
  }
  if (!is.numeric(tol) || length(tol) != 1L || !is.finite(tol) || tol <= 0) {
    stop("tol must be a finite positive number")
  }
  
  # Handle different cf input formats
  if (is.data.frame(cf)) {
    # Check for required columns
    if (!all(c("date", "amount") %in% names(cf))) {
      stop("cf data frame must contain 'date' and 'amount' columns")
    }
    dates <- as.Date(cf$date)
    amounts <- cf$amount
  } else if (is.vector(cf) && !is.null(names(cf))) {
    # Named vector: names are dates, values are amounts
    dates <- as.Date(names(cf))
    amounts <- as.numeric(cf)
  } else {
    stop("cf must be a data frame with 'date' and 'amount' columns, or a named vector")
  }
  
  if (!is.numeric(amounts) || is.complex(amounts)) {
    stop("cash-flow amounts must be numeric")
  }
  # Clean cash flows
  valid_idx <- is.finite(amounts) & amounts != 0 & is.finite(as.numeric(dates))
  dates <- dates[valid_idx]
  amounts <- amounts[valid_idx]
  
  if (length(amounts) == 0) {
    warning("No valid cash flows provided")
    return(NA_real_)
  }
  
  # Sort by date
  sort_idx <- order(dates)
  dates <- dates[sort_idx]
  amounts <- amounts[sort_idx]
  
  # Set start date
  if (is.null(start_date)) {
    start_date <- min(dates)
  } else {
    start_date <- as.Date(start_date)
  }
  if (length(start_date) != 1L || !is.finite(as.numeric(start_date))) {
    stop("start_date must be a single valid date")
  }
  
  # Calculate time periods in years
  t_years <- as.numeric(difftime(dates, start_date, units = "days")) / 365.25
  if (any(t_years < 0)) {
    stop("cash-flow dates must not precede start_date")
  }
  if (!any(t_years > 0)) {
    warning("Yield requires at least one cash flow after start_date")
    return(NA_real_)
  }

  # In continuously compounded yield x, every discount factor is exp(-x*t).
  # Include the investment as a negative time-zero term and normalize the terms
  # in log space. Signs and relative residuals survive extreme monetary scales.
  log.amounts <- log(abs(c(amounts, -pv)))
  signs <- sign(c(amounts, -pv))
  times <- c(t_years, 0)
  relative.pv <- function(x) {
    logs <- log.amounts - x * times
    terms <- signs * exp(logs - max(logs))
    sum(terms) / sum(abs(terms))
  }
  if (relative.pv(0) == 0) return(0)

  if (compounding == "continuous") {
    limit <- .Machine$double.xmax / (2 * max(1, max(times)))
    limits <- c(-limit, limit)
  } else {
    limits <- comp_freq * c(log(.Machine$double.eps / 2),
                           log(.Machine$double.xmax) - log(comp_freq))
  }

  tryCatch({
    interval <- c(-1, 1)
    values <- vapply(interval, relative.pv, numeric(1))
    iter <- 0L
    while (sign(values[1]) == sign(values[2]) && all(values != 0)) {
      expanded <- pmax(limits[1], pmin(limits[2], 2 * interval))
      if (identical(expanded, interval) || iter >= max_iter) {
        stop("No sign change found for a finite yield in the valid domain")
      }
      interval <- expanded
      values <- vapply(interval, relative.pv, numeric(1))
      iter <- iter + 1L
    }
    x <- uniroot(relative.pv, interval=interval, f.lower=values[1],
                 f.upper=values[2], check.conv=TRUE, maxiter=max_iter,
                 tol=min(tol, 1e-12) / max(1, max(times)))$root
    yield <- if (compounding == "continuous") x else comp_freq * expm1(x / comp_freq)
    if (!is.finite(yield) ||
        (compounding != "continuous" && yield <= -comp_freq)) {
      stop("Yield is outside the finite representable domain")
    }
    converted <- if (compounding == "continuous") yield else
      comp_freq * log1p(yield / comp_freq)
    if (abs(relative.pv(converted)) > tol) {
      stop("Present-value residual exceeds tolerance")
    }
    yield
  }, error = function(e) {
    warning("Yield calculation failed: ", e$message)
    return(NA_real_)
  })
}
