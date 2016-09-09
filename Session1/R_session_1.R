#########################################################
### Fall 2016 R Training Session, 1st meeting         ###
### Instructor: David Carlson                         ###
### Washington University in St. Louis                ###
#########################################################


# 1. Basics

# What are these four screens? 
# Editor - Where you do most of your work
# Console - Shows the code you have run and anything that gets printed
# Environment/History - Shows objects that you have created and a log of code you've run
# Plot/Help/Packages - A variety of windows that help in programming.  Describe each in detail

# Where can you write code? 
# Here (in a script) or in the Console (next to ">")

# How can I run code? 
# 1. Press command + enter on a line in your script. 
# 2. Highlight several lines from your script, press command + enter.
# 3. Press enter when working in the console. 
# 4. Use the buttons in the upper-right of the editor. 
# 5. From command line (various options - use google - I tend to use R CMD BATCH in a tmux session)

# What happens when I write code?  
# 1. The computer executes the code.  
# 2. The function will return some object.  This can be assigned to a new variable through <- 
# 3. In some cases, the function will print information to the console.  If you do not assign the output to a new variable, the output is printed to the console. 

# Use "#" to make comments on your code.  Comments are vital! These are reminders to your future self that say "what was I doing here?".  They are for others who may read your code someday (coauthors, professors, TAs, people replicating your paper, etc).  Use comments often.  They are your friend! 


# 1. Basics

"hello world!"

# 2. Simple operations

7 + 3

8 * 5

4 - 1

1 / 5

13 * 2 - 1

13 * (2 - 1)

x <- 7

x
ls()
x <- 4

x

y <- 2

x <- x + y

class(7)
class("Hello World!")
class(TRUE)
class(NA)
class(NaN)

x + NA
x + NaN

is.numeric(7)
is.character("Hello World!")
is.numeric("Hellow World!")
is.na(x)

?class
??class

class( x = 7 )

rnorm( 10 ,1,0)
rnorm( 10, mean = 0, sd = 1)
rnorm( n = 10, mean = 0, sd = 1)

#Activity 2.1:
#Hint: Use ?'%%' ?'%/%' when doing searches with ?

#Activity 2.2:
?rep
#3. Adding Complexity

c(1,1,2,3,5,8)
5:10
seq(5,10)
seq(5,10,by=2)

c("Statistical", "Programming", "is", "alRight!")

c(FALSE, 1, 5, "Words") # What happened here? 

fib <- c(1,1,2,3,5,8)

primes <- c(1,2,3,5,7,11)

fib <- c(fib, 13)

#Activity 3.1:

fib+primes

#Important Functions:
mean(fib)
sd(fib)
min(fib)
which.min(fib)
max(fib)
which.max(fib)
class()

#Functions for activity 3.2:
x<-rnorm(10)
sort(x)
order(x)
length(x)
summary(x)
unique(fib)
paste('hello','world')
paste0('hello','world')
paste('hello','world',sep='/')

table(primes)

#4. Making Comparisons

4 > 5

17 < 3

4 > "Hello"

"Hello" > 4 #What has happened here? 
'a'<'b'
5 >= -3

8 <= 8

"Politics" == "Politics"

"Political" != "Science"

"American" %in% c("American", "Comparative", "IR", "Theory", "Methods")

# Activity 4.1: What happens in these comparisons?
fib >= primes 

c(1,5,0,1) >= c(TRUE, FALSE)

fib >= 5

primes == c(1,2,3,4)

x <- rnorm(100)
y <- rnorm(100, 1, 0)

ifelse( x > y, x, NA)

# 5. Subsetting your vectors:

fib[4]

i <- 4
fib[i]

fib[-4]

primes[c(1,5)]
primes[-c(1,5)]


logicals <- c(F, T, F, F, T, T)


fib[logicals]
fib[ fib > 4]

subset(fib, fib == 1)
fib[fib==1]

# Activity 5.1:

#What's happening here?
vect <- c(1,1,2,3,3,4,9,5,6,6,7,8)

get_these <- unique(vect)
vect[get_these]

vect[unique(vect)]

( X <- matrix(c(1,2,3,4,5,6,7,8,9),ncol=3) )
( Z <- as.matrix(cbind(rep(1,length=5),rnorm(5))) )
rbind(rep(1,5),rnorm(5))
t(Z)%*%Z

expand.grid(c(1,2),c(1,2),c(1,2))


( ZZ <- t(Z) %*% Z )

#you don't have to know what all these are doing just yet...

solve(ZZ)

chol(ZZ)

diag(ZZ)

det(ZZ)

eigen(ZZ)$values

#arrays
m <- 5
Z.array <- array(NA,c(dim(ZZ),m))
Z.array[,,3]
Z.array[,,1] <- matrix(rnorm(4),ncol=2)
Z.array[,,1]

#data frames

freq <- c(9, 32, 4, 1, 8, 4, 3, 1, 40, 6, 2, 0, 1, 0, 8, 1, 9, 14,
          9, 6, 9, 41, 2, 5, 5, 7, 23, 3, 1, 7, 31, 24, 99, 2, 6, 33)
( psych.df <- data.frame(freq,expand.grid(anxiety=1:3,behavioral=1:2,
                                          depression=1:3,sex=1:2)) )
psych.df$anxiety <- factor(psych.df$anxiety, labels=c("Low","Medium","High"), 
                           ordered=TRUE)
psych.df$behavioral <- factor(psych.df$behavioral, labels=c("Present","Absent"))
psych.df$sex <- factor(psych.df$sex, labels=c("Male","Female"))
psych.df$depression <- factor(psych.df$depression, 
                              labels=c("Absent","Mild","Severe"), ordered=TRUE)
psych.df

# 6. Navigating your workspace and downloading data

getwd()

setwd("/home/david/Dropbox/RSessions/Session1/Data")
setwd('~/Dropbox/RSessions/Session1')
getwd()
setwd('Data')
list.files()
data <- read.csv("PBC_pres_returns.csv")
head(data)
data$state
?apply
#find means of columns
class(data$dem08)
apply(data, 2, mean)

install.packages('foreign')
library(foreign)
data <- read.dta('GerberGreenLarimer_APSR_2008_social_pressure.dta')
head(data)
#are males or females more likely to vote?
mean(data[data$sex=='male','voted']=='Yes')
mean(data[data$sex=='female','voted']=='Yes')

ls()

rm(fib)

rm(list = ls())

