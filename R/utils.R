#' Check if a variable is a vector with at least one non-NA value
#' @noRd
test_vector <- function(x) {
  # check input
  assertthat::assert_that(
    is.atomic(x),
    msg = "x must be a vector possibly containing missing values."
  )
  assertthat::assert_that(
    !all(is.na(x)),
    msg = "x must have at least one non-missing value to run."
  )
}

#' Find applicable variables for imputation
#' @noRd
imputable_variables <- function(data) {

  # fin which vars are numeric or factor and dont have all vulues NA
  tmp <- lapply(data, function(x) {
    (is.numeric(x) | is.factor(x)) & !all(is.na(x))
  })

  # return results as a vector of characters
  tmp <- unlist(tmp)
  names(tmp)[tmp]
}


#' Distance calculation: Haversine formula
#' Presuming a spherical Earth with radius R  and that the locations of the two
#' points in spherical coordinates (longitude and latitude) are lon1, lat1 and
#' lon2,lat2, then the Haversine Formula is:
#' @noRd
haversine <- function(lat1, lon1, lat2, lon2) {

  lat1 <- deg_to_rads(lat1)
  lat2 <- deg_to_rads(lat2)
  lon1 <- deg_to_rads(lon1)
  lon2 <- deg_to_rads(lon2)

  # Differences in latitude and longitude
  dlat <- lat2 - lat1
  dlon <- lon2 - lon1

  # radius of earth in km
  r_earh <- 6373

  # compute distance
  a <- (sin(dlat/2))^2 + cos(lat1) * cos(lat2) * (sin(dlon/2))^2
  r_earh * 2 * atan2( sqrt(a), sqrt(1-a) )

}

#' Euclidean distance calculation
#' @noRd
euclidean <- function(x1, y1, x2, y2) {
  sqrt((x1 - x2)^2 + (y1 - y2)^2)
}
