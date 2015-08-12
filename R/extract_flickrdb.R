#' extract_flickrdb - Extract Flickr data from sqlite database
#' @import sqldf
#' @param dbname name of the database (Generated using function flickrtodatabase)
#' @param outputfile output csv file
#' @return dataframe containing the Flickr data from database
#' @examples \dontrun{
#' mydat=extract_flickrdb("testdb","text.csv")
#' }
#' @export
extract_flickrdb <- function(dbname=NA,outputfile=NA){
  dat <- sqldf("select * from Flickrrec", dbname = dbname)
  write.csv(dat,outputfile)
  return(dat)
}