library(FinCal)

equal <- function(actual, expected, tolerance=1e-9) {
  stopifnot(isTRUE(all.equal(actual, expected, tolerance=tolerance,
                            check.attributes=FALSE)))
}
fails <- function(expr) {
  stopifnot(inherits(tryCatch({ force(expr); NULL }, error=identity), "error"))
}

# F01: inventory unit-level references and total-cost conservation.
for (method in c("FIFO", "LIFO", "WAC")) {
  for (sold in 0:10) {
    lots <- rep(c(2,3,5), c(2,3,5))
    if (method == "LIFO") lots <- rev(lots)
    sold.cost <- if (method == "WAC") mean(lots)*sold else sum(head(lots,sold))
    result <- cogs(2,2,c(3,5),c(3,5),sold,method)
    equal(result$costOfGoods, sold.cost)
    equal(result$endingInventory, sum(lots)-sold.cost)
    equal(sum(unlist(result)), sum(lots))
  }
  equal(unlist(cogs(2,2,numeric(),numeric(),1,method)), c(2,2))
  equal(unlist(cogs(0,2,numeric(),numeric(),0,method)), c(0,0))
  fails(cogs(2,2,c(3,5),c(3,5),11,method))
}

# F02 / issue #5: time-zero cash flow and adding zero payments are invariant.
for (rate in c(-0.9,0,0.1,2)) {
  for (amount in c(-100,0,100)) {
    equal(npv(rate, amount), amount)
    equal(npv(rate, c(amount,0)), amount)
  }
  for (cf in list(c(-100,40), c(-100,10,20,90), c(20,-30,5))) {
    equal(npv(rate,cf), sum(cf/(1+rate)^(seq_along(cf)-1)))
  }
}
fails(npv(0.1,numeric()))

# F03-F05: actual dates, analytic yields, convergence, scale, and valid domains.
cf <- data.frame(date=as.Date(c("2025-01-01","2026-01-01")),amount=c(10,110))
t <- 365/365.25
for (convention in c("monthly","quarterly","semiannual","annual","continuous")) {
  m <- switch(convention,monthly=12,quarterly=4,semiannual=2,annual=1,continuous=Inf)
  continuous <- log(110/90)/t
  expected <- if (is.infinite(m)) continuous else m*expm1(continuous/m)
  y <- yield.actual(cf,100,"2025-01-01",convention)
  equal(y,expected)
  discounted <- if (is.infinite(m)) cf$amount*exp(-y*c(0,t)) else
    cf$amount/(1+y/m)^(m*c(0,t))
  stopifnot(abs(sum(discounted)-100) < 1e-6)

  for (payment in c(0.5,110,400)) {
    one <- data.frame(date=as.Date("2026-01-01"),amount=payment)
    x <- log(payment/100)/t
    expected <- if (is.infinite(m)) x else m*expm1(x/m)
    equal(yield.actual(one,100,"2025-01-01",convention),expected)
  }
}
for (scale in c(1e-200,1,1e200)) {
  scaled <- transform(cf,amount=amount*scale)
  equal(yield.actual(scaled,100*scale,"2025-01-01","continuous"), log(110/90)/t)
}
equal(yield.actual(setNames(cf$amount,as.character(cf$date)),100,
                   "2025-01-01","continuous"), log(110/90)/t)
warnings <- character()
one <- data.frame(date=as.Date("2026-01-01"),amount=150)
result <- withCallingHandlers(
  yield.actual(one,100,"2025-01-01","continuous",max_iter=1),
  warning=function(w) { warnings <<- c(warnings,conditionMessage(w)); invokeRestart("muffleWarning") })
stopifnot(is.na(result), any(grepl("converg",warnings)))
equal(yield.actual(transform(one,amount=100),100,"2025-01-01","annual"),0)
stopifnot(is.na(suppressWarnings(yield.actual(transform(one,amount=-100),100,
                                             "2025-01-01","annual"))))
stopifnot(is.na(suppressWarnings(yield.actual(cf[1,],100,"2025-01-01"))))
fails(yield.actual(cf,100,"2025-01-02"))
fails(yield.actual(cf,Inf,"2025-01-01"))
fails(yield.actual(cf,100,"2025-01-01",max_iter=0))

# F06: independent enumeration of instrument-class subsets, including cases
# where an individually dilutive class becomes antidilutive after another class.
for (income in c(-100,100,200)) {
  for (preferred in c(0,50,200)) {
    for (debt in c(0,20,200)) {
      additions <- c(0,preferred,debt)
      shares <- c(50,100,100)
      subsets <- as.matrix(expand.grid(0:1,0:1,0:1))
      alternatives <- as.numeric((income + subsets %*% additions) /
                                  (100 + subsets %*% shares))
      equal(diluted.EPS(ni=income+preferred,pd=preferred,cpd=preferred,cdi=debt,
                        w=100,cps=100,cds=100,iss=50), min(alternatives))
    }
  }
}
equal(diluted.EPS(200,100,cpd=100,w=100,cps=10),1)
equal(diluted.EPS(-100,0,w=100,iss=50),-1)

