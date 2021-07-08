# load libraries
pths <- list.files("C:\\Users\\hejtm\\Downloads\\RAW_DATA_final\\GoNogoPEBL",
                   full.names = TRUE)
df_out <- data.frame()
for(filepath in pths){
  cat(filepath, " ----- ")
  df_experiment <- load_experiment(filepath, skip_first_section = TRUE)
  cat(nrow(df_experiment), " rows\n")
  if(nrow(df_experiment) != 340) next
  df_experiment <- preprocess_experiment(df_experiment)
  temp_out <- prepare_export(df_experiment)
  df_out <- rbind(df_out, temp_out)
}

write.csv(df_out, "gonogo-preprocessed.csv")
