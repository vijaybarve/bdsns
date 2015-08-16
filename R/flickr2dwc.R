#' flickr2dwc - Convert Flicker data frame to Darwin Core format
#' @param flickrdat - Flickr Data frame to convert to Darwin Core
#' @return data frame in Darwin Core format
#' @examples \dontrun{
#'  flickr2dwc(flickrdat)
#' } 
#' @export
flickr2dwc <- function(flickrdat=NA){
  dat<-flickrdat[,c(1,6,12,14,15,16,19,27,29)]
  names(dat)=c("catalogNumber","occurrenceRemarks","eventDate","recordedBy"
               ,"decimalLatitude","decimalLongitude","locationID"
               ,"fieldNotes","scientificName")
  return(dat)
}