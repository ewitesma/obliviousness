
//Generate binary variables for assigned sector (biz&socbiz combined)
tab sector2,gen(s)

//rename s1,s2,s3 to assigned sector
rename s1 sector_gov
rename s2 sector_npo
rename s3 sector_bizsocbiz

//generate binary variables for what people guessed
//gen guess_gov=0
//replace guess_gov =1 if guess==0
//gen guess_npo=0
//replace guess_npo=1 if guess==1
//gen guess_bizsocbiz=0
//replace guess_bizsocbiz=1 if guess==2
//replace guess_bizsocbiz=1 if guess==3

//Generate guessing business *Only 73 observations
//gen guess_biz=0
//replace guess_biz=1 if guess==2

//Analysis
//rightguess logistic regression
logistic rightguess sector_gov sector_npo
logistic rightguess sector_npo sector_bizsocbiz

//guessing a sector logistic regression
logistic guess_npo sector_npo sector_bizsocbiz
logistic guess_bizsocbiz sector_npo sector_bizsocbiz
logistic guess_gov sector_npo sector_bizsocbiz

//Big Logistic Tables for Paper
logistic guess_npo exp_fpo exp_npo exp_gov exp_mgmt sector_gov sector_npo define_npo2
logistic guess_npo sector_bizsocbiz

logistic guess_bizsocbiz exp_fpo exp_npo exp_gov exp_mgmt sector_gov sector_npo define_npo2
logistic guess_bizsocbiz sector_bizsocbiz

logistic guess_gov exp_fpo exp_npo exp_gov exp_mgmt sector_gov sector_npo define_npo2
logistic guess_gov sector_bizsocbiz

//Big logistics for paper with gender, race, age, workind, and education have any impact on guessing sector
logistic guess_npo exp_fpo_binary exp_npo_binary exp_gov_binary exp_mgmt_binary sector_gov sector_npo define_npo2 gender_binary income workind_binary education 

logistic guess_bizsocbiz exp_fpo_binary exp_npo_binary exp_gov_binary exp_mgmt_binary sector_gov sector_npo define_npo2 gender_binary income workind_binary education

logistic guess_gov exp_fpo_binary exp_npo_binary exp_gov_binary exp_mgmt_binary sector_gov sector_npo define_npo2 gender_binary income workind_binary education

logistic guess_biz exp_fpo_binary exp_npo_binary exp_gov_binary exp_mgmt_binary sector_gov sector_npo define_npo2 gender_binary income workind_binary education //DON"T DO

logistic rightguess exp_fpo_binary exp_npo_binary exp_gov_binary exp_mgmt_binary sector_gov sector_npo define_npo2 gender_binary income workind_binary education

//Generate Guess2 biz/socbiz collapsed
//gen guess2=guess
recode guess2 (3=2)
label define guess2_lab 0 "gov" 1 "npo" 2 "biz/socbiz" 
label values guess2 sector2_lab
label var guess2 "guess which sector"

//create gender variable binary
//gen gender_binary=0
replace gender_binary=1 if gender=="Female"
label variable gender_binary "1=Female"

//generate ordinal income
replace income = 1 if inc=="Below $20,000"
replace income = 2 if inc=="$20,000-$39,999"
replace income = 3 if inc=="$40,000-$59,999"
replace income = 4 if inc=="$60,000-$79,999"
replace income = 5 if inc=="$80,000-$99,999"
replace income = 6 if inc=="$100,000-$119,999"
replace income = 7 if inc=="$120,000-$139,999"
replace income = 8 if inc=="$140,000-$159,999"
replace income = 9 if inc=="$160,000-$179,999"
replace income = 10 if inc=="$180,000-$199,999"
replace income = 11 if inc=="$200,000 or above"


