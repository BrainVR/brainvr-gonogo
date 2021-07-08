library(tidyverse)

#' Prepares single participant line
#'
#' @param df_experiment 
#'
#' @return
#' @export
#'
#' @examples
prepare_export <- function(df_experiment){
  
  df_all_combinations <- data.frame(go_response = c("P", "P", "R", "R"),
                                    block = c(1,1,3,3),
                                    response_correct = c("error", "correct", "error", "correct"),
                                    should_go = c(FALSE, TRUE, FALSE, TRUE))
  df_separate <- df_experiment %>%
    filter(trial_type == "test") %>%
    group_by(go_response, block, response_correct, should_go) %>%
    summarise(mean_rt = mean(reaction_time),
              median_rt = median(reaction_time),
              sd_rt = sd(reaction_time),
              .groups="drop") %>%
    filter(should_go | !(should_go | response_correct)) %>%
    mutate(response_correct = ifelse(response_correct, "correct", "error")) %>%
    right_join(df_all_combinations)
    
  df_separate <- df_experiment %>%
    filter(trial_type == "test") %>%
    group_by(go_response, block, should_go) %>%
    summarise(accuracy = sum(response_correct)/n(),.groups="drop") %>%
    right_join(df_separate, by=c("go_response", "block", "should_go"))
  
  df_out <- df_separate %>%
    mutate(should_go = ifelse(should_go, "go", "nogo"),
           varname = paste(should_go, response_correct, go_response, sep="_")) %>%
    select(-c(block, go_response, should_go, response_correct)) %>%
    pivot_wider(names_from = varname, values_from = c(accuracy, mean_rt, median_rt, sd_rt)) 
  
  ls_sub <- extract_subject(df_experiment)
  
  df_out$participant <- ls_sub$subject
  return(df_out)
}