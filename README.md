
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Travis build
status](https://travis-ci.org/kvantas/missTune.svg?branch=master)](https://travis-ci.org/kvantas/missTune)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/kvantas/missTune?branch=master&svg=true)](https://ci.appveyor.com/project/kvantas/missTune)
[![Coverage
status](https://codecov.io/gh/kvantas/missTune/branch/master/graph/badge.svg)](https://codecov.io/github/kvantas/missTune?branch=master)

# missTune

This package is an alternative implementation of the `missForest` and
`missRanger` packages using tuned Random Forests.

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
res_imp <- miss_tune(x_miss = iris_na, num_trees = 100, tune_length = 5, verbose = TRUE)
#> iteration 1 in progress...
#>      Species  Sepal.Width Sepal.Length  Petal.Width Petal.Length 
#>   0.04444444   0.45413112   0.18733999   0.06621034   0.03844020
#> iteration 2 in progress...
#>      Species  Sepal.Width Sepal.Length  Petal.Width Petal.Length 
#>   0.05925926   0.46587393   0.19530027   0.05514636   0.03217743
```

Let’s view the original data-set with the missing values and the
infilled one.

``` r
head(iris_na)
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1          5.1         3.5           NA         0.2  setosa
#> 2          4.9         3.0          1.4         0.2  setosa
#> 3           NA         3.2          1.3         0.2  setosa
#> 4          4.6         3.1          1.5         0.2  setosa
#> 5          5.0         3.6           NA         0.2  setosa
#> 6          5.4         3.9          1.7         0.4  setosa
head(res_imp$x_imp)
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1     5.100000         3.5     1.439798         0.2  setosa
#> 2     4.900000         3.0     1.400000         0.2  setosa
#> 3     4.511461         3.2     1.300000         0.2  setosa
#> 4     4.600000         3.1     1.500000         0.2  setosa
#> 5     5.000000         3.6     1.406139         0.2  setosa
#> 6     5.400000         3.9     1.700000         0.4  setosa
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
