#' flickrlist - Get metadata  mediofa items available on Flickr for the search string.
#' @import XML
#' @import RCurl
#' @param apikey - API key provided by Flickr.com website. (Refer http://www.flickr.com/services/api/misc.api_keys.html for more details.)
#' @param stext - Test to search, a speice nems of common name.
#' @examples \dontrun{
#'  flickrlist(myapikey,"Danaus chrysippus")
#' }
#' @export
flickrlist <- function (apikey=NA,stext=NA){
  if(is.na(apikey)){
    print("Need to supply API key for Flicker.com website. \n Get yours at http://www.flickr.com/services/api/misc.api_keys.html")
    return(NULL)
  }
  if(is.na(stext)){
    print("Need to supply search string.")
    return(NULL)
  }
  cds="&extras=description%2C+license%2C+date_upload%2C+date_taken%2C+owner_name%2C+geo%2C+tags%2C+machine_tag%2C+url_c"
  stext=paste("%22",gsub(" ","+",stext),"%22",sep="")
  pgno=1
  url<-paste("https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=",apikey,"&text=",stext,cds,"&per_page=100&page=",pgno,"&format=rest",sep="")
  x <- getURL(url, ssl.verifypeer = FALSE)
  x <- unlist(strsplit(x,"\n"))
  x <- x[substr(x, 1, 13) == "<photos page="]
  pages <- as.integer(unlist(strsplit(x, "\""))[4])
  cat(pages)
  if (pages == 0){
    print("No records found... ")
    return(NULL)
  }
  cat("  0")
  for (k in 1:pages){
    url<-paste("https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=",apikey,"&text=",stext,cds,"&per_page=100&page=",k,"&format=rest",sep="")
    ret=url
    xData <- getURL(url, ssl.verifypeer = FALSE)
    doc <- xmlInternalTreeParse(xData)
    nodes <- getNodeSet(doc, "//photo ")
    if (length(nodes) == 0){
      print("Returning...")
      return(ansfin)
    }
    dscr <- xmlToDataFrame(doc)
    
    varNames <- c("id", "owner", "secret", "server", "farm", "title", "ispublic",
                  "isfriend", "isfamily", "license", "dateupload", "datetaken",
                  "datetakengranularity", "ownername", "latitude","longitude",
                  "accuracy", "context", "place_id", "woeid", "geo_is_family",
                  "geo_is_friend", "geo_is_contact", "geo_is_public", "tags", 
                  "machine_tags", "description", "url_c")
    dims <- c(length(nodes), length(varNames))
    ans <- as.data.frame(replicate(dims[2], rep(as.character(NA),dims[1]), 
                                    simplify = FALSE), stringsAsFactors = FALSE)
    names(ans) <- varNames
    for (j in 1:dims[1]){
      for (i in 1:dims[2]) {
        if(!is.null(xmlGetAttr(nodes[[j]],varNames[i]))) {ans[j,i] <- xmlGetAttr(nodes[[j]],varNames[i])}
      }
      ans[j,]$description <- as.character((dscr[1,j]))
    }
    cat(paste("-",k*100,sep=""))
    if (k==1){ansfin=ans}
    else{
      ansfin=rbind(ansfin,ans)
      ans=NULL
    }        
  }
  return(ansfin)
}
