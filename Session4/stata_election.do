* set -1 as global missing value, for 'out of universe' values
mvdecode _all, mv(-1)
 
* for other variables, all values <0 are missing
mvdecode  PEHSPNON PEMARITL PES2 PES3 PES4 PES5 PES6 PES7 PES8 PESEX PRINUYER PTDTRACE HUFAMINC PUSCK4 , mv(-2 -3 -9)
 
* for education variable, 0 is a missing value
mvdecode PREDUCA4, mv(0)
 
* rename variables
 
rename PES1 vote2004
rename PES2 registered
rename PES3 whynotreg
rename PES4 whynotvote
rename PES5 mailvote04
rename PES6 voteday
rename PES7 howreg
rename PES8 timeatadd
rename PESEX sex
rename PRTAGE age
rename HUFAMINC income
rename PREDUCA4 educ4
rename PTDTRACE race
 
 
* variable Vote counts as nonvoting all nonresponses (refuses to answer, dk, no response)
* excludes "not in universe" coding (-1)
* remember that variables have already been renamed
 
recode vote2004 (-2 -3 -9  2 = 0)
 
 
 
 
* generate selfreported or proxy vote reports
gen voteself04=0
replace voteself04=1 if PUSCK4==1
 
*generate early voting variable and inperson variable
gen earlyvote=0
replace earlyvote=1 if voteday==2
gen inperson=0
replace inperson=1 if mailvote==1
 
*recode age variables
gen age18to24=0
gen age75plus=0
 
replace age18to24=1 if (age>=18 & age <25)
replace age75plus=1 if (age>74)
 
 
* add state dummies
 
gen  ME=0
gen  NH=0
gen  VT=0
gen  MA=0
gen  RI=0
gen  CT=0
gen  NY=0
gen  NJ=0
gen  PA=0
gen  OH=0
gen  IN=0
gen  IL=0
gen  MI=0
gen  WI=0
gen  MN=0
gen  IA=0
gen  MO=0
gen  ND=0
gen  SD=0
gen  NE=0
gen  KS=0
gen  DE=0
gen  MD=0
gen  DC=0
gen  VA=0
gen  WV=0
gen  NC=0
gen  SC=0
gen  GA=0
gen  FL=0
gen  KY=0
gen  TN=0
gen  AL=0
gen  MS=0
gen  AR=0
gen  LA=0
gen  OK=0
gen  TX=0
gen  MT=0
gen  ID=0
gen  WY=0
gen  CO=0
gen  NM=0
gen  AZ=0
gen  UT=0
gen  NV=0
gen  WA=0
gen  OR=0
gen  CA=0
gen  AK=0
gen  HI=0
 
 
replace  ME=1 if GESTCEN==11
replace  NH=1 if GESTCEN==12
replace  VT=1 if GESTCEN==13
replace  MA=1 if GESTCEN==14
replace  RI=1 if GESTCEN==15
replace  CT=1 if GESTCEN==16
replace  NY=1 if GESTCEN==21
replace  NJ=1 if GESTCEN==22
replace  PA=1 if GESTCEN==23
replace  OH=1 if GESTCEN==31
replace  IN=1 if GESTCEN==32
replace  IL=1 if GESTCEN==33
replace  MI=1 if GESTCEN==34
replace  WI=1 if GESTCEN==35
replace  MN=1 if GESTCEN==41
replace  IA=1 if GESTCEN==42
replace  MO=1 if GESTCEN==43
replace  ND=1 if GESTCEN==44
replace  SD=1 if GESTCEN==45
replace  NE=1 if GESTCEN==46
replace  KS=1 if GESTCEN==47
replace  DE=1 if GESTCEN==51
replace  MD=1 if GESTCEN==52
replace  DC=1 if GESTCEN==53
replace  VA=1 if GESTCEN==54
replace  WV=1 if GESTCEN==55
replace  NC=1 if GESTCEN==56
replace  SC=1 if GESTCEN==57
replace  GA=1 if GESTCEN==58
replace  FL=1 if GESTCEN==59
replace  KY=1 if GESTCEN==61
replace  TN=1 if GESTCEN==62
replace  AL=1 if GESTCEN==63
replace  MS=1 if GESTCEN==64
replace  AR=1 if GESTCEN==71
replace  LA=1 if GESTCEN==72
replace  OK=1 if GESTCEN==73
replace  TX=1 if GESTCEN==74
replace  MT=1 if GESTCEN==81
replace  ID=1 if GESTCEN==82
replace  WY=1 if GESTCEN==83
replace  CO=1 if GESTCEN==84
replace  NM=1 if GESTCEN==85
replace  AZ=1 if GESTCEN==86
replace  UT=1 if GESTCEN==87
replace  NV=1 if GESTCEN==88
replace  WA=1 if GESTCEN==91
replace  OR=1 if GESTCEN==92
replace  CA=1 if GESTCEN==93
replace  AK=1 if GESTCEN==94
replace  HI=1 if GESTCEN==95
 
 
 