//make type of work (e.g. frontline,manager, etc.) ordinal
//encode workind, generate(workindord)
replace workindord = 1 if workind =="Front line (directly providing products or services to clients)"
replace workindord = 2 if workind =="Support (providing products or services to support people inside the organization)"
replace workindord = 3 if workind =="Supervisor (responsible for supervising others in the organization)"
replace workindord = 4 if workind =="Manager (making decisions for a unit or part of the organization)"
replace workindord = 5 if workind =="Executive (making decisions for the entire organization)"

//make education level ordinal
generate education = .
replace education = 1 if educ=="Less than high school"
replace education = 2 if educ=="High school"
replace education = 3 if educ=="Some college"
replace education = 4 if educ=="Associate's or other 2-year degree"
replace education = 5 if educ=="Bachelor's degree (BS, BA, BFA, etc.)"
replace education = 6 if educ=="Master's degree (MBA, MFA, MS, MA, MFA, etc.)"
replace education = 6 if educ=="Professional licensing degree (MD, DDS, JD, etc.)"
replace education = 6 if educ=="Doctoral degree (PhD, EdD, etc.)"

////GUESS make fancy table
eststo clear
eststo:logistic guess_npo exp_fpo_binary exp_npo_binary exp_gov_binary exp_mgmt_binary sector_gov sector_npo define_npo2 gender_binary income workind_binary education 
eststo:logistic guess_bizsocbiz exp_fpo_binary exp_npo_binary exp_gov_binary exp_mgmt_binary sector_gov sector_npo define_npo2 gender_binary income workind_binary education
eststo:logistic guess_gov exp_fpo_binary exp_npo_binary exp_gov_binary exp_mgmt_binary sector_gov sector_npo define_npo2 gender_binary income workind_binary education
esttab, eform se
//to export table to word
esttab using results.rtf, eform p


//to make Guessing right variables for each assignment
//npo right
//gen guess_npo_right=0
replace guess_npo_right=1 if rightguess==1 & guess_npo==1
logistic guess_npo_right exp_fpo_binary exp_npo_binary exp_gov_binary exp_mgmt_binary define_npo2 gender_binary income workind_binary education

//bizsocbiz right
//gen guess_bizsocbiz_right=0 
replace guess_bizsocbiz_right=1 if guess_bizsocbiz==1 & rightguess2==1
logistic guess_bizsocbiz_right exp_fpo_binary exp_npo_binary exp_gov_binary exp_mgmt_binary define_npo2 gender_binary income workind_binary education

//gov right
//gen guess_gov_right=0
replace guess_gov_right=1 if guess_gov==1 & rightguess==1
logistic guess_gov_right exp_fpo_binary exp_npo_binary exp_gov_binary exp_mgmt_binary define_npo2 gender_binary income workind_binary education


//DON"T DO biz right **ONLY 29 people guessed both **combine?
//gen guess_biz_right=0
replace guess_biz_right=1 if guess_biz==1 & rightguess==1

//DON"T DO socbiz right
//gen guess_socbiz_right=0
replace guess_socbiz_right=1 if guess_bizsocbiz==1 & rightguess==1

//to make a guess variable where guessing biz or socbiz will register as right
//gen rightguess2=0
replace rightguess2=1 if sector2==0 & guess==0
replace rightguess2=1 if sector2==1 & guess==1
replace rightguess2=1 if sector2==2 & guess==2
replace rightguess2=1 if sector2==2 & guess==3

//create work kind binary (managers and executives =1)
//gen workind_binary =0
replace workind_binary=1 if workindord==3
replace workind_binary=1 if workindord==1

//generate work experience binary
//gen exp_fpo_binary=0//
replace exp_fpo_binary=1 if exp_fpo>0  //1608 changes
//gen exp_npo_binary=0
replace exp_npo_binary=1 if exp_npo>0 //550 changes
//gen exp_gov_binary=0
replace exp_gov_binary=1 if exp_gov>0 //426 changes
//gen exp_mgmt_binary=0
replace exp_mgmt_binary=1 if exp_mgmt>0 //1008 changes


