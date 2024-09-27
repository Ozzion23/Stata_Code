clear

cd "C:\data\StataFolder_2"

insheet using "Trucost_Carbon_Data.csv", comma clear


// Build panel data
// organized by firm-year and include variables such as :
// firm name, indentifier, gvkey, and carbon earnings at risk 
// measured as Example: Carbon_earnings_at_risk_low_2020
// low, medium, high as well as 2020, 2025, 2030, 2040, 2050

// For every variable that is generated for carbon earnings at risk, use the 
// value for di_327642

// There are 905583 observations in the dataset

// CLEANING DATA & FORMATTING DATA

keep fiscalyear gvkey scenariolevel di_327642 companyname forecastyear companyid 

drop if di_327642 ==. // dropping the values give you 905370 observations

duplicates report periodid fiscalyear gvkey scenariolevel di_327642 companyname forecastyear companyid 

duplicates report // single copy of observation : 887626 unique observations
                  // two copies of observation: 16460 
				  // three copies of observation: 624
				  
duplicates report di_327642 companyname	fiscalyear forecastyear scenariolevel			  
				  
duplicates report fiscalyear gvkey scenariolevel di_327642 companyname forecastyear companyid	

isid periodid

isid companyid 


isid numbered_list


isid forecastyear periodid

xtset numbered_list fiscalyear

duplicates report companyid periodid

drop if missing(companyid, periodid, forecastyear)

duplicates report companyid fiscalyear

xtset numbered_list fiscalyear

isid companyid
isid companyid fiscalyear

drop if missing(companyid)

duplicates list

duplicates drop // dropping dulicate values in dataset

// ssc install mdesc

mdesc // gives us the number of missing values in the data set, can rerun to see missing values

drop if missing(fiscalyear, scenariolevel, forecastyear, di_327642, companyid, gvkey, companyname)

label variable di_327642 "carbon earnings at risk"
describe di_327642

// after dropping missing values and duplicates we have a total of 896064 observations

format di_327642 %12.2f // formats tha carbon earnings at risk to two decimal places

list in 28759
list in 1

list companyname if companyname == ")" // Company name is identified as ")" and need to chanage variable

list in 630811/630815

replace companyname = "Qatar Fuel (Woqod) Q.S.C" if companyname == ")"


list if companyname == "Qatar Fuel (Woqod) Q.S.C"


// CREATING PANEL DATA & GENERATING NEW VARIABLES

generate Carbonearningsatrisklow20 = di_327642 if scenariolevel == "Low" & forecastyear == 2020

generate Carbonearningsatrisklow25 = di_327642 if scenariolevel == "Low" & forecastyear ==  2025

generate Carbonearningsatrisklow30 = di_327642 if scenariolevel == "Low" & forecastyear == 2030

generate Carbonearningsatrisklow40 = di_327642 if scenariolevel == "Low" & forecastyear == 2040

generate Carbonearningsatrisklow50 = di_327642 if scenariolevel == "Low" & forecastyear == 2050


generate Carbonearningsatriskmed20 = di_327642 if scenariolevel == "Medium" & forecastyear == 2020

generate Carbonearningsatriskmed25 = di_327642 if scenariolevel == "Medium" & forecastyear ==  2025

generate Carbonearningsatriskmed30 = di_327642 if scenariolevel == "Medium" & forecastyear == 2030

generate Carbonearningsatriskmed40 = di_327642 if scenariolevel == "Medium" & forecastyear == 2040

generate Carbonearningsatriskmed50 = di_327642 if scenariolevel == "Medium" & forecastyear == 2050


generate Carbonearningsatriskh20 = di_327642 if scenariolevel == "High" & forecastyear == 2020

generate Carbonearningsatriskh25 = di_327642 if scenariolevel == "High" & forecastyear ==  2025

generate Carbonearningsatriskh30 = di_327642 if scenariolevel == "High" & forecastyear == 2030

generate Carbonearningsatriskh40 = di_327642 if scenariolevel == "High" & forecastyear == 2040

generate Carbonearningsatriskh50 = di_327642 if scenariolevel == "High" & forecastyear == 2050

// ***************LOOK AT THIS LINE OF CODE******************


list companyname if companyname == "BOK Financial Corporation" & fiscalyear == 2017 & scenariolevel == "Low"

list in 4
list in 8
list in 20
list in 28
list in 45

list in 75916/75920

