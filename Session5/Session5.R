## Vectors, matrices, solving equations, and plotting regression results

# vector manipulation

vec1 <- c(4,5,6)
vec2 <- c(3,-1,2)
vec1
vec2
vec1+vec2

#be careful! if length of vector is multiple of another vector, will add without warning
#this just loops through the shorter vector until done
vec3 <- c(1,2,3,4,5,6)
vec1+vec3
vec3a <- c(vec3,8,7,6)
vec3a
vec1+vec3a

#if not a multiple, will still add but with a warning
vec4 <- c(3,4,5,6)
vec1+vec4

#we can multiply...
vec1*5
vec1*4+vec2*5
vec1*4-vec2*5

# matrices
?matrix
mat1 <- matrix(c(vec1,vec2), ncol=2, byrow=FALSE)
mat1
3*mat1

mat2 <- matrix(c(1,7,6,5,8,6), ncol=2, byrow=FALSE)
mat2
mat1+mat2
mat1-mat2
3*mat1-4*mat2

#matrix multiplication
mat1%*%mat2
#why didn't this work?
#we need the transpose
t(mat1)
t(mat1)%*%mat2
#why is this 2x2?

#can multiply by vectors - the matrix needs correct dims, but the vector will take whatever shape needed
mat1%*%vec1
t(mat1)%*%vec1
vec1%*%mat1

#inverse...
solve(mat1)
#an inverse is the matrix such that multiplying a matrix by it results in identity

mat_square <- matrix(c(1,4,6,5),ncol=2)
mat_square
solve(mat_square)

mat_inv <- solve(mat_square)
mat_square%*%mat_inv

#but not everything is invertible
mat_no_inv <- matrix(rep(1,4),ncol=2)
mat_no_inv
solve(mat_no_inv)
#what does this mean?

#so, for homework, when asked if vectors are independent...
#11.1.4, b
a <- c(0,1,1)
b<-c(1,0,1)
c<-c(1,1,0)
cbind(a,b,c)
#also look at rbind()
rbind(a,b,c)
abc <- cbind(a,b,c)
solve(abc)
#independent (still show work)
#Example 3
a <- c(2,1,2)
b <- c(4,1,3)
c <- c(2,2,3)
solve(cbind(a,b,c))
#Whereas example 2...
c <- c(1,1,2)
solve(cbind(a,b,c))
#independent

#what if not square?
a <- c(1,1,1)
b<-c(2,2,2)
solve(cbind(a,b))
solve(t(cbind(a,b))%*%cbind(a,b))

b<- c(1,2,3)
solve(t(cbind(a,b))%*%cbind(a,b))
#notions as to why this works?

#or use determinants (don't have to know what this is just yet)
det(cbind(a,b,c))
b<-c(2,2,2)
det(cbind(a,b,c))
#some intuition
#define a 2x2 matrix as
# a  b
# c  d
#the determinant is ad-bc
#if this is zero, obviously they are not independent
#other formulas for large dimensions
#again, don't have to know what this means, but an eigenvalue of a matrix A is defined as the solution to
#det(A-xI)=0, so we are saying the eigenvalue is zero or non-existent
#perhaps more intuitively, the eigenvalue x multiplied by an eignenvector v,
#the relationship Av = xv, but there is no solution to the system of equations


#systems of equations

#consider example 3 in 12.2
A <- matrix(c(2,2,4,4,1,1,8,3,4,1,7,9),ncol=3,byrow=FALSE)
b <- c(5,8,5,8)
solve(t(A)%*%A)%*%t(A)%*%b

#and you have your answer (proof on board)
#again, still show your work

#how does this apply to stats?
#what if n>>k?
#we want y=XB, but need to add a term to identify the problem

library(faraway)
data(teengamb)
model1 <- lm(gamble ~ .,data=teengamb)
summary(model1)

X <- cbind(1,teengamb$sex, teengamb$status,
           teengamb$income, teengamb$verbal)
