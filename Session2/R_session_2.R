#########################################################
### Fall 2016 R Training Session, 2nd meeting         ###
### Instructor: David Carlson                         ###
### Washington University in St. Louis                ###
#########################################################

rm(list=ls()) #remember, this is good to put at the beginning of any code
setwd('~/Fall2016RSessions/Session2') #also good to put right at the top of the code

## Functions and plotting

#functions

#the basic setup of a function is as follows (do not run):
myfuncName <- function(argument1Name, argument2Name){  #name the function and arguments 
                    #anything you want (except keywords) and there can be as many arguments as you want
  #do some stuff
  return(result) #if you do not return anything, the last line will be returned, unless it is an assignment
                    #generally always return something, even if it is NULL
}

# what does this function do?
my_sum_squares <- function( x, y ){ 
  z <- sum(x^2,y^2)
  return(z)
}

my_sum_squares(2,4)

#can we send it multiple arguments? why or why not?
my_sum_squares(1:10, 2:11)



plot_my_sum_squares <- function( x, y ){ 
  # arguments are the variables used by the function
  # they can have defaults, or no defaults. 
  # you can have a function with no arguments
  
  # variables created within the function don't exist outside it.
  
  #the code within, however, can find variables from your global environment 
        #(this is generally bad practice, with the very notable exception of functions).
  z <- my_sum_squares(x,y)
  Dave <- 'Hello'
  output <- list(z, Dave) #lists allow combining any types of elements ?list - these are very useful
  
  # you can't alter variables in the global environment within the funciton
  
  #any plot functions in a function will be executed. more on plotting below
  plot(1:10,1:10, type = "o")
  
  #return is what the function gives back. It must be ONE object.  
  return(output)
}
my_sum_squares(1:10, 2:11)
z
Dave

#if you omit return, the last line of code's output is returned, but only if you don't assign it using the arrow.
#This is why lists are so valuable: you can get LOTS of output from your function. 
my_sum_squares <- function( x, y ){ 
  sum(x^2,y^2)
}
my_sum_squares(1:10, 2:11)

# let's (group) write a function that returns the sum of of a user-defined polynomial 
    #the sum of two vectors, where each element of each vector is raised to a user-given polynomial 

# 1. What are the steps?

# 2. What is the code?


# let's (group) write a function that calculates the dot product of two vectors
    # the dot product is the sum of the the products, i.e. x[1]*y[1]+x[2]*y[2]+...

# 1. What are the steps (words, not code)?

# 2. What is the code? 


### using lapply
#consider the silly function below (notice inline definition without brackets is fine):
sqrRt <- function(x) x^(.5)

#using lapply, get the square root of the numbers 1:1000, save the output


## plotting

#you saw an example of a very basic plot above, which showed up in your plot window
?plot

plot(1:10, seq(1,20,by=2))
#change types
plot(1:10, seq(1,20,by=2),type='b')
plot(1:10, seq(1,20,by=2),type='l')
#change point styles
plot(1:10, seq(1,20,by=2),type='b',pch=18)
#add labels
plot(1:10, (1:10)^2,type='b',pch=18, main='My First Plot', xlab='x', ylab=expression(x^2))
x<-1:10
y<-x^2
plot(x, y,type='b',pch=18, main='My First Plot', xlab='x', ylab=expression(x^2))

#what happens here:
plot(x ~ y,type='b',pch=18, main='My First Plot', xlab='x', ylab=expression(x^2))

#add lines
?abline

plot(x, y,type='b',pch=18, main='My First Plot', xlab='x', ylab=expression(x^2))
abline(v=6)
abline(h=6^2)

#what is the derivative of this function at x=6?
#what is the tangent line at x=6?
abline(-36,12)

plot(x, y,type='b',pch=18, main='My First Plot', xlab='x', ylab=expression(x^2))
#draw a segment connecting the x axis to the plot at x=6
?segments
segments(6,0,6,36)
#draw a segment connecting to y axis
segments(0,36,6,36)

