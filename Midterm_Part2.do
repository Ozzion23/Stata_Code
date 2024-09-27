clear

log using MidtermExam, replace

cd "C:\data\StataFolder_2"

sysuse fare1


gen log_fare = log(fare)
gen log_dist = log(dist)
gen log_distsquared = log_dist^2

describe

summarize

asdoc summarize year-log_distsquared

xtset id year

xtsum log_fare concen log_dist log_distsquared passen bmktshr dist fare


regress log_fare concen log_dist log_distsquared i.year, vce(cluster id)

outreg2 using midterm2, title(Regression Results) ctitle(Part B) bdec(4)word replace



regress log_fare concen log_dist log_distsquared i.year

regress log_fare concen log_dist log_distsquared i.year, vce(cluster id) 



display -_b[log_dist]/(_b[log_distsquared]*2)

display exp(4.38)

summarize dist



xtreg log_fare concen log_dist log_distsquared i.year, re

outreg2 using midterm2, ctitle(Part E) bdec(4)word append



xtreg log_fare concen log_dist log_distsquared i.year, fe

outreg2 using midterm2, ctitle(Part F) bdec(4)word append



log close 

translate MidtermExam.smcl MidtermLogOutput.pdf