y <- teengamb$gamble
solve(t(X)%*%X)%*%t(X)%*%y
coef(model1)

#plot results of a linear model

setwd('~/Fall2016RSessions/Session5')
data <- read.csv(file="MainData.csv")

dummy.matrix <- as.matrix(cbind(as.numeric(data$Year == 2006),
                                as.numeric(data$Year==2010), as.numeric(data$Year==2014)))

Main.Model <- lm(Ethnic_Vote_Share ~ log(Casualty):dummy.matrix[,1] 
                 + log(Casualty):dummy.matrix[,2] 
                 + log(Casualty):dummy.matrix[,3]
                 + HHI_SB
                 + HHI_CB
                 + HHI_SC
                 + Pop_Density
                 + Income_PC
                 + Avg_Age
                 + Avg_Age_Sqr 
                 + dummy.matrix, data)


preds <- predict(Main.Model, newdata = data.frame(
  Casualty = data$Casualty,
  HHI_SB = mean(data$HHI_SB),
  HHI_CB = mean(data$HHI_CB),
  HHI_SC = mean(data$HHI_SC),
  Pop_Density = mean(data$Pop_Density),
  Income_PC = mean(data$Income_PC),
  Avg_Age = mean(data$Avg_Age),
  Avg_Age_Sqr = mean(data$Avg_Age_Sqr)),
  interval = 'confidence')[1:321,]


preds06 <- preds[(1:321%%3==1),]
preds10 <- preds[(1:321%%3==2),]
preds14 <- preds[(1:321%%3==0),]

casualty <- data[1:321%%3==1, 'Casualty'][1:107]
casualty <- casualty[order(casualty, decreasing=FALSE)]

newx <- log(casualty)[order(log(casualty),decreasing=FALSE)]

plot(preds06[order(preds06[,1], decreasing=FALSE),1] ~ log(casualty), 
     type='n', ylab = 'Predicted Ethnic Vote Share', main='2006', ylim=c(60,100))
polygon(c(rev(newx), newx), c(rev(preds06[order(preds06[ ,3],decreasing=FALSE),
                                          3]), preds06[order(preds06[ ,2],
                                                             decreasing=FALSE),2]),
        col = 'grey80', border = NA)
lines(newx, preds06[order(preds06[ ,3],decreasing=FALSE),3],lty=2)
lines(newx, preds06[order(preds06[ ,2],decreasing=FALSE),2],lty=2)
lines(preds06[order(preds06[,1], decreasing=FALSE),1] ~ log(casualty), type='l')

plot(preds10[order(preds10[,1], decreasing=FALSE),1] ~ log(casualty), type='n', ylab = 'Predicted Ethnic Vote Share', main='2010', ylim=c(60,100))
polygon(c(rev(newx), newx), c(rev(preds10[order(preds10[ ,3],decreasing=FALSE),3]), preds10[order(preds10[ ,2],decreasing=FALSE),2]), col = 'grey80', border = NA)
lines(newx, preds10[order(preds10[ ,3],decreasing=FALSE),3],lty=2)
lines(newx, preds10[order(preds10[ ,2],decreasing=FALSE),2],lty=2)
lines(preds10[order(preds10[,1], decreasing=FALSE),1] ~ log(casualty), type='l')

plot(preds14[order(preds14[,1], decreasing=FALSE),1] ~ log(casualty), type='n', ylab = 'Predicted Ethnic Vote Share', main='2014', ylim=c(60,100))
polygon(c(rev(newx), newx), c(rev(preds14[order(preds14[ ,3],decreasing=FALSE),3]), preds14[order(preds14[ ,2],decreasing=FALSE),2]), col = 'grey80', border = NA)
lines(newx, preds14[order(preds14[ ,3],decreasing=FALSE),3], lty = 2)
lines(newx, preds14[order(preds14[ ,2],decreasing=FALSE),2], lty = 2)
lines(preds14[order(preds14[,1], decreasing=FALSE),1] ~ log(casualty), type='l')

