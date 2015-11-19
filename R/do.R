## do.R script

## Step 1: Load the UDF library source file
source(file = "./R/functions.R")

## Step 2: Create a random prediction model
create_random_preds_model_v0()

## Step 3: Create a basic Multiple Linear Regression model with no CV and basic features
create_linreg_preds_model_v1()