
<!-- README.md is generated from README.Rmd. Please edit that file -->

# govinfoR

<!-- badges: start -->
<!-- badges: end -->

The goal of govinfoR is to provide an easy way to interact with the
United States Government Publishing Office (GPO) GovInfo API in R. It’s
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
gpo_collections(collection = "BILLS", start_date = yesterday())
#> ⠙ Iterating 7 done (3.2/s) | 2.2s
#> ⠙ Iterating 8 done (2.9/s) | 2.7s
#> # A tibble: 87 × 7
#>    package_id          last_modified       package_link doc_class title congress
#>    <chr>               <dttm>              <chr>        <fct>     <chr>    <int>
#>  1 BILLS-118hr7278ih   2024-02-17 05:46:41 https://api… hr        Hous…      118
#>  2 BILLS-118hr7275ih   2024-02-17 05:46:41 https://api… hr        Comp…      118
#>  3 BILLS-118hr7288ih   2024-02-17 05:46:31 https://api… hr        Arme…      118
#>  4 BILLS-118hr7287ih   2024-02-17 05:46:31 https://api… hr        Coun…      118
#>  5 BILLS-118hr7286ih   2024-02-17 05:46:31 https://api… hr        Gene…      118
#>  6 BILLS-118hr7277ih   2024-02-17 05:46:26 https://api… hr        Halt…      118
#>  7 BILLS-118hr7276ih   2024-02-17 05:46:25 https://api… hr        Tele…      118
#>  8 BILLS-118hr7274ih   2024-02-17 05:46:25 https://api… hr        Conn…      118
#>  9 BILLS-118hr6544rh   2024-02-17 05:44:35 https://api… hr        Atom…      118
#> 10 BILLS-118hres1021ih 2024-02-17 05:44:30 https://api… hres      Prov…      118
#> # ℹ 77 more rows
#> # ℹ 1 more variable: date_issued <date>
```
