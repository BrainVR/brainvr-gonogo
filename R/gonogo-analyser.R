#' Calculates summative statistics for participant'S performance
#' 
#' @param df_experiment 
#'
#' @return
#' @export
#' @import dplyr tidyr
#'
#' @examples
participant_performance <- function(df_experiment, omit.na = TRUE){
  df_all_combinations <- data.frame(go_response = c("P", "P", "R", "R"),
                                    block = c(1,1,3,3),
                                    response_correct = c("error", "correct", "error", "correct"),
                                    should_go = c(FALSE, TRUE, FALSE, TRUE))
  
  df_separate <- df_experiment %>%
    filter(trial_type == "test") %>%
    group_by(go_response, block, response_correct, should_go) %>%
    summarise(mean_rt = mean(reaction_time, na.rm = omit.na),
              median_rt = median(reaction_time, na.rm = omit.na),
              sd_rt = sd(reaction_time, na.rm = omit.na),
              .groups="drop") %>%
    filter(should_go | !(should_go | response_correct)) %>%
    mutate(response_correct = ifelse(response_correct, "correct", "error")) %>%
    right_join(df_all_combinations)
  
  ## Accuracy calculation -----
  df_accuracy <- df_experiment %>%
    filter(trial_type == "test") %>%
    group_by(go_response, block, should_go) %>%
    summarise(accuracy = sum(response_correct)/n(),.groups="drop")%>%
    mutate(should_go = ifelse(should_go, "go", "nogo"),
           varname = paste("accuracy", should_go, "correct", go_response, sep = "_")) %>%
    select(varname, accuracy) %>%
    pivot_wider(names_from = varname, values_from = c(accuracy)) 
  
  # renames ----
  df_out <- df_separate %>%
    mutate(should_go = ifelse(should_go, "go", "nogo"),
           varname = paste(should_go, response_correct, go_response, sep = "_")) %>%
    select(-c(block, go_response, should_go, response_correct)) %>%
    pivot_wider(names_from = varname, values_from = c(mean_rt, median_rt, sd_rt))
  
  df_out <- cbind(df_out, df_accuracy)
  
  ls_sub <- extract_subject(df_experiment)
  
  df_out$participant <- ls_sub$subject
  df_out$n_test_trials <- sum(df_experiment$trial_type == "test")
  df_out$n_practice_trials <- sum(df_experiment$trial_type == "practice")
  return(df_out)
}

#' Extracts subject from preprocessed data and returns it
extract_subject <- function(df_experiment){
  subj <- df_experiment$subject[1]
  df_experiment$subject <- NULL
  return(list(subject = subj, data = df_experiment))
}