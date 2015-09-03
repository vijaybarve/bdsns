#' getflickrdata - Get list of media items on Flickr for the search string in a data frame with searchType and downloadDate appende.
#' @param apikey - API key provided by Flickr.com website. (Refer http://www.flickr.com/services/api/misc.api_keys.html for more details.)
#' @param searchText - Text to search, a speice name or common name.
#' @param searchType - Type of the search like Scientific Name or Common name etc. added as an attribute in the return data frame.
#' @examples \dontrun{
#'  getflickrdata(myapikey,"Danaus chrysippus","Scname")
#' }
#' @export
getflickrdata <- function(apikey=NA,searchText=NA,searchType=NA){
  if(is.na(apikey)){
    print("Need to supply API key for Flicker.com website. \n Get yours at http://www.flickr.com/services/api/misc.api_keys.html")
    return(NULL)
  }
  if(is.na(searchText)){
    print("Need to supply search string.")
    return(NULL)
  }
  downloadDate <- date()
  flickrData = flickrlist(apikey,searchText)
  if(is.null(flickrData)){
    return(NULL)
  } else {
    url_site=paste("http://www.flickr.com/photos/",flickrData$owner,"/",flickrData$id,sep="")
    out <- cbind(flickrData,url_site,searchText,searchType,downloadDate)  
  }
  return(out)
}
