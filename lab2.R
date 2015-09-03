## https://github.com/carlson9/QPM_Fall2015

## download data from Dropbox - must be a csv!

library(repmis)
#key for dropbox found in middle of public link
data <- source_DropboxData("samuels.csv",
                   "1vean5wpfiqkr51")[,-1]

## or download data from github, and run...
#library(foreign)
#read.dta('samuels.dta')

colnames(data)
names(data)
summary(data)

names(data[,c(2:13)])
summary(data[,c(2:13)])
summary(data[,c(2:13)])

## apply - look at ?apply
apply(data[,c(2:13)],2,sd)
apply(data[,c(2:13)],2,mean)
apply(data[,c(2:13)],2,function(x) any(x==2))

data$north
data[data$north==1,]
hold1 <- data[data$north==1,]
hold2 <- data[as.logical(data$north),]
hold1 == hold2
all(hold1 == hold2)
any(hold1 != hold2)

apply(data,1,function(x) any(x==1))
apply(data,1,function(x) any(x==2))
apply(data,1,function(x) any(x=='AL'))
hold <- apply(data,1,function(x) any(x=='AL'))
(data$state == 'AL') == hold
all((data$state == 'AL') == hold)

#######################################################
# Loops: For and If-Else
# For loops have the following basic structure

# for(i in ?:?){
# 	STUFF GOES HERE
#	}

# Essentially for loops will repeat an action multiple times. Here's a simple 
# example using the random.vector object we created earlier:

set.seed(1212) #sets a random seed so the results are always the same
random.vector <- rchisq(n = 100, df=2) #draw 100 random observations
random.vector
mean(random.vector)
sd(random.vector)

#make a histogram
hist(random.vector)

#make a density plot
plot(density(random.vector))
New.Vector <- numeric(100)
New.Vector
for(i in 1:100){
  New.Vector[i] <- random.vector[i] + 10		
}
New.Vector
mean(New.Vector)
sd(New.Vector) == sd(random.vector)
#If-else functions will carry out certain commands based on criteria you give them
New.Vector.2 <- numeric(100)

for(i in 1:100){
  if(random.vector[i] <= mean(random.vector)){
    New.Vector.2[i] <- 1	
  } else{
    New.Vector.2[i] <- 0
  }
}

New.Vector.2
as.logical(New.Vector.2)
sum(New.Vector.2)
sum(as.logical(New.Vector.2))


New.Vector[as.logical(New.Vector.2)]

## to do:
## 1. create a loop that loops 1,000 times, and at each iteration draw 100 samples from the above chi-square distribution
## 2. at each iteration, save the mean of the sample to a new vector
## 3. plot the density of the vector of means
## 4. Repeat with more iterations




#### If you have experience in R:

#You have a bag with 5 cats in it. 3 of the cats in the bag are black, and 2 of the cats are white. When you open the bag, one of the cats darts out and climbs a tree before you can see what kind of cat it
#is (black/white). Say you pull another cat out of the bag and see that it is a white cat. What is the probability that the cat in the tree is white?
#Write a function in R simulating the situation 5000 times and have it return (roughly) the probability.

#In the game show 'Let's Make a Deal,' you get to choose one of three closed doors, and you receive the prize behind the door you choose. Behind one door is a new car; behind the other two are goats.
#After you select one of the 3 doors, the host opens one of the other two doors, and reveals a goat. (Note: the host will always open another door, and the door will always reveal a                                                                                                                                                                                                                                                                                                           goat. The probability of the host opening another door that reveals the car equals zero. They’re not going to give the car away that easily!) Now, you have the option of either sticking with the
#door you originally selected, or switching to the only other door that is still closed. What should you do, and why? What are your probabilities of winning the car if you stay versus if you switch?
#Write a function to simulate this game under the two conditions (stay or switch), and play the game at least 1000 times under each condition. Use your results to answer the questions above.






