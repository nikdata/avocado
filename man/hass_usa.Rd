% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{hass_usa}
\alias{hass_usa}
\title{Hass Avocado Weekly US Sales}
\format{
a dataframe with 11 variables.
\describe{
\item{week_ending}{The date of the last day of the week in YYYY-MM-DD format.}
\item{type}{Whether the avocado type is conventional (meaning non-organic) or organic.}
\item{avg_selling_price}{The average selling price (which is NOT the advertised selling price) in US$ for Hass avocados. Not adjusted for inflation.}
\item{total_bulk_and_bags_units}{The number of avocados sold in bulk (i.e., individually) or in bags. A unit is 1 avocado - not 1 bag.}
\item{plu4046_units}{The amount or number of PLU4046 (non-organic) or PLU94046 (organic) Hass avocados sold. Use the type column to determine if the units is for non-organic or organic avocados.}
\item{plu4225_units}{The amount or number of PLU4225 (non-organic) or PLU94225 (organic) Hass avocados sold. Use the type column to determine if the units is for non-organic or organic avocados.}
\item{plu4770_units}{The amount or number of PLU4770 (non-organic) or PLU94770 (organic) Hass avocados sold. Use the type column to determine if the units is for non-organic or organic avocados.}
\item{total_bagged_units}{The amount of avocados sold in bags. One unit refers to one avocado, not 1 bag. From 2021 onwards, this value is not broken down by size of bag.}
\item{sml_bagged_units}{The amount of avocados sold in small bags. One unit refers to one avocado. This bag typically consists of Hass #60 sizes & smaller.}
\item{lrg_bagged_units}{The amount of avocados sold in large bags. One unit refers to one avocado. This bag typically consists of Hass #40 & Hass #48 sizes.}
\item{xlrg_bagged_units}{TThe amount of avocados sold in extra large bags. One unit refers to one avocado. This bag typically consists of Hass #36 sizes or larger.}
}
}
\source{
Hass Avocado Board \href{https://hassavocadoboard.com}{Category Data}
}
\usage{
hass_usa
}
\description{
Weekly summary of Hass avocado sales for the United States
}
\details{
This dataset contains a weekly sales summary for Hass avocados for the US.
}
\keyword{avocados}
\keyword{datasets}
\keyword{revenue}
\keyword{timeseries}
