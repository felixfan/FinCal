library(FinCal)

equal <- function(x,y,tolerance=1e-10) {
  stopifnot(isTRUE(all.equal(x,y,tolerance=tolerance,check.attributes=FALSE)))
}
fails <- function(expr) {
  stopifnot(inherits(tryCatch({ force(expr); NULL },error=identity),"error"))
}

# Reported examples: defaults are independent of the monetary unit and grid.
for (scale in c(1e-200,1,100,1e6,1e200)) {
  equal(irr2(c(-scale,1.1*scale)),0.1,tolerance=1e-12)
  equal(irr2(c(scale,-1.1*scale),from=0,to=0.2),0.1,tolerance=1e-12)
}
equal(irr2(c(-100,110.05),from=0,to=0.2,step=0.001),0.1005)
equal(irr2(c(-100,110.05),from=0,to=0.2,step=1),0.1005)

# Independent analytic roots and direct discounted-cash-flow checks.
for (rate in c(-0.99,-0.6,-0.1,0,0.1,1,49)) {
  for (n in c(1,2,5,20)) {
    for (scale in c(1e-100,1,1e100)) {
      cf <- c(-scale,rep(0,n-1),scale*(1+rate)^n)
      actual <- irr2(cf,to=max(10,2*rate+1))
      stopifnot(abs(actual-rate) < 1e-12)
      discounted <- cf/(1+actual)^(0:n)
      stopifnot(abs(sum(discounted)) / sum(abs(discounted)) < 1e-8)
    }
  }
}
equal(irr2(c(-100,110),from=0.1,to=0.1),0.1)
equal(irr2(c(0,-100,40,0)),-0.6)
equal(irr2(c(-1,1e100),from=1e99,to=1e101),1e100)

# Select distinct roots with bounds, and bracket roots inside one coarse cell.
equal(irr2(c(-100,230,-132),from=0.05,to=0.15),0.1)
equal(irr2(c(-100,230,-132),from=0.15,to=0.25),0.2)
stopifnot(min(abs(irr2(c(-100,230,-132))-c(0.1,0.2))) < 1e-10)
g <- 1+c(0.10035,0.10065)
equal(irr2(c(-100,100*sum(g),-100*prod(g)),from=0,to=1,step=0.0001),0.10035)

# Numeric cutoff deliberately keeps the absolute-tolerance, first-grid behavior.
amounts <- c(1,100,1e6)
equal(sapply(amounts,function(s)irr2(c(-s,1.1*s),cutoff=0.1,from=0,to=0.2)),
      c(0.000001,0.098902,0.1))
equal(sapply(amounts,function(s)irr2(c(-s,1.1*s),cutoff=1e-8*s,from=0,to=0.2)),
      rep(0.1,3))
fails(irr2(c(-100,110.05),cutoff=1e-6,from=0,to=0.2,step=0.001))
equal(irr2(c(-100,110.05),cutoff=1e-6,from=0,to=0.2,step=1e-5),0.1005)
equal(irr2(c(-100,50),cutoff=1e-8,from=-0.7,to=-0.5,step=0.01),-0.5)
fails(irr2(c(-100,120),cutoff=20,from=0,to=0))
equal(irr2(c(-100,120),cutoff=20+1e-8,from=0,to=0),0)

# No-root/invalid inputs must not produce small-money false positives or poles.
fails(irr2(c(-500,-200)))
fails(irr2(c(-1e-6,-1e-6),cutoff=0.1))
fails(irr2(c(-100,100,-100),from=0,to=0.2,step=0.01))
fails(irr2(c(-100,200),from=0,to=0.2,step=0.01))
fails(irr2(c(-1,1e-12)))
for (cf in list(numeric(),-100,c(NA,1),c(Inf,-1),c(0,0),c("-1","2"))) fails(irr2(cf))
for (args in list(list(from=-2),list(from=1,to=0),list(to=-1),list(to=Inf),
                  list(step=0),list(step=NA),list(cutoff=-1),list(cutoff=Inf),
                  list(tol=0),list(tol=1))) {
  fails(do.call(irr2,c(list(cf=c(-100,110)),args)))
}
