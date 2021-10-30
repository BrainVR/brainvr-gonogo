#' Prepares experimental data to cleaner stats
#' 
#' @description Renames columns, recodes some values, adds new deduced values
#'
#' @param df_experiment 
#'
#' @return
#' @export
#'
#' @examples
preprocess_experiment <- function(df_experiment){
  oldnames <- c("subnum","block","type","correctresponse",
                "trial","choice","x","y","stim","present",
                "response","responded", "starttime",
                "corr", "rt")
  newnames <- c("subject", "block", "trial_type", "go_response",
                "trial", "choice", "x", "y", "stimulus_shown",
                "should_go", "key_response", "response_correct",
                "start_time", "corr", "reaction_time")
  df_experiment <- col_rename(df_experiment, oldnames, newnames)
  df_experiment$responded <- df_experiment$key_response != "NONE"
  df_experiment$should_go <- df_experiment$should_go == 1
  df_experiment$response_correct <- df_experiment$responded == df_experiment$should_go
  return(df_experiment)   
}

col_rename <- function(df, oldnames, newnames){
  if(length(oldnames) != length(newnames)){
    warning("Column lenghts do not correspond")
    return(df)
  }
  for(i in seq_len(length(oldnames))){
    i_col <- which(colnames(df) == oldnames[i])
    if(length(i_col) < 1) next 
    colnames(df)[i_col] <- newnames[i]
  }
  return(df)
}


