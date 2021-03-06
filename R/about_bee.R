#'About the Berkeley Ecoinformatics Engine
#'
#' Function returns the current status of fast-evolving API. Returns endpoints and category. Default return is a \code{list} but one can also request a nicely formatted \code{data.frame} by setting the \code{as.df} argument to \code{TRUE}.
#' @param as.df = FALSE Returns a list unless this set to \code{TRUE}
#' @return \code{list}
#' @export
#' @importFrom RCurl getURL 
#' @importFrom plyr ldply
#' @importFrom RJSONIO fromJSON
#' @examples \dontrun{
#' about_bee()
#' # set \code{as.df = FALSE} to return a \code{list} rather than a \code{data.frame}
#' about_bee(as.df = FALSE)
#' # You can also filter by methods by data, meta-data, and actions.
#' about_bee(type = "data")
#' about_bee(type = "meta-data")
#' about_bee(type = "actions")
#'}
about_bee <- function(as.df = TRUE, type = NA) {
about_url <- "http://ecoengine.berkeley.edu/api/?format=json"
about <- getURL(about_url)
about <- as.list(fromJSON(I(about)))
if(!as.df) {
    return(about)
    } else {
        about_df <- ldply(about, function(f) {
             res <- as.data.frame(f)
            } )
        names(about_df) <- c("type", "endpoint")
        if(!is.na(type)) {
                about_df <- switch(type, 
                        data = subset(about_df, type == "data"),
                        actions = subset(about_df, type == "actions"),
                        "meta-data" = subset(about_df, type == "meta-data"),
                        )
        }
        return(about_df)

    }
}

# Expected output

#  about_bee(type = "data")
#   type                                        endpoint
# 3 data   http://ecoengine.berkeley.edu/api/checklists/
# 4 data      http://ecoengine.berkeley.edu/api/sensors/
# 5 data       http://ecoengine.berkeley.edu/api/vtmveg/
# 6 data http://ecoengine.berkeley.edu/api/observations/
# 7 data       http://ecoengine.berkeley.edu/api/photos/


#  about_bee(type = "meta-data")
#        type                                      endpoint
# 1 meta-data    http://ecoengine.berkeley.edu/api/sources/
# 2 meta-data http://ecoengine.berkeley.edu/api/footprints/


#  about_bee(type = "actions")
#      type                                  endpoint
# 8 actions http://ecoengine.berkeley.edu/api/search/
# > 