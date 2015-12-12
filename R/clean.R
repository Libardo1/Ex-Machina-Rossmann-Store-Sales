## Start CLEANING up and PREPPING the data

cat("\n Checking the data types of Train, Test and Store data sets...")
str(train_dt)
str(test_dt)
str(store_dt)

cat("\n Correcting the Date data type...")
train_dt[, Date := as.Date(Date)]
test_dt[, Date := as.Date(Date)]

## Check for NA in TRAIN data set
colSums(is.na(train_dt))

## Store     DayOfWeek          Date         Sales     Customers          Open         Promo  StateHoliday SchoolHoliday 
## 0             0             0             0             0             0             0             0             0 

## Check for NA in TEST data set
colSums(is.na(test_dt))

## Id         Store     DayOfWeek          Date          Open         Promo  StateHoliday SchoolHoliday 
## 0             0             0             0            11             0             0             0

## So this is the same store = 622 that has NA values
## Seeing the Store open status around these dates, I think its safe to replace the NA with 1
test_dt[is.na(Open), Open := 1] ## <<< This is MUCH conscise than the data frame syntax.

## Merge the Train and Store data sets
train_store_dt <- merge(x = train_dt,
                        y = store_dt, 
                        by = "Store")

## Do the same for TEST data set
test_store_dt <- merge(x = test_dt, 
                       y = store_dt, 
                       by = "Store")

## Remove the cases with ZERO sales; Kaggle will ignore these
## train_store_dt <- train_store_dt[Sales > 0]


## Drop the columns in TRAIN & TEST not needed
Sales <- train_store_dt[, Sales]
train_store_dt[, c("Sales", "Customers") := NULL]
test_store_id <- test_store_dt[, Id]
test_store_dt[, Id := NULL]

## Merge the resulting TRAIN and TEST data frames
train_store_dt[, source := "train"]
test_store_dt[, source := "test"]
train_test_store_dt <- rbind(train_store_dt, test_store_dt)


## Feature Engineering
cat("\n Beginning feature extraction and engineering...")
cat("\n ...")

## Breakdown the DATE into Week, Month and Year
cat("\n Breaking down the DATE into Week, Month and Year features...")
train_test_store_dt[, DayOfMonth := as.integer(format(Date, "%d"))]
train_test_store_dt[, DayOfYear := as.integer(format(Date, "%j"))]
train_test_store_dt[, Week := as.integer(format(Date, "%U"))]
train_test_store_dt[, Month := as.integer(format(Date, "%m"))]
train_test_store_dt[, Year := as.integer(format(Date, "%Y"))]

## Feature #2 >>> Extract whether the current month is PROMO_2 month
cat("\n Evaluating if the current month is a Promo2 month for that store and that date...")
train_test_store_dt[, IsPromoMonth := !is.na(str_match(pattern = format(Date, "%b"), string = PromoInterval))]

cat("\n Converting the PromoInterval into a more conscise categories...Jan Cycle (JC), Feb Cycle (FC), March Cycle (MC)")
train_test_store_dt[, Promo2Interval := as.factor(ifelse(PromoInterval == "Jan,Apr,Jul,Oct", "JC", 
                                              ifelse(PromoInterval == "Feb,May,Aug,Nov", "FC", 
                                                     ifelse(PromoInterval == "Mar,Jun,Sept,Dec", "MC", "None"))))]
                      

cat("\n Dropping the Date, PromoInterval columns, as no longer needed...")
train_test_store_dt[, c("Date", "PromoInterval") := NULL]

cat("\n Calculating duration in Months since the competition first opened near each store... ")
train_test_store_dt[, CompetitionDurationMonths := (Month - CompetitionOpenSinceMonth) + 12 * (Year - CompetitionOpenSinceYear)]
train_test_store_dt[, CompetitionDurationMonths := ifelse(CompetitionDurationMonths < 0, -1, CompetitionDurationMonths)]
cat("\n Dropping the CompetitionOpenSinceMonth and CompetitionOpenSinceYear columns, as no longer needed... ")
train_test_store_dt[, c("CompetitionOpenSinceMonth", "CompetitionOpenSinceYear") := NULL]

cat("\n Calculating duration in Weeks since Promo2 First begun at each Store...")
train_test_store_dt[, Promo2DurationWeeks := (Week - Promo2SinceWeek) + 52 * (Year - Promo2SinceYear)]
train_test_store_dt[, Promo2DurationWeeks := ifelse(Promo2DurationWeeks < 0, -1, Promo2DurationWeeks )]
cat("\n Dropping the Promo2SinceWeek and Promo2SinceYear columns, as no longer needed... ")
train_test_store_dt[, c("Promo2SinceWeek", "Promo2SinceYear") := NULL]


