rm(list=ls())
setwd('~/Fall2016RSessions/Session7')

##bootstrapping
#It is often used as an alternative to statistical inference
#based on the assumption of a parametric model when that
#assumption is in doubt, or where parametric inference is
#impossible or requires complicated formulas for the calculation
#of standard errors.
#####
#run and save a model
#loop over 1000 iterations
#within each iteration, randomly sample WOTH REPLACEMENT from your dataset to
#   obtain a dataset of equal dimensions to the original data
#run the same model as before, and store the estimated coefficients



#outside of the loop, you should have a vector of estimates
#find the mean of this vector
#use this vector to obtain 95% credible intervals of your data (hint: quantile())
#find a p-value using the distribution of this vector
#compare your results to those obtained before the loop



##Markov Chain - simulating correlated data
#draw an x0 from a standard normal
#draw another x, x1, centered at the previous x0
#draw an x2 centered at x1
#repeat until you have fifty draws
#do this cleverly (e.g., use a loop - don't literally write 50 draws)
#plot the x's as a function of time (1:50)
#connect them with a smoothed line (hint: loess())

#repeat the above for ten different variables,
#     changing the colors of lines and points for each variable
#use an intelligent algorithm and data structure



##Metropolis-Hastings walk
#draw a g0 from Unif(0,10)
#draw the next g1 from Unif(3/4*g0, 4/3*g0)
#continue for fifty iterations, and ten variables
#plot results as above


##Conditional distribution - multivariate normal
#Gibbs sampler
gibbs<-function (n, rho) 
{
  mat <- matrix(ncol = 2, nrow = n)
  x <- 0
  y <- 0
  mat[1, ] <- c(x, y)
  for (i in 2:n) {
    x <- rnorm(1, rho * y, sqrt(1 - rho^2))
    y <- rnorm(1, rho * x, sqrt(1 - rho^2))
    mat[i, ] <- c(x, y)
  }
  mat
}

mat <- gibbs(1000,.5)
#covariance
cov(mat[,1],mat[,2])
#variance
var(mat[,1])
var(mat[,2])

plot(1:1000,mat[,1])
plot(1:1000,mat[,2])
plot(density(mat[,1]))
plot(density(mat[,2]))

##integrating distributions with Monte Carlo
#find the area of a circle to estimate pi
#first, plot a quarter of a circle in x in 0:1 and y in 0:1
#   Use a function to find the y points at an x point
#randomly draw an x from Unif(0,1)
#randomly draw y from Unif(0,1)
#if your function at x is greater than or equal to y, plot x,y and store results
#calculate the area by calculating acceptance ratio
#what is your estimate?

circle <- function(x) sqrt(1-x^2)
r <- seq(0,1,.01)
plot(r,circle(r),type='l')
plot(circle,r,type='l')

x <- runif(10000,0,1)
y <- runif(10000,0,1)

ys <- circle(x)
mean(ys > y)*4