generate c201 = di_327642 if scenariolevel == "Low" & forecastyear == 2020

generate c252 = di_327642 if scenariolevel == "Low" & forecastyear ==  2025

generate c303 = di_327642 if scenariolevel == "Low" & forecastyear == 2030

generate c404 = di_327642 if scenariolevel == "Low" & forecastyear == 2040

generate c505 = di_327642 if scenariolevel == "Low" & forecastyear == 2050


generate c206 = di_327642 if scenariolevel == "Medium" & forecastyear == 2020

generate c257 = di_327642 if scenariolevel == "Medium" & forecastyear ==  2025

generate c308 = di_327642 if scenariolevel == "Medium" & forecastyear == 2030

generate c409 = di_327642 if scenariolevel == "Medium" & forecastyear == 2040

generate c500 = di_327642 if scenariolevel == "Medium" & forecastyear == 2050


generate c111 = di_327642 if scenariolevel == "High" & forecastyear == 2020

generate c222 = di_327642 if scenariolevel == "High" & forecastyear ==  2025

generate c333 = di_327642 if scenariolevel == "High" & forecastyear == 2030

generate c444 = di_327642 if scenariolevel == "High" & forecastyear == 2040

generate c555 = di_327642 if scenariolevel == "High" & forecastyear == 2050



// reshape long c, i(companyname fiscalyear scenario_id numbered_list) j(scenario_year)

reshape long c, i(companyname scenario_year_id numbered_list) j(fore_year_id)

// Observations: 905370 after dropping missing values

drop if c ==.

list companyname if companyname ==.

move numbered_list companyname

sort fiscalyear companyname

gen numbered_list = _n

move numbered_list fiscalyear

order numbered_list

rename c Carbon_earnings_at_risk

label define scenario_order 1 Low 2 Medium 3 High

encode scenariolevel, gen(scenario_id) label (scenario_order)

move scenario_id numbered_list

// gen scenario_fiscal_year = scenario_id + fiscalyear

egen scenario_year_1 = concat(scenariolevel fiscalyear)

label define scen_year_order 1 Low2017 2 Low2018 3 Low2019 4 Low2020 5 Medium2017 6 Medium2018 7 Medium2019 8 Medium2020 9 High2017 10 High2018 11 High2019 12 High2020

encode scenario_year_1, gen(scenario_year_id) label (scen_year_order)



egen group1 = group(fiscalyear scenariolevel companyname)

sort group1

reshape long Carbonearningsatrisklow Carbonearningsatriskh Carbonearningsatriskmed, i(numbered_list) j(year)



isid companyid fiscalyear // variables companyid and fiscal year should never be missing


mdesc


drop if missing(companyid) 


bysort companyid fiscalyear: assert _N == 1

egen id_company = group(companyid)

drop companyid
move id_company fiscalyear

egen id_year = group(fiscalyear)




gen numbered_list = _n

order numbered_list

quietly egen id_forecast_year = group(forecastyear)

drop id_forecast_year


reshape long Carbon_earnings_at_risk, i(numbered_list) j(year)

list companyname if companyname == ""


//reshape long scenariolevel forecastyear di_327642 companyid gvkey Carbon_earnings_at_risk_h_2020 Carbon_earnings_at_risk_h_2025 Carbon_earnings_at_risk_h_2030  Carbon_earnings_at_risk_h_2040 Carbon_earnings_at_risk_h_2050 Carbon_earnings_at_risk_low_2020 Carbon_earnings_at_risk_low_2025 Carbon_earnings_at_risk_low_2030 Carbon_earnings_at_risk_low_2040 Carbon_earnings_at_risk_low_2050 Carbon_earnings_at_risk_med_2020 Carbon_earnings_at_risk_med_2025 Carbon_earnings_at_risk_med_2030 Carbon_earnings_at_risk_med_2040 Carbon_earnings_at_risk_med_2050, i(companyid) j(fiscalyear)



list if companyname == "ABB Ltd"


// egen scenario_id = group(scenariolevel)

sort scenario_id companyname fiscalyear

reshape long Carbon_earnings_at_risk, i(scenario_id) j(year)


drop if missing(companyid)


xtset companyid fiscalyear

egen year_id = group(fiscalyear)

xtset companyid year_id

drop year_id


reshape long forecastyear di_327642 companyid gvkey scenariolevel, i(fiscalyear) j(scenariolevel) str


sort companyid fiscalyear



browse 
