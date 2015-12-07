## function.r script

fix_data_types <- function(data_frame) {
  

}

## Model that creates RANDOM PREDICTIONS - the WORST MODEL
create_random_preds_model_v0 <- function(){
  ## The first step is to guess; 
  ## Generate an output where the predictions are made based on no prior knowledge about these customers
  ## Really a guesswork
  submission_df <- data.frame()
  random_prediction_vec <- vector(mode = "numeric", length = nrow(test_df))
  for(i in 1:nrow(test_df)) {
    random_prediction_vec[i] <- sample(0:50000, 1, replace=TRUE)
  }
  
  ## Stick these columns together
  submission_file <- cbind(test_df$Id, random_prediction_vec)
  colnames(submission_file) <- c("Id", "Sales")
  options("scipen" = 100, 
          "digits" = 8)
  write.csv(x = submission_file, 
            file = "./output/preds/rossmann_store_sales_v0.csv", 
            row.names = FALSE, 
            quote = FALSE)
}

## Simplest Linear Regression model
create_linreg_preds_model_v1 <- function() {
  
  ##########################
  ## Build a quick and dirty LINEAR Regression model to see what it performs
  ## No feature engineering, just using the features available
  ## Additional features like Competition etc. will be brought in later
  ## In short - this is the MOST BASIC MODEL you can build with your EYES CLOSED
  ##########################
  
  split <- createDataPartition(y = train_df$Sales, p = 0.75, list = FALSE)
  train_df_75 <- train_df[split, ]
  train_df_25 <- train_df[-split, ]
  
  train_df_mod <- sqldf("SELECT Store, DayOfWeek, Open, Promo, StateHoliday, SchoolHoliday, Sales FROM train_df_75") 
  validation_df_mod <- sqldf("SELECT Store, DayOfWeek, Open, Promo, StateHoliday, SchoolHoliday, Sales FROM train_df_25") 
  
  ## Get the Store ID and Date duple
  store_id_date_duple <- test_df$Id
  test_df_mod <- sqldf("SELECT Store, DayOfWeek, Open, Promo, StateHoliday, SchoolHoliday FROM test_df") 
  
  # fitted_lm <- train(Sales ~ ., data = train_df_mod, method = "lm")  >> For some reason this is crashing the R session
  # summary(fitted_lm)
  
  ## Fit a LINEAR MODEL
  fitted_lm <- lm(Sales ~ ., 
                  data = train_df_mod)
  summary(fitted_lm)

  ## Now use this to predict
  predicted_sales <- predict(fitted_lm, test_df_mod)

  ## Then write the submission file
  write_submission_file(1)
}

## Same model as V1 but with more features extracted from STORES data set
create_linreg_preds_model_v2 <- function(train_data, test_data) {
  
  write("Starting Linear Regression model V2...", stdout())
  
  ##########################
  ## Same as V1 model, but with more features
  ##########################
  
  write("Fitting the model V2...", stdout())
  fitted_cv_lm <- lm(Sales ~ .,
                        data = train_data
                        ## method = "lm"
                        ## trControl = train_ctrl_params,
                        ## metric = 'Rsquared'
                        )
}


run_preds_with_model <- function(model_name) {
  ## Now use this to predict
  write("Starting Linear Regression model V2...", stdout())
  predicted_sales <- predict.train(fitted_cv_lm, test_data)
}



## Write the prediction submission file
write_submission_file <- function(file_version, store_id, predicted_sales) {
  
  ## Create the empty data.frame
  submission_file <- data.frame()
  ## Stick these columns together
  submission_file <- cbind(store_id, predicted_sales)
  colnames(submission_file) <- c("Id", "Sales")
  options("scipen" = 100, 
          "digits" = 8)
  write.csv(x = submission_file, 
            file = paste("./output/preds/rossmann_store_sales_v", file_version, ".csv", sep=""), 
            row.names = FALSE, 
            quote = FALSE)
}


## Evaluate the RMSPE to identify the optimal params
eval_rmspe <- function(y_hat, y) {
  ##cat("\n Calculating the RMSPE for the predicted Sales...\n")
  y <- expm1(getinfo(y, "label"))
  y_hat <- expm1(y_hat)
  return(list(metric = "rmspe", value = sqrt(mean(((y_hat - y)/y)^2))))
}