//Reverse code "Google is a nonprofit" and "Department of Labor is a nonprofit"
gen google2_reversed=6-google2

gen dol2_reversed=6-dol2 

//Reverse code "Govs are NPOs" and "NPOs are businesses"
gen govs_are_npos2_reversed=6-govs_are_npos2

gen npos_are_biz2_reversed=6-npos_are_biz2

//UPDATED TABLES FOR PAPER
////GUESS table
eststo clear
eststo:logistic guess_npo sector_gov sector_npo exp_fpo_binary exp_npo_binary exp_gov_binary exp_mgmt_binary  define_npo2 govs_are_npos2_reversed npos_are_biz2_reversed redcross2 google2_reversed dol2_reversed gender_binary income education 
eststo:logistic guess_bizsocbiz sector_gov sector_npo exp_fpo_binary exp_npo_binary exp_gov_binary exp_mgmt_binary  define_npo2 govs_are_npos2_reversed npos_are_biz2_reversed redcross2 google2_reversed dol2_reversed gender_binary income education
eststo:logistic guess_gov sector_gov sector_npo exp_fpo_binary exp_npo_binary exp_gov_binary exp_mgmt_binary define_npo2 govs_are_npos2_reversed npos_are_biz2_reversed redcross2 google2_reversed dol2_reversed gender_binary income education
esttab, eform se
//to export table to word
esttab using nvsq_table2.rtf, eform se replace //eform does odds ratios--exponentiated coefficients-- ; se does standard errors 

//Guess right and guess right by sector Logistic Regressions and Table
eststo clear
eststo:logistic rightguess sector_gov sector_npo exp_fpo_binary exp_npo_binary exp_gov_binary exp_mgmt_binary define_npo2 govs_are_npos2_reversed npos_are_biz2_reversed redcross2 google2_reversed dol2_reversed gender_binary income education
eststo:logistic guess_npo_right exp_fpo_binary exp_npo_binary exp_gov_binary exp_mgmt_binary sector_gov sector_npo define_npo2 govs_are_npos2_reversed npos_are_biz2_reversed redcross2 google2_reversed dol2_reversed gender_binary income education if sector2==1
eststo:logistic guess_bizsocbiz_right exp_fpo_binary exp_npo_binary exp_gov_binary exp_mgmt_binary sector_gov sector_npo define_npo2 govs_are_npos2_reversed npos_are_biz2_reversed redcross2 google2_reversed dol2_reversed gender_binary income education if sector2==2
eststo:logistic guess_gov_right exp_fpo_binary exp_npo_binary exp_gov_binary exp_mgmt_binary sector_gov sector_npo define_npo2 govs_are_npos2_reversed npos_are_biz2_reversed redcross2 google2_reversed dol2_reversed gender_binary income education if sector2==0
esttab using nvsq_table3.rtf, eform se replace




//Logistic regression results for bussocbiz table 2
eststo clear
eststo:logistic guess_npo sector_bizsocbiz sector_npo exp_fpo_binary exp_npo_binary exp_gov_binary exp_mgmt_binary  define_npo2 govs_are_npos2_reversed npos_are_biz2_reversed redcross2 google2_reversed dol2_reversed gender_binary income education  
eststo:logistic guess_bizsocbiz sector_bizsocbiz sector_npo exp_fpo_binary exp_npo_binary exp_gov_binary exp_mgmt_binary  define_npo2 govs_are_npos2_reversed npos_are_biz2_reversed redcross2 google2_reversed dol2_reversed gender_binary income education 
eststo:logistic guess_gov sector_bizsocbiz sector_npo exp_fpo_binary exp_npo_binary exp_gov_binary exp_mgmt_binary define_npo2 govs_are_npos2_reversed npos_are_biz2_reversed redcross2 google2_reversed dol2_reversed gender_binary income education 
esttab, eform se
