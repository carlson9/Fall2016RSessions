rm(list=ls())
setwd("~")
library(foreign); library(raster)

nov04 <- read.dta('2004_november.dta', convert.factors=FALSE) #read in a dta
nov04b <- read.dta('2004_november.dta') #preserve coding

setwd("~/Fall2016RSessions/Session4") #change wd
save(nov04, nov04b, file='novDatta.Rdata') #save as compressed R data

#start from here...
rm(list=ls())
setwd("~/Fall2016RSessions/Session4") #change wd
load('novDatta.Rdata') # Loading separate datasets


head(nov04)
colnames(nov04)
summary(nov04)

# Setting all -1s as NAs
nov04[nov04 == -1] <- NA

# Setting all less than zero for these vars to missing 
nov04$PEHSPNON <- ifelse(nov04$PEHSPNON %in% c(-2,-3,-9), NA, nov04$PEHSPNON)
nov04$PEMARITL <- ifelse(nov04$PEMARITL %in% c(-2,-3,-9), NA, nov04$PEMARITL)
nov04$PES2 <- ifelse(nov04$PES2 %in% c(-2,-3,-9), NA, nov04$PES2)
nov04$PES3 <- ifelse(nov04$PES3 %in% c(-2,-3,-9), NA, nov04$PES3)
nov04$PES4 <- ifelse(nov04$PES4 %in% c(-2,-3,-9), NA, nov04$PES4)
nov04$PES5 <- ifelse(nov04$PES5 %in% c(-2,-3,-9), NA, nov04$PES5)
nov04$PES6 <- ifelse(nov04$PES6 %in% c(-2,-3,-9), NA, nov04$PES6)
nov04$PES7 <- ifelse(nov04$PES7 %in% c(-2,-3,-9), NA, nov04$PES7)
nov04$PES8 <- ifelse(nov04$PES8 %in% c(-2,-3,-9), NA, nov04$PES8)
nov04$PESEX <- ifelse(nov04$PESEX %in% c(-2,-3,-9), NA, nov04$PESEX)
nov04$PRINUSYR <- ifelse(nov04$PRINUSYR %in% c(-2,-3,-9), NA, nov04$PRINUSYR)
nov04$PTDTRACE <- ifelse(nov04$PTDTRACE %in% c(-2,-3,-9), NA, nov04$PTDTRACE)
nov04$HUFAMINC <- ifelse(nov04$HUFAMINC %in% c(-2,-3,-9), NA, nov04$HUFAMINC)
nov04$PUSCK4 <- ifelse(nov04$PUSCK4 %in% c(-2,-3,-9), NA, nov04$PUSCK4)

#or...
nov04[,c('PEHSPNON', 'PEMARITL', 'PES2', 'PES3', 'PES4',
         'PES5', 'PES6', 'PES7', 'PES8',
         'PESEX', 'PRINUSYR', 'PTDTRACE', 'HUFAMINC',
         'PUSCK4')] <-
  apply(nov04[,c('PEHSPNON', 'PEMARITL', 'PES2', 'PES3', 'PES4',
                'PES5', 'PES6', 'PES7', 'PES8',
                'PESEX', 'PRINUSYR', 'PTDTRACE', 'HUFAMINC',
                'PUSCK4')], 2, function(x) ifelse(x%in%c(-2,-3,-9), NA, x))

summary(nov04)



# Renaming variables


colnames(nov04)[colnames(nov04) %in% c("PES1","PES2","PES3","PES4","PES5","PES6","PES7","PES8",
                                       "PESEX","PRTAGE","HUFAMINC","PREDUCA4","PTDTRACE")] <- 
  c("income","age","sex","race","vote2004","registered",
      "whynotreg","whynotvote","mailvote04","voteday","howreg","timeatadd")
# Recoding vote variable
nov04$vote2004  <- ifelse(nov04$vote2004 %in% c(-2,-3,-9, 2), 0, nov04$vote2004)

# Self reported vote
nov04$voteself04 <- ifelse(nov04$PUSCK4 == 1, 1, 0)

# Early vote and in person vote
nov04$earlyvote <- ifelse(nov04$voteday == 2, 1, 0)
nov04$inperson <- ifelse(nov04$mailvote == 1, 1, 0)

# Recoding age variables
nov04$age18to24 <- ifelse(nov04$age>=18 & nov04$age <25, 1, 0)
nov04$age75plus <- ifelse(nov04$age>74, 1, 0)
    
# State dummies - want factors!
nov04$state <- nov04b$GESTCEN
class(nov04$state)
head(nov04$state)

# Black dummy
nov04$black2 <- ifelse(nov04$race %in% c(2,6,10,11,12,15,16,19), 1, 0)

# Hispanic dummy
nov04$hispanic <- ifelse(nov04$PEHSPNON == 1, 1, 0)

# Citizenship variables
nov04$naturalized <- ifelse(nov04$PRCITSHP == 4, 1, 0)
nov04$nat_tenplus <- ifelse(nov04$naturalized == 1 & nov04$PRINUSYR <=14, 1, 0) # Replaced with PRINUSYR

# Southern dummy
nov04$south <- ifelse(nov04$state %in% c("AR","LA","MS","AL","GA","NC","SC","TN","VA","FL","TX"), 1, 0)

