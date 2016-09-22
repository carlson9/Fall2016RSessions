######################################################
####  R Training - Session 3 - 23 September 2016  ####
####  Instructor: David Carlson                   ####
####  Topic: Complex Data Structures & Work Flow  ####
######################################################

rm(list=ls())

# Matricies in R are like vectors, but with an extra dimension

#3 ways to create matrices:
rbind(1:10, 2:11)
cbind(1:10,2:11)

matrix(c(1:10,2:11), ncol = 2)
matrix(c(1:10,2:11), nrow = 10)
matrix(c(1:10,2:11), ncol = 2, nrow = 10)
matrix(c(1:10,2:11), ncol = 2, nrow = 10, byrow = TRUE) #not the same

#subsetting matrices is easy using square brackets
# like so: matrix[row, column]

vap<-voting.age.population<-c(3481823, 496387, 4582842, 2120139,26955438,3617942,2673154,472143,14085749,6915512,995937,1073799,9600372,4732010,2265860,2068253,3213141,3188765,1033632,4242214,4997677,7620982,3908159,2139918,4426278,731365,1321923,1870315,1012033,6598368,1452962,14838076,6752018,494923,8697456,2697855,2850525,9612380,824854,3303593,594599,4636679,17038979,1797941,487900,5841335,4876661,1421717,4257230,392344)

total.votes<-tv<-c(NA, 238307, 1553032, 780409,8899059,1586105, 1162391, 122356,4884544, 2143845,348988, 458927,3586292, 1719351,1071509, 864083,1370062, 954896,NA, 1809237, 2243835,3852008, 2217552,NA, 2178278, 411061,610499, 586274,418550, 2315643,568597, 4703830,2036451, 220479,4184072, NA,1399650, NA,392882, 1117311,341105, 1868363,NA, 582561, 263025,2398589, 2085074,473014, 2183155, 196217)

mat <- cbind(vap,tv)

mat[1, 1] # first row, first colum
mat[1:5, ] # blank means everything. 

head(mat) #just the first six rows

# matrices are a subset of a more generic thing, called an array. 
# Arrays have an unlimited number of dimensions
# the easist way to visualize an array is as a "loaf of bread".  A matrix is a slice of the load

my_array <- array(1:12, dim = c(3,2,2))
my_array[1 , , ] #only the first row.  Weird stuff happens here.
my_array[ , 1, ] #only the first column.  More weird stuff.
my_array[ , , 1] #only the first table.  This makes sense.


# matrices have some attributes. Attributes are some piece of data associated with the structure that isn't the data itself
attributes(mat)
str(mat) #gives you all of this information

dim(mat) #first row, then column. 
dimnames(mat)
dimnames(mat)[[1]]
dimnames(mat)[[2]]
dimnames(mat)[[2]][1] 
dimnames(mat)[[2]][1] <- "VotingAgePop" 
#whats with the double brackets?  It's because this is a list!  More below.  

#easier than dimnames
rownames(mat) #this is null, because there are no names
colnames(mat) # VotingAgePop, tv

# a more general type of data structure is a list.  Lists are just a bunch of stuff, clumped together. 

my_list <- list("Dave", pi, my_array, TRUE, getwd())
my_list #fewer rules than for vectors.

# More options for picking out things
#you can go list element-wise
my_list[[1]]
my_list[1]

attributes(my_list) # list has attributes, but we haven't set them
length(my_list) # this reports the number of major sub-elements in the list
dim(my_list) # this won't work for complicated lists
names(my_list)<-c("one", "two", "three", "four", "five")
str(my_list) # now each part of the list has a name attribute
my_list

#lists can also be named.
my_other_list <- list(person = "Dalston", months = month.name, stuff = my_list, voting = mat)
str(my_other_list) #lets talk about what's going on here. 
my_other_list$months[1]
my_other_list$stuff[[1]]
my_other_list$voting
# $ is used to select named elements in lists.  It can be repeated
my_other_list$stuff$one

# $ is the easiest way to extend a list.
my_other_list$advisor <- "Jeff"
my_other_list

# a special (and extremely useful) kind of list is a data frame.  These are like a hybrid of matrices and lists. 
data.frame(vap, tv)
turnout<-tv/vap
my_df <- data.frame(vap, tv, turnout, state.abb, stringsAsFactors = FALSE) #can include character, numeric, and logical. 

my_df$state.abb #you can use dollar signs. 
my_df[[4]] #Or double brackets.
my_df[4] # or single brackets without commas (to choose columns)
my_df[,4] # or single brackets with comma, like a matrix
length(my_df) #this is ncol
dim(my_df)
names(my_df)
str(my_df)

#sometimes all of the $ is a hassle.  
mean(my_df$turnout)
mean(my_df$turnout, na.rm = TRUE)

#avoid it using "with"
with(my_df, mean(turnout, na.rm = TRUE))
?with

with(my_df, mean(tv/vap, na.rm = TRUE))


#################################

#loading in data

getwd() # where are we?
setwd("~/Fall2016RSessions/")