* generate dummy var for race
* black limited to respondents who are black only
* black2 includes all mentions, and multiple racial identities
 
 
gen black2=0
replace black2=1 if (race==2 | race==6 |race==10 | race==11 | race==12 | race==15 | race==16 | race==19)
 
* generate hispanic variables plus subcategories of mexican and cuban
gen hispanic=0
replace hispanic=1 if PEHSPNON==1
 
 
* generate citizenship variables
gen naturalized=0
replace naturalized=1 if (PRCITSHP==4)
 
*generate years since U.S. entry for naturalized citizens
* variable =1 if naturalized citizen entered U.S. prior to 1994
 
gen nat_tenplus=0
replace nat_tenplus =1 if (naturalized==1 & PRINUYER <=14)
 
 
gen south=0
replace south=1 if (AR==1 | LA==1 | MS ==1 |AL==1 | GA ==1 |NC==1 | SC==1 | TN==1 | VA ==1 |FL ==1 | TX==1)
 
* election law classifications taken from figure 1
 
gen edr04=0
gen early04=0
gen edr_early04=0
gen sdr_early04=0
gen edr_early_sdr04=0
 
replace edr04=1 if (CT==1 | MN==1 |NH==1| RI==1)
replace early04=1 if (AZ==1 | CO ==1 |FL==1 | GA==1 | HI ==1 |IN ==1 |KS==1 | LA==1 | MD ==1 |NE==1 | NV ==1 |NJ ==1 |OK ==1 |SD ==1 | ///
TN==1 | TX==1 | UT ==1 | WV==1)
replace edr_early04=1 if (AK ==1 | ID==1)
replace sdr_early04=1 if (CA==1 | IL==1 | NM==1 | NC==1 | OH==1 | VT==1)
replace edr_early_sdr04 = 1 if (IA==1 | ME ==1 |MT ==1 |ND ==1 |WI ==1 |WY==1)
 
*voter ID data takenfrom NCSL, includes all states with voter ID requirements
gen voterid04=0
replace voterid04=1 if(AL==1 | CT==1|MI==1|MO==1|ND==1|SD==1|DE==1|VA==1|SC==1|GA==1|FL==1|KY==1|TN==1|AR==1|LA==1|TX==1|MT==1|CO==1|AZ==1|HI==1)
 
 
 
gen close30_04=0
replace close30_04=1 if (AK==1 | AR==1 | DC==1 |GA==1 |HI==1 |LA==1 |MI==1 |MS==1 |MT==1 |NV==1 |OH==1|PA==1|RI==1|SC==1|TN==1|TX==1|WY==1)
 
* recode marriage variable
gen married=0
replace married=1 if (PEMARIT==1 | PEMARIT==2)
 
* generate new time at address variable
gen oneyear=0
replace oneyear=1 if (timeatadd>=4)
 
label var oneyear "At Current Address longer than 1 year"
label var edr04 "Election Day Reg only"
label var early04 "Early Voting only"
label var edr_early04 "Early Voting + EDR"
label var sdr_early04 "Same Day Reg + early voting"
label var edr_early_sdr04 "edr + sdr + early voting"
 
label var black2 "Black multi cat"
label var hispanic "Hispanic"
label var voteself04 "Self reported vote (no proxy)"
label var naturalized "Foreign Born Naturalized US Citizen"
label var earlyvote "Resp Voted Before Election Day 2004"
label var inperson "Resp Voted in Person 2004"
 
* generate competitiveness measure
* Note: original merged data has up to 5 decimal points; this is entered here to maintain consistency with
* the original analysis
* data provided by Charles Franklin, from pollster.com records from 2004
* values are 100-abs(Bush-Kerry) for the last pre-election polling aggregation
 
 
gen polldiff04=0
 
 replace polldiff04= 77.55662          if(AL==1)   
 replace polldiff04= 75                       if(AK==1)
 replace polldiff04= 92.15571          if(AZ==1) 
 replace polldiff04= 94.96625          if( AR==1)
 replace polldiff04= 86.92389          if(CA==1) 
 replace polldiff04= 97.92025          if(CO==1)  
 replace polldiff04= 91.08546          if( CT==1)
replace polldiff04= 92                       if(DE==1) 
 replace polldiff04= .                          if( DC==1)    
 replace polldiff04= 99.20707          if( FL==1) 
 replace polldiff04= 85.04378          if( GA==1)  
 replace polldiff04= 99.36344          if(HI==1)
 replace polldiff04= 70.5                   if(ID==1)
