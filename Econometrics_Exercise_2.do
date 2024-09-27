clear

log using EconometricsE2, replace 

cd "C:\data\StataFolder_2"

sysuse data21b

// Question 1:

// Part A:

summarize  ltrade ldist lrgdp lrgdppc comlang border regional landl island lareap comcol curcol colony comctry if custrict == 1

summarize  ltrade ldist lrgdp lrgdppc comlang border regional landl island lareap comcol curcol colony comctry if custrict == 0


// Yes our stats match with those that are reported in Table 1. Glick and Rose rounded their values so once the true values are rounded we get the same results. 

// Part B:

xtset pairid year

xtsum ltrade ldist lrgdp lrgdppc comlang border regional landl island lareap comcol curcol colony comctry custrict



// The variables that are time constant include ldist, comlang, border, landl, island, lareap, comcol, colony, and comctry


// Part C:

xtdescribe, patterns(30)


// Each dot represents a year and a 1 represents an observation in that year. 10% of trades are seen in the first year with there being 200724 trades total. Since we only evaluated 30 years the remaining patterns are described in the bottom of the table totaling 13126 and  not included in this  data. we have complete records for 2090 trades. Above the table we have a distribution of the data which shows 50% of the trades are observed in 16 years or less


// Part D:

// The gravity model of international trade comprises of 14 explanatory variables some of which include log distance, GDP, GDP per capita, common language, currency union,etc. In the model the coeffiecient of interest is gamma which is the effect of a currency union on trade. The authors of the study use the standard OLS method, however, the force of the paper rests in employing a number of panel data techniques. They use both fixed effects and random effects estimators. The gravity model works well in a number of different dimensions. The model fits the data well, explaining almost two-thrids of the variation in bilateral trade flows. The gravity coefficients are economically and statistically significant with sensible interpretations. The variable ltrade (Log Value of Bilateral Trade in Real $) is the dependent variable and the key explanatory varaible is custrict (currecny union) in the gravity model. 



// Part E:

// Within or Fixed Estimator

xtreg ltrade custrict lrgdp lrgdppc regional landl island lareap comcol curcol colony comctry, fe

// By replicating the results our estimates were very similar. The only difference is that the authors rounded their estimates. The estimates for currency union was .651, log distance was 0, log product real GDP was .0479, log product real gdp per capita was .7909, common language was 0, and common land border was 0. The variables with 0 estimates were the omitted ones. After rounding our real values they match closely to the estimates that are found in Table 4. 

est store fe1

outreg2 using table3, title(Regression Results From Part 1E) ctitle(Fixed Effects) bdec(4) word replace

// Random effects estimator

xtreg ltrade custrict ldist lrgdp lrgdppc comlang border regional landl island lareap comcol curcol colony comctry, re

est store gls1


outreg2 using table3, ctitle(Random Effects) bdec(4) word append

// By replicating the results our estimates were very similar. The only difference is that the authors rounded their estimates. The FE estimators for currency union was .651, log distance was 0, log product real GDP was .0479, log product real gdp per capita was .7909, commonn language was 0, and common land border was 0. The variables with 0 estimates were the omitted ones. The RE estimators were also very similar, but again the authors of the study had rounded these estimates. After rounding our real values from stata they match closely to the estimates that are found in Table 4. 

// Part F:

hausman fe1 gls1 

// After performing the Hausman test we get a p-value that is very small and approximately equal to 0. In this situation we end up rejecting the null hypothesis which suggests that the fixed effects approach is more consistent and efficient thus the FE estimates are preferred over the RE estimates.



// Question 2:

clear

cd "C:\data\StataFolder_2"

sysuse INJURY

// Part A:

reg ldurat afchnge highearn afhigh if ky==1, robust

outreg2 using table4, title(Regression Results For Question #2) ctitle(Part 2A) bdec(4) word replace

reg ldurat afchnge highearn afhigh male married occdis manuf construc head neck upextr trunk lowback lowextr if ky==1, robust

outreg2 using table4, ctitle(Part 2A With Other Factors) bdec(4) word append


// The robust standard errors do not change much as compared to the regular standard errors. The robust standard errors are larger than the regular standard errors overall. By using robust standard errors we can see that most of the variables that were statistically significant using the usual t statistic are still statistically significant using the heteroskedasticity-robust t statistic. Neck injury is the one variable with the largest relative change in standard errors. The SE was 0.161 and the Robust SE is now 0.174. Due to the differences in the p-values under SE & Robust SE the variable neck injury is no longer statistically significant. If there was heteroskedasticity we would see a substantial difference between robust and regular standard errors. Since the associated p values are expected to vary from the robust statistic, the variance is not an indication of heteroskedasticity 

// Part B:

summarize if mi==1

// Part C:

reg ldurat afchnge highearn afhigh if mi==1, robust

outreg2 using table4, ctitle(Part 2C) bdec(4) word append

// For Kentucy the average length of time on workers' compensation for high earners increased by about 19.1% whereas for Michigan it increased by 19.2%. The policy effect for the Michigan estimate is not statistically  significant whereas the policy effect for Kentucy is. The robust standard error for Michigan more than doubles compared to the robust standard error for Kentucky for the policy effect. This results in a smaller t statistic on afigh for Michigan. One reason afhigh might be insignificant is due to much lower number of observations in Michigan then in Kentucky. While the p value is an indication that that afhigh is insignificant, the reduced number of observations from 5000 to 1500 has affected the statically significance negatively.

// Part D:

reg ldurat afchnge highearn afhigh male married occdis manuf construc head neck upextr trunk lowback lowextr if mi==1, robust

outreg2 using table4, ctitle(Part 2D) bdec(4) word append

// After considering other factors the estimate of the policy effect (ATET) or the afhigh coeffiecient decreases from 0.192 to 0.143. Additionally the p-value gets larger and the estimate is still not statistically significant. It is possible that in this situation adding additional variables reduced the coeffciect of the policy effect for Michigan. Additionally, as we stated previously the number of observations in Michigan are low compared to Kentucky which may cause this statistical insignificance. Due to the smaller number of observations in Michigan the likelihood of getting some outliers is not that low, and these outliers in this sample may have a disproportionate effect on our estimation resulting in our estimated coeffciect to be statistically insignificant. 


log close

translate EconometricsE2.smcl Econometrics_Excercise2.pdf








