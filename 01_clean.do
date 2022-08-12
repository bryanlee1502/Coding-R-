*Bryan Lee 

cd"/Users/bryanlee/Library/Mobile Documents/com~apple~CloudDocs/Spring 2022/Econ 5/Final Assignment/Data"
use brl020_individual.dta, clear
*PART 1 FINAL ASSIGNMENT

*A Make sure you have information for all key variables for the analysis
*Drop all mssing data. It seems that there are no missing data in the variable treatment
drop if voted=="Missing Data" //Drop the missing data
drop if social_pressure_continuous==. //Drop missing data
drop if social_pressure_categorical==. //Drop missing data


*B Make sure there are no obvious errors in the data
*First, we need to see if any values are too large or negative in the variable hh_size
tab hh_size 
*We found none. No negative values or large values.
*In the variable sex, we should change it to a . if it is missing
tab sex // to find missing sex and if it exists
replace sex="." if sex=="missing"
*In the variable age, we should change it to a . if it is negative
tab age // to find negative age and if it exists
*-9 is the only age that doesn't make sense

replace age=. if age== -9 //same thing here, we make the -9 into a .
*C Make string variables into 0/1 indicator variables

gen voted2 = (voted=="Yes") //we are making a new variable called voted2 for yes = 1 and no = 0 for the variable voted
gen treatment2 = (treatment=="Neighbors") // we are making a new variable called treatment2 for yes= 1 and no = 0 for the variable treatment

*SAVE IT
save brl020_clean_individual.dta
outsheet using brl020_clean_individual.csv, comma replace


