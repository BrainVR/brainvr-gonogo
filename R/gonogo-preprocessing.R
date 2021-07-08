preprocess_experiment <- function(df_experiment){
  colnames(df_experiment) <- c("subject", "block", "trial_type", "go_response",
                               "trial", "choice", "x", "y", "stimulus_shown",
                               "should_go", "key_response", "response_correct",
                               "start_time", "reaction_time")
  df_experiment$responded <- df_experiment$key_response != "NONE"
  df_experiment$should_go <- df_experiment$should_go == 1
  df_experiment$response_correct <- df_experiment$responded == df_experiment$should_go
  return(df_experiment)   
}

#' Extracts subject from preprocessed data and returns it
#'
#' @param df_experiemnt 
#'
#' @return
#' @export
#'
#' @examples
extract_subject <- function(df_experiemnt){
  subj <- df_experiemnt$subject[1]
  df_experiemnt$subject <- NULL
  return(list(subject = subj, data = df_experiemnt))
}