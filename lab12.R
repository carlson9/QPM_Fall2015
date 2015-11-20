#if you're comfortable with classes and subsetting data, skip to the plotting section

#The Leinhardt data frame (in car) has data on infant mortality. 
#load the car library, then run these commands:

library(car)
print(Leinhardt$income)
class(Leinhardt$income)
inc <- as.factor(Leinhardt$income)
print(inc)
as.numeric(inc)
as.numeric(as.character(inc))

#what are you doing/seeing at each step?

#now subset the data to only include oil producing countries with incomes above the mean (do not overwrite the data, as we'll use it again)
#which countries do you get?


### Plotting Section ###
#Regress infant mortality on oil and the log of income.
#Plot the line of best fit for when the country has oil, and a line for when it does not, distinguishing which is which by line type.
#Plot the 95% confidence intervals around the lines of best fit. The following code will work:

mod <- lm(infant ~ log(income) + oil, data=Leinhardt)

income.sorted <- sort(Leinhardt$income)
preds.oil <- predict(mod, newdata = data.frame(income=income.sorted, oil='yes'), interval = 'confidence')

preds.no.oil <- predict(mod, newdata = data.frame(income=income.sorted, oil='no'), interval = 'confidence')

plot(Leinhardt$infant ~ log(Leinhardt$income), type = 'n', xlab='log(income)', ylab='infant mortality')
polygon(c(rev(log(income.sorted)), log(income.sorted)), c(rev(preds.oil[ ,3]), preds.oil[ ,2]), col = 'grey80', border = NA)
lines(log(income.sorted), preds.oil[,1])
lines(log(income.sorted), preds.oil[ ,3], lty = 'dashed', col = 'red')
lines(log(income.sorted), preds.oil[ ,2], lty = 'dashed', col = 'red')

polygon(c(rev(log(income.sorted)), log(income.sorted)), c(rev(preds.no.oil[ ,3]), preds.no.oil[ ,2]), col = 'grey80', border = NA)
lines(log(income.sorted), preds.no.oil[,1], lty=3)
lines(log(income.sorted), preds.no.oil[ ,3], lty = 'dashed', col = 'red')
lines(log(income.sorted), preds.no.oil[ ,2], lty = 'dashed', col = 'red')
points(Leinhardt$infant ~ log(Leinhardt$income), type = 'p', pch=18)

legend('topright', legend=c('oil', 'no oil'), lty=c(1,3), bty='n')

#Now, using your final project data or any data we've already used, run a model including a variable of interest and at least one control.
#Next, create predictions as above, but your newdata argument should set all control variables at their means.
#Plot the predicted line, the confidence intervals, and the actual data points keeping all control variables at their means
#A trivial example:

income.sorted <- sort(Leinhardt$income)
mod <- lm(infant ~ log(income) + as.numeric(oil), data=Leinhardt)
preds <- predict(mod, newdata = data.frame(income=income.sorted, oil=mean(as.numeric(Leinhardt$oil))), interval='confidence')
plot(Leinhardt$infant ~ log(Leinhardt$income), type = 'n', xlab='log(income)', ylab='infant mortality')
polygon(c(rev(log(income.sorted)), log(income.sorted)), c(rev(preds[ ,3]), preds[ ,2]), col = 'grey80', border = NA)
lines(log(income.sorted), preds[,1])
lines(log(income.sorted), preds[ ,3], lty = 'dashed', col = 'red')
lines(log(income.sorted), preds[ ,2], lty = 'dashed', col = 'red')
