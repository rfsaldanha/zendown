
<!-- README.md is generated from README.Rmd. Please edit that file -->

# zendown

<!-- badges: start -->

[![R-CMD-check](https://github.com/rfsaldanha/zendown/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/rfsaldanha/zendown/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

Access, download and locally cache files deposited on Zenodo easily.

## Installation

You can install the development version of zendown from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("rfsaldanha/zendown")
```

## Example

``` r
library(zendown)
```

This [Zenodo deposit](https://zenodo.org/records/10959197) contains RDS
files from examples datasets.

First, you need to find the Zenodo deposit code. It is the number that
appears on the end of a Zenodo deposit link. The code number also
appears on the Zenodo DOI.

    https://zenodo.org/records/10959197

Deposition code: 10959197

With the deposit code and the desired file name, you can just access the
file with the `zen_file` function.

``` r
readRDS(file = zen_file(deposit_id = 10959197, file_name = "iris.rds")) |>
  head()
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1          5.1         3.5          1.4         0.2  setosa
#> 2          4.9         3.0          1.4         0.2  setosa
#> 3          4.7         3.2          1.3         0.2  setosa
#> 4          4.6         3.1          1.5         0.2  setosa
#> 5          5.0         3.6          1.4         0.2  setosa
#> 6          5.4         3.9          1.7         0.4  setosa
```

The function will create a local cache, avoiding re-downloading the file
when you access the file again.

## zen4R

To explore the Zenodo API possibilities to problematically store files
and other procedures, check the
[zen4R](https://github.com/eblondel/zen4R) package.
