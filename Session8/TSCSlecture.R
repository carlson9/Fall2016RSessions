#serial correlation biases SE downward

#lagged DV
#non-dynamic instantaneous or with set lags of IV
#serially correlated error models
#autoregressive distributed lag model
#error correction
#first differencing
  #slowly changing variables
    #performs poorly, and cannot analyze long-term changes
  #effect of change is same regardless of value of y

##theory based modeling
  #refugee flows cause war
  #econ crises affect approval ratings
  #party affects macroeconomic outcomes





library(plm)
?plm
library(RCurl)
dat_url <- getURL('https://raw.githubusercontent.com/carlson9/Fall2016RSessions/master/Session8/garrett1998.tab')
data <- read.table(text = dat_url, row.names=NULL, header=TRUE)
#data <- read.table('garrett1998.tab', header = TRUE)
head(data)
# #GDP growth as function of political factors and 
#   economic controls. The political variables are 
#   the proportion of cabinet posts occupied by left 
#   parties (LEFT), the degree of centralized labor 
#   bargaining as a measure of corporatism (CORP), 
#   and the product of the latter two variables 
#   (LEFT x CORP). The economic and control variables 
#   are a dummy marking the relatively prosperous 
#   period through 1973 (PER73), overall OECD GDP 
#   growth (DEMAND), trade openness (TRADE), capital 
#   mobility (CAPMOB), and a measure of oil imports (OILD).
#   All variables, following Garrett's use of country 
#   fixed effects, were mean centered by country.

#ols
mod1 <- lm(gdp ~ demand + trade +
             capmob + oild +
             corp*leftlab,data=data)

mod1.1 <- plm(gdp ~ demand + trade +
              capmob + oild +
              corp*leftlab,data=data,
            model='pooling')

#panel with country fixed effects
mod2 <- plm(gdp ~ demand + trade +
              capmob + oild +
              corp*leftlab,data=data,effect='individual',
            index = 'country',model='within')

#panel with time fixed effects
mod3 <- plm(gdp ~ demand + trade +
              capmob + oild +
              corp*leftlab,data=data,effect='time',
            index = 'year',model='within')

#panel with country and year fixed effects
mod4 <- plm(gdp ~ demand + trade +
              capmob + oild +
              corp*leftlab,data=data,effect='twoways',
            index = c('country','year'))

##correct standard errors?
#Beck and Katz PCSE (HC0), most common
coeftest(mod4)
coeftest(mod4,vcov=vcovBK)
coeftest(mod4, vcov=function(x) vcovBK(x, type="HC1", cluster='group'))
#usually cluster just on group, but choice matters
coeftest(mod4, vcov=function(x) vcovBK(x, type="HC1", cluster='time'))

#Double-clustering robust covariance (HC0)
coeftest(mod4,vcov=vcovDC)

#robust covariance
coeftest(mod4, vcov=function(x) vcovHC(x, cluster='group'))

#library(clusterSEs) for more, but software is buggy


#lagged dv
mod5 <- plm(gdp ~ demand + trade +
     capmob + oild +
     corp*leftlab + gdpl,data=data,
     effect='twoways',
     index = c('country','year'))
coeftest(mod5, vcov=function(x) vcovBK(x, type="HC1", cluster='group'))

#AR1
library(nlme)
mod6 <- gls(gdp ~ demand + trade +
              capmob + oild +
              corp*leftlab + gdpl,
            correlation=corAR1(form=~year|country),data=data)
#without lagged DV (more typical)
mod7 <- gls(gdp ~ demand + trade +
              capmob + oild +
              corp*leftlab,
            correlation=corAR1(form=~year|country),data=data)




#FE model assumption: time-invariant 
  #characteristics are unique to the
  #individual and should not be 
  #correlated with other individual
  #characteristics -- entity's error
  #term and the constant capturing
  #individual characteristics should
  #not be correlated with others
#FE can only model changes within an entity
  #not time-invariant differences between entities
  #so no causal estimates of time-invariant IV on DV
#fixed effects vs. random effects
  #Hausman test (null=RE)
#RE vs. OLS -- Breusch-Pagan Lagrange multiplier

?phtest
mod8 <- plm(gdp ~ demand + trade +
              capmob + oild +
              corp*leftlab,data=data,
            effect='individual', model='random',
            index = c('country'))
phtest(mod2, mod8)
#also see library(lme4) for random effects
#no need for error correction in RE model


#no one way is best, depends on data
#clustering not advised for t<15 or non-linear links
#random effects can be biased when correlations exist