#and prediction intervals?
model.hold <- lm(lpsa ~ lweight, data = prostate)
newx <- seq(2, 7, length.out = 50)
newx <- as.data.frame(newx)
names(newx) <- "lweight"
preds <- predict(model.hold, newdata = newx, interval = "confidence")
preds2 <- predict(model.hold, newdata = newx, interval = "prediction")
newx <- unlist(newx)
plot(lpsa ~ lweight, data = prostate, type = "n", xlim = c(2, 7), ylim = c(-1,
                                                                           8))
polygon(c(rev(newx), newx), c(rev(preds[, 3]), preds[, 2]), col = "grey80",
        border = NA)
abline(model.hold)
lines(newx, preds[, 3], lty = "dashed", col = "red")
lines(newx, preds[, 2], lty = "dashed", col = "red")
lines(newx, preds2[, 3], col = "red")
lines(newx, preds2[, 2], col = "red")
points(prostate$lweight, prostate$lpsa, type = "p", pch = 19)




#marginal effects plots (only if you need them now)
interaction_plot_continuous <- function(model, effect, 
                                        moderator, interaction, 
                                        varcov="default", minimum="min", 
                                        maximum="max", incr="default", 
                                        num_points = 50, conf=.95, mean=FALSE, 
                                        median=FALSE, alph=80, rugplot=T, 
                                        histogram=T, 
                                        title="Marginal effects plot", 
                                        xlabel="Value of moderator", ylabel="Estimated marginal coefficient"){
  
  # Define a function to make colors transparent
  makeTransparent<-function(someColor, alpha=alph){
    newColor<-col2rgb(someColor)
    apply(newColor, 2, function(curcoldata){rgb(red=curcoldata[1], green=curcoldata[2],
                                                blue=curcoldata[3],alpha=alpha, maxColorValue=255)})
  }
  
  # Extract Variance Covariance matrix
  if (varcov == "default"){
    covMat = vcov(model)
  }else{
    covMat = varcov
  }
  
  # Extract the data frame of the model
  mod_frame = model.frame(model)
  
  # Get coefficients of variables
  beta_1 = model$coefficients[[effect]]
  beta_3 = model$coefficients[[interaction]]
  
  # Set range of the moderator variable
  # Minimum
  if (minimum == "min"){
    min_val = min(mod_frame[[moderator]])
  }else{
    min_val = minimum
  }
  # Maximum
  if (maximum == "max"){
    max_val = max(mod_frame[[moderator]])
  }else{
    max_val = maximum
  }
  
  # Check if minimum smaller than maximum
  if (min_val > max_val){
    stop("Error: Minimum moderator value greater than maximum value.")
  }
  
  # Determine intervals between values of the moderator
  if (incr == "default"){
    increment = (max_val - min_val)/(num_points - 1)
  }else{
    increment = incr
  }
  
  # Create list of moderator values at which marginal effect is evaluated
  x_2 <- seq(from=min_val, to=max_val, by=increment)
  
  # Compute marginal effects
  delta_1 = beta_1 + beta_3*x_2
  
  # Compute variances
  var_1 = covMat[effect,effect] + (x_2^2)*covMat[interaction, interaction] + 2*x_2*covMat[effect, interaction]
  
  # Standard errors
  se_1 = sqrt(var_1)
  
  # Upper and lower confidence bounds
  z_score = qnorm(1 - ((1 - conf)/2))
  upper_bound = delta_1 + z_score*se_1
  lower_bound = delta_1 - z_score*se_1
  
  # Determine the bounds of the graphing area
  max_y = max(upper_bound)
  min_y = min(lower_bound)
  
  # Make the histogram color
  hist_col = makeTransparent("grey")
  
  # Initialize plotting window
  plot(x=c(), y=c(), ylim=c(min_y, max_y), xlim=c(min_val, max_val), xlab=xlabel, ylab=ylabel, main=title)
  
  # Plot estimated effects
  lines(y=delta_1, x=x_2)
  lines(y=upper_bound, x=x_2, lty=2)
  lines(y=lower_bound, x=x_2, lty=2)
  
  # Add a dashed horizontal line for zero
  abline(h=0, lty=3)
  
  # Add a vertical line at the mean
  if (mean){
    abline(v = mean(mod_frame[[moderator]]), lty=2, col="red")
  }
  
  # Add a vertical line at the median
  if (median){
    abline(v = median(mod_frame[[moderator]]), lty=3, col="blue")
  }
  
  # Add Rug plot
  if (rugplot){
    rug(mod_frame[[moderator]])
  }
  # Add Histogram (Histogram only plots when minimum and maximum are the min/max of the moderator)
  if (histogram & minimum=="min" & maximum=="max"){
    par(new=T)
    hist(mod_frame[[moderator]], axes=F, xlab="", ylab="",main="", border=hist_col, col=hist_col)
  }
}


