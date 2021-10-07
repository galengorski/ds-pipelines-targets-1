The code can be run using the following set of functions in order:

```ruby
#Get the data from ScienceBase
data <- fetch_data('1_fetch/out')

#Prepare the data for plotting
eval_data <- process_data(data)

#Create a plot
plot_data(eval_data, colors = c('#7570b3','#d95f02','#1b9e77'), markers = c(23,22,21), 
          out_path = '3_data_viz/out/figure_1.png', plot_dim = c(8,10))

#Save the processed data
save_proc_data(eval_data)

#Save the model diagnostics
model_types <- c('pgdl','dl','pb','dl','pb','dl','pb','pgdl','pb')
exper_ids <- c('similar_980','similar_980','similar_980','similar_500',
               'similar_500','similar_100','similar_100','similar_2','similar_2')
save_model_diag(eval_data,model_types,exper_ids)
```