cat("\n Start extracting some Sales trends...")
cat("\n >>> Get average sales per store, per month, per year...")
train_test_store_dt



## Now Fix the data types
cat("\n Begin: Fixing the data types of the train & test combined data set...")
#train_test_store_dt$Store <- as.factor(train_test_store_dt$Store)
#train_test_store_dt$DayOfWeek <- as.numeric(train_test_store_dt$DayOfWeek)
#train_test_store_dt$Open <- as.numeric(train_test_store_dt$Open)
#train_test_store_dt$Promo <- as.numeric(train_test_store_dt$Promo)
#train_test_store_dt$StateHoliday <- as.numeric(train_test_store_dt$StateHoliday)
#train_test_store_dt$SchoolHoliday <- as.numeric(train_test_store_dt$SchoolHoliday)
#train_test_store_dt$StoreType <- as.numeric(train_test_store_dt$StoreType)
#train_test_store_dt$Assortment <- as.numeric(train_test_store_dt$Assortment)
#train_test_store_dt$CompetitionDistance <- as.numeric(train_test_store_dt$CompetitionDistance)
#train_test_store_dt$Promo2 <- as.numeric(train_test_store_dt$Promo2)
#train_test_store_dt$Week <- as.numeric(train_test_store_dt$Week)
#train_test_store_dt$Month <- as.numeric(train_test_store_dt$Month)
#train_test_store_dt$Year <- as.numeric(train_test_store_dt$Year)
#train_test_store_dt$IsPromoMonth <- as.factor(train_test_store_dt$IsPromoMonth)
#train_test_store_dt$Promo2Interval <- as.numeric(train_test_store_dt$Promo2Interval)
#train_test_store_dt$CompetitionDurationMonths <- as.numeric(train_test_store_dt$CompetitionDurationMonths)
#train_test_store_dt$Promo2DurationWeeks <- as.numeric(train_test_store_dt$Promo2DurationWeeks)
#cat("\n End: Fixing the data types of the train & test combined data set...")

## Check for NA 
colSums(is.na(train_test_store_dt))

## Since only INTEGER columns have NA values, set them -1
train_test_store_dt[is.na(train_test_store_dt)] <- as.integer(-1)

## Check for Correlation between predictors
## correlationMatrix <- cor(train_test_store_dt[, -which(colnames(train_test_store_dt) == "source")])
## print(correlationMatrix)
# find attributes that are highly corrected (ideally >0.75)
## highlyCorrelated <- findCorrelation(correlationMatrix, 
##                                     cutoff = 0.5)
## Visualize the Correlations
## corrplot(correlationMatrix, 
##          order = "hclust")

# dummify the data
#dmy <- dummyVars(" ~ .", data = train_test_store_dt[, !"source", with = FALSE])
#train_test_store_dt_dummied <- data.frame(predict(dmy, newdata = train_test_store_dt[, !"source", with = FALSE]))
#print(train_test_store_dt_dummied)
#cat("\n Adding the source column to this one-hot-encoded data table...")
#train_test_store_dt_dummied <- as.data.table(cbind(train_test_store_dt_dummied, source = train_test_store_dt[, source]))

cat("\n Splitting the train and test data sets now...")
train_store_dt <- train_test_store_dt[source == "train"]
test_store_dt <- train_test_store_dt[source == "test"]

cat("\n Dropping the 'source' column from the Train and Test data sets...")
train_store_dt[, source := NULL]
train_store_dt[, Sales := Sales]
test_store_dt[, source := NULL]


## Trying this new approach
cat("\n There are more stores in Training data set than there are in test data set...")
cat("\n ... Removing those stores from the training data set that are absent in the test data set...")
test_stores <- unique(test_store_dt$Store)
train_store_dt <- train_store_dt[Store %in% test_stores]


#cat("\n Converting factor variables into dummy variables...in Train data...")
#train_store_dt_dummy <- dummyVars(" ~ .", data = train_store_dt)
#train_store_dt_dummy <- data.table(predict(train_store_dt_dummy, newdata = train_store_dt))

#cat("\n Converting factor variables into dummy variables...in Test data...")
#test_store_dt_dummy <- dummyVars(" ~ .", data = test_store_dt)
#test_store_dt_dummy <- data.table(predict(test_store_dt_dummy, newdata = test_store_dt))

## Remove the intermediate dataframes now that we have MODEL READY data set
##rm(correlationMatrix)
## Remove the STORE data set- not needed anymore
rm(store_dt)
rm(train_dt)
rm(test_dt)
rm(train_test_store_dt)
gc()
