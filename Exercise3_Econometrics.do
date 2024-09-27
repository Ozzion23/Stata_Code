clear

log using Econometrics3new, replace

cd "C:\data\StataFolder_2"

import delimited loanapp2.txt, delimiters(tab)


// Question 1:

// Part A:

summarize approve white hrat obrat loanprc unem male married dep sch cosign chist pubrec mortlat1 mortlat2 vr

// Part B:


// Linear Probability Model

reg approve white

estimates store lpm1

outreg2 using table10, title(Table 1: Coefficient Estimates) ctitle(LPM) bdec(4) word replace

predict p1ols

margins, dydx(*)post 

estimates store ame_lpm1


// Probit Model 1

probit approve white 

estimates store probit1

outreg2 using table10, ctitle(Probit 1) bdec(4) word append

predict p3probit

margins, dydx(*) post // Average Marginal Effect
 
estimates store ame_probit1


// Part C:

// Probit Model 2

probit approve white hrat obrat loanprc unem male married dep sch cosign chist pubrec mortlat1 mortlat2 vr

estimates store probit2

outreg2 using table10, ctitle(Probit 2) bdec(4) word append

predict p4probit

margins, dydx(*) post

estimates store ame_probit2


// Part D: 

// Logit Model

logit approve white hrat obrat loanprc unem male married dep sch cosign chist pubrec mortlat1 mortlat2 vr

estimates store logit1

outreg2 using table10, ctitle(Logit) bdec(4) word append

predict p4logit 

margins, dydx(*) post

estimates store ame_logit1


// Creating Tables for AME Estimates 

estimates table ame_lpm1 ame_probit1 ame_probit2 ame_logit1, title(Table 2: Average Marginal Effects of White On Porbability Loan Approval) b(%7.4f) se(%7.4f) 

putdocx begin

putdocx table results = etable

putdocx save myresults.docx, replace

estimates table ame_lpm1 ame_probit1 ame_probit2 ame_logit1, title(Table 2: Average Marginal Effects of White On Porbability Loan Approval) b(%7.4f) star(.10 .05 .01)

putdocx begin

putdocx table results = etable

putdocx save myresults1.docx, replace



// Question 2: Summary Statistics

clear

cd "C:\data\StataFolder_2"

insheet using "car.txt", comma clear

gen fatal_rate_car = (sinj_occ + fat_occ)/occ_invl // Creating Dependent Variable

summarize fatal_rate_car veh2_for_car1 small_city med_city big_city seat_belt rain snow dark wkday inter_highway div_highway alc_1 drug_1 age1_21 age1_60 male_1 ymale_1 occup_1 speed_1 alc_2 drug_2 age2_21 age2_60 male_2 ymale_2 speed_2 occup_2 weight i.year



clear

insheet using "truck.txt", comma clear 

gen fatal_rate_truck = (sinj_occ + fat_occ)/occ_invl // Creating Dependent Variable

summarize fatal_rate_truck veh2_for_truck1 small_city med_city big_city seat_belt rain snow dark wkday inter_highway div_highway alc_1 drug_1 age1_21 age1_60 male_1 ymale_1 occup_1 speed_1 alc_2 drug_2 age2_21 age2_60 male_2 ymale_2 speed_2 occup_2 weight i.year


clear

insheet using "single.txt", comma clear

gen fatal_rate_single = (sinj_occ + fat_occ)/occ_invl // Creating Dependent Variable

summarize fatal_rate_single small_city med_city big_city seat_belt rain snow dark wkday inter_highway div_highway alc_1 drug_1 age1_21 age1_60 male_1 ymale_1 occup_1 speed_1 weight i.year


log close

translate Econometrics3new.smcl Econometrics3new_output.pdf



