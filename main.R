library(tidyverse)
df_experiment <- read.table("data/pebl/gonogo-ZK210612KT.csv", header = TRUE, sep = ",")

df_experiment <- preprocess_experiment(df_experiment)
head(df_experiment)

df_experiment %>%
  group_by(x, y) %>%
  summarise(mean(reaction_time))

table(df_experiment$block, df_experiment$go_response)

df_all <- df_experiment %>%
  filter(trial_type == "test") %>%
  group_by(go_response, block) %>%
  summarise(mean_rt = mean(reaction_time),
            median_rt = median(reaction_time),
            sd_rt = sd(reaction_time),
            n_correct = sum(response_correct)/n())

df_separate <- df_experiment %>%
  filter(trial_type == "test") %>%
  group_by(go_response, block, response_correct, should_go) %>%
  summarise(mean_rt = mean(reaction_time),
            median_rt = median(reaction_time),
            sd_rt = sd(reaction_time),
            .groups="drop") %>%
  filter(should_go | !(should_go | response_correct)) %>%
  mutate(response_correct = ifelse(response_correct, "correct", "error"))
  

df_separate <- df_experiment %>%
  filter(trial_type == "test") %>%
  group_by(go_response, block, should_go) %>%
  summarise(accuracy = sum(response_correct)/n(),.groups="drop") %>%
  right_join(df_separate, by=c("go_response", "block", "should_go"))

df_separate %>%
  mutate(should_go = ifelse(should_go, "go", "nogo"),
         varname = paste(should_go, response_correct, go_response, sep="_")) %>%
  select(-c(block, go_response, should_go, response_correct)) %>%
  pivot_wider(names_from = varname, values_from = c(accuracy, mean_rt, median_rt, sd_rt))