#if you want to save the plot, either use RStudio, or pdf():
pdf('MyFirstPlot.pdf')
plot(x, y,type='b',pch=18, main='My First Plot', xlab='x', ylab=expression(x^2))
#draw a segment connecting the x axis to the plot at x=6
segments(6,0,6,36)
#draw a segment connecting to y axis
segments(0,36,6,36)
dev.off()

#this dev.off() can also be used to wipe an old plot and restore settings (more on this later ?par)

# load in the NFL data 
library(foreign)
nfl <- read.dta("nfl_playerdata.dta")

#Make a subset of the NFL data called "nfl2" that contains only observations from the year 2000 or later.

nfl2 <- nfl[nfl$firstyear >= 2000, ]

# R plotting can be broken into three basic categories: high level, low level, and lattice/ggplot.  
#This covers high level and low level, which are two different ways of using a single basic system.
#Lattice and ggplot have numerous differences - lattice plots multiple graphs at once and ggplot allows 
#for easy layering.  

# High level plots: these are plots in R that do most of the work for you. Some plot basic data:

#Histograms: These are barplots that show the frequency of a certain value/set of values in a distribution. 
#They are very useful/commonly used.  The height of the bars in this sort of plot tells us about how frequent 
#these values are in the data. 

hist(nfl2$weight, main = "NFL Player Weight",xlab = "Weight (lbs.)")

#you can adjust the breaks
hist(nfl2$weight, main = "NFL Player Weight", xlab = "Weight (lbs.)", breaks = "SCOTT")
hist(nfl2$weight, main = "NFL Player Weight", xlab = "Weight (lbs.)", breaks = "FD")
hist(nfl2$weight, main = "NFL Player Weight", xlab = "Weight (lbs.)", breaks = 100)

#you can plot frequencies rather than counts
hist(nfl2$weight, main = "NFL Player Weight", xlab = "Weight (lbs.)", breaks = 100, probability = TRUE)

#You can add plots to each other
hist(nfl2$weight[nfl2$firstyear == 2000], 
     main = "NFL Player Weight",
     xlab = "Weight (lbs.)", col = 'red', probability = T, ylim = c(0, .014))
hist(nfl2$weight[nfl2$firstyear == 2010],
     main = "NFL Player Weight",
     xlab = "Weight (lbs.)",
     add = TRUE, col = 'blue', probability = TRUE) 
# will want to pre-set ylim in this example (more on ylim below)

# Box plots: another useful way to visualize a distribution
# these display, for a set of values: 
# 1. the median as a line
# 2. the median of the bottom half of the distribution as the side of the box
# 3. the median of the top half of the distribution as the side of the box
# 4. the whiskers represent the smallest/largest points up-to 1.5 IQR away from the box.
# 5. Any outliers as points. 

boxplot(nfl2$weight, xlab = "all players")

# if you have a grouping factor (e.g. states, years, teams), this can be used with boxplot
boxplot(nfl2$weight ~ nfl2$firstyear, 
        main = "NFL Player Weight",
        ylab = "Weight (lbs.)",
        horizontal = TRUE)

##### Okay, these are some useful built-in plotting functions.  But usually, you'll want things that are more complex

plot(nfl$weight ~ nfl$firstyear)
plot(nfl$firstyear, nfl$weight)
plot( x = nfl$firstyear, y = nfl$weight,
      xlab = "Year",
      ylab = "Weight (lbs.)",
      main = "NFL Player Weight by Year",
      ylim = c(200,300),
      xlim = c(1960,2011)
)

#use the argument type to control the plotting
year_means <- sapply(1960:2011, function(year) mean(nfl$weight[nfl$firstyear == year]))
years <- 1960:2011

plot(x = years, y = year_means)
plot(x = years, y = year_means, type = "l") #lines
plot(x = years, y = year_means, type = "b") #both
plot(x = years, y = year_means, type = "o") #both, no gaps (overplotted)
plot(x = years, y = year_means, type = "n") #Nothing
plot(x = years, y = year_means, type = "h") #Fake histogram situation
plot(x = years, y = year_means, type = "s") #stair steps

