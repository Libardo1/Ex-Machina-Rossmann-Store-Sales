cat("\n Begin exploring the time series XTS class... ")
cat("\n https://cran.r-project.org/web/packages/xts/vignettes/xts.pdf \n")

require(xts)
data("sample_matrix")
class(sample_matrix)

str(sample_matrix)

## convert this matrix into XTS object
sample_matrix_xts <- as.xts(sample_matrix, dateFormat = 'Date')
str(sample_matrix_xts)

## Now convert this into a data frame and then into a XTS object
sample_df_xts <- as.xts(as.data.frame(sample_matrix), 
                        addition_info = "DF to XTS")


## Subsetting data using date range
sample_matrix_xts['2007-03']

## Subsetting data using a FROM/TO format ~ here the FROM is empty indicating from beginning of time
sample_matrix_xts["/2007-02"]

## Spirit of HEAD and TAIL functions, FIRST and LAST functions are provided
## Here, we are extracting the first ONE week of the data
first(sample_matrix_xts, '1 week') # >> Get the first one week
first(sample_matrix_xts, '2 week') # >> Get the first two week
first(sample_matrix_xts, '3 week') # >> Get the first thriee week
first(sample_matrix_xts, '1 month') # >> Get the first one month
first(sample_matrix_xts, '1 year') # >> Get the first one year

## This is so handy ^^

## Try the LAST function
last(sample_matrix_xts, '1 week') # >> Get the first one week
last(sample_matrix_xts, '2 week') # >> Get the first two week
last(sample_matrix_xts, '3 week') # >> Get the first thriee week
last(sample_matrix_xts, '1 month') # >> Get the first one month
last(sample_matrix_xts, '1 year') # >> Get the first one year

## try another variation - extract specified number of days
first(sample_matrix_xts, '10 days')

## first 3 days of last ONE week
first(last(sample_matrix_xts, '1 week'), '3 days')


## Indexing 
## Find the index class
indexClass(sample_matrix_xts)


## Now comes the most important part - PLOTTING
axTicksByTime(sample_matrix_xts, ticks.on="months")
plot(sample_matrix_xts, major.ticks = "months", minor.ticks = TRUE)


## OK - lets try doing this on the Rossmann stores train data
train_dt[, Date := as.POSIXct(Date)]
train_dt_mod_2013 <- train_dt[Store == 1 & format(Date, "%Y") == 2013, .(Date, Store, Sales, Customers)]
# train_dt_mod[Sales > 0]
train_dt_xts_2103 <- as.xts(train_dt_mod_2013)
train_dt_mod_2015 <- train_dt[Store == 1 & format(Date, "%Y") == 2015, .(Date, Store, Sales, Customers)]
train_dt_xts_2015 <- as.xts(train_dt_mod_2015)


# first(last(train_dt_xts_2103, '1 week'), '20 days')
# train_dt_xts["2013-04"]

## Plot now

x1_2013 <- first(train_dt_xts_2103, '30 weeks')
x1_2015 <- first(train_dt_xts_2015, '30 weeks')
# y <- sample_matrix_xts
plot(x1_2013[, 2], major.ticks = "months", minor.ticks = FALSE, col = "red")
par(new = TRUE)
plot(x1_2015[, 2], major.ticks = "months", minor.ticks = FALSE, col = "blue")




