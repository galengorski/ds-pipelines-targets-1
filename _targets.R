library(targets)
source("1_fetch/src/fetch_data.R")
source("2_process/src/process_data.R")
source("3_data_viz/src/plot_data.R")
tar_option_set(packages = c("tidyverse", "sbtools", "whisker"))

list(
  # Get the data from ScienceBase
  tar_target(
    model_RMSEs_csv,
    fetch_data(out_path = "1_fetch/out"),
    format = 'file'
  ), 
  # Prepare the data for plotting
  tar_target(
    eval_data,
    process_data(data = model_RMSEs_csv),
  ),
  # Create a plot
  tar_target(
    figure_1_png,
    plot_data(eval_data, colors = c('#7570b3','#d95f02','#1b9e77'), markers = c(23,22,21), 
              out_path = '3_data_viz/out/figure_1.png', plot_dim = c(8,10)), 
    format = "file"
  ),
  # Save the processed data
  tar_target(
    model_summary_results_csv,
    save_proc_data(eval_data), 
    format = "file"
  ),
  # Save the model diagnostics
  tar_target(
    model_diagnostic_text_txt,
    save_model_diag(eval_data),
    format = "file"
  )
)