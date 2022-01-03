
<!-- README.md is generated from README.Rmd. Please edit that file -->

# avocado <a href='https://nikdata.github.io/avocado/'><img src='man/figures/avocado.png' align="right" width="150" height="150" />

<!-- badges: start -->

[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/avocado)](https://cran.r-project.org/package=avocado)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![License:
MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![GitHub
commit](https://img.shields.io/github/last-commit/nikdata/avocado)](https://github.com/nikdata/avocado/commit/main)
[![R-CMD-check](https://github.com/nikdata/avocado/workflows/R-CMD-check/badge.svg)](https://github.com/nikdata/avocado/actions)
<!-- badges: end -->

The {avocado} package provides a summary of weekly Hass avocado sales
for the contiguous United States. The underlying data are from [The Hass
Avocado Board](https://hassavocadoboard.com) (free registration
required). Hass Avocados are the most popular variety of avocados sold
in the United States and the Haas Avocado Board (HAB) provides crucial
data on them to growers and marketers.

The HAB makes this information available to anyone who may be interested
(free registration required). An important note to remember is that when
they use the term ‘units’, it often means the weight in US pounds. The
HAB does not provide (at least publicly) actual piece-count sales to
retailers.

## About the PLUs

The {avocadoo} package consists of 6 different
[PLUs](https://en.wikipedia.org/wiki/Price_look-up_code):

-   4046: non-organic small/medium Hass Avocados (\~3-5 oz)
-   4225: non-organic large Hass Avocados (\~8-10 oz)
-   4770: non-organic extra large Hass Avocados (\~10-15 oz)
-   94046: organic small/medium Hass Avocados (\~3-5 oz)
-   94225: organic large Hass Avocados (\~8-10 oz)
-   94770: organic extra large Hass Avocados (\~10-15 oz)

Source: [Love One
Today](https://loveonetoday.com/how-to/identify-hass-avocados/)

## Bags vs PLU

Another distinction that the HAB makes is between bags versus bulk. Bulk
typically means avocados sold as individual pieces and are easily
distinguishable with their PLU codes. Hence, the PLU refers to a bulk
sale. On the other hand, the bags indicates a pre-packaged container
consisting of a variable number of avocados of mixed PLU type. For
instance, a package of six avocados may consist of 2 PLU 4046, 3 PLU
4770 and 1 PLU 4225. In other words, bagged sales are unable to account
for individual PLU sales.

See this
[vignette](https://nikdata.github.io/avocado/articles/a_intro.html) for
more information.

## Installation

Install the development version from [GitHub](https://github.com/):

``` r
# install.packages("devtools")
devtools::install_github("nikdata/avocado", ref = 'main')
```

## Datasets

The {avocado} package consists of three different datasets:

-   `hass_usa`: weekly contiguous US avocado sales at the country level
-   `hass_region`: weekly contiguous US avocado sales at the region
    level
-   `hass`: weekly contiguous US avocado sales at the city/sub-region
    level

### Example

The `hass` dataset provides a weekly sales summary of Hass Avocado sales
in the contiguous US (subdivided by region and select cites/sub-regions
within each ‘parent’ region):

``` r
library(avocado)
dplyr::glimpse(hass)
#> Rows: 11,685
#> Columns: 23
#> $ week_ending            <date> 2017-01-02, 2017-01-02, 2017-01-02, 2017-01-02…
#> $ location               <chr> "Albany", "Atlanta", "Baltimore/Washington", "B…
#> $ region                 <chr> "Northeast", "Southeast", "Midsouth", "West", "…
#> $ avg_price_nonorg       <dbl> 1.47, 0.93, 1.47, 0.92, 1.29, 1.43, 1.21, 1.15,…
#> $ total_nonorg_units     <dbl> 129948.2, 547565.9, 631760.8, 104510.1, 458830.…
#> $ total_nonorg_bag_units <dbl> 7874.69, 204228.49, 153891.12, 55914.28, 79553.…
#> $ total_org_units        <dbl> 1376.70, 5342.85, 13901.46, 2823.82, 13438.22, …
#> $ total_org_bag_units    <dbl> 1112.42, 1523.17, 5857.48, 2455.19, 11241.89, 3…
#> $ plu4046                <dbl> 4845.77, 224073.54, 54530.42, 27845.16, 4119.90…
#> $ plu4225                <dbl> 117027.41, 118926.37, 408952.26, 9408.92, 37122…
#> $ plu4770                <dbl> 200.36, 337.48, 14387.01, 11341.75, 3933.72, 10…
#> $ small_nonorg_bag       <dbl> 7866.86, 111599.58, 151345.59, 53093.47, 79339.…
#> $ large_nonorg_bag       <dbl> 7.83, 92628.91, 2542.41, 2793.61, 213.75, 255.6…
#> $ xlarge_nonorg_bag      <dbl> 0.00, 0.00, 3.12, 27.20, 0.00, 18.06, 46.67, 50…
#> $ avg_price_org          <dbl> 1.87, 1.81, 1.92, 1.05, 2.06, 1.64, 1.70, 1.34,…
#> $ plu94046               <dbl> 71.65, 956.73, 1420.47, 0.00, 14.80, 8.52, 120.…
#> $ plu94225               <dbl> 192.63, 2862.95, 6298.07, 368.63, 2181.53, 320.…
#> $ plu94770               <dbl> 0.00, 0.00, 325.44, 0.00, 0.00, 0.00, 489.12, 0…
#> $ small_org_bag          <dbl> 1112.42, 5.55, 5857.48, 577.91, 10636.25, 2585.…
#> $ large_org_bag          <dbl> 0.00, 1517.62, 0.00, 1877.28, 605.64, 511.31, 3…
#> $ xlarge_org_bag         <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
#> $ bulk_nonorg_gtin       <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ bulk_org_gtin          <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
```

## Use Cases

Some potential use cases include:

-   Determining peak sale periods for each region
-   Determining which PLU is most popular in some major cities (e.g.,
    Chicago, Los Angeles, etc.)
-   Differences between organic and non-organic Hass Avocados

## Limitations

The source of the data for this package is from the Hass Avocado Board.
However, the data are known to come from a 3rd party source and is the
best available information at the time it was provided to the Hass
Avocado Board. There are many instances where adding up individual
columns will not equal the total columns that are provided. No
explanation is provided by the Hass Avocado Board about this discrepancy
(or at least I couldn’t find any information).

For instance, the column `total_org_bag_units` may seem to be the total
of three columns: `small_org_bag`, `large_org_bag`, and
`xlarge_org_bag`. However, the sum of these 3 columns will often be
less. On their website, Hass Avocado seems to use the total columns as
often as possible without going into details of the totals.
