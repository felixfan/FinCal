library(FinCal)

assert.error <- function(expr, pattern) {
  message <- tryCatch({ force(expr); NULL }, error = conditionMessage)
  stopifnot(is.character(message), length(message) == 1L,
            grepl(pattern, message, fixed = TRUE))
}

assert.irr <- function(cf, expected, tolerance = 1e-9) {
  rate <- irr(cf)
  stopifnot(is.finite(rate), rate > -1,
            abs(rate - expected) <= tolerance * max(1, abs(expected)))
  # Verify the equation independently of the solver's scaled objective.
  # Leading zero periods contribute a common positive discount factor; remove
  # them to keep the direct power calculation representable at extreme rates.
  cf <- cf[min(which(cf != 0)):length(cf)]
  discounted <- cf / (1 + rate)^(seq_along(cf) - 1)
  stopifnot(abs(sum(discounted)) <= 1e-8 * sum(abs(discounted)))
  invisible(rate)
}

# Issue #6: negative returns must not be skipped, and r = -1 is not a root.
assert.irr(c(-100, 40), -0.6)
assert.irr(c(-100, 90), -0.1)
assert.error(irr(c(-500, -200)), "positive and one negative")
assert.error(irr(c(500, 200)), "positive and one negative")

# Analytic single-payment cases, including rates outside the old interval.
for (rate in c(-0.99999, -0.99, -0.9, -0.6, -0.1, 0, 0.1, 1, 10, 1e12)) {
  for (period in c(1, 2, 5, 20)) {
    cf <- c(-100, rep(0, period - 1), 100 * (1 + rate)^period)
    assert.irr(cf, rate)
    assert.irr(-cf, rate)
  }
}

# Independent textbook and polynomial examples, intermediate payments,
# leading/trailing zeros, and a zero return.
assert.irr(c(-100, 60, 60), (60 + sqrt(27600)) / 200 - 1)
assert.irr(c(-100, 0, 121), 0.1)
assert.irr(c(-100, 10, 110), 0.1)
assert.irr(c(-100, 20, 30, 50), 0)
assert.irr(c(0, 0, -100, 40, 0, 0), -0.6)
assert.irr(c(-1, 0, 0, 0, 0, 32), 1)

# Scaling the monetary unit must not change the rate or create a false zero.
for (scale in c(1e-300, 1e-12, 1, 1e12, 1e300)) {
  assert.irr(scale * c(-1, 0.4), -0.6)
  assert.irr(scale * c(-1, 1.1), 0.1)
  assert.error(irr(scale * c(-1, 1, -1)), "No sign change")
}

# A long series and extreme rates must not overflow/underflow during search.
assert.irr(c(-1, rep(0, 999), 2), expm1(log(2) / 1000))
assert.irr(c(-1, 1e300), 1e300)
assert.irr(c(0, -1, 1e300), 1e300)
assert.irr(c(-1e-300, 1), 1e300)
assert.irr(c(-1e300, 1e300), 0)

# Mixed signs are necessary but not sufficient: these polynomials have no
# positive discount-factor root. Boundary-only roots are also rejected.
assert.error(irr(c(-100, 100, -100)), "No sign change")
assert.error(irr(c(100, -100, 100)), "No sign change")
assert.error(irr(c(-100, 0)), "positive and one negative")
assert.error(irr(c(0, 100)), "positive and one negative")
assert.error(irr(c(0, 0)), "positive and one negative")

# A mathematical root too close to -1 cannot pass the residual check after
# conversion to a representable rate. Do not return a misleading approximation.
assert.error(irr(c(-1, 1e-12)), "NPV residual")
assert.error(irr(c(-1, 1e-20)), "No sign change")

for (cf in list(numeric(), -100, c(-100, NA), c(-100, NaN),
                c(-100, Inf), c(-100, -Inf), c("-100", "40"),
                c(-100 + 0i, 40 + 0i), list(-100, 40), matrix(c(-100, 40)))) {
  assert.error(irr(cf), "finite numeric vector")
}
