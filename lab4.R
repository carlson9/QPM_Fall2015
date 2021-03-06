## create a blank R script, and save it as a .R file. Work on these questions in the .R file, saving frequently.
## throughout, if you do not know how to do something, google first, then ask.
## when an error is received, google the error, try to figure out why you received the error.
## There are different tiers. If you cannot do the basic tier, focus on this for the day. Otherwise look ahead and see what you think you can accomplish. Feel free to skip things that are too easy or too hard.

##### Basic Tier #####
## download the samuels data from https://github.com/carlson9/QPM_Fall2015 or from blackboard lab 2 folder.
## summarize the variables (just have the code in your .R file, don't bother writing down the results).
## create histograms and density plots of a few variables and make titles that are different from the defaults. Try changing axis labels as well.

##### Tier 1 ####
## download and load the package faraway
## load the data named divusa
## explore the data with the help files
## plot female labor participation on year, divorce rate on year, marriage rate on year, and birth rate on marriage rate, while creating meaningful titles and axis labels
## are there any apparent trends? What are some possible explanations?
## pick some of these variables and see if they are distributed normally using quantile-quantile plots
## add a Q-Q line to one of these plots
## treat the observations of divorce rates pre-1960 as one distribution and post-1960 as another. Use a 2-sample t-test to determine if the sample means are statistically distinguishable.

#### Tier 2a ####
## simulate data from different normal distributions
## create quantile-quantile plots on the ditributions with normal as the baseline
## add a line of the theoretical distribution to each plot
## explain what these are doing
## plot the pdf of the distributions you drew from, and plot the density of your draws on that pdf with a dashed line
## use 1-sample t-tests to determine if the simulated data have a statistically distinguishable mean from the target distribution
## do shapiro-wilks tests on the simulated data
## interpret the results
## in the hypothetical distribution, at what values would the z-score equal 2?
## what percentage of your simulated data fall at these values or more extreme?

z <- rnorm(1000,10,3)
qqnorm(z)
qqline(z)
qnorm(pnorm(5,10,3))
qnorm(pnorm(10,10,3))
x <- seq(0,20, length=1000)
y <- dnorm(x, mean=10, sd=3)
plot(x,y, type='l')
par(new=TRUE)
plot(density(z), lty=2, xlab='',main='',ylab='', yaxt='n', xaxt='n')
t.test(z, mu=10)
shapiro.test(z)
sum(z<=4|z>=16)/1000

#### Tier 2b - plotting practice ####
## plot a pdf of any normal
## draw a verticle line at two standard deviations above the mean
## shade the tail from the line onward
## calculate the probability of drawing from this tail

plot(x, y, type='l')
points(list(x=c(16,16),y=c(0,dnorm(16,10,3))), type='l')
cord.x <- c(16, 16, 20, 20)
cord.y <- c(0, dnorm(16,10,3), 0, dnorm(20,10,3))
polygon(cord.x, cord.y, col='grey')
plot(x, y, type='l')
points(list(x=c(16,16),y=c(0,dnorm(16,10,3))), type='l')
cord.x <- c(16, seq(16,20,.01), 20)
cord.y <- c(0, dnorm(seq(16,20,.01), 10,3), 0)
polygon(cord.x, cord.y, col='grey')
pnorm(16,10,3, lower=FALSE)
1-pnorm(16,10,3)


#### very advanced tier ####

## Sampling distributions and p-values
## 1. Make a three dimensional array with dim=c(20,5, 1000) and fill it with random data. Think of this as 1000 random datasets with 20 observations and 5 covariates
## 2. Here is the vector of covariates
##    Beta <- matrix(c(1,2,0,4,0), ncol=1)
##    Make a function to create Y values (for a linear model). The Y-values should be a linear combination of the X’s plus some normally distributed error. The output should be a 20 by 1000 array.
## 3. Run 1,000 regressions across all of this simulated data. Have as the output a 1000 by 6 matrix of estimated regression coefficients.
## 4. Create a density plot for each of the 6 coefficients (each of which should have been estimated 1,000 times). What does this distribution represent?
## 5. Alter your code so that you now collect t-statistics for all 1,000 regressions for all six coefficients.
## 6. For the 1,000 regressions, calculate how many t-statistics are statistically "significant" (p≤.05) for each variable. (Make sure you use the right degrees of freedom). Discuss.
## 7. Re-run that code in parallel. Using the system.time command, estimate how much time is saved (or not) using the parallel code.

library(plyr)
library(doSNOW)
####Question 1

##create an array with dimensions 20,5,1000, filled with random normal draws
my.array<-array(rnorm(1000*20*5),dim=c(20,5,1000))

####Question 2

##vector of covariates
beta<-matrix(c(1,2,0,4,0),ncol=1)
##apply crossprod plus normally distributed disturbance
Y<-apply(my.array,3,function(x){
  x%*%beta+rnorm(dim(x)[1])
})

