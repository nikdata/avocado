# process raw data

directory_path <- 'data-raw'

all_files <- list.files(path = directory_path, pattern = '.csv', full.names = TRUE) |>
  purrr::map(readr::read_csv)

df_combined <- all_files |>
  dplyr::bind_rows() |>
  janitor::clean_names() |>
  # change to date only
  dplyr::mutate(
    current_year_week_ending = as.Date(current_year_week_ending)
  ) |>
  dplyr::rename(
    avg_selling_price = asp_current_year,
    week_ending = current_year_week_ending,
    plu4046_units = x4046_units,
    plu4225_units = x4225_units,
    plu4770_units = x4770_units,
    xlrg_bagged_units = x_lrg_bagged_units
  ) |>
  # round up units to whole numbers
  dplyr::mutate(
    dplyr::across(
      .cols = tidyr::ends_with('units'),
      .fns = ceiling
    )
  )

# let's add some geographical data
df_geo <- df_combined |>
  dplyr::mutate(
    geo_type = dplyr::case_when(
      geography == 'Total U.S.' ~ 'country',
      geography %in% c('California','West','Plains','South Central','Great Lakes','Midsouth','Southeast','Northeast') ~ 'region',
      TRUE ~ 'market'
    ),
    region = dplyr::case_when(
      geography %in% c('San Diego','Sacramento','Los Angeles','San Francisco') ~ 'California',
      geography %in% c('Portland','Boise','Spokane','West Tex/New Mexico','Seattle','Denver','Las Vegas','Phoenix/Tucson') ~ 'West',
      geography %in% c('St. Louis','Wichita') ~ 'Plains',
      geography %in% c('New Orleans/Mobile', 'Dallas/Ft. Worth','Houston') ~ 'South Central',
      geography %in% c('Chicago','Indianapolis','Columbus','Cincinnati/Dayton','Grand Rapids','Detroit') ~ 'Great Lakes',
      geography %in% c('South Carolina', 'Charlotte','Richmond/Norfolk','Raleigh/Greensboro','Baltimore/Washington','Louisville','Roanoke','Nashville') ~ 'Midsouth',
      geography %in% c('Atlanta','Orlando','Tampa','Jacksonville','Miami/Ft. Lauderdale') ~ 'Southeast',
      geography %in% c('Philadelphia','New York','Buffalo/Rochester','Harrisburg/Scranton','Albany','Northern New England','Boston','Syracuse','Hartford/Springfield','Pittsburgh') ~ 'Northeast'
    )
  )

# create 3 main data sets
hass_usa <- df_geo |>
  dplyr::filter(geo_type == 'country') |>
  dplyr::arrange(type, week_ending) |>
  dplyr::select(-geo_type, -region, -geography, -timeframe)

hass_region <- df_geo |>
  dplyr::filter(geo_type == 'region') |>
  dplyr::arrange(type, week_ending) |>
  dplyr::select(-geo_type, -timeframe, -region) |>
  dplyr::rename(region = geography)

hass_market <- df_geo |>
  dplyr::filter(geo_type == 'market') |>
  dplyr::arrange(type, week_ending) |>
  dplyr::select(-geo_type, -timeframe) |>
  dplyr::rename(market = geography) |>
  dplyr::select(region, market, week_ending, type, avg_selling_price, tidyr::ends_with('units'))

hass_usa |> dplyr::glimpse()
hass_region |> dplyr::glimpse()
hass_market |> dplyr::glimpse()

# write out files
usethis::use_data(hass_usa, overwrite=TRUE, compress = 'xz')
usethis::use_data(hass_region, overwrite=TRUE, compress = 'xz')
usethis::use_data(hass_market, overwrite=TRUE, compress = 'xz')
