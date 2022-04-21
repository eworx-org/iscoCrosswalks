/*
*******************************
The code was prepared by the Institute for Structural Research - IBS.
In case of using it please include the following citation:

Hardy, W., Keister, R. and Lewandowski, P. (2018). Educational upgrading, structural change and the task composition of jobs in Europe. Economics Of Transition 26.

For details, you can find the paper here: https://onlinelibrary.wiley.com/doi/full/10.1111/ecot.12145
*******************************

*******************************
This code was written for Stata 12 but should work for other versions without any or any major changes.
*******************************

*******************************
Other Notes
* The code below was last run for the 20.1 O*NET dataset release (2015).
* Parts of the code are based on the do-files provided on the website of David Autor (http://economics.mit.edu/faculty/dautor/data/acemoglu) and his measures of task content.
* The initial conversion to .dta format might be different for previous years (that are not in .xlsx), but should pose no problems.
*******************************
*/


//insert the path to your .xlsx O*NET data directory. Files required for the derivation of task content items:
* Abilities.xlsx
* Skills.xlsx
* Work Activities.xlsx
* Work Context.xlsx
//downloaded from: https://www.onetcenter.org/database.html . 
global source "..."   

//insert the path to your crosswalks directory.
global crosswalks "..."

//insert the path for your output files (the do-file will create several .dta files along the way - one for each classification).
global output "..."


clear all	

//save the data in .dta format.
import excel using "$source\\Abilities.xlsx", firstrow clear
	rename *, lower
save "$source\\Abilities.dta", replace

import excel using "$source\\Skills.xlsx", firstrow clear
	rename *, lower
save "$source\\Skills.dta", replace

import excel using "$source\\Work Activities.xlsx", firstrow clear
	rename *, lower
save "$source\\Work Activities.dta", replace

import excel using "$source\\Work Context.xlsx", firstrow clear
	rename *, lower
save "$source\\Work Context.dta", replace


//append the prepared O*NET data, but only the needed variables
clear all
append using "$source\Abilities.dta", keep(scaleid datavalue onetsoccode elementid)
append using "$source\Skills.dta", keep(scaleid datavalue onetsoccode elementid)
append using "$source\Work Context.dta", keep(scaleid datavalue onetsoccode elementid)
append using "$source\Work Activities.dta", keep(scaleid datavalue onetsoccode elementid)

//keep only the needed measurements 
keep if scaleid=="IM" | scaleid=="CX"
drop scaleid

//simplify values and names
rename datavalue score
replace elementid=subinstr(elementid, ".", "", 5) 

//reshape so that each ONET-SOC code has one observation with all task measures */
reshape wide score, i(onetsoccode) j(elementid) string

//simplify names
renpfix score t_

//some correction for the calculation of task contents (scale reversion of selected items)
gen t_4C3b8_rev=6-t_4C3b8
gen t_4C1a2l_rev=6-t_4C1a2l
gen t_4C2a3_rev=6-t_4C2a3
foreach var in t_4A4a4 t_4A4a5 t_4A4a8 t_4A4b5 t_4A1b2 t_4A3a2 t_4A3a3 t_4A3a4 t_4A3b4 t_4A3b5 {
	gen `var'_rev=6-`var'
}

//keep only needed items
keep onetsoccode t_4A2a4 t_4A2b2 t_4A4a1 t_4A4a4 t_4A4b4 t_4A4b5 t_4C3b7 t_4C3b4 t_4C3b8_rev t_4C3d3 t_4A3a3 t_4C2d1i t_4A3a4 t_4C2d1g t_1A2a2 t_1A1f1 t_2B1a t_4C1a2l_rev t_4A4a5_rev t_4A4a8_rev t_4A1b2_rev t_4A3a2_rev t_4A3b4_rev t_4A3b5_rev

//final cleaning
sort onetsoccode
rename onetsoccode onetsoc10


*******the following lines will convert the values to other classifications, averaging them along the way, by classification codes*******
*******the code will save the data in each classification along the way, modify this as necessary if you only want to acquire one final file*******

//saving the clean, O*NET-SOC 10 data
save "$output\onetsoc10.dta", replace


//from O*NET-SOC 10 to O*NET-SOC 09
use "$output\onetsoc10.dta", clear
	joinby onetsoc10 using "$crosswalks\onetsoc09_onetsoc10.dta"
	collapse (mean) t_* , by(onetsoc09)
save "$output\onetsoc09.dta", replace

//from O*NET-SOC 10 to SOC 10
use "$output\onetsoc10.dta", clear
	replace onetsoc10 = subinstr(onetsoc10, "-", "", 1)
	destring onetsoc10, replace
	gen soc10=int(onetsoc10)
	collapse (mean) t_* , by(soc10)
save "$output\soc10.dta", replace

//from O*NET-SOC 09 na SOC 00
use "$output\onetsoc09.dta", clear
	replace onetsoc09 = subinstr(onetsoc09, "-", "", 1)
	destring onetsoc09, replace
	gen soc00=int(onetsoc09)
	collapse (mean) t_* , by(soc00)
save "$output\soc00.dta", replace

//from SOC 10 to ISCO-08
use "$output\soc10.dta", clear
	joinby soc10 using "$crosswalks\soc10_isco08.dta"
	collapse (mean) t_*, by(isco08)
save "$output\isco08.dta", replace

//from SOC 00 to ISCO-88
use "$output\soc00.dta", clear
	joinby soc00 using "$crosswalks\isco88_soc00.dta"
	collapse (mean) t_* , by(isco88)
	destring isco88, replace
	drop if isco88==.
save "$output\isco88.dta", replace
