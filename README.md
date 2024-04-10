
<!-- README.md is generated from README.Rmd. Please edit that file -->

# zendown

<!-- badges: start -->

[![R-CMD-check](https://github.com/rfsaldanha/zendown/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/rfsaldanha/zendown/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

A simple R package to download files from Zenodo.

## Installation

You can install the development version of zendown from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("rfsaldanha/zendown")
```

## Example

First, you need to find the Zenodo deposition code. It is the number
that appears on the end of a Zenodo deposition link. The code number
also appears on the Zenodo DOI of the version.

    https://zenodo.org/records/10950327

Deposition code: 10950327

With the deposition code, get a list of files available at the
deposition

``` r
library(zendown)

res <- file_list(deposit_id = 10950327)
res
#> # A tibble: 9 × 5
#>   id                                   filename   filesize checksum links       
#>   <chr>                                <chr>         <dbl> <chr>    <list>      
#> 1 354f3f9c-68c1-4371-bd85-54a619e0bf37 indi_0002…     4312 ae0e78c… <named list>
#> 2 2009399c-e516-41dc-a93e-95221e4c5a87 indi_0002…    10125 7d102ad… <named list>
#> 3 43250883-cce6-45d0-995e-89b9f5095dca indi_0002…    25198 fc84fef… <named list>
#> 4 1b5b9285-d320-481c-963e-497ae92fcd07 indi_0002…  1041878 cfbe847… <named list>
#> 5 86670252-1b0e-42ef-b490-622040b2f95f indi_0002…  2229008 7fb9d70… <named list>
#> 6 8703e1fb-58fb-4cd6-aa31-7080177f1e0e indi_0002…    79814 1c960f8… <named list>
#> 7 2509c72c-5a0c-4dc8-862d-a759e7d5729f indi_0002…    23929 8752b55… <named list>
#> 8 ed4bdcaa-7cb0-444f-a44f-1e6caf86f53f indi_0002…   292771 a388cb0… <named list>
#> 9 baecc25f-d7c0-42c1-b3d0-397f2ec1eb6d indi_0002…   218872 fe15a4f… <named list>
```

You can download all files.

``` r
zendown(file_list = res, dest = tempdir())
```

Or a single file by specifying its name.

``` r
zendown(file_list = res, file_name = "indi_0002_regsaude_res_year.parquet", dest = tempdir())
```

## zen4R

To fully explore the Zenodo API possibilities, check the
[zen4R](https://github.com/eblondel/zen4R) package.
