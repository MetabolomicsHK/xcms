## Functions related to the Param class and sub-classes.
#' @include DataClasses.R

##
##' @description Extract all slot values and put them into a list, names being
##' the slot names. If a slot \code{addParams} exist its content will be
##' appended to the returned list.
##'
##' @param x A Param class.
##' @author Johannes Rainer
##' @noRd
.param2list <- function(x) {
    ## Get all slot names, skip those matching the provided pattern.
    sNames <- slotNames(x)
    skipSome <- grep(sNames, pattern = "^\\.")
    if(length(skipSome) > 0)
        sNames <- sNames[-skipSome]
    ## handle a slot called "addParams" differently: this is thougth to contain
    ## ... arguments thus we have to skip this one too.
    if (any(sNames == "addParams")) {
        sNames <- sNames[sNames != "addParams"]
        addP <- x@addParams
    } else {
        addP <- list()
    }
    if(length(sNames) > 0){
        resL <- vector("list", length(sNames))
        for(i in 1:length(sNames))
            resL[[i]] <- slot(x, name = sNames[i])
        names(resL) <- sNames
        resL <- c(resL, addP)
        return(resL)
    }else{
          return(list())
    }
}

############################################################
## CentWaveParam

##' @return The \code{CentWaveParam} function returns a \code{CentWaveParam}
##' class instance with all of the settings specified for feature detection by
##' the centWave method.
##'
##' @rdname featureDetection-centWave
CentWaveParam <- function(ppm = 25, peakwidth = c(20, 50), snthresh = 10,
                          prefilter = c(3, 100), mzCenterFun = "wMean",
                          integrate = 1L, mzdiff = -0.001, fitgauss = FALSE,
                          noise = 0, verboseColumns = FALSE, roiList = list(),
                          firstBaselineCheck = TRUE, roiScales = numeric()) {
    return(new("CentWaveParam", ppm = ppm, peakwidth = peakwidth,
               snthresh = snthresh, prefilter = prefilter,
               mzCenterFun = mzCenterFun, integrate = as.integer(integrate),
               mzdiff = mzdiff, fitgauss = fitgauss, noise = noise,
               verboseColumns = verboseColumns, roiList = roiList,
               firstBaselineCheck = firstBaselineCheck, roiScales = roiScales))
}


############################################################
## MatchedFilterParam

##' @return The \code{MatchedFilterParam} function returns a
##' \code{MatchedFilterParam} class instance with all of the settings specified
##' for feature detection by the centWave method.
##'
##' @rdname featureDetection-matchedFilter
MatchedFilterParam <- function(binSize = 0.1, impute = "none",
                               baseValue = numeric(), distance = numeric(),
                               fwhm = 30, sigma = fwhm / 2.3548,
                               max = 5, snthresh = 10, steps = 2,
                               mzdiff = 0.8 - binSize * steps, index = FALSE) {
    return(new("MatchedFilterParam", binSize = binSize, impute = impute,
               baseValue = baseValue, distance = distance, fwhm = fwhm,
               sigma = sigma, max = max, snthresh = snthresh, steps = steps,
               mzdiff = mzdiff, index = index))
}

############################################################
## MassifquantParam

##' @return The \code{MassifquantParam} function returns a \code{MassifquantParam}
##' class instance with all of the settings specified for feature detection by
##' the centWave method.
##'
##' @rdname featureDetection-massifquant
MassifquantParam <- function(ppm = 25, peakwidth = c(20, 50), snthresh = 10,
                             prefilter = c(3, 100), mzCenterFun = "wMean",
                             integrate = 1L, mzdiff = -0.001, fitgauss = FALSE,
                             noise = 0, verboseColumns = FALSE,
                             criticalValue = 1.125, consecMissedLimit = 2,
                             unions = 1, checkBack = 0, withWave = FALSE) {
    return(new("MassifquantParam", ppm = ppm, peakwidth = peakwidth,
               snthresh = snthresh, prefilter = prefilter,
               mzCenterFun = mzCenterFun, integrate = as.integer(integrate),
               mzdiff = mzdiff, fitgauss = fitgauss, noise = noise,
               verboseColumns = verboseColumns, criticalValue = criticalValue,
               consecMissedLimit = as.integer(consecMissedLimit),
               unions = as.integer(unions), checkBack = as.integer(checkBack),
               withWave = withWave))
}