####Question 3

##function est.func returns lm coefficients for a column of output matrix regressed on sub-matrix of an array
## @param i Index of output matrix and submatrix of array
## @param y Output variable matrix
## @param array Input array
## @return vector of coefficients
est.func<-function(i,y,array){
  return(coefficients(lm(y[,i]~array[,,i])))
}

beta.hat<-laply(1:dim(my.array)[3],est.func,Y,my.array) ##apply est.function from i=1 to i=1000 (last dimension of array) and store as matrix of betas




####Question 4
par(mfrow=c(2,3))  ##output six graphs at once, 2 by 3

##plot densities for beta0 through beta5
##using l_aply because we don't need an output outside of what the function itself is doing, and this also allows labelling graphs with number for beta
l_ply(1:dim(beta.hat)[2],function(x){
  plot(density(beta.hat[,x]),xlab=paste("beta",x-1),main=paste("Beta ",x-1," Distribution"))
})
##the above-created graphs represent the sampling distributions of our beta estimates, beta 0 is the intercept term



####Question 5

##function t.est.func returns t stats of a linear model for column of output matrix regressed on sub-matrix of an array
## @param i Index of output matrix and submatrix of array
## @param y Output variable matrix
## @param array Input array
## @return vector of t stats - each model will be represented by a row, each variable by a column
t.est.func<-function(i,y,array){
  t.model<-lm(y[,i]~array[,,i])  ##define model
  return(coefficients(t.model)/sqrt(diag(vcov(t.model))))  ##divide beta estimates by standard error
}

t.stats<-laply(1:dim(my.array)[3],t.est.func,Y,my.array)  ##apply t.est.func on my.array from i=1 to 1000


####Question 6


##function t.sig outputs a vector containing the number of t stats from a matrix of t stats are statistically different from zero with a t-test at significance level alpha and n-k-1 degrees of freedom
## @param t.statistics A matrix of t-stats. The columns should be the different variables, each row are the t-stats created by a different linear model
## @param n Number of observations per model
## @param alpha Significance level to test at - default = .05
## @return vector of length the same as number of variables - each entry is the total number of t stats that were statistically different from 0 for that variable
t.sig<-function(t.statistics,n, alpha=.05){
  conf.int<-qt(alpha/2,n-dim(t.statistics)[2]-2)  ##sets lower bound to confidence interval at alpha/2 and n-k-1 degrees of freedom (k=dim(t.statistics)[2]-1)
  conf.int.vec<-c(conf.int,-conf.int)  ##creates vector of lower (conf.int) and upper (-conf.int) bounds of confidence interval including zero
  return(apply(t.stats,2,function(x){
    sum(x>=conf.int.vec[2]|x<=conf.int.vec[1])  ##returns a vector of number of observations for each variable where t stat is outside bounds
  }))
}

(num.sig<-t.sig(t.stats,20))  ##assigns number of t stats outside bounds at default alpha=.05 and n=20 (k is 5 due to dimensions - determined in function)


####Question 7


registerDoSNOW(makeCluster(5, type = "SOCK"))  ##allow parallel running in 5 clusters
##same function as t.sig but with computation in parallel:
##function t.sig.doSNOW outputs a vector containing the number of t stats from a matrix of t stats are statistically different from zero with a t-test at significance level alpha and n-k-1 degrees of freedom
## @param t.statistics A matrix of t-stats. The columns should be the different variables, each row are the t-stats created by a different linear model
## @param n Number of observations per model
## @param alpha Significance level to test at - default = .05
## @return vector of length the same as number of variables - each entry is the total number of t stats that were statistically different from 0 for that variable
t.sig.doSNOW<-function(t.statistics,n, alpha=.05){
  conf.int<-qt(alpha/2,n-dim(t.statistics)[2]-2)  ##sets lower bound to confidence interval at alpha/2 and n-k-1 degrees of freedom (k=dim(t.statistics)[2]-1)
  conf.int.vec<-c(conf.int,-conf.int)  ##creates vector of lower (conf.int) and upper (-conf.int) bounds of confidence interval including zero
  return(foreach(i=1:dim(t.stats)[2],.combine="c")%dopar%{  ##for one to six, determines how many in each column are outside intervals and binds results into single vector
    sum(t.statistics[,i]>=conf.int.vec[2]|t.statistics[,i]<=conf.int.vec[1])
  })
}

system.time(t.stats<-laply(1:dim(my.array)[3],t.est.func,Y,my.array))+
  system.time(t.sig(t.stats,20))  ##calculates system time of above calculations, without parallel

system.time(t.stats.doSNOW<-foreach(i=1:dim(my.array)[3],.combine="rbind")%dopar%{
  t.est.func(i,Y,my.array)  ##runs function t.est.func along last dimension
})+system.time(t.sig.doSNOW(t.stats.doSNOW,20)) ##calculates system time of above calculations with parallel computation
