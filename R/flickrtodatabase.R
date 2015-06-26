#' flickrtodatabase - Get Flickr data for a list of items and store into a database
#' @import sqldf
#' @param apikey - API key provided by Flickr.com website. (Refer http://www.flickr.com/services/api/misc.api_keys.html for more details.)
#' @param inputfile - Input csv file containing the list of species to search for.
#' @param inputfield - Fieldname containing the names to search.
#' @param outdbname - Name of the database
#' @param dbfolder - Folder in which the database should be stored.
#' @param StIndex - Starting Index. If is 1, then creates the databse file, otherwise appends the data in the database.
#' @examples \dontrun{
#'  getflickrdata(myapikey,"test.txt","scname","testdb")
#' }
#' @export
flickrtodatabase <- function(apikey,inputfile,inputfield,outdbname,dbfolder=".",StIndex=1){
  list <- read.csv(inputfile)
  if(is.element(inputfield,names(list))){
  lp=as.character(list[,which(names(list)==inputfield)])
  } else {
    print("The inputfield not found in the data file...")
    return(NULL)
  }
  origloc=getwd()
  setwd(dbfolder)
  rsql=paste("attach '",outdbname,"' as new",sep="")
  sqldf(rsql)
  if (StIndex==1){
    First=TRUE
  } else{First=FALSE}
  #StIndex = 1
  
  Filesize = 100 
  fdata=NULL
  for (i in StIndex:length(lp)){
    st = as.character(lp[i])
    print(paste(i,st,Sys.time()))
    a <- getflickrdata(apikey,st,inputfield)
    if(is.na(a[1])){} else{fdata=rbind(fdata,a)}
    if(!(is.null(fdata))){
      if (dim(fdata)[1]>Filesize){
        StIndex=i
        print(paste("Writing to database ... till species",i))
        if (First){
          sqldf("create table Flickrrec as select * from fdata", dbname = outdbname)
          First = FALSE
        } else {
          sqldf("insert into Flickrrec select * from fdata",dbname=outdbname)
        }
        fdata=NULL
      }
     }
  }
  if(!is.null(fdata)){
    print(paste("Writing to database ... till species",i))
    sqldf("insert into Flickrrec select * from fdata",dbname=outdbname)
  }
  setwd(origloc)
}
