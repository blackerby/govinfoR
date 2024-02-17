
<!-- README.md is generated from README.Rmd. Please edit that file -->

# govinfoR

<!-- badges: start -->
<!-- badges: end -->

The goal of govinfoR is to provide an easy way to interact with the
United States Government Publishing Office GovInfo API in R. It’s
currently a work in progress and not ready for serious use.

## Installation

You can install the development version of govinfoR from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("blackerby/govinfoR")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(govinfoR)

set_govinfo_key("DEMO_KEY")
govinfo_collections(collection = "BILLS", start_date = yesterday())
#> Iterating ■■■■■■■■■                         25% | ETA:  4s
#> Iterating ■■■■■■■■■■■                       35% | ETA:  4s
#> Iterating ■■■■■■■■■■■■■■■■■■■■■■            70% | ETA:  2s
#> # A tibble: 147 × 7
#>    packageId         lastModified packageLink docClass title congress dateIssued
#>    <chr>             <chr>        <chr>       <chr>    <chr> <chr>    <chr>     
#>  1 BILLS-118s3777is  2024-02-17T… https://ap… s        Budg… 118      2024-02-08
#>  2 BILLS-118sres562… 2024-02-17T… https://ap… sres     Hono… 118      2024-02-13
#>  3 BILLS-118s3775is  2024-02-17T… https://ap… s        Buil… 118      2024-02-08
#>  4 BILLS-118hr7145ih 2024-02-17T… https://ap… hr       Stre… 118      2024-01-30
#>  5 BILLS-118hr7267ih 2024-02-17T… https://ap… hr       Disa… 118      2024-02-07
#>  6 BILLS-118s3716is  2024-02-17T… https://ap… s        401K… 118      2024-01-31
#>  7 BILLS-118s3774is  2024-02-17T… https://ap… s        Fami… 118      2024-02-08
#>  8 BILLS-118hr7273ih 2024-02-17T… https://ap… hr       Undo… 118      2024-02-07
#>  9 BILLS-118hr7269ih 2024-02-17T… https://ap… hr       Fair… 118      2024-02-07
#> 10 BILLS-118s3776is  2024-02-17T… https://ap… s        Coas… 118      2024-02-08
#> # ℹ 137 more rows
```
