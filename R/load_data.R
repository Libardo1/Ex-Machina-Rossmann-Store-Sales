## Load the data from the raw files
BASE_DATA_DIR <- "/Users/KCUser/ExMachina/Kagglespace/All_Projects_Data_Repo"
RAW_PROJECT_DATA_DIR <- "/Rossmann_Store_Sales/raw"
PROC_PROJECT_DATA_DIR <- "/Rossmann_Store_Sales/processed"

## Start loading the data sets
cat("\n Loading the training data set...")
train_dt <- fread(input = paste(BASE_DATA_DIR, RAW_PROJECT_DATA_DIR, "/train.csv", sep=""), 
                  sep = ",", 
                  header = TRUE,
                  na.strings = "NA",
                  stringsAsFactors = TRUE)

cat("\n Loading the test data set...")
test_dt <- fread(input = paste(BASE_DATA_DIR, RAW_PROJECT_DATA_DIR, "/test.csv", sep=""), 
                 sep = ",", 
                 header = TRUE,
                 na.strings = "NA",
                 stringsAsFactors = TRUE)

cat("\n Loading the store data set...")
store_dt <- fread(input = paste(BASE_DATA_DIR, RAW_PROJECT_DATA_DIR, "/store.csv", sep=""), 
                  sep = ",", 
                  header = TRUE,
                  na.strings = "NA",
                  stringsAsFactors = TRUE)

#cat("\n Loading the Google flu trend data set...")
#google_flu_trends_dt <- fread(input = paste(BASE_DATA_DIR, RAW_PROJECT_DATA_DIR, "/google_flu_trend.csv", sep=""), 
#                              sep = ",", 
#                              header = TRUE,
#                              na.strings = "NA",
#                              stringsAsFactors = TRUE)
gc()