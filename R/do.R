## do.R script

<<<<<<< HEAD
## >>>>>>>>>>>> Step 1: Perform a RANDOM GUESS

## The first step is to guess; 
## Generate an output where the predictions are made based on no prior knowledge about these customers
## Really a guesswork
submission_df <- data.frame()
random_prediction_vec <- vector(mode="numeric", length = nrow(test_df))
for(i in 1:nrow(test_df)) {
  random_prediction_vec[i] <- sample(0:50000, 1, replace=TRUE)
}

## Stick these columns together
submission_file <- cbind(test_df$Id, random_prediction_vec)
colnames(submission_file) <- c("Id", "Sales")
options("scipen"=100, "digits"=8)
write.csv(submission_file, "./output/preds/rossmann_store_sales_v0.csv", row.names = FALSE, quote = FALSE)
=======
## The first step is to guess; generate an output where the predictions are made based on no prior knowledge about these customers
submission_df <- data.frame()
for(i in 1:nrow(test_data)) {
  print("the index is: " + i)
  new_row <- c(test_data[i, ][1], sample(0:1, 1, replace=TRUE))
  # do stuff with row
  submission_df <- rbind(submission_df, new_row) 
}

head(submission_df)


for(i in 1:nrow(test_data)) {
  ##print(i)
  print(test_data[i, ][1])
}

submission_df <- data.frame()
new_row <- c(test_data[1, ][1], target=sample(0:1, 1, replace=TRUE))
submission_df <- rbind(submission_df, new_row) 
new_row <- c(test_data[2, ][1], target=sample(0:1, 1, replace=TRUE))
submission_df <- rbind(submission_df, new_row)
new_row <- c(test_data[3, ][1], target=sample(0:1, 1, replace=TRUE))
submission_df <- rbind(submission_df, new_row)





setwd('/Users/KCUser/ExMachina/Kagglespace/Springleaf_Marketing_Response/output')
random_prediction_vec <- vector(mode="numeric", length = nrow(test_data))
for(i in 1:nrow(test_data)) {
  random_prediction_vec[i] <- sample(0:1, 1, replace=TRUE)
}

submission_file <- cbind(test_data$ID, random_prediction_vec)
colnames(submission_file) <- c("ID", "target")
options("scipen"=100, "digits"=8)
write.csv(submission_file, "springleaf_response_prediction_v0.csv", row.names = FALSE, quote = FALSE)
>>>>>>> c318b774ca3430f304430d53666906a3eb661be4


