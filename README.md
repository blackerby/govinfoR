
<!-- README.md is generated from README.Rmd. Please edit that file -->

# govinfoR

<!-- badges: start -->
<!-- badges: end -->

`govinfoR` offers an easy way to access data provided by the [United
States Government Publishing Office (GPO)
GovInfo](https://www.govinfo.gov/) API in R. It’s currently in early
development, but functions for all GET endpoints are available. The
API’s `search` endpoint, which as of this writing is in Public Preview,
is outside the scope of this package at present.

## Installation

You can install the stable version of `govinfoR` from
[CRAN](https://cran.r-project.org/package=govinfoR) with:

``` r
install.packages("govinfoR")
```

You can install the development version of `govinfoR` from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("blackerby/govinfoR")
```

## Examples

This first example loads the package, sets the API key (gotten from the
environment), and gets metadata about all 39 GovInfo collections.

``` r
library(govinfoR)

gpo_collections()
#> # A tibble: 39 × 4
#>    collection_code collection_name                  package_count granule_count
#>    <chr>           <chr>                                    <int>         <int>
#>  1 BILLS           Congressional Bills                     260096            NA
#>  2 BILLSTATUS      Congressional Bill Status               147507            NA
#>  3 BUDGET          United States Budget                       338          6759
#>  4 CCAL            Congressional Calendars                   5516         88218
#>  5 CDIR            Congressional Directory                    237         15024
#>  6 CDOC            Congressional Documents                  24174          9580
#>  7 CFR             Code of Federal Regulations               6090       7155023
#>  8 CHRG            Congressional Hearings                   38974           285
#>  9 CMR             Congressionally Mandated Reports           244            NA
#> 10 COMPS           Statutes Compilations                     2449            NA
#> # ℹ 29 more rows
```

The following example demonstrates getting all records in the `BILLS`
collection since midnight yesterday.

> The package provides three simple helpers to make it easier to specify
> dates as arguments to functions (`yesterday()`, `today()`, and
> `tomorrow()`)

``` r
gpo_collections(collection = "BILLS", start_date = "2024-02-17T00:00:00Z")
#> # A tibble: 29 × 7
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
#> # ℹ 19 more rows
#> # ℹ 1 more variable: date_issued <date>
```

Examples of the use of other package functions are in the documentation.
