% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/functions-binning.R
\name{breaks_on_nBins}
\alias{breaks_on_nBins}
\title{Generate breaks for binning}
\usage{
breaks_on_nBins(fromX, toX, nBins, shiftByHalfBinSize = FALSE)
}
\arguments{
\item{fromX}{numeric(1) specifying the lowest value for the bins.}

\item{toX}{numeric(1) specifying the largest value for the bins.}

\item{nBins}{numeric(1) defining the number of bins.}

\item{shiftByHalfBinSize}{Logical indicating whether the bins should be shifted
left by half bin size. This results centered bins, i.e. the first bin being
centered at \code{fromX} and the last around \code{toX}.}
}
\value{
A numeric vector of length \code{nBins + 1} defining the lower and
upper bounds of the bins.
}
\description{
Calculate breaks for same-sized bins for data values
from \code{fromX} to \code{toX}.
}
\details{
This generates bins such as a call to
\code{seq(fromX, toX, length.out = nBins)} would. The first and second element
in the result vector thus defines the lower and upper boundary for the first
bin, the second and third value for the second bin and so on.
}
\examples{
## Create breaks to bin values from 3 to 20 into 20 bins
breaks_on_nBins(3, 20, nBins = 20)
## The same call but using shiftByHalfBinSize
breaks_on_nBins(3, 20, nBins = 20, shiftByHalfBinSize = TRUE)
}
\author{
Johannes Rainer
}
\seealso{
\code{\link{binYonX}} for a binning function.

Other functions to define bins: \code{\link{breaks_on_binSize}}
}

