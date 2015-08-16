#' dcw2XML - Convert Darwin Core format data frame to XML
#' @import XML
#' @param dat - Darwin Core Data frame to convert to XML
#' @return Simple Darwin Core format XML
#' @examples \dontrun{
#'  dcw2XML(dat)
#' } 
#' @export
dcw2XML <- function(dat=NA){
  root <- newXMLNode("SimpleDarwinRecordSet")
  for(i in 1:dim(dat[1])){
    rec <- newXMLNode("SimpleDarwinRecord", parent=root);
    for(j in 1:dim(dat)[2]){
      child <- newXMLNode(names(dat)[j], parent=rec)
      xmlValue(child) <- dat[i,j]
    }
  } 
  return(root)
}
