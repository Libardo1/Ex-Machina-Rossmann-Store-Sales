## Load the data from the raw files
BASE_DATA_DIR <- "/Users/KCUser/ExMachina/Kagglespace/All_Projects_Data_Repo"
PROJECT_DATA_DIR <- "/Rossmann_Store_Sales/raw/train.csv"
train_df <- read.csv(file=paste(BASE_DATA_DIR, PROJECT_DATA_DIR, sep=""), sep=",", header=TRUE)
test_df <- read.csv(file=paste(BASE_DATA_DIR, PROJECT_DATA_DIR, sep=""), sep=",", header=TRUE)
store_df <- read.csv(file=paste(BASE_DATA_DIR, PROJECT_DATA_DIR, sep=""), sep=",", header=TRUE)