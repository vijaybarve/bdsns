#' flickrlist - Get list of media items on Flickr for the search string.
#' @import XML
#' @importFrom RCurl getURL
#' @param apikey - API key provided by Flickr.com website. (Refer http://www.flickr.com/services/api/misc.api_keys.html for more details.)
#' @param stext - Test to search, a species name of common name.
#' @param bbox - Bounding box. Geographical coordinates of Left top and right bottom corners separate by comma in string format i.e. "-180,-90,180,90" for whole world.
#' 
#' Using bbox parameter would not return photo without geocoding. If photos returned are more than 4000 the function automatically defaults to geocoded photos.
#' @examples \dontrun{
#'  flickrlist(myapikey,"Danaus chrysippus")
#' }
#' @export
flickrlist <- function (apikey=NA,stext=NA,bbox=NA){
  if(is.na(apikey)){
    print("Need to supply API key for Flicker.com website. \n Get yours at http://www.flickr.com/services/api/misc.api_keys.html")
    return(NULL)
  }
  if(is.na(stext)){
    print("Need to supply search string.")
    return(NULL)
  }
  cds <- "&extras=description%2C+license%2C+date_upload%2C+date_taken%2C+owner_name%2C+geo%2C+tags%2C+machine_tag%2C+url_c"
  if (! is.na(bbox)){
    cds <- paste(cds,"&bbox=",bbox,sep="")
  } else {
    bbox <- "-180,-90,180,90"
  }
  stext <- paste("%22",gsub(" ","+",stext),"%22",sep="")
  pgno <- 1
  url<-paste("https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=",apikey,"&text=",stext,cds,"&per_page=100&page=",pgno,"&format=rest",sep="")
  ret <- url
  x <- getURL(url, ssl.verifypeer = FALSE)
  x <- unlist(strsplit(x,"\n"))
  x <- x[substr(x, 1, 13) == "<photos page="]
  n <- as.integer(unlist(strsplit(x, "\""))[8])
  if (length(n) == 0L){
    n <- 0
  }
  if (n > 4000){
    #cat("\n Too many records fetching a smaller sets")
    bbox <- checkbbox(bbox)
    bbe <- as.numeric(unlist(strsplit(bbox,",")))
    xm <- (bbe[3] + bbe[1]) / 2
    ym <- (bbe[4] + bbe[2]) / 2
    q1<- checkbbox(paste(bbe[1],",",bbe[2],",",xm,",",ym,sep=""))
    q2 <- checkbbox(paste(bbe[3],",",bbe[2],",",xm,",",ym,sep=""))
    q3 <- checkbbox(paste(bbe[1],",",bbe[4],",",xm,",",ym,sep=""))
    q4 <- checkbbox(paste(bbe[3],",",bbe[4],",",xm,",",ym,sep=""))
    res <- flickrlist(apikey,stext,bbox=q1)
    resret <- res 
    res <- flickrlist(apikey,stext,bbox=q2)
    resret <- rbind(resret,res)
    res <- flickrlist(apikey,stext,bbox=q3)
    resret <- rbind(resret,res)
    res <- flickrlist(apikey,stext,bbox=q4)
    resret <- rbind(resret,res)
    return(resret)
  } else {
    pages <- as.integer(unlist(strsplit(x, "\""))[4])
    cat(paste("\n",pages))
    if (pages == 0){
      cat("\n No records found... ")
      return(NULL)
    }
    cat("  0")
    for (k in 1:pages){
      url<-paste("https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=",apikey,"&text=",stext,cds,"&per_page=100&page=",k,"&format=rest",sep="")
      ret <- url
      xData <- getURL(url, ssl.verifypeer = FALSE)
      doc <- xmlInternalTreeParse(xData)
      nodes <- getNodeSet(doc, "//photo ")
      if (length(nodes) == 0){
        #print("Returning...")
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
      if (k==1){ansfin <- ans}
      else{
        ansfin <- rbind(ansfin,ans)
        ans <- NULL
      }        
    }
    return(ansfin)
  }
}

checkbbox <- function(bbox="-180,-90,180,90"){
  bbe <- as.numeric(unlist(strsplit(bbox,",")))
  if(length(bbe)!=4){
    print("Bounding bix needs four values")
    return(NULL)
  }
  if(bbe[1]>bbe[3]){
    temp <- bbe[1]
    bbe[1] <- bbe[3]
    bbe[3] <- temp
  }
  if(bbe[2]>bbe[4]){
    temp <- bbe[2]
    bbe[2] <- bbe[4]
    bbe[4] <- temp
  }
  return(paste(bbe[1],",",bbe[2],",",bbe[3],",",bbe[4],sep=""))
}