list.files() # list files
list.dirs() # list folders
dir.create("New Folder") #make a new folder
dir.exists("New Folder") #see if a folder exists
file.exists("anes codebook.pdf") #see if a file exists
file.exists("Session3/anes codebook.pdf")
file.path("Users", "clockbob1", "Dropbox", "R training", "Session 3", "New Folder", "dataStuff.csv") # easy way to construct a file path. 

#### helpful function:
paste()
paste("text 1", "text 2", sep = " * ")

# Today we will work with data from the 2008 ANES
anes <- read.csv("Session3/anes2008.csv", stringsAsFactors = FALSE)
setwd('Session3')
anes <- read.csv(list.files()[1], stringsAsFactors = FALSE) #can all use subsetting, becuase everything in R is an object 

#it also works the other way, we can write datasets.
write.csv(my_df, "Turnout.csv")
library(foreign)
write.dta(my_df, "Turnout.dta")

############### Working efficiently

# if statements 

if(TRUE){
  print("Great")
}

if(FALSE){
  print("Not so great")
}

if(1) "Numbers work too"
if(0) "Not this one though"
#note the brackets are optional if its all one one line

#this can be combined with an else
x <- 4
if( x < 3){
  print("x is less than 3")
} else {
  print("x is not less than 3")
}

#or multiple if's
if(x > 4){
  print("bigger than four")
} else if( x < 4 ){
  print("x smaller than four")
} else {
  print("x is four")
}

#this doesnt handle vectors well
if( turnout > .5 ){
  print("lots of people vote")
}

#for this, there is ifelse(condition, if-true, if-false)
ifelse(turnout > .5, "lots of voters", "few voters")

#this also works with vectors very nicely
ifelse(turnout > .5, my_df$state.abb, "few voters")

####### Loops!

#repeat: you need to include break, or else you will be stuck.
plot(NULL, xlim=c(0, 100), ylim=c(0, 1)) # make a blank plot with the limits set by those vectors
x = 1
repeat {
  y = 1 / x
  x = x + 1
  points(x, y)
  if (x == 100) { 
    break 
  }
}

# while()
# A while loop is just a repeat, where the if(condition){break} is specified at the top


# Re-doing the above example
plot(NULL, xlim=c(0, 100), ylim=c(0, 1))
x = 0
while(x < 100) {
  y = 1 / x
  x = x + 1
  points(x, y)
}

Fib1 = 1
Fib2 = 1
Fibonacci = c(0, Fib2)
while(Fib2 <= 300) {
  Fibonacci = c(Fibonacci, Fib2)
  oldFib2 = Fib2
  Fib2 = Fib1 + Fib2
  Fib1 = oldFib2
}
Fibonacci

###### By far the most useful kind of loop: for loops

for (monkey in c("Spider", "Howler", "Jacob")) {
  # Each loop does the equivalent of: monkey = "Spider" or monkey = "Howler"
  print(paste(monkey,'monkey'))
}

# or more commonly
for (i in 1:20){
  print(i)
}

# for loops are very useful in many situations
plot(NULL, xlim=c(0, 100), ylim=c(0, 1))
for (i in 0:100) {
  points(i, 1 / i)
}

# Sometimes you might not want to execute the commands for every element in the vector
# use the next command to skip (you can also use the break)
some.odds = NULL
for (i in 1:200) {
  if (i %% 2 == 0) {
    next
  }
  some.odds = c(some.odds, i)
}
some.odds

###
#
# In class exercise!
#
#  1) Write code that will print every third number in [1, 100]
#
#  2) Flip a coin (hint: sample(c("H","T"), 1) and print what you get 
#     until you get the same thing three times in a row
#
###

# So lets go back and talk about functions again
# We have been using functions this whole time, but we can also make our own.
# This both helps you keep your code organized, and helps you better understand other people's functions

# Example:
# Three ways to write the same function
my.function <- function(x) { # take in a value of x
  y <- x^2 + 3*x - 2 # conduct some set of operations using the input values
  return(y) # return some value. In this case we are returning a simple numeric value
}

my.function2 <- function(x) {
  x^2 + 3*x - 2 # we don't have to specify a return
}

my.function3 <- function(x) x^2 + 3*x - 2 # for simple functions, we don't even need brackets

my.function(c(1:20))
my.function2(c(1:20))
my.function3(c(1:20))


# As we noted -- local variables are not written into the global environment.
# What happens in the function, stays in the function

f  <- function() {
  x <- 1 #local x
  g()
  return(x)
}

g <- function() {
  x <- 2 # local x
  return(x)
}
f()

x = 3 # global x
f()
g()
x

# HOWEVER: you can pass values downwards in a function chain
f <- function() {
  x <- 1
  y <- g(x)
  return(c(x, y))
}
g <- function(x) {
  return(x + 2)
}
a <- f()
a

######## Exercises:

# 1. Using the ANES data, write a for loop that creates a data frame for each race and then saves a .csv file.
# hint: unique()
# hint: paste()

# 2. Create a function that determines whether the turnout in a given state is higher than average, and also tells you how much higher or lower than average it is.

# 3. For each value of party id in the Anes data, plot age against obama approval.  Save this plot as a pdf.

#hint: pdf() PLOTTING CODE dev.off()

