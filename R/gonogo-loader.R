#' Title
#'
#' @param pth 
#' @param skip_first_section some files ahve multiple starting points. if true,
#' we simply skip to the last portion
#'
#' @return
#' @export
#'
#' @examples
load_experiment <- function(pth, skip_first_section = TRUE){
  if(skip_first_section){
    i_head <- grep("subnum,block,type,correctresponse,trial,choice,x,y,stim,present,response,responded,starttime,rt",
         readLines(pth), value = FALSE)
    i_head <- i_head[length(i_head)] - 1
  }
  df_data <- read.table(pth, header = TRUE, sep = ",", skip = i_head)
  return(df_data)
}