# Election law classifications
nov04$edr04 <- ifelse(nov04$state %in% c("CT", "MN", "NH", "RI"), 1, 0)
nov04$early04 <- ifelse(nov04$state %in% c("AZ","CO","FL","GA","HI","IN","KS","LA","MD","NE","NV","NJ","OK","SD","TN","TX","UT","WV"), 1, 0)
nov04$edr_early04 <- ifelse(nov04$state %in% c("AK","ID"), 1, 0)
nov04$sdr_early04 <- ifelse(nov04$state %in% c("CA","IL","NM","NC","OH","VT"), 1, 0)
nov04$edr_early_sdr04 <- ifelse(nov04$state %in% c("IA","ME","MT","ND","WI","WY"), 1, 0)

# Voter ID laws
nov04$voterid04 <- ifelse(nov04$state %in% c("AL","CT","MI","MO","ND","SD","DE","VA","SC","GA","FL","KY","TN","AR","LA","TX","MT","CO","AZ","HI"), 1, 0)

# Close
nov04$close30_04 <- ifelse(nov04$state %in% c("AK","AR","DC","GA","HI","LA","MI","MS","MT","NV","OH","PA","RI","SC","TN","TX","WY"), 1, 0)
  
# Married
nov04$married <- ifelse(nov04$PEMARIT %in% c(1,2), 1, 0)

# Time at address
nov04$oneyear <- ifelse(nov04$timeatadd >=4, 1, 0) # This might not go right as the factor needs to be coerced

# Competitiveness

compet <- c(77.55662, 75, 92.15571, 94.96625, 86.92389, 97.92025, 91.08546, 92, 99.20707, 85.04378, 99.36344, 70.5, 88.88827, 80.50172, 98.69521, 75.90806, 80.23806, 
  86.48149, 93.67503, 85.19057, 84.06894, 98.89129, 97.74577, 80, 95.30721, 78.14225, 70.33333, 94.82961, 98.45051, 97.71729, 95.29222, 83.07148, 92.16432, 75.5,
  99.78515, 70.03732, 95.11276, 98.72044, 82.25779, 84.16378, 79.17751, 84.36106, 77.69822, 55.533, 87.33333, 95.77582, 93.62582, 94.08593, 98.50197, 64)

polldiff04 <- rep(NA, 156519)

for(i in 1:50){
  polldiff04[which(nov04$state == state.abb[i])] <- compet[i]
}

nov04$polldiff04 <- polldiff04

nov04$vote_mnl04 <- ifelse(nov04$vote2004 ==0, 0, NA)
nov04$vote_mnl04 <- ifelse(nov04$voteday==1, 1, nov04$vote_mnl04)
nov04$vote_mnl04 <- ifelse(nov04$voteday==2 & nov04$mailvote04==1, 2, nov04$vote_mnl04)
nov04$vote_mnl04 <- ifelse(nov04$voteday==2 & nov04$mailvote04==2, 3, nov04$vote_mnl04)

# Logit
model.1 <- glm(vote2004 ~ early04 + sdr_early04 + edr_early04 + edr_early_sdr04 + edr04 + close30_04 + 
                 voterid04 + black2 + hispanic + voteself04 + naturalized + nat_tenplus + married + 
                 oneyear + income + sex + age + age18to24 + age75plus + polldiff04 + south, 
                 family=binomial(link="logit"), data=nov04)
summary(model.1)

nov04$vote2004

library(stargazer) #for pretty tables in latex
stargazer(model.1)

#Probit

model.2 <- glm(vote2004 ~ early04 + sdr_early04 + edr_early04 + edr_early_sdr04 + edr04 + close30_04 + 
                 voterid04 + black2 + hispanic + voteself04 + naturalized + nat_tenplus + married + 
                 oneyear + income + sex + age + age18to24 + age75plus + polldiff04 + south, 
               family=binomial(link="probit"), data=nov04)
summary(model.2)

stargazer(model.1, model.2) #side by side

#fixed effects

model.3 <- glm(vote2004 ~ state + early04 + sdr_early04 + edr_early04 + edr_early_sdr04 + edr04 + close30_04 + 
                 voterid04 + black2 + hispanic + voteself04 + naturalized + nat_tenplus + married + 
                 oneyear + income + sex + age + age18to24 + age75plus + polldiff04 + south, 
               family=binomial(link="logit"), data=nov04)
summary(model.3)
#can you guess what's going on?

#linear models are the same set-up, but use lm (although could actually still use glm)
plot(density(na.omit(nov04$polldiff04)))
#can we make this linear?
plot(density(na.omit(1/nov04$polldiff04)))
plot(density(na.omit(1/nov04$polldiff04^(.5))))
plot(density(na.omit(1/nov04$polldiff04^(.25))))
plot(density(na.omit(log(nov04$polldiff04))))
plot(density(na.omit(nov04$polldiff04^2)))
plot(density(na.omit(nov04$polldiff04^3)))
plot(density(na.omit(nov04$polldiff04^.5)))
##not really, but doesn't matter

#let's do something very simple - does age affect income?
model.4 <- lm(income ~ age, nov04)
summary(model.4)
plot(nov04$income ~ nov04$age, pch=18)
abline(model.4)

#not very interesting...

library(faraway)
data(divusa)
summary(divusa)


## Note these are NOT proper time series...

#is divorce increasing over time?
model.div <- lm(divorce ~ year, divusa)
plot(divusa$divorce ~ divusa$year)
abline(model.div)

#is female labor increasing in the US?
plot(divusa$femlab ~ divusa$year)
abline(lm(femlab ~ year, divusa)) #can actually put the lm in the abline
