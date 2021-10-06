
library(sbtools)

# Get the data from ScienceBase
fetch_data <- function(){
dir.create('1_fetch/out/')
item_file_download('5d925066e4b0c4f70d0d0599', names = 'me_RMSE.csv', destinations = '1_fetch/out/model_RMSEs.csv', overwrite_file = TRUE)
}