############################################################
## MSWParam
##' @inheritParams featureDetection-centWave
##'
##' @param scales Numeric defining the scales of the continuous wavelet
##' transform (CWT).
##'
##' @param nearbyPeak logical(1) whether to include nearby peaks of
##' major peaks.
##'
##' @param peakScaleRange numeric(1) defining the scale range of the
##' peak (larger than 5 by default).
##'
##' @param ampTh numeric(1) defining the minimum required relative
##' amplitude of the peak (ratio of the maximum of CWT coefficients).
##'
##' @param minNoiseLevel numeric(1) defining the minimum noise level
##' used in computing the SNR.
##'
##' @param ridgeLength numeric(1) defining the minimum highest scale
##' of the peak in 2-D CWT coefficient matrix.
##'
##' @param peakThr numeric(1) with the minimum absolute intensity
##' (above baseline) of peaks to be picked. If provided, the smoothing function
##' \code{\link[MassSpecWavelet]{sav.gol}} function is called to estimate the
##' local intensity.
##'
##' @param tuneIn logical(1) whther to tune in the parameter
##' estimation of the detected peaks.
##'
##' @param ... Additional parameters to be passed to the
##' \code{\link[MassSpecWavelet]{identifyMajorPeaks}} and
##' \code{\link[MassSpecWavelet]{sav.gol}} functions from the
##' \code{MassSpecWavelet} package.
##'
##' @return The \code{MSWParam} function returns a \code{MSWParam}
##' class instance with all of the settings specified for feature detection by
##' the centWave method.
##'
##' @rdname featureDetection-MSW
MSWParam <- function(snthresh = 3, verboseColumns = FALSE,
                     scales = c(1, seq(2, 30, 2), seq(32, 64, 4)),
                     nearbyPeak = TRUE, peakScaleRange = 5,
                     ampTh = 0.01, minNoiseLevel = ampTh / snthresh,
                     ridgeLength = 24, peakThr = NULL, tuneIn = FALSE,
                     ... ) {
    addParams <- list(...)
    if (is.null(peakThr))
        peakThr <- numeric()
    return(new("MSWParam", snthresh = snthresh, verboseColumns = verboseColumns,
               scales = scales, nearbyPeak = nearbyPeak,
               peakScaleRange = peakScaleRange, ampTh = ampTh,
               minNoiseLevel = minNoiseLevel, ridgeLength = ridgeLength,
               peakThr = peakThr, tuneIn = tuneIn, addParams = addParams))
}

############################################################
## CentWavePredIsoParam

##' @return The \code{CentWavePredIsoParam} function returns a
##' \code{CentWavePredIsoParam} class instance with all of the settings
##' specified for the two-step centWave-based feature detection considering also
##' feature isotopes.
##'
##' @rdname featureDetection-centWaveWithPredIsoROIs
CentWavePredIsoParam <- function(ppm = 25, peakwidth = c(20, 50), snthresh = 10,
                          prefilter = c(3, 100), mzCenterFun = "wMean",
                          integrate = 1L, mzdiff = -0.001, fitgauss = FALSE,
                          noise = 0, verboseColumns = FALSE, roiList = list(),
                          firstBaselineCheck = TRUE, roiScales = numeric(),
                          snthreshIsoROIs = 6.25, maxCharge = 3, maxIso = 5,
                          mzIntervalExtension = TRUE, polarity = "unknown") {
    return(new("CentWavePredIsoParam", ppm = ppm, peakwidth = peakwidth,
               snthresh = snthresh, prefilter = prefilter,
               mzCenterFun = mzCenterFun, integrate = as.integer(integrate),
               mzdiff = mzdiff, fitgauss = fitgauss, noise = noise,
               verboseColumns = verboseColumns, roiList = roiList,
               firstBaselineCheck = firstBaselineCheck, roiScales = roiScales,
               snthreshIsoROIs = snthreshIsoROIs, maxIso = as.integer(maxIso),
               maxCharge = as.integer(maxCharge),
               mzIntervalExtension = mzIntervalExtension, polarity = polarity))
}
