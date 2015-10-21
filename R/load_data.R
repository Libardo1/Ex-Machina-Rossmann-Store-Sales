## Load the data from the raw files
BASE_DATA_DIR <- "/Users/KCUser/ExMachina/Kagglespace/All_Projects_Data_Repo"
RAW_PROJECT_DATA_DIR <- "/Rossmann_Store_Sales/raw"
PROC_PROJECT_DATA_DIR <- "/Rossmann_Store_Sales/processed"
train_df <- read.csv(file=paste(BASE_DATA_DIR, PROJECT_DATA_DIR, "/train.csv", sep=""), sep=",", header=TRUE)
test_df <- read.csv(file=paste(BASE_DATA_DIR, PROJECT_DATA_DIR, "/test.csv", sep=""), sep=",", header=TRUE)
store_df <- read.csv(file=paste(BASE_DATA_DIR, PROJECT_DATA_DIR, "/store.csv", sep=""), sep=",", header=TRUE)