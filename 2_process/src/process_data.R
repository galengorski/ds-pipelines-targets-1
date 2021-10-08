
library(dplyr)
library(tidyr)
library(readr)
library(stringr)
library(whisker)



# Prepare the data for plotting
process_data <- function(data){ 
  dir.create('2_process/out/', showWarnings = FALSE)
  readr::read_csv(data, col_types = 'iccd') %>%
  #data %>%
  filter(str_detect(exper_id, 'similar_[0-9]+')) %>%
  mutate(col = case_when(
    model_type == 'pb' ~ '#1b9e77',
    model_type == 'dl' ~'#d95f02',
    model_type == 'pgdl' ~ '#7570b3'
  ), pch = case_when(
    model_type == 'pb' ~ 21,
    model_type == 'dl' ~ 22,
    model_type == 'pgdl' ~ 23
  ), n_prof = as.numeric(str_extract(exper_id, '[0-9]+')))
}


# Save the processed data
save_proc_data <- function(eval_data){
readr::write_csv(eval_data, file = file.path('2_process/out/', 'model_summary_results.csv'))
}

# custom filter function
filter_data_for_render <- function(eval_data){

#define models we're interested in saving
model_types <- c('pgdl','dl','pb','dl','pb','dl','pb','pgdl','pb')
exper_ids <- c('similar_980','similar_980','similar_980','similar_500',
                 'similar_500','similar_100','similar_100','similar_2','similar_2')
  
  
#concat model type and exper id for filtering
mdl_typ_exp_id <- paste(model_types, exper_ids, sep = '_')

#create a filtered dataframe with the desired model runs and their mean rmse values
filtered_data_df <- eval_data %>%
  group_by(model_type, exper_id) %>%
  summarise(mean_rmse = round(mean(rmse),2)) %>%
  mutate(mdl_typs_exp_ids = paste(model_type, exper_id, sep = '_')) %>%
  filter(mdl_typs_exp_ids %in% mdl_typ_exp_id) %>%
  #clean up model identifiers
  separate(mdl_typs_exp_ids, c('A','B','C'),sep = '_') %>%
  mutate(model_type_exper_id = paste(A,C,sep = '_')) %>%
  ungroup() %>%
  select(model_type_exper_id, mean_rmse)


#convert tibble to named list for rendering
filtered_data_list <- as.list(filtered_data_df$mean_rmse) 
names(filtered_data_list) <- filtered_data_df$model_type_exper_id

return(filtered_data_list)
}


# Save the model diagnostics
save_model_diag <- function(eval_data){
render_data <- filter_data_for_render(eval_data)
template_1 <- 'resulted in mean RMSEs (means calculated as average of RMSEs from the five dataset iterations) of {{pgdl_980}}, {{dl_980}}, and {{pb_980}}°C for the PGDL, DL, and PB models, respectively.
  The relative performance of DL vs PB depended on the amount of training data. The accuracy of Lake Mendota temperature predictions from the DL was better than PB when trained on 500 profiles 
  ({{dl_500}} and {{pb_500}}°C, respectively) or more, but worse than PB when training was reduced to 100 profiles ({{dl_100}} and {{pb_100}}°C respectively) or fewer.
  The PGDL prediction accuracy was more robust compared to PB when only two profiles were provided for training ({{pgdl_2}} and {{pb_2}}°C, respectively). '

whisker.render(template_1 %>% str_remove_all('\n') %>% str_replace_all('  ', ' '), render_data ) %>% cat(file = file.path('2_process/out/', 'model_diagnostic_text.txt'))

}