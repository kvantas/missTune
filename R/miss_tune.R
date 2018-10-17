#' Imputation of Missing Values by Automatic Tuned Chained Tree Ensembles
#'
#' @description Uses the \code{caret} and the \code{randomForest} packages to do
#' missing value imputation by automatic tuned chained tree ensembles, see
#' [1, 2]. The resampling method used for the selection of the hyper-parameters
#' of the automatic tuning is five folds cross validation.
#' The iterative chaining stops as soon as \code{max_iter} is reached or if the
#' average out-of-bag estimate of performance stops improving.
#' In the latter case, the best imputed data is returned.
#'
#' @param x_miss A \code{data.frame} or \code{tibble} with missing values to
#'   impute.
#' @param max_iter Maximum number of chaining iterations.
#' @param seed Integer seed to initialize the random generator.
#' @param verbose Boolean. FALSE (default) to print nothing, TRUE to print
#'   the OOB prediction error per iteration and variable (1 minus R-squared for
#'   regression).
#' @param num_trees Number of trees passed to \code{train} function of the
#' \code{caret} package.
#' @param tune_length the number of random sets of hyper-parameters passed to
#' the \code{trainControl} function of the \code{caret} package.
#'
#' @return A class with the imputed data having the smaller OOB error, and all
#' the OOB errors from the iterations of the algorithm.
#'
#' @references
#' [1] Liaw, Andy, and Matthew Wiener. "Classification and regression by
#' randomForest." R news 2.3 (2002): 18-22.

#'
#' [2] Stekhoven, D.J. and Buehlmann, P. (2012). 'MissForest - nonparametric
#' missing value imputation for mixed-type data', Bioinformatics, 28(1) 2012,
#' 112-118, doi: 10.1093/bioinformatics/btr597
#'
#'
#' @export miss_tune
#'
#' @examples
#'
#' \dontrun{
#' iris_na <- generate_na(iris)
#' iris_imp <- miss_tune(iris_na)
#' head(iris_imp)
#' head(iris_na)
#' }

miss_tune <- function(x_miss, max_iter = 10L, seed = NULL, num_trees = 200,
                      tune_length = 12, verbose = TRUE) {


  # check parameters ###########################################################
  assertthat::assert_that(is.data.frame(x_miss))
  assertthat::assert_that(assertthat::is.count(max_iter))
  assertthat::assert_that(assertthat::is.count(num_trees))
  assertthat::assert_that(assertthat::is.count(tune_length))
  assertthat::assert_that(assertthat::is.flag(verbose),
                          msg = "verbose is not a boolean (TRUE/FALSE)")

  # create data to impute  #####################################################

  # make names for data.frame variables

  # get variables that are factors or numeric and dont have all NAs
  all_vars <- imputable_variables(x_miss)

  # stop if no variable is appropriate
  assertthat::assert_that(
    length(all_vars) >= 2,
    msg ="At least two factor and or numeric variables are needed to run the algorithm")


  # report about ignored variables
  if (verbose && length(all_vars) < ncol(x_miss)) {
    message(
      paste("Variables ignored in algorithm:",
            setdiff(names(x_miss), all_vars))
    )
  }

  # fing na proportion per variable and sort them increasing
  x_na <- as.data.frame(is.na(x_miss[, all_vars, drop = FALSE]))
  impute_vars <- sort(colMeans(x_na))
  impute_vars <- names(which(impute_vars > 0))

  assertthat::assert_that(
    length(impute_vars) > 0,
    msg = "No appropriate variable found for infilling")

  # perform initial S.W.A.G. on x_miss  ########################################

  # set seed
  if (!is.null(seed)) {
    set.seed(seed)
  }

  # perform initial S.W.A.G.
  x_imp <- x_miss

  x_imp[impute_vars] <- lapply(impute_vars, function(j) {
    if(is.numeric(x_imp[[j]])) {
      imp_median(x_imp[[j]])
    } else if(is.factor(x_imp[[j]])){
      imp_factor(x_imp[[j]])
    }
  })

  # Iterate Algorithm  #########################################################

  # init variables
  i <- 0
  oob <- vector("list", max_iter)
  oob_error <- rep(Inf, length(impute_vars))
  names(oob_error) <- impute_vars
  criterion <- FALSE

  while (TRUE) {

    if (verbose) {
      message(paste("iteration", i+1, "in progress..."))
    }

    # keep last step's results
    oob_last <- oob_error
    x_old <- x_imp

    # tune for every variable
    for(variable in impute_vars) {

      na_index <- x_na[[variable]]

      # create formula for tuneRanger
      frm <- reformulate(all_vars, response = variable)

      # tune using caret
      fit_control <- caret::trainControl(
        method = "cv", number = 5, search = "random"
      )
      suppressMessages(
        suppressWarnings(
          rf_tune <- caret::train(
            frm, data = x_imp[!na_index, all_vars], method = "rf",
            num.trees = num_trees, tuneLength = tune_length,
            trControl = fit_control
          )
        ))
      # use tuned model to predict NA values
      pred <- caret::predict.train(rf_tune, x_imp[na_index, all_vars])
      x_imp[na_index, variable] <- pred

      # OOB error
      if (rf_tune$finalModel$type == "regression") {
        # rf's OOB prediction error is 1 - R2
        oob_error[[variable]] <- 1 - rf_tune$finalModel$rsq[num_trees]
      } else {
        # rf's OOB prediction error is the ratio of missclassified samples
        oob_error[[variable]] <- rf_tune$finalModel$err.rate[num_trees]
      }

      # if error metric is NAN change it to zero
      if (is.nan(oob_error[[variable]])) {
        oob_error[[variable]] <- 0
      }
    }
    if (verbose) {
      print(oob_error)
    }

    # check conditions to break algorithm iterations
    i <- i + 1L
    oob[[i]] <- oob_error
    criterion <- mean(oob_error) > mean(oob_last)
    if (i == max_iter || criterion){
      break()
    }
  }

  # if the algorithm stopped of the criterion keep the previous iteration
  if (criterion) {
    x_imp <- x_old
    oob_error <- oob_last
  }


  res <- list(x_imp = x_imp,
              oob_list = oob[1:i])

  class(res) <- "missTune"
  res

}
