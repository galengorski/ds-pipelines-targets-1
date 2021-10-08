
library(sbtools)

# Get the data from ScienceBase
fetch_data <- function(out_path){
dir.create(out_path, showWarnings = F)
dest <- file.path(out_path, 'model_RMSEs.csv')
item_file_download('5d925066e4b0c4f70d0d0599', names = 'me_RMSE.csv', destinations = dest, overwrite_file = TRUE)
}