# Load air quality Data
data(airquality)
# Linear model - Max Temperature (F) = Ozone Level (ppb) + Avg Wind Speed (mph) + Ozone*WindSpeed
test_model <- lm(Temp ~ Ozone + Wind + Wind*Ozone, data=airquality)
summary(test_model)

# Create an interaction plot
interaction_plot_continuous(test_model, effect="Wind", moderator="Ozone", interaction="Ozone:Wind", mean=T, title="Relationship between Wind Speed and Maximum Temperature\nfor different levels of Ozone (ppb)",xlabel="Mean Ozone (ppb)", ylabel="Marginal effect of wind speed (mph) on temperature (F)")


#plot confidence interval thingy

##function CI_plot plots confidence intervals of linear model estimates
#param mod : a linear model object
#param horizontal : if TRUE, estimates are arranged horizontally, vertically otherwise - default is TRUE
#param alpha : the level of significance - default is .05
#param intercept : boolean whether or not to include intercept - default is TRUE
#param ... : additional arguments to pass into plot function. Can be color, pch, xlab, etc.

CI_plot <- function(mod, horizontal=TRUE, alpha=.05, intercept=TRUE, ...){
  estimates <- summary(mod)$coef[,1]
  std.errors <- summary(mod)$coef[,2]
  if(!intercept){
    estimates <- estimates[-1]
    std.errors <- std.errors[-1]
  }
  plot_max <- max(abs(c(estimates+std.errors*-1*qnorm((alpha)/2),
                        estimates+std.errors*qnorm((alpha)/2))))*1.1
  if(horizontal){
    plot(x=1:length(estimates), y=estimates, ylim=c(-plot_max, plot_max), pch=20, xaxt='n', xlab='variable names')
    for(i in 1:length(std.errors)){
      lines(x=c(i,i), y=c(estimates[i]+std.errors[i]*c(-1, 1)*qnorm((alpha)/2)))
    }
    abline(h=0, lty=2)
    axis(1, at=1:length(estimates), labels=names(estimates))
  }else{
    plot(x=estimates, y=1:length(estimates), 
         xlim=c(-plot_max, plot_max), pch=20, yaxt='n', ylab='variable names', ...)
    for(i in 1:length(std.errors)){
      lines(x=c(estimates[i]+std.errors[i]*c(-1, 1)*qnorm((alpha)/2)), y=c(i, i))
    }
    abline(v=0, lty=2)
    axis(2, at=1:length(estimates), labels=names(estimates))
  }
}

#example
library(faraway)
data(sat)
library(car)
sat.model<-lm(total~expend+salary+ratio+takers,data=sat)
CI_plot(sat.model)
CI_plot(sat.model, intercept = FALSE)
CI_plot(sat.model, horizontal = FALSE)
CI_plot(sat.model, intercept = FALSE, horizontal = FALSE)
CI_plot(sat.model, intercept=FALSE, horizontal = FALSE, xlab = 'coef estimates')
