% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utilMWRfre.R
\name{utilMWRfre}
\alias{utilMWRfre}
\title{Prep results data for frequency checks}
\usage{
utilMWRfre(resdat, param, accdat, warn = TRUE)
}
\arguments{
\item{resdat}{results data as returned by \code{\link{readMWRresults}}}

\item{param}{character string to filter results and check if a parameter in the \code{"Characteristic Name"} column in the results file is also found in the data quality objectives file for accuracy, see details}

\item{accdat}{\code{data.frame} for data quality objectives file for accuracy as returned by \code{\link{readMWRacc}}}

\item{warn}{logical to return warnings to the console (default)}
}
\value{
\code{resdat} filtered by \code{param} with any entries in \code{"Result Value"} as \code{"BDL"} or \code{"AQL"} replaced with appropriate values in the \code{"Quantitation Limit"} column, if present, otherwise the \code{"MDL"} or \code{"UQL"} columns from the data quality objectives file for accuracy are used.  Values as \code{"BDL"} use one half of the appropriate limit. Values not in the \code{"Value Range"} column of the accuracy file are removed from the output.
}
\description{
Prep results data for frequency checks
}
\details{
This function is similar to \code{utilMWRlimits} with some additional processing appropriate for creating the frequency table in \code{tabMWRfree}.  The \code{param} argument is used to identify the appropriate \code{"MDL"} or \code{"UQL"} values in the data quality objectives file for accuracy.  A warning is returned to the console if the accuracy file does not contain the appropriate information for the parameter.  Results will be filtered by \code{param} regardless of any warning.
}
\examples{
# results file path
respth <- system.file('extdata/ExampleResults.xlsx', package = 'MassWateR')

# results data
resdat <- readMWRresults(respth)

# accuracy path
accpth <- system.file('extdata/ExampleDQOAccuracy.xlsx', 
     package = 'MassWateR')

# accuracy data
accdat <- readMWRacc(accpth)

# apply to total phosphorus
utilMWRfre(resdat, accdat, param = 'TP')

# apply to E.coli
utilMWRfre(resdat, accdat, param = 'E.coli')
}
