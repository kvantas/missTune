#' missTune: Fast Imputation of Missing Values by Automatic Tuned Chained Tree Ensembles.
#'
#' @description Alternative implementation of the 'missRanger' package using
#' tuned Random Forests. missRanger is also an alternative implementation of the
#' 'MissForest' algorithm used to impute mixed-type data sets by chaining tree
#' ensembles, introduced by Stekhoven, D.J. and Buehlmann, P. (2012)
#' <doi:10.1093/bioinformatics/btr597>.
#'
#' @name missTune
#' @aliases missTune-package
#' @docType package
#'
#' @importFrom stats var reformulate median na.omit runif
#'
#' @keywords internal
"_PACKAGE"
