clear

log using Econometrics_Excercise_1, replace

cd "C:\data\StataFolder_2"

sysuse fertil

// Question 1:

// Part A:

gen agesq = age * age

summarize

asdoc summarize mnthborn-agesq

// Part B:

regress children educ age agesq

outreg2 using table1, title(Table 1 OLS and IV Estimation) ctitle(OLS Estimation Part B) bdec(4)word replace

// children = -4.138 - 0.091educ + 0.332age - 0.0026age^2
            
			// (0.241)  (0.006)     (0.017)      (0.0003)
			
			// n =  4361, R^2 = 0.5687


// Holding age fixed, another year of education is estimated to lower fertility by 0.091 children. If 100 women recieve another year of education, they are expected to have 9 fewer children.



// Part C:

regress educ frsthalf age agesq	// First-stage regression (reduced form)

outreg2 using table2, title(Table 2 Reduced Form (first stage) Regression Results) ctitle(Reduced Form Part C) bdec(4)word replace

test _b[frsthalf] = 0

// Assume that frsthalf is uncorrelated with the error term in the structural equation, the instrument exogeneity requirement is satsified. We need to test the instrument relevance requirement. In the reduced form equation for educ, beta hat (frsthalf) =  -0.852 meaning that the women born in the first six months of the year have 0.85 fewer years of education than the women born in the second half of the year on average. Estimator is statistically significant at the 1% level and the F-stat = 57.06, so frsthalf is a valid IV for education. 

// Part D: 

ivregress 2sls children age agesq (educ = frsthalf), first

outreg2 using table1, ctitle(IV Estimation Part D) bdec(4)word append

estimates store IV

regress children educ age agesq

estimates store OLS

esttab OLS IV, mtitles se star (* 0.1 ** 0.05 *** 0.01) b(%8.4f)

// The negative effect of education on fertility is much larger by 2SLS than by OLS.The standard errors in 2SLS are also larger than OLS. The 95% confidence interval for education by 2SLS is wider than that by OLS.


// Part E:

regress children age agesq electric tv bicycle educ

outreg2 using table1, ctitle(OLS Estimation Part E) bdec(4)word append

estimates store OLS2

regress educ age agesq electric tv bicycle frsthalf // First-stage regression (reduced form)

outreg2 using table2, ctitle(Reduced Form Part E) bdec(4)word append

ivregress 2sls children age agesq electric tv bicycle (educ = frsthalf) 

outreg2 using table1, ctitle(IV Estimation Part E) bdec(4)word append 

estimates store IV2


esttab OLS2 IV2, mtitles se star(* 0.1 ** 0.05 *** 0.01)


// The effect of education on fertility from 2SLS is double that of the effect from OLS. The TV ownership has a significant negative effect on fertility from the OLS estimation. The reason why is because television can be seen as a form of recreation. Television ownership can be a proxy for different things, including income and perhaps geographic location.The 2SLS estimate becomes statistically insignificant because the estimate is not reliable. If TV is exogenous, OLS is more appropriate. If TV is endogenous, we should find a valid IV for it. 



clear 

cd "C:\data\StataFolder_2"

sysuse murder

// Question 2: 

// Part A:

count if exec >= 1 & year == 93

summarize exec if year == 93

list id state exec if exec == 34

// 16 states executed atleast one prisoner from 1991 to 1993, the highest number of executions were 34 and the state with the highest execution was Texas.

// Part B: 

regress mrdrte d93 exec unem if year == 90 | year == 93

// mrdrte = -5.28 -2.07d93 + .128exec + 2.53 unem 
          
		  // (4.43) (2.14)    (.263)     (0.78)

	      // n = 102, R^2 = .102, R^2adj = .074	  
		  
// The estimate of the coefficient on execution is positive (.128) and is statistically insignificant, the estimate suffers from omitted variable bias.

// Part C:

count if year == 93

regress cmrdrte cexec cunem if year == 93

// The estimate of the coefficient on execution is -.104 and statistically different from zero at the 5% level. One more execution in the past three years is estimated to lower the murder rate by 0.1. In other words 10 more executions are estimated to reduce the murder rate by about 1 murder per 100,000 people. The capital punishment has a deterrent effect.


// Part D: 

regress cexec cexec_1

// delta_exec = .350 - 1.08delta_exec_-1

          //    (.370)   (0.17)
		  
		  // n = 51, R^2 = .456, R^2adj = .444

regress cexec cexec_1 cunem 

// We regress the change in execution on the first lag of it and find that the slope coefficient is statistically significant. We can add the change in unemployment to the model and estimate the reduced form equation for delta execution. It is the first stage in the two stage least squares, it does not change the conclusion that the changes in execution are correlated. The estimate is -1.1. This implies that the number of last period's executions is negatively associated with the number of current executions.


// Part E:

ivregress 2sls cmrdrte cunem (cexec = cexec_1), first 

// delta_mrdrte = .411 -.100delta_exec - .067delta_unem

              //  (.211)  (.064)           (.159)
			  
			  // n = 51, R^2 = .110, R^2adj = .073

estat endogenous

// If we employ the IV 2sls method to the first differencing equation the standard error becomes larger and estimate becomes stataisitcally insignificant. The endogeneity test shows no evidence that the current delta execution is endogenous. In this situation the IV method is not necessary after the first differencing. 


log close

translate Econometrics_Excercise_1.smcl Econometrics_Excercise_1_out_2.pdf



