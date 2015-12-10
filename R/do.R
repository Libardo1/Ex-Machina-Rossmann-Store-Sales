## do.R script

## Step 0: Load the UDF library source file
source(file = "./R/load_libs.R")
source(file = "./R/load_data.R")
source(file = "./R/functions.R")
source(file = "./R/clean.R")

## Step 1: Change the appropriate columns into factors
# convert_into_factors()

## Step 2: Create a random prediction model
## create_random_preds_model_v0()

## Step 3: Create a basic Multiple Linear Regression model with no CV and basic features
## create_linreg_preds_model_v1()

gc()
create_linreg_preds_model_v2(train_store_model_df, test_store_model_df)


split <- createDataPartition(y = train_model_df$Sales, 
                             p = 0.75, 
                             list = FALSE)
train_model_df_75 <- train_model_df[split, ]
train_model_df_25 <- train_train_model_df[-split, ]



gbmGrid <-  expand.grid(interaction.depth = c(1, 5, 9),
                        n.trees = (1:30)*50,
                        shrinkage = 0.1,
                        n.minobsinnode = 20)


train_ctrl_params <- trainControl(method = "repeatedcv",
                                  number = 10,
                                  ## repeated ten times
                                  repeats = 10)

gc()
cat("\nBegin: Fitting the model V2...")
fitted_cv_lm <- train(Sales ~ .,
                   data = train_model_df,
                   method = "gbm",
                   trControl = train_ctrl_params,
                   tuneGrid = gbmGrid,
                   verbose = TRUE
                   )
cat("\nEnd: Fitting the model V2...")
gc()


## Now use this to predict using FINAL MODEL
predicted_sales <- predict(fitted_cv_lm$finalModel, 
                           newdata = test_model_df)

## Now Write the prediction
write_submission_file(file_version = 2, 
                      store_id = test_store_id, 
                      predicted_sales = predicted_sales)



##############################################################################################################################
## Trying the XGBOOST Model now
##############################################################################################################################
cat("\n\n Beginning Cross-validation...")
cat("*********************************************")
cat("\nConverting train and test data tables into matrix...")
train_dmat <- sapply(train_store_dt[, setdiff(colnames(train_store_dt), "Sales"), with = FALSE], as.numeric)
test_dmat <- sapply(test_store_dt, as.numeric)


## Check for NA 
colSums(is.na(train_dmat))
colSums(is.na(test_dmat))

## Since only INTEGER columns have NA values, set them -1
train_dmat[is.na(train_dmat)] <- as.integer(-1)
test_dmat[is.na(test_dmat)] <- as.integer(-1)

## This CV needs to run until the test-error rate begins to increase
## which will indicate the optimal params of the models
cat("\n Running cross-validation now... ")
xgboost_cv <- xgb.cv(data = train_dmat, 
                     label = log1p(train_store_dt$Sales),
                     booster = "gbtree",
                     nfold = 10,
                     nthread = 8,
                     eta = 0.1,
                     nround = 100000,
                     max.depth = 6,
                     verbose = TRUE,
                     objective = "reg:linear",
                     eval_metric = eval_rmspe,
                     subsample = 0.8,
                     colsample_bytree = 0.75,
                     min_child_weight = 3,
                     early.stop.round = 10,
                     maximize = FALSE
                     )

plot(xgboost_cv$test.rmspe.mean)

cat("\n Now fitting the XGBoost model on the entire training data set now...")
xgboost_fit <- xgboost(data = train_dmat, 
                       label = log1p(train_store_dt$Sales),
                       booster = "gbtree",
                       nthread = 8,
                       eta = 0.1,
                       nround = 2246,
                       max.depth = 6,
                       verbose = TRUE,
                       objective = "reg:linear",
                       eval_metric = eval_rmspe,
                       subsample = 0.8,
                       colsample_bytree = 0.75,
                       min_child_weight = 3
                       )

##Predict using the XGBoost - NOTE the inversion applied on the predicted value
pred_dense <- expm1(predict(xgboost_fit, test_dmat))


## Now Write the prediction
write_submission_file(file_version = 11, 
                      store_id = test_store_id, 
                      predicted_sales = pred_dense)



xgb.plot.tree(feature_names = colnames(train_store_dt), 
              model = xgboost_fit
              )


cat("\n Plotting feature importance...")
xgb.importance(feature_names = colnames(train_dmat), model = xgboost_fit)




##############################################################################################################################
## Trying the Linear Regression again... with 10-fold Cross validation repeated 10-times
##############################################################################################################################


cat("\n Running a version of Linear Regression Model with Sparse matrix, and stacking with XGBoost...")

## Just create a copy of the DT 
train_store_dt_mod <- train_store_dt
test_store_dt_mod <- test_store_dt

## Now LM models cannot handle factors, so convert this into a One Hot Encoding
# binarize all factors
library(caret)

cat("\n Merging the Train and Test data sets, before One-Hot-Encoding...")
Sales <- train_store_dt$Sales
train_store_dt$Sales <- NULL
train_store_dt$Source <- 1
test_store_dt$Source <- 2
train_test_store_dt <- rbind(train_store_dt, test_store_dt)

## Convert the data types into Factors wherever necessary
train_test_store_dt$Store <- as.factor(train_test_store_dt$Store)
train_test_store_dt$DayOfWeek <- as.factor(train_test_store_dt$DayOfWeek)
train_test_store_dt$Open <- as.integer(train_test_store_dt$Open)
train_test_store_dt$Promo <- as.factor(train_test_store_dt$Promo)
train_test_store_dt$Promo2 <- as.factor(train_test_store_dt$Promo2)
train_test_store_dt$Week <- as.factor(train_test_store_dt$Week)
train_test_store_dt$Month <- as.factor(train_test_store_dt$Month)
train_test_store_dt$IsPromoMonth <- as.factor(train_test_store_dt$IsPromoMonth)

cat("\n One-hot Encoding factor variables in Training & Test data sets...")
dmy <- dummyVars(" ~ .", data = train_test_store_dt)
train_test_store_dt_ohec <- data.frame(predict(dmy, newdata = train_test_store_dt))

cat("\n Now split the One-hot-encoded data sets into training and test...")
train_store_dt_ohec <- train_test_store_dt_ohec[train_test_store_dt_ohec$Source == 1, ]
test_store_dt_ohec <- train_test_store_dt_ohec[train_test_store_dt_ohec$Source == 2, ]
train_store_dt_ohec$Sales <- Sales

cat("\n Setting up Cross-validation parameters...")
train_ctrl_params <- trainControl(method = "repeatedcv",
                                  number = 10,
                                  ## repeated ten times
                                  repeats = 3)

gc()
cat("\n Begin: Fitting the LM model...")
fitted_cv_lm <- train(Sales ~ .,
                      data = train_store_dt_ohec,
                      method = "lm",
                      trControl = train_ctrl_params,
                      verbose = TRUE
                      )
cat("\nEnd: Fitting the model V2...")
gc()


## Now use this to predict using FINAL MODEL
predicted_sales <- predict(fitted_cv_lm$finalModel, 
                           newdata = test_store_dt_ohec)

## Now Write the prediction
write_submission_file(file_version = 2, 
                      store_id = test_store_id, 
                      predicted_sales = predicted_sales)


