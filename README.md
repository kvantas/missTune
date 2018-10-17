
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Travis build
status](https://travis-ci.org/kvantas/missTune.svg?branch=master)](https://travis-ci.org/kvantas/missTune)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/kvantas/missTune?branch=master&svg=true)](https://ci.appveyor.com/project/kvantas/missTune)
[![Coverage
status](https://codecov.io/gh/kvantas/missTune/branch/master/graph/badge.svg)](https://codecov.io/github/kvantas/missTune?branch=master)
[![CRAN
status](https://www.r-pkg.org/badges/version/missTune)](https://cran.r-project.org/package=missTune)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

# missTune

This package is an alternative implementation of the `missForest` and
`missRanger` packages using tuned Random Forests. The `tuneRF` function
from the `randomForest` is used internally to find the optimal `mtry`
parameter.

## Installation

You can install the development version from Github with:

``` r
# install.packages("devtools")
devtools::install_github("kvantas/missTune")
```

## Example

This is a basic example about infilling a dataset.

``` r
library(missTune)
# create random na values
iris_na <- generate_na(iris, p = 0.1, seed = 123)

# infill values
res_imp <- miss_tune(x_miss = iris_na, num_trees = 100, verbose = TRUE)
#> iteration 1 in progress...
#> Sepal.Length  Sepal.Width Petal.Length  Petal.Width      Species 
#>    0.3460387    0.5778749    0.1487706    0.1839707    0.1333333
#> iteration 2 in progress...
#> Sepal.Length  Sepal.Width Petal.Length  Petal.Width      Species 
#>   0.25616110   0.44955516   0.05855077   0.09440227   0.11333333
#> iteration 3 in progress...
#> Sepal.Length  Sepal.Width Petal.Length  Petal.Width      Species 
#>   0.23369627   0.46068315   0.04231241   0.07152515   0.12666667
#> iteration 4 in progress...
#> Sepal.Length  Sepal.Width Petal.Length  Petal.Width      Species 
#>   0.21898068   0.45219127   0.04015487   0.07033734   0.14000000
#> iteration 5 in progress...
#> Sepal.Length  Sepal.Width Petal.Length  Petal.Width      Species 
#>   0.21780414   0.43343415   0.03696376   0.06442391   0.13333333
#> iteration 6 in progress...
#> Sepal.Length  Sepal.Width Petal.Length  Petal.Width      Species 
#>   0.20834627   0.43931631   0.03779168   0.06757198   0.14666667
```

Let’s view the original data-set with the missing values and the
infilled one.

``` r
head(iris_na)
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1          5.1         3.5          1.4         0.2  setosa
#> 2          4.9         3.0           NA         0.2  setosa
#> 3          4.7         3.2          1.3          NA    <NA>
#> 4          4.6          NA          1.5         0.2  setosa
#> 5           NA         3.6          1.4         0.2  setosa
#> 6          5.4         3.9          1.7         0.4  setosa
head(res_imp$x_imp)
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
#> 1     5.100000    3.500000     1.400000   0.2000000     setosa
#> 2     4.900000    3.000000     1.469838   0.2000000     setosa
#> 3     4.700000    3.200000     1.300000   0.5044111 versicolor
#> 4     4.600000    3.305738     1.500000   0.2000000     setosa
#> 5     5.115963    3.600000     1.400000   0.2000000     setosa
#> 6     5.400000    3.900000     1.700000   0.4000000     setosa
```

And finally let’s create a plot with the mean out of bag error during
the iterations of the algorithm.

``` r
library(ggplot2)
mean_errors <- unlist(lapply(res_imp$oob_list, mean))
ggplot()+
  geom_line(aes(x = 1: length(mean_errors), mean_errors)) +
  scale_x_continuous(breaks = 1: length(mean_errors)) + 
  xlab("Iteration") + ylab("Error")+
  theme_bw()
```

<img src="man/figures/README-plot_oob_error-1.png" width="100%" />

## Meta

Please note that the `missTune` project is released with a [Contributor
Code of Conduct](CODE_OF_CONDUCT.md). By contributing to this project,
you agree to abide by its terms.