# You can now draw on top of these plots using a variety of functions
plot(x = years, y = year_means, type = "n", xlab = "Year", ylab = "Weight (lbs.)", main = "Some Weights") #Nothing
lines(x = 1960:2011, y = year_means, col = "red")

#Some notes about lines: the argument lty is very useful.
lines(x = 1960:2011, y = year_means-10, col = "red", lty = 2)
lines(x = 1960:2011, y = year_means+10, col = "red", lty = 3)
lines(x = 1960:2011, y = year_means+5, col = "red", lty = 4)
lines(x = 1960:2011, y = year_means-5, col = "red", lty = 5)

#We can do the same with points; use pch to change 
plot(x = years, y = year_means, 
     type = "n",
     xlab = "Year",
     ylab = "Weight (lbs.)",
     main = "Some Weights") #Nothing
points(x = 1960:2011, y = year_means, col = "red")
points(x = 1960:2011, y = year_means + 5, col = "red", pch = 20) #20 is my personal preference. 
points(x = 1960:2011, y = year_means - 5, col = "red", pch = "+")

#we can write on plots easily too. 
text( "Did you look here?", x = 1970, y = 235)
text( c("Did you look here?", "Maybe here?"), x = c(1970, 2000), y = c(235, 220))

#More complicated: draw line segments.  To do this, you must give starting x and y, and finishing x and y
plot(x = years, y = year_means, 
     type = "n", 
     xlab = "Year", 
     ylab = "Weight (lbs.)", 
     main = "Some Weights") #Nothing

segments( x0 = 1970, #starting x
          y0 = 220, #starting y
          x1 = 1975, #finishing x
          y1 = 225, #finishing y
          col = "red")


#segments takes vectors. 
segments( x0 = 1960:2005, #starting x
          y0 = seq(from = 220, to = 235, length = 46),  #starting y
          x1 = 1965:2010, #finishing x
          y1 = seq(from = 225, to = 240, length = 46), #finishing y
          col = "peru")

# arrows, curve, and polygon exist as well.  

# a common task you'll have to do is plot density curves.  Do this using the density function

density(nfl2$weight) #not particularly helpful
nfl_dens <- density(nfl2$weight)
str(nfl_dens) #what's going on here?

plot(nfl_dens,
     xlab = "Weight (lbs.)",
     main = "Density of player weights, 2000-2011")

#You can also use a density object with lines
lines(density(nfl$weight), col = "blue")

#Notice the plotting area is too small... use ylim to adjust. 
plot(nfl_dens,
     xlab = "Weight (lbs.)",
     main = "Density of player weights, 2000-2011",
     ylim = c(0, 0.015))
lines(density(nfl$weight), col = "blue") #rise of the 300 pound player...

#how can we differntiate these? use a legend. (use ?legend early and often.)
legend("topright",
       legend = c("2000-2011", "All Years"),
       lty = c(1,1),
       col = c("black", "blue"),
       bty = "n"
)

# You can also create a "rug plot" to easily show where your data is
rug(nfl$weight, col = "blue")
rug(nfl2$weight, col = "black")


##### finer grained control:

#1. lwd = line width
plot(x = years, y = year_means, type = "n", xlab = "Year", ylab = "Weight (lbs.)", main = "Some Weights") #Nothing
lines(x = 1960:2011, y = year_means, col = "red", lwd = 1)
lines(x = 1960:2011, y = year_means+5, col = "red", lwd = 2)
lines(x = 1960:2011, y = year_means+10, col = "red", lwd = 3)

#2. cex - point and text size.  1 is standard. 
#We can do the same with points; use pch to change 
plot(x = years, y = year_means, 
     type = "n",
     xlab = "Year",
     ylab = "Weight (lbs.)",
     main = "Some Weights") #Nothing
points(x = 1960:2011, y = year_means, col = "red")
points(x = 1960:2011, y = year_means + 5, col = "blue", cex = 1.5) 
points(x = 1960:2011, y = year_means - 5, col = "green", cex = 2)

