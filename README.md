#The code can be run using the following set of functions in order:

# Get the data from ScienceBase
data <- fetch_data()
# Prepare the data for plotting
eval_data <- process_data(data)
# Create a plot
plot_data(eval_data)
# Save the processed data
save_proc_data(eval_data)
# Save the model diagnostics
save_model_diag(eval_data)
