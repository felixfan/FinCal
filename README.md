Examples of using FinCal
========================================================
Created on Fri Jul 19 2013   
Updated on Mon May 12 15:57:11 2014   


FinCal -- Time Value of Money, time series analysis and Computational Finance
--------------------------------------------------------------------------------    
FinCal is available on [CRAN] (http://cran.r-project.org/web/packages/FinCal/) and [GitHub](http://felixfan.github.io/FinCal/)

```
install.packages("FinCal",dependencies=TRUE) # from CRAN
```
or   

```
library("devtools")
install_github("felixfan/FinCal") # from GitHub
```


```r
library(FinCal)
```


Functions available:    

```r
ls("package:FinCal")
```

```
 [1] "bdy"                   "bdy2mmy"              
 [3] "candlestickChart"      "cash.ratio"           
 [5] "coefficient.variation" "cogs"                 
 [7] "current.ratio"         "ddb"                  
 [9] "debt.ratio"            "diluted.EPS"          
[11] "discount.rate"         "ear"                  
[13] "ear.continuous"        "ear2bey"              
[15] "ear2hpr"               "EIR"                  
[17] "EPS"                   "financial.leverage"   
[19] "fv"                    "fv.annuity"           
[21] "fv.simple"             "fv.uneven"            
[23] "geometric.mean"        "get.ohlc.google"      
[25] "get.ohlc.yahoo"        "get.ohlcs.google"     
[27] "get.ohlcs.yahoo"       "gpm"                  
[29] "harmonic.mean"         "hpr"                  
[31] "hpr2bey"               "hpr2ear"              
[33] "hpr2mmy"               "irr"                  
[35] "iss"                   "lineChart"            
[37] "lineChartMult"         "lt.d2e"               
[39] "mmy2hpr"               "n.period"             
[41] "npm"                   "npv"                  
[43] "pmt"                   "pv"                   
[45] "pv.annuity"            "pv.perpetuity"        
[47] "pv.simple"             "pv.uneven"            
[49] "quick.ratio"           "r.continuous"         
[51] "r.norminal"            "r.perpetuity"         
[53] "sampling.error"        "SFRatio"              
[55] "Sharpe.ratio"          "slde"                 
[57] "total.d2e"             "twrr"                 
[59] "volumeChart"           "was"                  
[61] "wpr"                  
```


Getting help on a function (e.g., pv)    
```
help{pv}    # display the documentation for the function
args{pv}    # see arguments of the function
example{pv} # see example of using the function
```

* [Examples for version 0.1 -0.6](http://felixfan.github.io/finance/2014/05/12/FinCal-example-0.6/)