replace polldiff04= 88.88827          if(IL==1 )
 replace polldiff04= 80.50172          if( IN==1)   
 replace polldiff04= 98.69521          if( IA==1)
 replace polldiff04= 75.90806          if(KS==1) 
 replace polldiff04= 80.23806          if( KY==1) 
 replace polldiff04= 86.48149          if( LA==1) 
 replace polldiff04= 93.67503          if(ME==1)
 replace polldiff04= 85.19057          if( MD==1)  
 replace polldiff04= 84.06894          if( MA==1)   
 replace polldiff04= 98.89129          if( MI==1)   
 replace polldiff04= 97.74577          if( MN==1)   
 replace polldiff04= 80                       if( MS==1) 
 replace polldiff04= 95.30721          if(  MO==1) 
 replace polldiff04= 78.14225          if(MT==1)
replace polldiff04= 70.33333          if(NE==1 )
 replace polldiff04= 94.82961          if(NV==1)
 replace polldiff04= 98.45051          if( NH==1)  
 replace polldiff04= 97.71729          if( NJ==1)   
 replace polldiff04= 95.29222          if(NM==1) 
 replace polldiff04= 83.07148          if( NY==1)   
 replace polldiff04= 92.16432          if(NC==1)   
 replace polldiff04= 75.5                   if(ND==1) 
 replace polldiff04= 99.78515          if( OH==1)   
 replace polldiff04= 70.03732          if(OK==1) 
 replace polldiff04= 95.11276          if(OR==1) 
 replace polldiff04= 98.72044          if( PA==1)
replace polldiff04= 82.25779          if( RI==1)
 replace polldiff04= 84.16378          if(SC==1)   
 replace polldiff04= 79.17751          if( SD==1) 
 replace polldiff04= 84.36106          if(TN==1)   
 replace polldiff04= 77.69822          if( TX==1) 
 replace polldiff04= 55.533              if(UT==1) 
 replace polldiff04= 87.33333          if( VT==1)   
 replace polldiff04= 95.77582          if( VA==1)
replace polldiff04= 93.62582          if(WA==1)
replace polldiff04= 94.08593          if( WV==1)   
 replace polldiff04= 98.50197          if( WI==1)   
 replace polldiff04= 64                       if(WY==1) 
 
 gen vote_mnl04=.
replace vote_mnl04=0 if (vote2004==0)
replace vote_mnl04=1 if (voteday==1)
replace vote_mnl04=2 if (voteday==2 & mailvote04==1)
replace vote_mnl04=3 if (voteday==2 & mailvote04==2)
 
* save file
* save  "path and filename", replace
 
*********************************************************************************************
*
* THIS IS THE RUN FOR THE AJPS ARTICLE
* updated October 4, 2014
*
**********************************************************************************************
 
****************************************************************
* individual turnout in 2004; clustered standard errors by state
****************************************************************
               
                 
logit vote2004 early04 sdr_early04  edr_early04 edr_early_sdr04 edr04 close30_04 voterid04 educ4 black2 hispanic voteself04 naturalized nat_tenplus  ///
married oneyear income sex age age18to24 age75plus polldiff04 south ND OR WA  , vce (cluster GESTCEN)
 
summarize vote2004  edr04 early04 edr_early04 sdr_early04 edr_early_sdr04 educ4 black2 hispanic voteself04 naturalized nat_tenplus close30_04 ///
married oneyear income sex age age18to24 age75plus south polldiff04 OR WA ND voterid04
 
* compute confidence intervals for coefficients of interest
test edr04=early04
test edr04=edr_early04
test edr04=sdr_early04
test edr04=edr_early_sdr04
test early04=edr_early04
test early04=sdr_early04
test early04=edr_early_sdr04
test edr_early04=sdr_early04
test edr_early04=edr_early_sdr04
test sdr_early04=edr_early_sdr04
 
 
*predict vhat1 if e(sample)
estat clas
*compute marginal effects of variables of interest
mfx compute, varlist(early04 sdr_early04  edr_early04 edr_early_sdr04 edr04 educ4 black2 age sex married income south OR WA) dydx at(mean)
 
 
****************************************************************
* multinomial logit 2004; clustered standard errors by state
* voting on election day is the excluded category
****************************************************************
 
mlogit vote_mnl04  early04 sdr_early04  edr_early04 edr_early_sdr04 edr04 close30_04 voterid04 educ4 black2 hispanic voteself04 naturalized nat_tenplus  ///
married oneyear income sex age age18to24 age75plus polldiff04 south ND OR WA  , vce (cluster GESTCEN)
