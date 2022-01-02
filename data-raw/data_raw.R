# This file is used to ingest and tidy the raw data -------------

## import the pipe ----
`%>%` <- magrittr:::`%>%`

## loop through and load all CSV files in folder

df_raw <- list.files(path = 'data-raw', pattern = '*.csv', full.names = T) %>%
  purrr::map(readr::read_csv)

## extract into separate dataframes & clean up names
dfr_2017 <- df_raw[[1]] %>% janitor::clean_names(.)
dfr_2018 <- df_raw[[2]] %>% janitor::clean_names(.)
dfr_2019 <- df_raw[[3]] %>% janitor::clean_names(.)
dfr_2020 <- df_raw[[4]] %>% janitor::clean_names(.)
dfr_2021 <- df_raw[[5]] %>% janitor::clean_names(.)

# clean

cleaner <- function(df) {

  # remove the total columns (redundant)
  df <- df %>%
    dplyr::select(-total_bulk_and_bags_units, -total_bagged_units)

  # get the meta data columns & create a region type
  meta <- df %>%
    dplyr::select(geography, current_year_week_ending) %>%
    dplyr::rename(week_ending = current_year_week_ending) %>%
    dplyr::distinct() %>%
    dplyr::mutate(
      geo_type = dplyr::case_when(
        geography == 'Total U.S.' ~ 'country',
        geography %in% c('California','West','Plains','South Central','Great Lakes','Midsouth','Southeast','Northeast') ~ 'region',
        TRUE ~ 'city/subregion'
      ),
      region = dplyr::case_when(
        geography %in% c('San Diego','Sacramento','Los Angeles','San Francisco') ~ 'California',
        geography %in% c('Portland','Boise','Spokane','West Tex/New Mexico','Seattle','Denver','Las Vegas','Phoenix/Tucson') ~ 'West',
        geography %in% c('St. Louis') ~ 'Plains',
        geography %in% c('New Orleans/Mobile', 'Dallas/Ft. Worth','Houston') ~ 'South Central',
        geography %in% c('Chicago','Indianapolis','Columbus','Cincinnati/Dayton','Grand Rapids','Detroit') ~ 'Great Lakes',
        geography %in% c('South Carolina', 'Charlotte','Richmond/Norfolk','Raleigh/Greensboro','Baltimore/Washington','Louisville','Roanoke','Nashville') ~ 'Midsouth',
        geography %in% c('Atlanta','Orlando','Tampa','Jacksonville') ~ 'Southeast',
        geography %in% c('Philadelphia','New York','Buffalo/Rochester','Harrisburg/Scranton','Albany','Northern New England','Boston','Syracuse','Hartford/Springfield','Pittsburgh') ~ 'Northeast'
      )
    )

  # get the non-organic data
  nonorg <- df %>%
    dplyr::filter(type == 'Conventional') %>%
    dplyr::rename(
      avg_price_nonorg = asp_current_year,
      plu4046 = x4046_units,
      plu4225 = x4225_units,
      plu4770 = x4770_units,
      small_nonorg_bag = sml_bagged_units,
      large_nonorg_bag = lrg_bagged_units,
      xlarge_nonorg_bag = x_lrg_bagged_units
    ) %>%
    {if('bulk_gtin' %in% names(.)) dplyr::rename(.,bulk_nonorg_gtin=bulk_gtin) else .} %>%
    dplyr::select(
      -geography,
      -timeframe,
      -current_year_week_ending,
      -type,
    )

  # get the organic data
  org <- df %>%
    dplyr::filter(type == 'Organic') %>%
    dplyr::rename(
      avg_price_org = asp_current_year,
      plu94046 = x4046_units,
      plu94225 = x4225_units,
      plu94770 = x4770_units,
      small_org_bag = sml_bagged_units,
      large_org_bag = lrg_bagged_units,
      xlarge_org_bag = x_lrg_bagged_units
    ) %>%
    {if('bulk_gtin' %in% names(.)) dplyr::rename(.,bulk_org_gtin=bulk_gtin) else .} %>%
    dplyr::select(
      -geography,
      -timeframe,
      -current_year_week_ending,
      -type,
    )

  # combine
  combo <- dplyr::bind_cols(meta, nonorg, org)

  return(combo)

}

# clean all the raw dataframes

dfc_2017 <- cleaner(dfr_2017)
dfc_2018 <- cleaner(dfr_2018)
dfc_2019 <- cleaner(dfr_2019)
dfc_2020 <- cleaner(dfr_2020)
dfc_2021 <- cleaner(dfr_2021)

# combine all of them into one
df_all = dplyr::bind_rows(dfc_2017, dfc_2018, dfc_2019, dfc_2020)

# create 3 datasets: country, region, city/subregion

hass_usa <- df_all %>%
  dplyr::filter(geo_type == 'country') %>%
  dplyr::select(-geo_type, -region, -geography)
hass_region <- df_all %>%
  dplyr::filter(geo_type == 'region') %>%
  dplyr::select(-geo_type, -region) %>%
  dplyr::rename(region = 'geography') %>%
  dplyr::select(week_ending, region, avg_price_nonorg, plu4046, plu4225, plu4770, small_nonorg_bag, large_nonorg_bag, xlarge_nonorg_bag, avg_price_org, plu94046, plu94225, plu94770, small_org_bag, large_org_bag, xlarge_org_bag)

hass <- df_all %>%
  dplyr::filter(!geo_type %in% c('country','region')) %>%
  dplyr::select(-geo_type) %>%
  dplyr::rename(location = 'geography') %>%
  dplyr::select(week_ending, location, region, avg_price_nonorg, plu4046, plu4225, plu4770, small_nonorg_bag, large_nonorg_bag, xlarge_nonorg_bag, avg_price_org, plu94046, plu94225, plu94770, small_org_bag, large_org_bag, xlarge_org_bag)

# write out
usethis::use_data(hass_usa, overwrite = TRUE, compress = 'xz')
usethis::use_data(hass_region, overwrite = TRUE, compress = 'xz')
usethis::use_data(hass, overwrite = TRUE, compress = 'xz')

# write out CSV
write.csv(hass_usa, 'csv/hass_usa.csv', row.names = FALSE)
write.csv(hass_region, 'csv/hass_region.csv', row.names = FALSE)
write.csv(hass, 'csv/hass.csv', row.names = FALSE)

#tools::checkRdaFiles(paths='data/')
#tools::resaveRdaFiles(paths = 'data/', compress = 'auto')
