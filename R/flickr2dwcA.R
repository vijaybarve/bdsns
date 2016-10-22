#' flickr2dwcA - Convert Flicker data frame to Darwin Core Archiev file
#' @importFrom utils zip
#' @param flickrdat - Flickr Data frame to convert to Darwin Core Archiev file
#' @param outfile - Output file name without a .zip extension
#' @examples \dontrun{
#'  flickr2dwcA(flickrdat)
#' } 
#' @export
flickr2dwcA <- function(flickrdat=NA,outfile=NA){
  if(is.na(outfile)){
    outfile="Flickr_dcwA.zip"
  } else {
    outfile = paste(outfile,".zip",sep="")
  }
  write.csv(flickrdat,"Flickr.tab")
  packagePath <- find.package("bdsns", lib.loc=NULL, quiet = TRUE)
  metafile=paste(packagePath,"/extdata/meta.xml",sep="")
  zip(outfile,c("Flickr.tab",metafile))
}