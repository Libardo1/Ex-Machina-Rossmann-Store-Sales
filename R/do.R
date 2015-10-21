## do.R script

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


