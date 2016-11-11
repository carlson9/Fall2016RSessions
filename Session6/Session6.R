### random numbers and sampling

set.seed(45) #this sets the seed, making your code reproducible

?runif
?rnorm
?rexp
?rbinom
?rbeta
#the list goes on...

rnorm(10)
rnorm(1000)
rnorm(1000, mean=5, sd=10)

set.seed(99)
my_sample <- rnorm(10000)
hist(my_sample)

plot(density(my_sample))
lines(seq(-4,4,by=.01),
      dnorm(seq(-4,4,by=.01)),
      lty=2)
legend('topright',lty=c(1,2),
       legend=c('sample','true'))

pnorm(4)

lines(seq(-4,4,by=.01),pnorm(seq(-4,4,by=.01)), lty=3)

plot(density(my_sample), xlim=c(-4,4),
     ylim=c(0,1))
lines(seq(-4,4,by=.01),
      dnorm(seq(-4,4,by=.01)),
      lty=2)
lines(seq(-4,4,by=.01),pnorm(seq(-4,4,by=.01)), lty=3)

#just to compare to logit...
lines(seq(-4,4,by=.01),
      1/(1+exp(-seq(-4,4,by=.01))), col='blue')

qnorm(seq(0,1,by=.01))
par(new=TRUE) #add a new plot to current window
plot(density(qnorm(runif(1000))),col='red',
     xlim=c(-4,4),ylim=c(0,1),
     main='',xlab='',ylab='',xaxt='n',yaxt='n') #inverse of normal, sampling from uniform
#don't really have to know why this works yet

## generating data

set.seed(99)
x <- rnorm(100, 5, 5)
y <- x*3+rnorm(100) #adding noise, generating y
plot(y~x, pch=18)
abline(lm(y~x), col='red')

summary(lm(y~x))
#why is the intercept so close to zero?
abline(v=0)
abline(h=0)

y <- x*3+rnorm(100,0,5) #noisier
plot(y~x, pch=18)
abline(lm(y~x), col='red')

summary(lm(y~x)) #still pretty good

set.seed(87)
y <- x*3+rt(100,1)
plot(y~x, pch=18)
abline(lm(y~x), col='red')

summary(lm(y~x)) #still pretty good for beta, but notice intercept - why problematic?
set.seed(8)
x2 <- rnorm(100)
summary(lm(y~x+x2))
#run the first simulation again, but include the x2 - will not be like this

#how do these distributions look? not much different actually
plot(seq(-4,4,by=.01),dt(seq(-4,4,by=.01),1),type='l', ylim=c(0,.45))
lines(seq(-4,4,by=.01),dnorm(seq(-4,4,by=.01)),lty=2)


#exercise
#demonstrate the central limit theorem (very important in statistics)
#draw from any distribution (even binomial) a sample of size 15 and find the mean
#repeat this many times, and plot the distribution of the means
#increase n and repeat
#plot the distribution of the means, and the distribution of sqrt(n)(mean-total.mean)/sample.sigma

?t.test
set.seed(7)
t.test(rnorm(10),rnorm(10))
t.test(rnorm(1000),rnorm(1000))
t.test(rnorm(1000),rnorm(1000,mean=1))
t.test(rnorm(10),rnorm(10,mean=.2))
t.test(rnorm(1000),rnorm(1000,mean=.2))
t.test(rt(1000,1),rt(1000,1))
t.test(rt(1000,1),rt(1000,10))
t.test(rt(1000,1),rt(1000,10,10))
plot(seq(-4,10,by=.01),dt(seq(-4,10,by=.01),1),type='l', ylim=c(0,.45),xlim=c(-4,10))
lines(seq(-4,10,by=.01),dt(seq(-4,10,by=.01),10),lty=2, ylim=c(0,.45))
lines(seq(-4,10,by=.01),dt(seq(-4,10,by=.01),10,5),lty=3, ylim=c(0,.45))
abline(v=0)
abline(v=5)

#exercise
#write a function that takes n as an argument, FUN as an argument, p as an argument, and ... as an argument
#FUN will be your distribution (e.g., rnorm)
#sample two samples of size n from the distribution and return TRUE if p-value is less than p
#the ... argument will be used for all other arguments to FUN
#give every argument a default


?dbinom
#use the above to determine the probability that you would get heads 5 times in eight coin flips
#what about 3 heads?


##sample (refresher)

my_vec <- 1:10
?sample
sample(my_vec, 2)
sample(my_vec, 12)
sample(my_vec, 12, replace=TRUE)

?expand.grid
mat <- expand.grid(my_vec,my_vec)
mat
sample(mat, 10) #doesn't work
mat[sample(1:dim(mat)[1], 10),]

rbinom(1,1,.5)
sample(0:1,1)
rbinom(1,1,.3)
sample(0:1,1,prob=c(.3,.7)) #run this with a much larger n and take the mean (in one line of code)
  # repeat with rbinom

#exercise
#write a function that simulates the monty hall problem
#from wikipedia:
#Suppose you're on a game show, and you're given the choice
#of three doors: Behind one door is a car; behind the others,
#goats. You pick a door, say No. 1, and the host, who knows
#what's behind the doors, opens another door, say No. 3, which
#has a goat. He then says to you, "Do you want to pick door No. 2?"
#Is it to your advantage to switch your choice?
#
#basically write a function that will take a choice, and return TRUE
#if you get the car, FALSE otherwise
#write another function that will call this function multiple times,
#and assess the probability of getting the car given a choice
#writing pseudo code is a good idea


