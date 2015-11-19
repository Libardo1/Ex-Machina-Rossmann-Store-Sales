## function.r script


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
  
  ## Lets change the data types of these variables in Train DF modeified
  train_df_mod$Store <- as.factor(train_df_mod$Store)
  train_df_mod$DayOfWeek <- as.factor(train_df_mod$DayOfWeek)
  train_df_mod$Open <- as.factor(train_df_mod$Open)
  train_df_mod$Promo <- as.factor(train_df_mod$Promo)
  train_df_mod$StateHoliday <- as.factor(train_df_mod$StateHoliday)
  train_df_mod$SchoolHoliday <- as.factor(train_df_mod$SchoolHoliday)
  
  
  ## Lets change the data types of these variables in Train DF modeified
  validation_df_mod$Store <- as.factor(validation_df_mod$Store)
  validation_df_mod$DayOfWeek <- as.factor(validation_df_mod$DayOfWeek)
  validation_df_mod$Open <- as.factor(validation_df_mod$Open)
  validation_df_mod$Promo <- as.factor(validation_df_mod$Promo)
  validation_df_mod$StateHoliday <- as.factor(validation_df_mod$StateHoliday)
  validation_df_mod$SchoolHoliday <- as.factor(validation_df_mod$SchoolHoliday)
  
  
  test_df_mod$Store <- as.factor(test_df_mod$Store)
  test_df_mod$DayOfWeek <- as.factor(test_df_mod$DayOfWeek)
  test_df_mod$Open <- as.factor(test_df_mod$Open)
  test_df_mod$Promo <- as.factor(test_df_mod$Promo)
  test_df_mod$StateHoliday <- as.factor(test_df_mod$StateHoliday)
  test_df_mod$SchoolHoliday <- as.factor(test_df_mod$SchoolHoliday)
  
  
  
  # fitted_lm <- train(Sales ~ ., data = train_df_mod, method = "lm")  >> For some reason this is crashing the R session
  # summary(fitted_lm)
  
  ## Fit a LINEAR MODEL
  fitted_lm <- lm(Sales ~ ., data = train_df_mod)
  summary(fitted_lm)

  ## Now use this to predict
  predicted_sales <- predict(fitted_lm, test_df_mod)

  
  ## Create the empty data.frame
  submission_file <- data.frame()
  ## Stick these columns together
  submission_file <- cbind(store_id_date_duple, predicted_sales)
  colnames(submission_file) <- c("Id", "Sales")
  options("scipen" = 100, 
          "digits" = 8)
  write.csv(x = submission_file, 
            file = "./output/preds/rossmann_store_sales_v1.csv", 
            row.names = FALSE, 
            quote = FALSE)
  
}