#Bryan Lee. Final Project Econ 5.
#ID: A17238775

#Analysis Part 2 to Part 6

###Part 2###

#load data brl020_clean_individual.csv and setting up tidyverse, haven, lubridate packages
#only tidyverse and stargazer (part 6) needed for this assignment.
#remove "#" and run the codes if you haven't done it in RStudio 
rm(list=ls()) 
#install.packages("tidyverse")
#install.packages("haven")
#install.packages("lubridate")
library(tidyverse)
library(haven)
library(lubridate)
setwd("/Users/bryanlee/Library/Mobile Documents/com~apple~CloudDocs/Spring 2022/Econ 5/Final Assignment/Data")
CLEAN_INDIVIDUAL<-read_csv("brl020_clean_individual.csv")

#fraction of individuals that voted 
table (CLEAN_INDIVIDUAL$voted2) 
# we can also use the variable voted 2 to do it with the table function, yes being equal to 1, no being equal to 0
table (CLEAN_INDIVIDUAL$voted)
#since variable voted2 is binary, the mean will compute the fraction too! 
#Make this a value so that we can use this to for the lines for the Histogram
turnoutrate<-mean(CLEAN_INDIVIDUAL$voted2)
#load turnout_basedata
TURNOUT_BASEDATA<-read_csv("turnout_basedata.csv")
# Make a histogram to show the distribution of voters across these localities
hist(TURNOUT_BASEDATA$turnout, xlab="Turnout Rates",
     ylab="Frequency",
     main="Histogram of Voter Turnout by Locality Codes", col="red",ylim=c(0,40),xlim=c(0,1))
     lines(c(turnoutrate, turnoutrate), c(-10,100), lty=2, col="blue")
                
###Part 3###

#Boxplot to see the relationship between social pressure index and whether an individual voted
     
boxplot(CLEAN_INDIVIDUAL$social_pressure_continuous ~ CLEAN_INDIVIDUAL$voted,
dataset =CLEAN_INDIVIDUAL, main = "Boxplot of Social Pressure Index Between People Who Voted VS Did Not Vote", 
xlab = "Vote", ylab = "Social Pressure Index")

#correlation or causal effect of social pressure and voting? these are functions to help answer this question

lm.social_pressure_vote<-lm(CLEAN_INDIVIDUAL$social_pressure_continuous~CLEAN_INDIVIDUAL$voted2)
summary(lm.social_pressure_vote)


#Dataset, unit of observation is age, for each age we have the average value of social_pressure_continuous
Age_Social_Pressure_Continuous<- CLEAN_INDIVIDUAL %>%
  group_by(age) %>%
  summarize(MeanSocialPressureContinuous = mean(social_pressure_continuous))
#We will use a scatter plot to see the relationship between age and social pressure index (continuous)
ggplot(Age_Social_Pressure_Continuous,mapping=aes(x=age,y=MeanSocialPressureContinuous))+
  geom_point(color="blue")+geom_smooth(method="lm",se=FALSE,color="red",lty=2)+xlab("Age")+ylab("Mean Social Pressure Index")+
  ggtitle("Mean Social Pressure Index for Different Ages of Individuals ")
#Estimating the linear regression Votedi=alpha+beta*ln(age)
lm.voted_age<-lm(voted2~log(age),data=CLEAN_INDIVIDUAL)
summary(lm.voted_age)
#we can see that the coefficient estimate of log(age) is 0.21350
#Now, Find 1Q and 3Q of age to find the 25th and 75th percentile of age
summary(CLEAN_INDIVIDUAL$age)
#OR we can also use quantile function
quantile(CLEAN_INDIVIDUAL$age,na.rm=TRUE)
#25th percentile=40, 75th percentile=59

#use the regression coefficients and plug in values of age
-0.47112+0.21350*log(40)
#0.3164558
-0.47112+0.21350*log(59)
#0.3994342

###Part 4###

#Checking for randomization in 2 demographic variables. 10% higher or lower indicates randomization failed.
mean_ageN <-mean(CLEAN_INDIVIDUAL$age[CLEAN_INDIVIDUAL$treatment=="Neighbors"], na.rm=T)
mean_ageC <-mean(CLEAN_INDIVIDUAL$age[CLEAN_INDIVIDUAL$treatment=="Control"], na.rm=T)

mean_hhsizeN <-mean(CLEAN_INDIVIDUAL$hh_size[CLEAN_INDIVIDUAL$treatment=="Neighbors"], na.rm=T)
mean_hhsizeC <-mean(CLEAN_INDIVIDUAL$hh_size[CLEAN_INDIVIDUAL$treatment=="Control"], na.rm=T)
#print the values OR immediately use the values for next step
print(mean_ageN)
print(mean_ageC)
print(mean_hhsizeN)
print(mean_hhsizeC)
#check the percent change by using the formula: (Pass Rate Treatment-Pass Rate Control)/Pass Rate Control
#for age
(mean_ageN-mean_ageC)/mean_ageC
#we get -0.0164303. Ignore the negative sign, we see that there is a change of 1.6% which is less than 10%
(mean_hhsizeN-mean_hhsizeC)/mean_hhsizeC
#we get -0.00539268. Ignore the negative sign, we see that there is a change of 0.54% which is less than 10%
#Hence, our data is random.

###Part 5###

#Make a regression of voted2 and treatment2 and observe the estimates
lm.voted_treatment<-lm(CLEAN_INDIVIDUAL$voted2~CLEAN_INDIVIDUAL$treatment2)
summary(lm.voted_treatment)

###Part 6###

#install stargazer if you haven't in your RStudio
#install.packages("stargazer")
library(stargazer)
#find the median age
median(CLEAN_INDIVIDUAL$age, na.rm=T)
#generate a variable for whether an individual is younder than 49 or older than or equal to 49
CLEAN_INDIVIDUAL$AgeVotedLess49<-as.integer(as.logical(CLEAN_INDIVIDUAL$age<49))
CLEAN_INDIVIDUAL$AgeVotedMore49<-as.integer(as.logical(CLEAN_INDIVIDUAL$age>=49))
#estimate the treatment effect using linear regression and observe the estimates

lm.AgeVotedless49<-lm(CLEAN_INDIVIDUAL$treatment2~CLEAN_INDIVIDUAL$AgeVotedLess49)
summary(lm.AgeVotedless49)

lm.AgeVotedMore49<-lm(CLEAN_INDIVIDUAL$treatment2~CLEAN_INDIVIDUAL$AgeVotedMore49)
summary(lm.AgeVotedMore49)
#use stargazer to get a table and edit and paste it to the final project document

stargazer(lm.AgeVotedMore49,lm.AgeVotedless49, title="Effectiveness of Treatment on Different Age Groups",
          align=TRUE,type="html",out="regtable.html") 
































































