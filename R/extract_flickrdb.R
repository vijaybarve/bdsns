#' extract_flickrdb - Extract Flickr data from sqlite database
#' @import sqldf
#' @param dbname name of the database (Generated using function flickrtodatabase)
#' @param outputfile output csv file
#' @return dataframe containing Flickr data from database
#' @examples \dontrun{
#' mydat=extract_flickrdb("testdb","text.csv")
#' }
#' @export
extract_flickrdb <- function(dbname=NA,outputfile=NA){
  if(is.na(dbname)){
    print("Please specify a database file name saved using bdsns")
    return(NULL)
  }
  if (!file.exists(dbname)){
    print(paste("Database file",dbname,"does not extst"))
    return(NULL)
  }
  dat <- sqldf("select * from Flickrrec", dbname = dbname)
  if(!is.na(outputfile)){
    write.csv(dat,outputfile)
  }
  return(dat)
}