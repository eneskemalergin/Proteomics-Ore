protViz Package for R
================
Enes Kemal Ergin
January 19, 2018

About the package
-----------------

protViz is an R package for visualizations, analysis of mass spectrometry data coming from proteomics experiments.

### Trellis Plots

Trellis graphs/plots (simply Trellis) are special plotting to graph multivariate data as an array of MxN panels.

When the data includes a column of categorical data, or multiple columns characterizing some sort of nested sub-grouping of data, you might gain from plotting the data asa Trellis. [1](https://www.originlab.com/doc/Origin-Help/Trellis-Plot)

In the following 3 examples, we will look at the data they provided from Grossman et al 2010, J Proteomics\[2\], called `fetuinLFQ`. Contains the subset of the data they used.

``` r
library(lattice)
library(protViz)
library(tidyr)
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(ggplot2)
```

``` r
data(fetuinLFQ)
class(fetuinLFQ)
```

    ## [1] "list"

``` r
str(fetuinLFQ)
```

    ## List of 3
    ##  $ t3pq :'data.frame':   235 obs. of  4 variables:
    ##   ..$ conc     : int [1:235] 100 300 160 80 40 60 300 120 300 120 ...
    ##   ..$ prot     : Factor w/ 8 levels "Fetuin","P15891",..: 2 2 2 2 2 2 2 2 2 2 ...
    ##   ..$ abundance: num [1:235] 111601 142743 174585 196602 199395 ...
    ##   ..$ method   : Factor w/ 1 level "T3PQ": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ apex :'data.frame':   228 obs. of  4 variables:
    ##   ..$ conc     : int [1:228] 20 20 20 20 40 40 40 40 60 60 ...
    ##   ..$ prot     : Factor w/ 6 levels "Fetuin","P15891",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##   ..$ abundance: num [1:228] 10.4 9.27 14.32 11.53 24.86 ...
    ##   ..$ method   : Factor w/ 1 level "APEX": 1 1 1 1 1 1 1 1 1 1 ...
    ##  $ empai:'data.frame':   179 obs. of  4 variables:
    ##   ..$ conc     : int [1:179] 40 40 40 60 60 80 80 80 100 100 ...
    ##   ..$ prot     : Factor w/ 6 levels "Fetuin","P15891",..: 1 1 1 1 1 1 1 1 1 1 ...
    ##   ..$ abundance: num [1:179] 1.65 1.87 2.11 2.66 2.97 2.97 3.3 2.66 3.3 2.97 ...
    ##   ..$ method   : Factor w/ 1 level "emPAI": 1 1 1 1 1 1 1 1 1 1 ...

It seems like the dataset has 3 dataframes stored in a list, and seperated by method used to calculate the abundance; `T3PQ, APEX, emPAI`. Each method-dataframe has 4 columns;

-   `conc`: concentration of the sample
-   `prot`: protein name or ID
-   `abundance`: Abundance value
-   `method`: Method used to calculate the abundance

``` r
cv<-1-1:7/10
t<-trellis.par.get("strip.background")
t$col<-(rgb(cv,cv,cv))
trellis.par.set("strip.background",t)

my.xlab="Fetuin concentration spiked into experiment [fmol]"
my.ylab<-"Abundance"

xyplot(abundance~conc|prot*method, 
    data=fetuinLFQ$apex, 
    groups=prot,
    aspect=1,
    panel = function(x, y, subscripts, groups) {
        if (groups[subscripts][1] == "Fetuin")  {
            panel.fill(col="#ffcccc")
        }
                panel.grid(h=-1,v=-1)
                panel.xyplot(x, y)
                panel.loess(x,y, span=1)
            },
    xlab=my.xlab,
    ylab=my.ylab
)
```

![](protViz_package_files/figure-markdown_github/example1:%20calls%20APEX%20dataframe-1.png)

**This plot could be used to show which proteins has more abundance in the dataset for Yeast, human, and both together.** But overall, this is not exactly what I am looking for.

Resources
---------

1.  <https://www.originlab.com/doc/Origin-Help/Trellis-Plot>
2.  Grossmann, J., Roschitzki, B., Panse, C., Fortes, C., Barkow-Oesterreicher, S., Rutishauser, D., & Schlapbach, R. (2010). Implementation and evaluation of relative and absolute quantification in shotgun proteomics with label-free methods. Journal of Proteomics, 73(9), 1740-1746. <doi:10.1016/j.jprot.2010.05.011>
3.