#3. bty -> remove the box.
#We can do the same with points; use pch to change 
plot(x = years, y = year_means, 
     type = "n",
     xlab = "Year",
     ylab = "Weight (lbs.)",
     main = "Some Weights",
     bty = "n") #Nothing

#4. xaxt, yaxt = axis control
plot(x = years, y = year_means, 
     type = "n",
     xlab = "Year",
     ylab = "Weight (lbs.)",
     main = "Some Weights",
     bty = "n",
     xaxt = "n",
     yaxt = "n") #Nothing

#You can make your own axis. 
axis(side = 1 # 1 = bottom, 2 = left, 3 = top, 4 = right
)
axis(side = 2, at = c(220, 230, 240), labels = c("Two-Twenty", "Two-Thirty", "Two-Forty"))

#5. Colors! use col
colors() #try googling "colors in R"
plot(x = years, y = year_means, 
     type = "n",
     xlab = "Year",
     ylab = "Weight (lbs.)",
     main = "Some Weights",
     ylim = c(208, 251)) #Nothing
points(x = 1960:2011, y = year_means, col = sample(colors(), 1), pch = 20)
points(x = 1960:2011, y = year_means + 5, col = sample(colors(), 2), pch = 20) 
points(x = 1960:2011, y = year_means - 5, col = sample(colors(), 52), pch = 20)

b <- rgb( 0,0,1, alpha = .1)
r <- rgb( 1,0,0, alpha = .1)


#6. Change axis text direction: las = 1
plot(x = years, y = year_means, 
     type = "o",
     xlab = "Year",
     ylab = "Weight (lbs.)",
     main = "Some Weights",
     ylim = c(208, 251),
     las = 1) #Nothing

#### abline()
plot( x = nfl$firstyear, y = nfl$weight,
      xlab = "Year",
      ylab = "Weight (lbs.)",
      main = "NFL Player Weight by Year",
      pch = "."
)
abline (h = 250, col = "red")
abline (v = 1960, col = "red")
abline (a = -3000, b = 1, col = "blue")
abline (lm( nfl$weight ~ nfl$firstyear), col = "orange", lwd = 3)

#### using par()

#1. when using par, do the following:

opar <- par()
<<plotting commands here>>
  par(opar)

#this allows you to reset your plotting window. 

#2. par(mfrow = c(r, c))
opar <- par(mfrow = c(1, 2))
hist(nfl$weight)
hist(nfl2$weight)
par(opar)

#3. par(mar = c(bottom, left, top, right))
opar <- par(mar = c(0,0,0,0))
plot(x = years, y = year_means, 
     type = "n",
     xlab = "Year",
     ylab = "Weight (lbs.)",
     main = "Some Weights",
     ylim = c(208, 251)) #Nothing
points(x = 1960:2011, y = year_means, col = sample(colors(), 1), pch = 20)
par(opar)

#4. you can undo all of this using dev.off()  Be careful, this will delete all of your unsaved plots. 

# Activity: create histograms of player weight from 1930-1950 and 1990-2010 on the same plot.  Then overlay separate density curves.  Then make separate rug plots

early <- nfl$weight[nfl$firstyear %in% c(1930:1950)]
late <- nfl$weight[nfl$firstyear %in% c(1990:2010)]

r <- rgb(0,1,0, alpha = .4)
b <- rgb(1,0,1, alpha = .4)

hist(early, probability = T, col = b, xlim = c(120, 400), xlab = "Player Weight", main = "NFL Player Weight in 2 Eras", breaks = seq(from = 120, to = 410, by = 10))
hist(late, probability = T, add = T, col = r, breaks = seq(from = 120, to = 410, by = 10))

lines(density(early), col = b, lwd = 3, lty = 2)
lines(density(late), col = r, lwd = 3, lty = 4)

rug(early, col = b)
rug(late, col = r)

legend("topright", legend = c("1930-1950", "1990-2010"), col = c(b,r), bty = "n", pch = 15)