# F07-F10: preserve dates and warning settings, render data, use named fills,
# and apply inclusive filters independently. No network or image snapshots.
d <- data.frame(date=as.Date("2026-01-01")+0:2,open=c(1,3,2),high=c(3,4,4),
                low=c(0.5,1,1),close=c(2,2,3),volume=10:12,adjusted=c(2,2,3))
shifted <- transform(d,date=date+10)
for (other in list(shifted,shifted[1:2,],shifted[FALSE,])) {
  p <- suppressWarnings(lineChartMult(list(A=d,B=other)))
  equal(as.character(p$data$Date[p$data$variable=="B"]),as.character(other$date))
  equal(p$data$value[p$data$variable=="B"],other$close)
  suppressWarnings(ggplot2::ggplot_build(p))
}
for (setting in c(-1,0,2)) {
  previous <- options(warn=setting)
  for (f in list(lineChart,volumeChart,candlestickChart)) {
    suppressWarnings(f(d))
    equal(getOption("warn"),setting)
  }
  suppressWarnings(lineChartMult(list(A=d,B=d)))
  equal(getOption("warn"),setting)
  options(previous)
}
for (column in c("open","close","high","low","adjusted")) {
  p <- suppressWarnings(lineChart(d,y=column))
  equal(suppressWarnings(ggplot2::ggplot_build(p))$data[[1]]$y,d[[column]])
}
p <- suppressWarnings(candlestickChart(d))
equal(suppressWarnings(ggplot2::ggplot_build(p))$data[[1]]$fill,
      c("transparent","red","transparent"))
equal(as.character(suppressWarnings(candlestickChart(d,start="2026-01-02"))$data$date),
      as.character(d$date[2:3]))
equal(as.character(suppressWarnings(candlestickChart(d,end="2026-01-02"))$data$date),
      as.character(d$date[1:2]))
equal(as.character(suppressWarnings(candlestickChart(d,start="2026-01-01",
      end="2026-01-03"))$data$date),as.character(d$date))

# F11-F12: stable long products, small-rate cash-flow sums, and TVM inverses.
equal(geometric.mean(rep(0.1,10000)),0.1)
equal(geometric.mean(rep(-0.1,10000)),-0.1)
equal(geometric.mean(c(-1,0.1)),-1)
fails(geometric.mean(c(-1.1,0.1)))
for (rate in c(-1e-9,0,1e-9,0.1)) {
  for (n in c(1,5,20)) {
    for (type in 0:1) {
      times <- seq_len(n)-type
      equal(pv.annuity(rate,n,10,type),-sum(10/(1+rate)^times))
      equal(fv.annuity(rate,n,-10,type),sum(10*(1+rate)^(n-times)))
      present <- pv(rate,n,fv=50,pmt=10,type=type)
      equal(pmt(rate,n,present,50,type),10)
      equal(n.period(rate,present,50,10,type),n,tolerance=1e-7)
    }
  }
}
# For tiny rates over long horizons, reference with the exp(1) limit and a
# deliberately looser tolerance than the finite-rate approximation error.
equal(fv.annuity(1e-9,1e9,-1)/1e9,exp(1)-1,tolerance=1e-8)
equal(pv.annuity(1e-9,1e9,1)/1e9,exp(-1)-1,tolerance=1e-8)
equal(pmt(1e-9,1e9,-1,0)/1e-9,1/(1-exp(-1)),tolerance=1e-8)
equal(n.period(1e-9,-1,2,0)/1e9,log(2),tolerance=1e-8)
equal(n.period(-0.1,-100,100*0.9^500,0),500)
equal(pmt(-0.2,10000,-1,100),-20)

# F13: clone the transport environment so real Yahoo is never contacted.
transport <- new.env(parent=asNamespace("FinCal"))
transport$requests <- character()
transport$read.csv <- function(file,...) {
  transport$requests <- c(transport$requests,file)
  data.frame(Date=c("2025-01-02","2025-01-01"),Open=1,High=2,Low=0,
             Close=1,Volume=10,Adj.Close=1)
}
single <- get.ohlc.yahoo; environment(single) <- transport
batch <- get.ohlcs.yahoo; environment(batch) <- transport
for (start in c("firstDay","2024-02-03")) {
  for (frequency in c("d","w","m")) {
    result <- single("AAPL",start=start,end="2025-01-01",freq=frequency)
    equal(result$date,c("2025-01-01","2025-01-02"))
    url <- tail(transport$requests,1)
    stopifnot(grepl(paste0("&g=",frequency),url,fixed=TRUE),
              grepl("&d=0&e=01&f=2025",url,fixed=TRUE))
    if (start != "firstDay") stopifnot(grepl("&a=1&b=03&c=2024",url,fixed=TRUE))
  }
}
batch(c("AAPL","MSFT"),end="2025-01-01",freq="m")
stopifnot(all(grepl("&g=m",tail(transport$requests,2),fixed=TRUE)),
          all(grepl("&f=2025",tail(transport$requests,2),fixed=TRUE)))
equal(batch(character()),list())
fails(single("AAPL",start="2026-01-01",end="2025-01-01"))
