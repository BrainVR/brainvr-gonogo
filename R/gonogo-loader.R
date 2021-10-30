#' Title
#'
#' @param pth 
#' @param skip_first_section some files ahve multiple starting points. if true,
#' we simply skip to the last portion
#' @param preprocess shoul dthe data be automatically processed. Calls `preprocess_experiment` function
#'
#' @return data.frame
#' @export
#'
#' @examples
load_experiment <- function(pth, skip_first_section = TRUE, preprocess = TRUE){
  if(skip_first_section){
    #ptr <- "subnum,block,type,correctresponse,trial,choice,x,y,stim,present,response,responded,starttime,rt"
    ptr <- "subnum,block,type,correctresponse.*"
    i_head <- grep(ptr, readLines(pth,100), value = FALSE)
    i_head <- i_head[length(i_head)] - 1
  } else {
    i_head <- 0
  }
  df_data <- read.table(pth, header = TRUE, sep = ",", skip = i_head)
  if(preprocess){
    df_data <- preprocess_experiment(df_data)
  }
  return(df_data)
}