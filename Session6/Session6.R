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

summary(lm(y~x)) #still pretty good for beta, but notice intercept
plot(seq(-4,4,by=.01),dt(seq(-4,4,by=.01),1),type='l', ylim=c(0,.45))
lines(seq(-4,4,by=.01),dnorm(seq(-4,4,by=.01)),lty=2)




##sample

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


