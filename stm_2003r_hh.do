************************************************************************************
** file: \\stm_analysis\do\stm_2003r_hh_level.do
** Programmer: james r. hull
** Date started: 2012 02 07
** Date finished: 2012 05 15
** Updates: Fixed program bugs 2012 06 19
** Data Input: man_main.dta; 
** 		man_main_part_2.dta; 
** 		woman_main.dta; 
** 		w_subtable_q101_125_household_characteristics.dta;
** 		w_subtable_q145_163_decision_making_process.dta		
** 		w_subtable_q126_144_household_assets.dta
** 		w_subtable_q32_49_household_level_activities.dta
** 		m_subtable_q24_26_landusecover.dta
**		m_subtable_q28_production.dta 
** 		m_subtable_q47_rentpasture.dta
** 		m_subtable_q53_timber.dta
** 		m_subtable_q68_technology.dta
** 		m_subtable_q75_credit.dta
** 		w_subtable_q100_household_characteristics.dta
**      w_subtable_q09_otherhh.dta
** Data Output: stm2003r_hh.dta
**              stm2003r_hh_public.dta
** STATA Version: 11
** Purpose: Complete Merge and Clean of 2003 Rural Santarem Household-Level Data
** Notes: 
************************************************************************************

****************************************************************************************

*********************************
** SET ENVIRONMENTAL PARAMETERS
*********************************

capture log close
* Note that if folder is moved, all directory path prior to "stm_analysis" must be changed
log using "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\log\stm_2003r_hh_level", replace text

* Note that if folder is moved, all directory path prior to "stm_analysis" must be changed
cd "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\data\stm_2003r\data\stata\"

* Tell Stata to create all new variables in type double in order to prevent truncation of ID vars and so forth
set type double, permanently

* Tell Stata not to pause in displaying results of this do-file
set more off

****************************************************************************************

********************************************
** SEQUENTIAL MERGE OF HH-LEVEL DATA FILES
********************************************

*******************************************************
* Preliminary rename of man_main.dta --> base0001.dta
*******************************************************
use man_main.dta, clear
save base0001.dta, replace

***************************************************************************************************
* Merge man_main_part_2.dta --> base0001.dta
*******************************************************
* Sort Base File and check uniqueness of id variable
use base0001.dta, clear
sort mprop_hh_id											
save base0001_sort.dta, replace
by mprop_hh_id: assert _N==1

* Sort Merge File and check uniqueness of id variable
use man_main_part_2.dta, clear
sort mprop_hh_id
save man_main_part_2_sort.dta, replace
by mprop_hh_id: assert _N==1

* Compare All Common Variables between Base (Master) and Merge (Using) File
* NOTE: Comment out cf command after identifying any errors
use base0001_sort.dta, clear
* cf _all using man_main_part_2_sort.dta, verbose 

* If necessary, correct any mismatched variable issues revealed above before merging

* Merge files (with extra consistency checks) and check for any id problems
use base0001_sort.dta, clear
merge 1:1 mprop_hh_id using man_main_part_2_sort.dta, update replace
by mprop_hh_id: assert _N==1
tab _merge
drop _merge

* Summary Report: merging man_main_part_2.dta --> base0001.dta
describe, short
save base0002.dta, replace

***************************************************************************************************
* Merge woman_main.dta --> base0002.dta
*******************************************************

* Sort Base File and check uniqueness of id variable
use base0002.dta, clear
sort mprop_hh_id
save base0002_sort.dta, replace
by mprop_hh_id: assert _N==1

* Sort Merge File and check uniqueness of id variable
use woman_main.dta, clear
rename wprop_hh_id mprop_hh_id

* Rename registro_ on woman file
rename registro_ registro_w
sort mprop_hh_id

save woman_main_sort.dta, replace
by mprop_hh_id: assert _N==1

* Compare All Common Variables between Base (Master) and Merge (Using) File
* NOTE: Comment out cf command after identifying any errors
use base0002_sort.dta, clear
* cf _all using woman_main_sort.dta, verbose

* If necessary, correct any mismatched variable issues revealed above before merging
use base0002_sort.dta, clear
replace mprop_hh_id=62202 if mprop_hh_id==62203
save base0002_sort.dta, replace

*Merge files (with extra consistency checks) and check for any id problems
use base0002_sort.dta, clear
merge 1:1 mprop_hh_id using woman_main_sort.dta, update
by mprop_hh_id: assert _N==1
tab _merge
drop _merge

* Summary Report: merging woman_main.dta --> base0003.dta
describe, short
save base0003.dta, replace

***************************************************************************************************
* Merge w_subtable_q101_125_household_characteristics.dta --> base0003.dta
*******************************************************

* Sort Base File and check uniqueness of id variable
use base0003.dta, clear
sort wintrno
save base0003_sort.dta, replace
by wintrno: assert _N==1

* Sort Merge File and check uniqueness of id variable
use w_subtable_q101_125_household_characteristics.dta, clear
sort wintrno
save w_subtable_q101_125_household_characteristics_sort.dta, replace
by wintrno: assert _N==1

* Compare All Common Variables between Base (Master) and Merge (Using) File
* !NOTE: Comment out cf command after identifying any errors
use base0003_sort.dta, clear
* cf _all using w_subtable_q101_125_household_characteristics_sort.dta, verbose

* If necessary, correct any mismatched variable issues revealed above before merging

*Merge files (with extra consistency checks) and check for any id problems
use base0003_sort.dta, clear
merge 1:1 wintrno using w_subtable_q101_125_household_characteristics_sort.dta, update
by wintrno: assert _N==1
tab _merge
drop _merge

* Summary Report: merging w_subtable_q101_125_household_characteristics.dta --> base0003.dta
describe, short
save base0004.dta, replace

***************************************************************************************************
* Merge w_subtable_q145_163_decision_making_process.dta --> base0004.dta
*******************************************************

* Sort Base File and check uniqueness of id variable
use base0004.dta, clear
sort wintrno
save base0004_sort.dta, replace
by wintrno: assert _N==1

* Sort Merge File and check uniqueness of id variable
use w_subtable_q145_163_decision_making_process.dta, clear
sort wintrno
save w_subtable_q145_163_decision_making_process_sort.dta, replace
by wintrno: assert _N==1

* Compare All Common Variables between Base (Master) and Merge (Using) File
* !NOTE: Comment out cf command after identifying any errors
use base0004_sort.dta, clear
* cf _all using w_subtable_q145_163_decision_making_process_sort.dta, verbose

* If necessary, correct any mismatched variable issues revealed above before merging

*Merge files (with extra consistency checks) and check for any id problems
use base0004_sort.dta, clear
merge 1:1 wintrno using w_subtable_q145_163_decision_making_process_sort.dta, update
by wintrno: assert _N==1
tab _merge
drop _merge

* Summary Report: merging w_subtable_q145_163_decision_making_process.dta --> base0004.dta
describe, short
save base0005.dta, replace

***************************************************************************************************
* Merge w_subtable_q126_144_household_assets.dta --> base0005.dta
*******************************************************

* Sort Base File and check uniqueness of id variable
use base0005.dta, clear
sort wintrno
save base0005_sort.dta, replace
by wintrno: assert _N==1

* Sort Merge File and check uniqueness of id variable
use w_subtable_q126_144_household_assets.dta, clear
sort wintrno
save w_subtable_q126_144_household_assets_sort.dta, replace
by wintrno: assert _N==1

* Compare All Common Variables between Base (Master) and Merge (Using) File
* NOTE: Comment out cf command after identifying any errors
use base0005_sort.dta, clear
* cf _all using w_subtable_q126_144_household_assets_sort.dta, verbose

* If necessary, correct any mismatched variable issues revealed above before merging

*Merge files (with extra consistency checks) and check for any id problems
use base0005_sort.dta, clear
merge 1:1 wintrno using w_subtable_q126_144_household_assets_sort.dta, update
by wintrno: assert _N==1
tab _merge
drop _merge

* Summary Report: merging w_subtable_q126_144_household_assets.dta --> base0005.dta
describe, short
save base0006.dta, replace

***************************************************************************************************
* Merge w_subtable_q32_49_household_level_activities.dta --> base0006.dta
*******************************************************

* Sort Base File and check uniqueness of id variable
use base0006.dta, clear
sort wintrno
save base0006_sort.dta, replace
by wintrno: assert _N==1

* Sort Merge File and check uniqueness of id variable
use w_subtable_q32_49_household_level_activities.dta, clear
sort wintrno

* Delete Duplicate Case (!SOLUTION FOR NOW)
quietly by wintrno:  gen dup = cond(_N==1,0,_n)
drop if dup>1
drop dup

* Recode all dichotomous string variables to numeric dichotomous variables
forvalues k = 32/45 {
replace _2w_`k'="1" if _2w_`k'=="Yes"
replace _2w_`k'="0" if _2w_`k'=="No"
destring _2w_`k', replace
replace _2w_`k'=9999 if _2w_`k'==.
rename _2w_`k' w`k'
}

replace _2w_16="1" if _2w_16=="HH"
destring _2w_16, replace
replace _2w_16=9999 if _2w_16==.
rename _2w_16 w16

replace _2w_17="1" if _2w_17=="Yes"
replace _2w_17="0" if _2w_17=="No"
destring _2w_17, replace
replace _2w_17=9999 if _2w_17==.
rename _2w_17 w17

save w_subtable_q32_49_household_level_activities_sort.dta, replace
by wintrno: assert _N==1

/* *!NOTE - CF does not provide verbose output with mismatched Ns b/t datasets 
* Compare All Common Variables between Base (Master) and Merge (Using) File
* NOTE: Comment out cf command after identifying any errors
use base0006_sort.dta, clear
cf _all using w_subtable_q32_49_household_level_activities.dta_sort.dta, verbose
*/

* If necessary, correct any mismatched variable issues revealed above before merging

*Merge files (with extra consistency checks) and check for any id problems
use base0006_sort.dta, clear
merge 1:1 wintrno using w_subtable_q32_49_household_level_activities_sort.dta, update
by wintrno: assert _N==1
tab _merge
drop _merge

* code missing values following 1:less than 1 merge
forvalues k = 32/45 {
replace w`k'=9998 if w`k'==.
}

forvalues k = 16/17 {
replace w`k'=9998 if w`k'==.
}

* Unecessary and confusing variable dropped
drop key

* Summary Report: merging w_subtable_q32_49_household_level_activities.dta --> base0006.dta
describe, short
save base0007.dta, replace

***************************************************************************************************
* Merge m_subtable_q24_26_landusecover.dta --> base0007.dta
*******************************************************

* Sort Base File and check uniqueness of id variable
use base0007.dta, clear
sort mprop_hh_id
save base0007_sort.dta, replace
by mprop_hh_id: assert _N==1

* Sort Merge File and check uniqueness of id variable
use m_subtable_q24_26_landusecover.dta, clear
gen double mprop_hh_yr_id=mprop_hh_id*100+_26_when
sort mprop_hh_yr_id _26_lot
save m_subtable_q24_26_landusecover_sort.dta, replace

* generate new variable that distinguishes source of information on questionnaire

* fix data coding errors
replace _25_1=. if uniqueid==117
replace _25_2=. if uniqueid==117
replace _25_3=. if uniqueid==117

*drop a noninformative case
drop if uniqueid==1270

replace _24_1=. if _24_1==0
replace _24_2=. if _24_2==0
replace _24_3=. if _24_3==0
replace _24_4=. if _24_4==0
replace _24_5=. if _24_5==0
replace _25_1=. if _25_1==0
replace _25_2=. if _25_2==0
replace _25_3=. if _25_3==0
replace _25_6=. if _25_6==0
replace _25_7=. if _25_7==0

replace _24_4=9999 if (_24_4==. & _24_5!=.)
replace _24_5=9999 if (_24_5==. & _24_4!=.)

replace _24_5=9999 if (_24_5==. & (_24_2!=. | _24_3!=.))
replace _24_4=9999 if (_24_4==. & (_24_2!=. | _24_3!=.))

replace _25_2=9999 if (_25_2==. & _25_3!=.)
replace _25_3=9999 if (_25_3==. & _25_2!=.)
replace _25_2=9999 if (_25_2==. & _25_1!=.)
replace _25_3=9999 if (_25_3==. & _25_1!=.)

gen lottype=1
replace lottype=2 if _24_4!=.
replace lottype=3 if _25_2!=.

save m_subtable_q24_26_landusecover_sort.dta, replace

* Grab general ID variables (CHUNK A)
keep donolote_ mpropid mhouseid mprop_hh_id 
duplicates drop
save chunk_a.dta, replace

* Grab sold land count variables (CHUNK B)
use m_subtable_q24_26_landusecover_sort.dta, clear
keep if _24_3==1
sort mprop_hh_id
collapse (sum) _24_5, by(mprop_hh_id)
rename _24_5 m24_05_sold

save chunk_b_sold.dta, replace

* Grab sold land year variables (CHUNK C)
use m_subtable_q24_26_landusecover_sort.dta, clear
keep if _24_3==1
keep mprop_hh_id _26_lot _24_4 
replace _24_4=. if (_24_4==8888 | _24_4==9999)
replace _26_lot=2 if (mprop_hh_id==715101) & (_24_4==2000)
duplicates drop _24_4 mprop_hh_id, force
reshape wide _24_4, i(mprop_hh_id) j(_26_lot)
tostring _24_41 _24_42 _24_43 _24_44 _24_45, replace
replace _24_41="" if (_24_41==".")
replace _24_42="" if (_24_42==".")
replace _24_43="" if (_24_43==".")
replace _24_44="" if (_24_44==".")
replace _24_45="" if (_24_45==".")
gen _24_4_all = _24_41+" "+_24_42+" "+_24_43+" "+_24_44+" "+_24_45 
replace _24_4_all="" if (_24_4_all=="    ")
replace _24_4_all=trim(_24_4_all)
drop _24_41 _24_42 _24_43 _24_44 _24_45
rename _24_4_all m24_04_sold_year

save chunk_c_sold.dta, replace

* Grab acquired land count variables (CHUNK B)
use m_subtable_q24_26_landusecover_sort.dta, clear
keep if _24_2==1
sort mprop_hh_id
collapse (sum) _24_5, by(mprop_hh_id)
rename _24_5 m24_05_acquired

save chunk_b_acquired.dta, replace

* Grab acquired land year variables (CHUNK C)
use m_subtable_q24_26_landusecover_sort.dta, clear
keep if _24_2==1
keep mprop_hh_id _26_lot _24_4 
replace _24_4=. if (_24_4==8888 | _24_4==9999)
replace _26_lot=3 if (mprop_hh_id==343201) & (_24_4==2000)  
duplicates drop _24_4 mprop_hh_id, force
reshape wide _24_4, i(mprop_hh_id) j(_26_lot)
tostring _24_42 _24_43 _24_44, replace
replace _24_42="" if (_24_42==".")
replace _24_43="" if (_24_43==".")
replace _24_44="" if (_24_44==".")
gen _24_4_all = _24_42+" "+_24_43+" "+_24_44
replace _24_4_all="" if (_24_4_all=="  ")
replace _24_4_all=trim(_24_4_all)
drop _24_41 _24_42 _24_43 _24_44
rename _24_4_all m24_04_acquired_year

save chunk_c_acquired.dta, replace

* Grab other land count variables (CHUNK B)
use m_subtable_q24_26_landusecover_sort.dta, clear
keep if lottype==3
sort mprop_hh_id
replace _25_3=. if (_25_3==9999 | _25_3==999)
collapse (sum) _25_3, by(mprop_hh_id)
rename _25_3 m25_03_other

save chunk_b_other.dta, replace

* Grab other land year variables (CHUNK C)
use m_subtable_q24_26_landusecover_sort.dta, clear
keep if lottype==3
keep mprop_hh_id _26_lot _25_2 
replace _25_2=. if (_25_2==9999)
replace _26_lot=6 if (mprop_hh_id==13403) & (_25_2==1973)  
replace _26_lot=6 if (mprop_hh_id==55205) & (_25_2==2003)  
duplicates drop _25_2 mprop_hh_id, force
reshape wide _25_2, i(mprop_hh_id) j(_26_lot)
tostring _25_26 _25_27 _25_28, replace
replace _25_26="" if (_25_26==".")
replace _25_27="" if (_25_27==".")
replace _25_28="" if (_25_28==".")
gen _25_2_all = _25_26+" "+_25_27+" "+_25_28
replace _25_2_all="" if (_25_2_all=="  ")
replace _25_2_all=trim(_25_2_all)
drop _25_21 _25_26 _25_27 _25_28
rename _25_2_all m25_02_other_year

save chunk_c_other.dta, replace

* Grab string landcover variables (CHUNK D)
use m_subtable_q24_26_landusecover_sort.dta, clear
drop if _26_lot==.

keep _26_6a _26_12a _26_13a _26_15a _26_16a _26_17a mprop_hh_yr_id
rename _26_6a _26_06a
replace _26_06a="" if (_26_06a=="8888" | _26_06a=="9999")
replace _26_12a="" if (_26_12a=="8888" | _26_12a=="9999")
replace _26_13a="" if (_26_13a=="8888" | _26_13a=="9999")
replace _26_15a="" if (_26_15a=="8888" | _26_15a=="9999")
replace _26_16a="" if (_26_16a=="8888" | _26_16a=="9999")
replace _26_17a="" if (_26_17a=="8888" | _26_17a=="9999")

bysort mprop_hh_yr: gen sortvar=_n

reshape wide _26_06a _26_12a _26_13a _26_15a _26_16a _26_17a,  i(mprop_hh_yr_id) j(sortvar)

gen _26_06a_all = _26_06a1+" "+_26_06a2+" "+_26_06a3+" "+_26_06a4+" "+_26_06a5+" "+_26_06a6+ ///
" "+_26_06a7+" "+_26_06a8+" "+_26_06a9+" "+_26_06a10
replace _26_06a_all="" if (_26_06a_all=="         ")

gen _26_12a_all = _26_12a1+" "+_26_12a2+" "+_26_12a3+" "+_26_12a4+" "+_26_12a5+" "+_26_12a6+ ///
" "+_26_12a7+" "+_26_12a8+" "+_26_12a9+" "+_26_12a10
replace _26_12a_all="" if (_26_12a_all=="         ")

gen _26_13a_all = _26_13a1+" "+_26_13a2+" "+_26_13a3+" "+_26_13a4+" "+_26_13a5+" "+_26_13a6+ ///
" "+_26_13a7+" "+_26_13a8+" "+_26_13a9+" "+_26_13a10
replace _26_13a_all="" if (_26_13a_all=="         ")

gen _26_15a_all = _26_15a1+" "+_26_15a2+" "+_26_15a3+" "+_26_15a4+" "+_26_15a5+" "+_26_15a6+ ///
" "+_26_15a7+" "+_26_15a8+" "+_26_15a9+" "+_26_15a10
replace _26_15a_all="" if (_26_15a_all=="         ")

gen _26_16a_all = _26_16a1+" "+_26_16a2+" "+_26_16a3+" "+_26_16a4+" "+_26_16a5+" "+_26_16a6+ ///
" "+_26_16a7+" "+_26_16a8+" "+_26_16a9+" "+_26_16a10
replace _26_16a_all="" if (_26_16a_all=="         ")

gen _26_17a_all = _26_17a1+" "+_26_17a2+" "+_26_17a3+" "+_26_17a4+" "+_26_17a5+" "+_26_17a6+ ///
" "+_26_17a7+" "+_26_17a8+" "+_26_17a9+" "+_26_17a10
replace _26_17a_all="" if (_26_17a_all=="         ")

keep mprop_hh_yr_id _26_06a_all _26_12a_all _26_13a_all _26_15a_all _26_16a_all _26_17a_all 
replace _26_06a_all=trim(_26_06a_all)
replace _26_12a_all=trim(_26_12a_all)
replace _26_13a_all=trim(_26_13a_all)
replace _26_15a_all=trim(_26_15a_all)
replace _26_16a_all=trim(_26_16a_all)
replace _26_17a_all=trim(_26_17a_all)
 
* Rename variables
rename _26_06a_all m26_06a_all
rename _26_12a_all m26_12a_all
rename _26_13a_all m26_13a_all
rename _26_15a_all m26_15a_all
rename _26_16a_all m26_16a_all
rename _26_17a_all m26_17a_all

save chunk_d.dta, replace

* Grab numeric landcover variables (CHUNK E)
use m_subtable_q24_26_landusecover_sort.dta, clear

mvdecode _26_1 _26_2 _26_3 _26_4 _26_5 _26_6 _26_7 _26_8 _26_9 _26_10 _26_11 _26_12 _26_13 _26_14 ///
_26_15 _26_16 _26_17 _26_18 _26_19 _26_20 _26_21 _26_22 _26_23 _26_24, mv(8888 9999)

* This code preserves any missing data coding during sum collapse function
forvalues k =1/24 {
		by mprop_hh_yr_id: egen nt_26_`k'=total(_26_`k'>-1)
		by mprop_hh_yr_id: egen nm_26_`k'=total(_26_`k'==.)
		gen mr_26_`k'=(nm_26_`k'/nt_26_`k')
		}

drop nt* nm*

collapse (sum) _26_1 _26_2 _26_3 _26_4 _26_5 _26_6 _26_7 _26_8 _26_9 _26_10 _26_11 _26_12 _26_13 ///
_26_14 _26_15 _26_16 _26_17 _26_18 _26_19 _26_20 _26_21 _26_22 _26_23 _26_24  ///
(first) mr_26_1 mr_26_2 mr_26_3 mr_26_4 mr_26_5 mr_26_6 mr_26_7 mr_26_8 mr_26_9 mr_26_10 mr_26_11 ///
mr_26_12 mr_26_13 mr_26_14 mr_26_15 mr_26_16 mr_26_17 mr_26_18 mr_26_19 mr_26_20 mr_26_21 mr_26_22 ///
mr_26_23 mr_26_24, by(mprop_hh_yr_id)

forvalues k = 1/24 {
		replace _26_`k'=9999 if mr_26_`k'==1
}

drop mr*

save chunk_e.dta, replace

use chunk_d.dta, clear

merge 1:1 mprop_hh_yr_id using chunk_e.dta, update
drop _merge

gen mprop_hh_id=round(mprop_hh_yr_id/100)
tostring mprop_hh_yr_id, replace
gen year=substr(mprop_hh_yr_id,-2,2)
destring year, replace
drop mprop_hh_yr_id

rename _26_1 _26_01
rename _26_2 _26_02
rename _26_3 _26_03
rename _26_4 _26_04
rename _26_5 _26_05
rename _26_6 _26_06
rename _26_7 _26_07
rename _26_8 _26_08
rename _26_9 _26_09

* The following line, along with the commenting-out of the section that follows, results in
* only the data on the hh's lots at present being retained (at time acquired is dropped). If
* it is desirable in the future to retain this information, comment out the following line
* and remove commenting from the section that follows - result will be two variables for each
* class of land, etc. - _26_XX1 for when acquired and _26_XX2 for the present day

drop if year==1
rename year m26_present
replace m26_present=1 if m26_present==2

* reshape wide _26_01 _26_02 _26_03 _26_04 _26_05 _26_06 _26_07 _26_08 _26_09 _26_10 _26_11 _26_12 ///
* _26_13 _26_14 _26_15 _26_16 _26_17 _26_18 _26_19 _26_20 _26_21 _26_22 _26_23 _26_24 _26_06a_all ///
* _26_12a_all _26_13a_all _26_15a_all _26_16a_all _26_17a_all, i(mprop_hh_id) j(year)

forvalues k = 1/9 {
rename _26_0`k' m26_0`k'
}

forvalues k = 10/24 {
rename _26_`k' m26_`k'
}

save chunk_de.dta, replace

use chunk_b_sold.dta, clear
merge 1:1 mprop_hh_id using chunk_c_sold.dta, update
drop _merge

save chunk_bc_sold.dta, replace

use chunk_b_acquired.dta, clear
merge 1:1 mprop_hh_id using chunk_c_acquired.dta, update
drop _merge

save chunk_bc_acquired.dta, replace

use chunk_b_other.dta, clear
merge 1:1 mprop_hh_id using chunk_c_other.dta, update
drop _merge

save chunk_bc_other.dta, replace

use chunk_de.dta, clear
merge 1:1 mprop_hh_id using chunk_bc_sold.dta, update
drop _merge
merge 1:1 mprop_hh_id using chunk_bc_acquired.dta, update
drop _merge
merge 1:1 mprop_hh_id using chunk_bc_other.dta, update
drop _merge

replace m24_04_acquired_year="9998" if m24_04_acquired_year==""
replace m24_04_sold_year="9998" if m24_04_sold_year==""
replace m25_02_other_year="9998" if m25_02_other_year==""

replace m24_05_acquired=9998 if m24_05_acquired==.
replace m24_05_sold=9998 if m24_05_sold==.
replace m25_03_other=9998 if m25_03_other==.

save chunk_bcde.dta, replace

use chunk_a.dta, clear
merge 1:1 mprop_hh_id using chunk_bcde.dta, update
drop _merge

sort mprop_hh_id
order _all, seq

save chunk_all_sort.dta, replace

* Compare All Common Variables between Base (Master) and Merge (Using) File
* NOTE: Comment out cf command after identifying any errors
use base0007_sort.dta, clear

* cf _all using chunk_all_sort.dta, verbose

* If necessary, correct any mismatched variable issues revealed above before merging
use chunk_all_sort.dta, clear
replace mprop_hh_id=62202 if mprop_hh_id==62203
save chunk_all_sort.dta, replace

*Merge files (with extra consistency checks) and check for any id problems
use base0007_sort.dta, clear
merge 1:1 mprop_hh_id using chunk_all_sort.dta, update
by mprop_hh_id: assert _N==1
tab _merge
drop _merge

* Summary Report: merging #NEWFILE.dta --> #base0000.dta
describe, short

*reorder variables
order _all, seq
save base0008.dta, replace

***************************************************************************************************
* Merge m_subtable_q28_production.dta --> base0008.dta
*******************************************************

* Sort Base File and check uniqueness of id variable
use base0008.dta, clear
sort mprop_hh_id
save base0008_sort.dta, replace
by mprop_hh_id: assert _N==1

* Sort Merge File and check uniqueness of id variable
use m_subtable_q28_production.dta, clear
sort mprop_hh_id _28_1

* drop excess
drop unique donolote_ mpropid mhouseid _28_b_qt

* create single string variable for all units (was two var's)
gen str _28_a_temp=" "

replace _28_a_temp="head" if _28_a==1
replace _28_a_temp="litre" if _28_a==2
replace _28_a_temp="kg" if _28_a==3
replace _28_a_temp="sack (60kg)" if _28_a==4
replace _28_a_temp="bunch" if _28_a==5
replace _28_a_temp="thousand" if _28_a==6
replace _28_a_temp=_28_aa if _28_a==7
replace _28_a_temp="9999" if (_28_a==9 | _28_a==.)

drop _28_a _28_aa
rename _28_a_temp _28_a

* fix coding errors in _24_c (code 8 is a single weird missing data situation)

recode _28_c (0=9999) (9=9999) (8=9999)
replace _28_1a="9998" if _28_1a=="nao chegou a colher nenhuma safra ate o momento"
replace _28_d=0 if _28_c==1
replace _28_d=9999 if (_28_c==4 & _28_d==0)
replace _28_d=9999 if _28_d==9
replace _28_d=9999 if _28_c==9999
replace _28_d=9999 if (_28_c==2 & _28_d==0)
replace _28_d=8888 if (_28_d==0)

* fix coding errors in _24_b
replace _28_b="9999" if _28_b=="nova"
replace _28_b="9999" if _28_b=="19999"
replace _28_b="9999" if _28_b==""
replace _28_b="1000" if _28_b=="1,000"
replace _28_b="1400" if _28_b=="1,400"
replace _28_b="15000" if _28_b=="15,000"
replace _28_b="20" if _28_b=="20 (milheiro)"
replace _28_b="3000" if _28_b=="3,000"
replace _28_b="3600" if _28_b=="3,600"
replace _28_b="50" if _28_b=="50 sacs"
replace _28_b="2190" if _28_b=="6/dia"
replace _28_b="364" if _28_b=="999 (7/semana"
replace _28_b="780" if _28_b=="9999 (15/semana)"

replace _28_a="head" if (_28_b=="8888" & _28_a=="kg")

destring _28_b, replace

* fix coding errors in _24_1a

replace _28_1a="9998" if _28_1a==""

* create single string variable for all units (was two var's)
gen str _28_d_temp=" "

replace _28_d_temp="9998" if _28_d==8888
replace _28_d_temp="local market" if _28_d==1
replace _28_d_temp="Santarem" if _28_d==2
replace _28_d_temp="neighbors" if _28_d==3
replace _28_d_temp=_28_da if _28_d==4
replace _28_d_temp="9999" if (_28_d==9999 | _28_d==.)

drop _28_d _28_da
rename _28_d_temp _28_d

* recode _28_1 others
replace _28_1=28 if (_28_1>28)

*rename variables to conform with convention used elsewhere
order _all, seq

foreach var of varlist _28_1-_28_g {
		local short = substr("`var'", 2, 5)
		rename `var' m`short'
}

*recode product to string in preparation for string-based reshape

*Find non-uniquely identified cases (FAILS test, by #ID: assert _N==1)
bysort mprop_hh_id m28_1: gen a=_N
sort a mprop_hh_id
drop a

* delete problem #1 - duplicate entry (cross-checked against _28_29e)
duplicates drop _all, force

save midway_0001.dta, replace

* fix problem #2 - some "citrus" (coded 25 for _28_1) listed seperately (e.g. limes, oranges, etc.)
replace m28_1a="citrus" if m28_1==25

collapse (sum) m28_b m28_e m28_f m28_g (first) m28_1a m28_a m28_c m28_d, by(mprop_hh_id m28_1), if m28_1==25

save citrus.dta, replace

use midway_0001.dta, clear
drop if m28_1==25
append using citrus.dta

* fix problem #3 - multiple instances of "beans" for same HHs (coded 24 for _28_1)
save midway_0002.dta, replace

collapse (sum) m28_b m28_e m28_f m28_g (first) m28_1a m28_a m28_c m28_d, by(mprop_hh_id m28_1), if (m28_1==14 & (mprop_hh_id==483102 | mprop_hh_id==774101))

save beans.dta, replace

use midway_0002.dta, clear
drop if m28_1==14 & (mprop_hh_id==483102 | mprop_hh_id==774101)
append using beans.dta

* fix problem #4 - multiple instances of "corn" for same HHs (coded 15 for _28_1)
save midway_0003.dta, replace

collapse (sum) m28_b m28_e m28_f m28_g (first) m28_1a m28_a m28_c m28_d, by(mprop_hh_id m28_1), if (m28_1==15 & mprop_hh_id==445701)

save corn.dta, replace

use midway_0003.dta, clear
drop if m28_1==15 & mprop_hh_id==445701
append using corn.dta

* fix problem #5 - multiple instances of "other" (coded 28 for _28_1)
bysort mprop_hh_id m28_1: gen a=_n
sort mprop_hh_id m28_1 a

replace m28_1=29 if a==2
replace m28_1=30 if a==3
replace m28_1=31 if a==4
replace m28_1=32 if a==5
replace m28_1=33 if a==6

drop a

*one more rename to insert extra spacer

foreach var of varlist m28_1a-m28_g {
		local front = substr("`var'", 1, 4)
		local back = substr("`var'", 5, 3)
		rename `var' `front'_`back'
}

* rename variable stubs (ie recode variable) to strings to make new variable names more understandable

gen m28_1text=""

replace m28_1text="9998" if m28_1==8888
replace m28_1text="cattle" if m28_1==1
replace m28_1text="milk" if m28_1==2
replace m28_1text="cheese" if m28_1==3
replace m28_1text="fish" if m28_1==4
replace m28_1text="poultry" if m28_1==5
replace m28_1text="swine" if m28_1==6
replace m28_1text="horse" if m28_1==7
replace m28_1text="coffee" if m28_1==8
replace m28_1text="cocoa" if m28_1==9
replace m28_1text="pepper" if m28_1==10
replace m28_1text="banana" if m28_1==11
replace m28_1text="rubber" if m28_1==12
replace m28_1text="rice" if m28_1==13
replace m28_1text="beans" if m28_1==14
replace m28_1text="corn" if m28_1==15
replace m28_1text="manioc" if m28_1==16
replace m28_1text="flour" if m28_1==17
replace m28_1text="tucupi" if m28_1==18
replace m28_1text="tapioca" if m28_1==19
replace m28_1text="vine" if m28_1==20
replace m28_1text="cupu" if m28_1==21
replace m28_1text="pupunha" if m28_1==22
replace m28_1text="guarana" if m28_1==23
replace m28_1text="cashewfr" if m28_1==24
replace m28_1text="citrus" if m28_1==25
replace m28_1text="honey" if m28_1==26
replace m28_1text="passion" if m28_1==27
replace m28_1text="other1" if m28_1==28
replace m28_1text="other2" if m28_1==29
replace m28_1text="other3" if m28_1==30
replace m28_1text="other4" if m28_1==31
replace m28_1text="other5" if m28_1==32
replace m28_1text="other6" if m28_1==33

drop m28_1

rename m28__1a m28__name

* reshape data to wide (at last!)
reshape wide m28_@_name m28_@_a m28_@_b m28_@_c m28_@_d m28_@_e m28_@_f m28_@_g, i(mprop_hh_id) j(m28_1text) string

* drop unneccesary variables (every name variable except for the other groups) - NO GUARANA...
drop m28_cattle_name m28_milk_name m28_cheese_name m28_fish_name m28_poultry_name m28_swine_name ///
m28_horse_name m28_coffee_name m28_pepper_name m28_banana_name m28_rubber_name m28_rice_name ///
m28_beans_name m28_corn_name m28_manioc_name m28_flour_name m28_tucupi_name m28_tapioca_name ///
m28_vine_name m28_cupu_name m28_pupunha_name m28_cashewfr_name m28_honey_name m28_passion_name 

sort mprop_hh_id
save midway0004.dta, replace

* add empty identifiers for HHs that had no production data - pull from base0008 to be safe
use base0008.dta, clear
sort mprop_hh_id
keep mprop_hh_id

merge 1:1 mprop_hh_id using midway0004.dta, update replace
drop _merge

save midway0005.dta, replace

* recode automatically generated missing values (from merge and reshape) to something meaningful

order _all, seq

foreach var of varlist m28_banana_a-m28_vine_g {
		if (substr("`var'",-2,2)=="_b" | substr("`var'",-2,2)=="_c" | substr("`var'",-2,2)=="_e" | ///
		substr("`var'",-2,2)=="_f" | substr("`var'",-2,2)=="_g") {
		replace `var'=9998 if `var'==. 
		}
}

order mprop_hh_id, before(m28_banana_a)

save midway0006.dta, replace

* get livestock count data for Q28 from other location
use base0008_sort.dta
keep mprop_hh_id m28_29*
sort mprop_hh_id
save livestock_data.dta, replace

* drop livestock count data from main file once grabbed
use base0008_sort.dta
drop m28_29*
save base0008_sort.dta, replace

use midway0006.dta, clear

merge 1:1 mprop_hh_id using livestock_data.dta, update replace

* clean up data inconsistencies for cattle
replace m28_29a=. if m28_29a==9999 
replace m28_29b=. if m28_29b==9999 
replace m28_29c=. if m28_29c==9999 
replace m28_cattle_b=m28_29a+m28_29b+m28_29c
replace m28_cattle_b=9999 if m28_cattle_b==.

replace m28_cattle_a="head" if (m28_cattle_b>0 & (m28_cattle_a=="" | m28_cattle_a=="9998"))
replace m28_cattle_a="9999" if m28_cattle_b==9999
replace m28_cattle_c=9999 if ((m28_cattle_b>0 & m28_cattle_c==9998) | m28_cattle_b==9999)
replace m28_cattle_d="9998" if (m28_cattle_b>0 & m28_cattle_c==1 & (m28_cattle_d=="" | m28_cattle_d=="9998"))
replace m28_cattle_d="9999" if (m28_cattle_b>0 & m28_cattle_c!=1 & (m28_cattle_d=="" | m28_cattle_d=="9998"))
replace m28_cattle_d="9999" if m28_cattle_b==9999
replace m28_cattle_e=9999 if ((m28_cattle_b>0 & m28_cattle_e==9998) | m28_cattle_b==9999)
replace m28_cattle_f=9999 if ((m28_cattle_b>0 & m28_cattle_f==9998) | m28_cattle_b==9999)
replace m28_cattle_g=9999 if ((m28_cattle_b>0 & m28_cattle_g==9998) | m28_cattle_b==9999)

replace m28_cattle_d="" if m28_cattle_b==0
replace m28_cattle_a="" if m28_cattle_b==0
replace m28_cattle_c=9998 if m28_cattle_b==0
replace m28_cattle_e=9998 if m28_cattle_b==0
replace m28_cattle_f=9998 if m28_cattle_b==0
replace m28_cattle_g=9998 if m28_cattle_b==0

* clean up data inconsistencies for poultry

replace m28_29d=. if m28_29d==9999 
replace m28_poultry_b=m28_29d
replace m28_poultry_b=9999 if m28_poultry_b==.

replace m28_poultry_a="head" if (m28_poultry_b>0 & (m28_poultry_a=="" | m28_poultry_a=="9998"))
replace m28_poultry_a="9999" if m28_poultry_b==9999
replace m28_poultry_c=9999 if ((m28_poultry_b>0 & m28_poultry_c==9998) | m28_poultry_b==9999)
replace m28_poultry_d="9998" if (m28_poultry_b>0 & m28_poultry_c==1 & (m28_poultry_d=="" | m28_poultry_d=="9998"))
replace m28_poultry_d="9999" if (m28_poultry_b>0 & m28_poultry_c!=1 & (m28_poultry_d=="" | m28_poultry_d=="9998"))
replace m28_poultry_d="9999" if m28_poultry_b==9999
replace m28_poultry_e=9999 if ((m28_poultry_b>0 & m28_poultry_e==9998) | m28_poultry_b==9999)
replace m28_poultry_f=9999 if ((m28_poultry_b>0 & m28_poultry_f==9998) | m28_poultry_b==9999)
replace m28_poultry_g=9999 if ((m28_poultry_b>0 & m28_poultry_g==9998) | m28_poultry_b==9999)

replace m28_poultry_d="" if m28_poultry_b==0
replace m28_poultry_a="" if m28_poultry_b==0
replace m28_poultry_c=9998 if m28_poultry_b==0
replace m28_poultry_e=9998 if m28_poultry_b==0
replace m28_poultry_f=9998 if m28_poultry_b==0
replace m28_poultry_g=9998 if m28_poultry_b==0

* clean up data inconsistencies for swine

replace m28_29e=. if m28_29e==9999 
replace m28_swine_b=m28_29e
replace m28_swine_b=9999 if m28_swine_b==.

replace m28_swine_a="head" if (m28_swine_b>0 & (m28_swine_a=="" | m28_swine_a=="9998"))
replace m28_swine_a="9999" if m28_swine_b==9999
replace m28_swine_c=9999 if ((m28_swine_b>0 & m28_swine_c==9998) | m28_swine_b==9999)
replace m28_swine_d="9998" if (m28_swine_b>0 & m28_swine_c==1 & (m28_swine_d=="" | m28_swine_d=="9998"))
replace m28_swine_d="9999" if (m28_swine_b>0 & m28_swine_c!=1 & (m28_swine_d=="" | m28_swine_d=="9998"))
replace m28_swine_d="9999" if m28_swine_b==9999
replace m28_swine_e=9999 if ((m28_swine_b>0 & m28_swine_e==9998) | m28_swine_b==9999)
replace m28_swine_f=9999 if ((m28_swine_b>0 & m28_swine_f==9998) | m28_swine_b==9999)
replace m28_swine_g=9999 if ((m28_swine_b>0 & m28_swine_g==9998) | m28_swine_b==9999)

replace m28_swine_d="" if m28_swine_b==0
replace m28_swine_a="" if m28_swine_b==0
replace m28_swine_c=9998 if m28_swine_b==0
replace m28_swine_e=9998 if m28_swine_b==0
replace m28_swine_f=9998 if m28_swine_b==0
replace m28_swine_g=9998 if m28_swine_b==0

* clean up data inconsistencies for horses

replace m28_29f=. if m28_29f==9999 
replace m28_horse_b=m28_29f
replace m28_horse_b=9999 if m28_horse_b==.

replace m28_horse_a="head" if (m28_horse_b>0 & (m28_horse_a=="" | m28_horse_a=="9998"))
replace m28_horse_a="9999" if m28_horse_b==9999
replace m28_horse_c=9999 if ((m28_horse_b>0 & m28_horse_c==9998) | m28_horse_b==9999)
replace m28_horse_d="9998" if (m28_horse_b>0 & m28_horse_c==1 & (m28_horse_d=="" | m28_horse_d=="9998"))
replace m28_horse_d="9999" if (m28_horse_b>0 & m28_horse_c!=1 & (m28_horse_d=="" | m28_horse_d=="9998"))
replace m28_horse_d="9999" if m28_horse_b==9999
replace m28_horse_e=9999 if ((m28_horse_b>0 & m28_horse_e==9998) | m28_horse_b==9999)
replace m28_horse_f=9999 if ((m28_horse_b>0 & m28_horse_f==9998) | m28_horse_b==9999)
replace m28_horse_g=9999 if ((m28_horse_b>0 & m28_horse_g==9998) | m28_horse_b==9999)

replace m28_horse_d="" if m28_horse_b==0
replace m28_horse_a="" if m28_horse_b==0
replace m28_horse_c=9998 if m28_horse_b==0
replace m28_horse_e=9998 if m28_horse_b==0
replace m28_horse_f=9998 if m28_horse_b==0
replace m28_horse_g=9998 if m28_horse_b==0

* clean up
drop m28_29* _merge

sort mprop_hh_id

save midway0007_sort.dta, replace
by mprop_hh_id: assert _N==1

* Compare All Common Variables between Base (Master) and Merge (Using) File
* NOTE: Comment out cf command after identifying any errors
use base0008_sort.dta, clear
* cf _all using midway0007_sort.dta, verbose

* If necessary, correct any mismatched variable issues revealed above before merging

*Merge files (with extra consistency checks) and check for any id problems
use base0008_sort.dta, clear
merge 1:1 mprop_hh_id using midway0007_sort.dta, update
by mprop_hh_id: assert _N==1
tab _merge
drop _merge

order _all, seq

* Summary Report: merging m_subtable_q28_production.dta --> base0008.dta
describe, short

save base0009.dta, replace

***************************************************************************************************
* Merge  m_subtable_q47_rentpasture.dta--> base0009.dta
*******************************************************

* Sort Base File and check uniqueness of id variable
use base0009.dta, clear
sort mprop_hh_id
save base0009_sort.dta, replace
by mprop_hh_id: assert _N==1

* Sort Merge File and check uniqueness of id variable
* For kicks, will simply process the qno=1 and qno=0 responses separately

* qno=1 (terra firma)
use m_subtable_q47_rentpasture.dta, clear
sort mprop_hh_id

keep if qno==1
keep mprop_hh_id trent ttransp totalcost

* no missing recodes needed

by mprop_hh_id: gen m47_1_numyr=_N
collapse (sum) trent ttransp totalcost (mean) m47_1_numyr, by(mprop_hh_id)

rename trent m47_2_rent
rename ttransp m47_3_transp
rename totalcost m47_4_total

save terra.dta, replace

* qno=0 (floodplains)
use m_subtable_q47_rentpasture.dta, clear
sort mprop_hh_id

keep if qno==0
keep mprop_hh_id trent ttransp totalcost

* missing recodes

replace trent=. if trent==9999
replace totalcost=. if totalcost==9999

gen misvalue=0
replace misvalue=1 if (trent==. |totalcost==.)

by mprop_hh_id: gen m50_1_numyr=_N
collapse (sum) trent ttransp totalcost (mean) m50_1_numyr (mean) misvalue, by(mprop_hh_id)

replace trent=9999 if misvalue>0
replace totalcost=9999 if misvalue>0
drop misvalue

rename trent m50_2_rent
rename ttransp m50_3_transp
rename totalcost m50_4_total

save flood.dta, replace

* grab and reshape location data for floodplains
use m_subtable_q47_rentpasture.dta, clear
sort mprop_hh_id

keep if qno==0
keep mprop_hh_id year where

rename where m50_5_where_

reshape wide m50_5_where_, i(mprop_hh_id) j(year)

merge 1:1 mprop_hh_id using flood.dta, update replace
drop _merge
 
save flood.dta, replace

* Add other hhs to both files and code missing
use base0009.dta, clear
sort mprop_hh_id
keep mprop_hh_id

merge 1:1 mprop_hh_id using flood.dta, update replace
drop _merge
merge 1:1 mprop_hh_id using terra.dta, update replace
drop _merge

* Recode Missing/NA to conform with new standards

order _all, seq

foreach var of varlist m47_1_numyr-m50_4_total {
		replace `var'=9998 if `var'==.
}

foreach var of varlist m50_5_where_1998-m50_5_where_2003 {
		replace `var'="9998" if `var'==""
}

save m_subtable_q47_rentpasture_sort.dta, replace
by mprop_hh_id: assert _N==1

* Compare All Common Variables between Base (Master) and Merge (Using) File
* NOTE: Comment out cf command after identifying any errors
* use base0009_sort.dta, clear
* cf _all using m_subtable_q47_rentpasture_sort.dta, verbose

* If necessary, correct any mismatched variable issues revealed above before merging

*Merge files (with extra consistency checks) and check for any id problems
use base0009_sort.dta, clear
merge 1:1 mprop_hh_id using m_subtable_q47_rentpasture_sort.dta, update
by mprop_hh_id: assert _N==1
tab _merge
drop _merge

* Summary Report: merging m_subtable_q47_rentpasture.dta --> base0010.dta
describe, short
order _all, seq
save base0010.dta, replace

***************************************************************************************************
* Merge m_subtable_q53_timber.dta --> base0010.dta
*******************************************************

* Sort Base File and check uniqueness of id variable
use base0010.dta, clear
sort mprop_hh_id
save base0010_sort.dta, replace
by mprop_hh_id: assert _N==1

* Sort Merge File and check uniqueness of id variable
use m_subtable_q53_timber.dta, clear
sort mprop_hh_id _53_1 _53_2

* drop extraneous variables

drop unique donolote_ mpropid mhouseid 

* Rename variables to conform to standard

rename _53_1 m53_wood_1
rename _53_2 m53_wood_2
rename _53_3 m53_wood_3
rename _53_4 m53_wood_4
rename _53_5 m53_wood_5

* Reshape data file

by mprop_hh_id: gen tempid=_n

reshape wide m53_wood@_1 m53_wood@_2 m53_wood@_3 m53_wood@_4 m53_wood@_5, i(mprop_hh_id) j(tempid)

* Recode Missing

foreach var of varlist m53_wood1_1-m53_wood4_5 {
		if (substr("`var'",-2,2)=="_1" | substr("`var'",-2,2)=="_3" | substr("`var'",-2,2)=="_5" ) {
		replace `var'=9998 if `var'==. 
		}
		if (substr("`var'",-2,2)=="_2" | substr("`var'",-2,2)=="_4") {
		replace `var'="9998" if `var'=="" 
		}
}

save timber.dta, replace

* Add other hhs to both files and code missing
use base0010.dta, clear
sort mprop_hh_id
keep mprop_hh_id

merge 1:1 mprop_hh_id using timber.dta, update replace
drop _merge

* Recode Missing

foreach var of varlist m53_wood1_1-m53_wood4_5 {
		if (substr("`var'",-2,2)=="_1" | substr("`var'",-2,2)=="_3" | substr("`var'",-2,2)=="_5" ) {
		replace `var'=9998 if `var'==. 
		}
		if (substr("`var'",-2,2)=="_2" | substr("`var'",-2,2)=="_4") {
		replace `var'="9998" if `var'=="" 
		}
}

save m_subtable_q53_timber_sort.dta, replace
by mprop_hh_id: assert _N==1

* Compare All Common Variables between Base (Master) and Merge (Using) File
* NOTE: Comment out 2 command after identifying any errors
* use base0010_sort.dta, clear
* cf _all using m_subtable_q53_timber_sort.dta, verbose

* If necessary, correct any mismatched variable issues revealed above before merging

*Merge files (with extra consistency checks) and check for any id problems
use base0010_sort.dta, clear
merge 1:1 mprop_hh_id using m_subtable_q53_timber_sort.dta, update
by mprop_hh_id: assert _N==1
tab _merge
drop _merge

* Summary Report: m_subtable_q53_timber.dta --> base0010.dta
describe, short

*recode two other variables related to timber

recode m53_1 (8=9998) (9=9999)
recode m53_2 (8=9998) (9=9999) (0=9998)

* And cross-check variable agreement between main survey items and subtable

replace m53_1=0 if (m53_wood1_1==9998 & m53_wood2_1==9998 & m53_wood3_1==9998 & m53_wood4_1==9998)
replace m53_2=9998 if (m53_wood1_1==9998 & m53_wood2_1==9998 & m53_wood3_1==9998 & m53_wood4_1==9998)

replace m53_1=1 if (m53_1==0 & (m53_wood1_1!=9998 | m53_wood2_1!=9998 & m53_wood3_1!=9998 & m53_wood4_1!=9998))
replace m53_2=9999 if (m53_2==9998 & (m53_wood1_1!=9998 | m53_wood2_1!=9998 & m53_wood3_1!=9998 & m53_wood4_1!=9998))

order _all, seq
save base0011.dta, replace

***************************************************************************************************
* Merge m_subtable_q68_technology.dta --> base0011.dta
*******************************************************

* Sort Base File and check uniqueness of id variable
use base0011.dta, clear
sort mprop_hh_id
save base0011_sort.dta, replace
by mprop_hh_id: assert _N==1

* Sort Merge File and check uniqueness of id variable
use m_subtable_q68_technology.dta, clear
sort mprop_hh_id _68_1

* drop excess
drop unique donolote_ mpropid mhouseid

*rename variables to conform with convention used elsewhere
order _all, seq

foreach var of varlist _68_1-_68_5 {
		local short = substr("`var'", 5, 3)
		rename `var' m68__`short'
}

* fix multiple instances of "other" (coded 21 for m68__1)
bysort mprop_hh_id m68__1: gen a=_n
sort mprop_hh_id m68__1 a

replace m68__1=22 if a==2
replace m68__1=23 if a==3

drop a

* Recode N/A

replace m68__4=9998 if (m68__3==0)

* Deal with possible entry error by deleting entirely noninformative cases (n=3)
drop if m68__1==0

* rename variable stubs (ie recode variable) to strings to make new variable names more understandable

gen m68_1text=""

replace m68_1text="animaldisc" if m68__1==1
replace m68_1text="animalplow" if m68__1==2
replace m68_1text="animalcart" if m68__1==3
replace m68_1text="caminhao" if m68__1==4
replace m68_1text="tractor" if m68__1==5
replace m68_1text="disc" if m68__1==6
replace m68_1text="plow" if m68__1==7
replace m68_1text="cart" if m68__1==8
replace m68_1text="chainsaw" if m68__1==9
replace m68_1text="waterengine" if m68__1==10
replace m68_1text="generator" if m68__1==11
replace m68_1text="insecticides" if m68__1==12
replace m68_1text="fungicides" if m68__1==13
replace m68_1text="herbicides" if m68__1==14
replace m68_1text="chemfertilizer" if m68__1==15
replace m68_1text="orgfertilizer" if m68__1==16
replace m68_1text="mineralsalt" if m68__1==17
replace m68_1text="animalmeds" if m68__1==18
replace m68_1text="scythe" if m68__1==19
replace m68_1text="seeder" if m68__1==20
replace m68_1text="othertech1" if m68__1==21
replace m68_1text="othertech2" if m68__1==22
replace m68_1text="othertech3" if m68__1==23


drop m68__1

rename m68__1a m68__name

* reshape data to wide
reshape wide m68_@_name m68_@_2 m68_@_3 m68_@_4 m68_@_5, i(mprop_hh_id) j(m68_1text) string

* drop unneccesary variables (every name variable except for the other groups) - NO GUARANA...
drop m68_animaldisc_name m68_animalplow_name m68_animalcart_name m68_caminhao_name m68_tractor_name /// 
m68_disc_name m68_plow_name m68_cart_name m68_chainsaw_name m68_waterengine_name m68_generator_name ///
m68_insecticides_name m68_fungicides_name m68_herbicides_name m68_chemfertilizer_name m68_orgfertilizer_name ///
m68_mineralsalt_name m68_animalmeds_name m68_scythe_name m68_seeder_name

order _all, seq

foreach var of varlist m68_animalcart_2-m68_waterengine_5 {
		if (substr("`var'",-2,2)=="_2" | substr("`var'",-2,2)=="_3" | ///
		substr("`var'",-2,2)=="_4" | substr("`var'",-2,2)=="_5" ) {
		replace `var'=9998 if `var'==. 
		}
		if (substr("`var'",-5,5)=="_name") {
		replace `var'="9998" if `var'=="" 
		}
}

sort mprop_hh_id

save timber.dta, replace

use base0011.dta, clear
keep mprop_hh_id
sort mprop_hh_id
merge 1:1 mprop_hh_id using timber.dta, update replace
drop _merge

order _all, seq

foreach var of varlist m68_animalcart_2-m68_waterengine_5 {
		if (substr("`var'",-2,2)=="_2" | substr("`var'",-2,2)=="_3" | ///
		substr("`var'",-2,2)=="_4" | substr("`var'",-2,2)=="_5" ) {
		replace `var'=9998 if `var'==.
		}
		if (substr("`var'",-5,5)=="_name") {
		replace `var'="9998" if `var'=="" 
		}
}

save m_subtable_q68_technology_sort.dta, replace
by mprop_hh_id: assert _N==1

* Compare All Common Variables between Base (Master) and Merge (Using) File
* NOTE: Comment out 2 command after identifying any errors
* use base0011_sort.dta, clear
* cf _all using m_subtable_q68_technology_sort.dta, verbose

* If necessary, correct any mismatched variable issues revealed above before merging

*Merge files (with extra consistency checks) and check for any id problems
use base0011_sort.dta, clear
merge 1:1 mprop_hh_id using m_subtable_q68_technology_sort.dta, update
by mprop_hh_id: assert _N==1
tab _merge
drop _merge
order _all, seq

* Summary Report: merging m_subtable_q68_technology.dta --> base0011.dta
describe, short
save base0012.dta, replace

***************************************************************************************************
* Merge m_subtable_q75_credit.dta --> base0012.dta
*******************************************************

* Sort Base File and check uniqueness of id variable
use base0012.dta, clear
sort mprop_hh_id
save base0012_sort.dta, replace
by mprop_hh_id: assert _N==1

* Sort Merge File and check uniqueness of id variable
use m_subtable_q75_credit.dta, clear
sort mprop_hh_id

* drop excess
drop unique donolote_ mpropid mhouseid

* recode string values to numeric for variable m75_cr_8 (future name)

replace _75_8="5" if _75_8=="5 amos"
replace _75_8="3" if _75_8=="3 anos de carencia"
replace _75_8="9999" if _75_8==""

destring _75_8, replace

order _all, seq

foreach var of varlist _75_1-_75_9 {
		local short = substr("`var'", 5, 1)
		rename `var' m75_cr_`short'
}

* reshape data to wide
reshape wide m75_cr@_2 m75_cr@_3 m75_cr@_4 m75_cr@_6 m75_cr@_7 m75_cr@_8 m75_cr@_9, i(mprop_hh_id) j(m75_cr_1)

order _all, seq

foreach var of varlist m75_cr1_2-m75_cr3_9 {
		if (substr("`var'",-2,2)=="_3" | substr("`var'",-2,2)=="_4" | ///
		substr("`var'",-2,2)=="_7" | substr("`var'",-2,2)=="_8" | substr("`var'",-2,2)=="_9") {
		replace `var'=9998 if `var'==. 
		}
		if (substr("`var'",-2,2)=="_2" | substr("`var'",-2,2)=="_6") {
		replace `var'="9998" if `var'=="" 
		}
}

sort mprop_hh_id

save rental.dta, replace

* Merge on identifiers for HHs with no rental data
use base0011.dta, clear
keep mprop_hh_id
sort mprop_hh_id
merge 1:1 mprop_hh_id using rental.dta, update replace
drop _merge

order _all, seq

foreach var of varlist m75_cr1_2-m75_cr3_9 {
		if (substr("`var'",-2,2)=="_3" | substr("`var'",-2,2)=="_4" | ///
		substr("`var'",-2,2)=="_7" | substr("`var'",-2,2)=="_8" | substr("`var'",-2,2)=="_9") {
		replace `var'=9998 if `var'==. 
		}
		if (substr("`var'",-2,2)=="_2" | substr("`var'",-2,2)=="_6") {
		replace `var'="9998" if `var'=="" 
		}
}

save m_subtable_q75_credit_sort.dta, replace
by mprop_hh_id: assert _N==1

* Compare All Common Variables between Base (Master) and Merge (Using) File
* NOTE: Comment out 2 command after identifying any errors
* use base0011_sort.dta, clear
* cf _all using m_subtable_q75_credit_sort.dta, verbose

* If necessary, correct any mismatched variable issues revealed above before merging

*Merge files (with extra consistency checks) and check for any id problems
use base0012_sort.dta, clear
merge 1:1 mprop_hh_id using m_subtable_q75_credit_sort.dta, update
by mprop_hh_id: assert _N==1
tab _merge
drop _merge
order _all, seq

* Cross-check against variable m75 in base data stream

replace m75=1 if m75_cr1_8!=9998
replace m75=0 if m75_cr1_8==9998

* Summary Report: merging m_subtable_q75_credit.dta --> base0012.dta

describe, short
save base0013.dta, replace

***************************************************************************************************
* Merge w_subtable_q100_household_characteristics.dta --> base0013.dta
*******************************************************

* Sort Base File and check uniqueness of id variable
use base0013.dta, clear
sort wintrno
save base0013_sort.dta, replace
by wintrno: assert _N==1

* Sort Merge File and check uniqueness of id variable
use w_subtable_q100_household_characteristics.dta, clear
sort wintrno

save w_subtable_q100_household_characteristics_sort.dta, replace
by wintrno: assert _N==1

order _all, seq

* Recode NA

foreach var of varlist w100_1a-w100_8g {
		if (substr("`var'",-1,1)=="a" | substr("`var'",-1,1)=="b" | ///
		substr("`var'",-1,1)=="c" | substr("`var'",-1,1)=="d") {
		replace `var'=9998 if `var'==8 
		}
		if (substr("`var'",-1,1)=="e" | substr("`var'",-1,1)=="f" | substr("`var'",-1,1)=="g" ) {
		replace `var'="9998" if `var'=="8" 
		}
}

* Recode Missing

foreach var of varlist w100_1a-w100_8g {
		if (substr("`var'",-1,1)=="a" | substr("`var'",-1,1)=="b" | ///
		substr("`var'",-1,1)=="c" | substr("`var'",-1,1)=="d") {
		replace `var'=9999 if (`var'==. | `var'==9)
		}
		if (substr("`var'",-1,1)=="e" | substr("`var'",-1,1)=="f" | substr("`var'",-1,1)=="g" ) {
		replace `var'="9999" if (`var'=="" | `var'=="9" )
		}
}

* Recode unknown entry errors

foreach var of varlist w100_1a-w100_8g {
		if (substr("`var'",-1,1)=="b" |	substr("`var'",-1,1)=="c" | substr("`var'",-1,1)=="d") {
		replace `var'=9999 if `var'==0
		}
		if (substr("`var'",-1,1)=="e" | substr("`var'",-1,1)=="f" | substr("`var'",-1,1)=="g" ) {
		replace `var'="9999" if `var'=="2" 
		}
}

* Rename variables to standard convention

foreach var of varlist w100_1a-w100_1g {
		local front = substr("`var'", 1, 5)
		local back = substr("`var'", 7, 1)
		rename `var' `front'garden_`back'
}
		
foreach var of varlist w100_2a-w100_2g {
		local front = substr("`var'", 1, 5)
		local back = substr("`var'", 7, 1)
		rename `var' `front'snacks_`back'
}		

foreach var of varlist w100_3a-w100_3g {
		local front = substr("`var'", 1, 5)
		local back = substr("`var'", 7, 1)
		rename `var' `front'cheese_`back'
}

foreach var of varlist w100_4a-w100_4g {
		local front = substr("`var'", 1, 5)
		local back = substr("`var'", 7, 1)
		rename `var' `front'handcraft_`back'
}

foreach var of varlist w100_5a-w100_5g {
		local front = substr("`var'", 1, 5)
		local back = substr("`var'", 7, 1)
		rename `var' `front'crochet_`back'
}

foreach var of varlist w100_6a-w100_6g {
		local front = substr("`var'", 1, 5)
		local back = substr("`var'", 7, 1)
		rename `var' `front'clothes_`back'
}

foreach var of varlist w100_7a-w100_7g {
		local front = substr("`var'", 1, 5)
		local back = substr("`var'", 7, 1)
		rename `var' `front'other1_`back'
}

foreach var of varlist w100_8a-w100_8g {
		local front = substr("`var'", 1, 5)
		local back = substr("`var'", 7, 1)
		rename `var' `front'other2_`back'
}

save household_production.dta, replace

* Merge on identifiers for HHs with no household production data
use base0013.dta, clear
keep wintrno
sort wintrno
merge 1:1 wintrno using household_production.dta, update replace
drop _merge

order _all, seq

foreach var of varlist w100_cheese_a-w100_snacks_g {
		if (substr("`var'",-1,1)=="a" | substr("`var'",-1,1)=="b" | ///
		substr("`var'",-1,1)=="c" | substr("`var'",-1,1)=="d") {
		replace `var'=9998 if `var'==. 
		}
		if (substr("`var'",-1,1)=="e" | substr("`var'",-1,1)=="f" |substr("`var'",-1,1)=="g" ) {
		replace `var'="9998" if `var'=="" 
		}
}

save w_subtable_q100_household_characteristics_sort.dta, replace

* Compare All Common Variables between Base (Master) and Merge (Using) File
* NOTE: Comment out 2 command after identifying any errors
* use base0013_sort.dta, clear
* cf _all using w_subtable_q100_household_characteristics_sort.dta, verbose

* If necessary, correct any mismatched variable issues revealed above before merging

*Merge files (with extra consistency checks) and check for any id problems
use base0013_sort.dta, clear
merge 1:1 wintrno using w_subtable_q100_household_characteristics_sort.dta, update
by wintrno: assert _N==1
tab _merge
drop _merge
order _all, seq

* Summary Report: merging w_subtable_q100_household_characteristics.dta --> base0013.dta
describe, short
sort mprop_hh_id
save base0014.dta, replace


***************************************************************************************************
* Merge w_subtable_q09_otherhh.dta --> base0014.dta
*******************************************************

* Sort Base File and check uniqueness of id variable
use base0014.dta, clear
sort wintrno
save base0014_sort.dta, replace
by wintrno: assert _N==1

* Sort Merge File and check uniqueness of id variable
use w_subtable_q09_otherhh.dta, clear
sort wintrno id
drop _1w9_1
order _all, seq

** Recode Missing before collapse

replace _1w9_2=0 if _1w9_2==9999

** Collapse

gen newid=wintrno*100+id
gen w9_3_1=1 if _1w9_3==1
gen w9_3_2=1 if _1w9_3==2
gen w9_3_3=1 if _1w9_3==3
gen w9_3_4=1 if _1w9_3==4
gen w9_3_5=1 if _1w9_3==5
gen w9_3_6=1 if _1w9_3==6
by wintrno: gen w9_1=_N

sort newid
collapse (sum) _1w9_2 w9_3_1 w9_3_2 w9_3_3 w9_3_4 w9_3_5 w9_3_6 (mean) w9_1, by(wintrno)
rename _1w9_2 w9_2
order _all, seq

save w_subtable_q09_otherhh_sort.dta, replace

*Merge files (with extra consistency checks) and check for any id problems
use base0014_sort.dta, clear
merge 1:1 wintrno using w_subtable_q09_otherhh_sort.dta, update
by wintrno: assert _N==1
tab _merge
drop _merge
order _all, seq

* Summary Report: merging w_subtable_q100_household_characteristics.dta --> base0013.dta
describe, short
sort mprop_hh_id
save base0015.dta, replace

******************************************************************************************************
** Cleanup Directory
******************************************************************************************************

capture erase base0001.dta
capture erase base0001_sort.dta
capture erase base0002.dta
capture erase base0002_sort.dta
capture erase base0003.dta
capture erase base0003_sort.dta
capture erase base0004.dta
capture erase base0004_sort.dta
capture erase base0005.dta
capture erase base0005_sort.dta
capture erase base0006.dta
capture erase base0006_sort.dta
capture erase base0007.dta
capture erase base0007_sort.dta
capture erase base0008.dta
capture erase base0008_sort.dta
capture erase base0009.dta
capture erase base0009_sort.dta
capture erase base0010.dta
capture erase base0010_sort.dta
capture erase base0011.dta
capture erase base0011_sort.dta
capture erase base0012.dta
capture erase base0012_sort.dta
capture erase base0013.dta
capture erase base0013_sort.dta
capture erase base0014.dta
capture erase base0014_sort.dta

capture erase id_add_01.dta

capture erase beans.dta
capture erase citrus.dta
capture erase corn.dta
capture erase flood.dta
capture erase household_production.dta
capture erase livestock_data.dta
capture erase rental.dta
capture erase terra.dta
capture erase timber.dta

capture erase chunk.dta
capture erase chunk_a.dta
capture erase chunk_all_sort.dta

capture erase chunk_b_sold.dta
capture erase chunk_c_sold.dta
capture erase chunk_bc_sold.dta

capture erase chunk_b_acquired.dta
capture erase chunk_c_acquired.dta
capture erase chunk_bc_acquired.dta

capture erase chunk_b_other.dta
capture erase chunk_c_other.dta
capture erase chunk_bc_other.dta

capture erase chunk_bcde.dta

capture erase chunk_d.dta
capture erase chunk_de.dta
capture erase chunk_e.dta

capture erase midway_0001.dta
capture erase midway_0002.dta
capture erase midway_0003.dta
capture erase midway0004.dta
capture erase midway0005.dta
capture erase midway0006.dta
capture erase midway0007.dta
capture erase midway0007_sort.dta

******************************************************************************************************
** Cleanup Household Data File
******************************************************************************************************

use base0015.dta, clear
sort mprop_hh_id
order _all, seq

**************************************************************
* Recode missing and NA

*m1
rename m1 m1a

*m2
rename m2 m2_2
rename m2c m2_1

* m2a
rename m2a m2_month
replace m2_month=9999 if m2_month==99
replace m2_month=9998 if m2_month==0

* m2b
rename m2b m2_year
replace m2_year=9998 if m2_year==0

*m3_reclass
replace m3_reclass="9999" if m3_reclass=="99"
replace m3_reclass="9998" if m3_reclass=="88"

*m4
rename m4 m4a

* m6
replace m6=9999 if m6==9
replace m6=9998 if m6==8

* recode question m6 to remove skipped codes and bring into agreement with questionnaire
replace m6=1 if m6==2
replace m6=2 if m6==3
replace m6=3 if m6==5
replace m6=4 if m6==6
replace m6=5 if m6==7

* m7 variables
rename m7a m7
rename m7a_recl m7_reclass
rename m7b m7_3_1a
rename m7c m7_3_2a
rename m7d m7_3_3a
rename m7e m7_4a

replace m7=9999 if m7==9
replace m7=9998 if m7==8
replace m7=9998 if m7==5

* m8_month
rename m8a m8_month
rename m8b m8_year
rename m8c m8_nap

replace m8_month=9999 if m8_month==99
replace m8_month=9998 if m8_month==88

* m8_year
replace m8_year=9998 if m8_year==8888

* m9_month
rename m9a m9_month
replace m9_month=9999 if m9_month==99
replace m9_month=9998 if m9_month==88
replace m9_month=9999 if m9_month==0

* m9_year
rename m9b m9_year
replace m9_year=9999 if m9_year==0

* m10_1
replace m10_1=9999 if m10_7==99
replace m10_1=9998 if m10_8==5
replace m10_1=1 if (m10_1!=0 & m10_1!=9998 & m10_1!=9999)

* m10_2
replace m10_2=9999 if m10_7==99
replace m10_2=9998 if m10_8==5
replace m10_2=1 if (m10_2!=0 & m10_2!=9998 & m10_2!=9999)

* m10_3
replace m10_3=9999 if m10_7==99
replace m10_3=9998 if m10_8==5
replace m10_3=1 if (m10_3!=0 & m10_3!=9998 & m10_3!=9999)

* m10_4
replace m10_4=9999 if m10_7==99
replace m10_4=9998 if m10_8==5
replace m10_4=1 if (m10_4!=0 & m10_4!=9998 & m10_4!=9999)

* m10_5
replace m10_5=9999 if m10_7==99
replace m10_5=9998 if m10_8==5
replace m10_5=1 if (m10_5!=0 & m10_5!=9998 & m10_5!=9999)

* m10_6
replace m10_6=9999 if m10_7==99
replace m10_6=9998 if m10_8==5
replace m10_6=1 if (m10_6!=0 & m10_6!=9998 & m10_6!=9999)

* m10_7
replace m10_7=9999 if m10_7==99
replace m10_7=9998 if m10_8==5
replace m10_7=1 if (m10_7!=0 & m10_7!=9998 & m10_7!=9999)

* m10_8
replace m10_8=9999 if m10_7==9999
replace m10_8=9998 if m10_8==5
replace m10_8=1 if (m10_8!=0 & m10_8!=9998 & m10_8!=9999)

*m10_maincriteria
rename m10_maincriteria m10_main

replace m10_main=9998 if m10_main==8
replace m10_main=9999 if m10_main==9

*m11
replace m11=9999 if m11==9
replace m11=9999 if m11==0

* m12a
rename m12a m12_1
rename m12b m12_2
rename m12c m12_nap

replace m12_1=9999 if m12_1==99
replace m12_1=9998 if m12_1==88
replace m12_1=9998 if m12_nap==1

* m12b
replace m12_2=9999 if m12_2==99
replace m12_2=9998 if m12_2==88
replace m12_2=9998 if m12_nap==1

gen temp1=m12_1+m12_2

replace m12_1=9999 if (temp1<12 & m12_2!=0)
replace m12_2=9999 if (temp1<12 & m12_1!=0)

replace m12_1=9998 if (m12_1==0 & m12_2==0)
replace m12_2=9998 if (m12_1==9998 & m12_2==0)

drop temp1

*m13_1
replace m13_1="9998" if m13_1=="8888"
replace m13_1="9999" if m13_1==""

*m13_2
replace m13_2=9998 if m13_2==8
replace m13_2=9999 if m13_2==9
replace m13_2=9999 if m13_2==.
replace m13_2=9998 if m13_1=="9998"

*m13_3
replace m13_3="9998" if m13_3=="8888"
replace m13_3="9998" if m13_1=="9998"

*m13_4
replace m13_4=9998 if m13_4==888
replace m13_4=9999 if m13_4==999
replace m13_4=9998 if m13_1=="9998"

*m13_5
replace m13_5=9998 if m13_5==888
replace m13_5=9999 if m13_5==999
replace m13_5=9998 if m13_1=="9998"

*m13_6a
rename m13_6a m13_6_1a
rename m13_6b m13_6_2a
rename m13_6c m13_6_3a

replace m13_6_1a="9998" if m13_6_1a=="8888"
replace m13_6_1a="9999" if m13_6_1a==""
replace m13_6_1a="9998" if m13_1=="9998"
replace m13_6_1a="9999" if m13_1=="9999"

*m13_6b
replace m13_6_2a="9998" if m13_6_2a=="8888"
replace m13_6_2a="9999" if m13_6_2a==""
replace m13_6_2a="9998" if m13_1=="9998"
replace m13_6_2a="9999" if m13_1=="9999"

*m13_6c
replace m13_6_3a="9998" if m13_6_3a=="8888"
replace m13_6_3a="9999" if m13_6_3a==""
replace m13_6_3a="9998" if m13_1=="9998"
replace m13_6_3a="9999" if m13_1=="9999"

*m14_1
replace m14_1=9998 if m14_1==8
replace m14_1=9999 if m14_1==9
replace m14_1=9999 if m14_1==7
replace m14_1=9999 if m14_1==.

*m14_2
rename m14_2 m14_2a
replace m14_2a="9998" if m14_2a=="8888"
replace m14_2a="9998" if m14_1==9998
replace m14_2a="9999" if m14_1==9999
replace m14_2a="9999" if m14_2a==""

*m14_3
replace m14_3=9998 if m14_3==888
replace m14_3=9999 if m14_3==999
replace m14_3=9998 if m14_1==9998
replace m14_3=9999 if m14_1==9999

*m14_4
replace m14_4=9998 if m14_4==888
replace m14_4=9999 if m14_4==999
replace m14_4=9998 if m14_1==9998
replace m14_4=9999 if m14_1==9999

*m14_5a
rename m14_5a m14_5_1a
rename m14_5b m14_5_2a
rename m14_5c m14_5_3a
replace m14_5_1a="9998" if m14_5_1a=="8888"
replace m14_5_1a="9998" if m14_1==9998
replace m14_5_1a="9999" if m14_1==9999

*m14_5b
replace m14_5_2a="9998" if m14_5_2a=="8888"
replace m14_5_2a="9998" if m14_1==9998
replace m14_5_2a="9999" if m14_1==9999

*m14_5c
replace m14_5_3a="9998" if m14_5_3a=="8888"
replace m14_5_3a="9998" if m14_1==9998
replace m14_5_3a="9999" if m14_1==9999

*fix variable naming problem
rename m14_5_1a m14_6_1a
rename m14_5_2a m14_6_2a
rename m14_5_3a m14_6_3a
rename m14_4 m14_5
rename m14_3 m14_4
rename m14_2 m14_3
rename m14_1 m14_2

*m14_6_1a-m14_6_3a
replace m14_6_1a="9999" if m14_6_1a==""
replace m14_6_2a="9999" if m14_6_2a==""
replace m14_6_3a="9999" if m14_6_3a==""

*m15_2
replace m15_2=9998 if m15_2==8
replace m15_2=9999 if m15_2==9
replace m15_2=9999 if m15_2==0
replace m15_2=9999 if m15_2==.

*m15_3
rename m15_3 m15_3a
replace m15_3a="9998" if m15_3a=="8888"
replace m15_3a="9999" if m15_3a==""
replace m15_3a="9999" if m15_2==9999

*m15_4
replace m15_4=9998 if m15_4==888
replace m15_4=9999 if m15_4==999
replace m15_4=9999 if m15_2==9999
replace m15_4=9999 if m15_4==.

*m15_5
replace m15_5=9998 if m15_5==888
replace m15_5=9999 if m15_5==999
replace m15_5=9999 if m15_2==9999

*m15_6a
rename m15_6a m15_6_1a
rename m15_6b m15_6_2a
rename m15_6c m15_6_3a
replace m15_6_1a="9998" if m15_6_1a=="8888"
replace m15_6_1a="9999" if m15_6_1a=="999"
replace m15_6_1a="9999" if m15_2==9999

*m15_6b
replace m15_6_2a="9998" if m15_6_2a=="8888"
replace m15_6_2a="9999" if m15_6_2a=="999"
replace m15_6_2a="9999" if m15_2==9999

*m15_6c
replace m15_6_3a="9998" if m15_6_3a=="8888"
replace m15_6_3a="9999" if m15_6_3a=="999"
replace m15_6_3a="9999" if m15_2==9999

*m16_1
replace m16_1=9998 if m16_1==8
replace m16_1=9999 if m16_1==9

*m16_1a
replace m16_1a="9998" if m16_1a=="8888"
replace m16_1a="9999" if m16_1==9999
replace m16_1a="9999" if m16_1a==""

*m16_2
replace m16_2=9998 if m16_2==8
replace m16_2=9999 if m16_2==9
replace m16_2=9999 if m16_2==3

*m16_3
replace m16_3=9998 if m16_3==8
replace m16_3=9999 if m16_3==9

*m16_3a
replace m16_3a="9998" if m16_3a=="8888"
replace m16_3a="9999" if m16_3==9999
replace m16_3a="9998" if m16_3a==""

*m16_4
replace m16_4=9998 if m16_4==8
replace m16_4=9999 if m16_4==9
replace m16_4=9999 if m16_4==6

*m18a-*m18d
rename m18_1 m18_1_1a
rename m18a m18_1
rename m18b m18_2
rename m18c m18_3
rename m18d m18_4
rename m18d_a m18_4a

*m18_4
replace m18_4a="9998" if m18_4a=="8888"
replace m18_4a="9998" if m18_4a==""

*m18_1_1a
replace m18_1_1a="9998" if m18_1_1a==""

*m19_1
replace m19_1=9999 if m19_1==0
replace m19_1=9999 if m19_1==9

*m19_1a
replace m19_1a="9998" if m19_1a=="8888"
replace m19_1a="9998" if m19_1a==""
replace m19_1a="9999" if m19_1==9999

*m19_2
replace m19_2=9998 if (m19_1!=9999 & m19_2==0)
replace m19_2=9999 if m19_2==0
replace m19_2=9999 if m19_2==9
replace m19_2=9998 if m19_2==8

*m19_2a
replace m19_2a="9998" if m19_2a=="8888"
replace m19_2a="9998" if m19_2a==""
replace m19_2a="9999" if m19_2==9999

*m20_1
replace m20_1=9999 if m20_1==999
replace m20_1=9998 if m20_1==0
replace m20_1=9998 if m20_1==.

*m20_2
replace m20_2=9999 if m20_2==999
replace m20_2=9998 if m20_2==0
replace m20_2=9998 if m20_2==.

*m20_3
replace m20_3=9999 if m20_3==999
replace m20_3=9998 if m20_3==0
replace m20_3=9998 if m20_3==.

*m20_4
replace m20_4=9999 if m20_4==999
replace m20_4=9998 if m20_4==0
replace m20_4=9998 if m20_4==.

*m20_4a
replace m20_4a="9999" if m20_4a=="????"
replace m20_4a="9998" if m20_4a=="8888"
replace m20_4a="9998" if m20_4a==""
replace m20_4a="9999" if m20_4==9999

*m20_5
replace m20_5=9998 if m20_5==8888
replace m20_5=9998 if m20_5==0
replace m20_5=9998 if m20_5==.

*m21_1a-m21_10b
rename m21_1 m21_01_0
rename m21_1a m21_01_1
rename m21_1b m21_01_2
rename m21_2 m21_02_0
rename m21_2a m21_02_1
rename m21_2b m21_02_2
rename m21_3 m21_03_0
rename m21_3a m21_03_1
rename m21_4 m21_04_0
rename m21_4a m21_04_1
rename m21_5 m21_05_0
rename m21_5a m21_05_1
rename m21_5b m21_05_2
rename m21_6 m21_06_0
rename m21_6a m21_06_1
rename m21_7 m21_07_0
rename m21_7a m21_07_1
rename m21_8 m21_08_0
rename m21_8a m21_08_1
rename m21_9 m21_09_0
rename m21_9a m21_09_1
rename m21_10 m21_10_0
rename m21_10a m21_10_1a

*m21_1a
replace m21_01_1=9999 if m21_01_1==999
replace m21_01_1=9998 if m21_01_1==8888

*m21_1b
replace m21_01_2=9998 if m21_01_2==8888

*m21_2a
replace m21_02_1=9999 if m21_02_1==999
replace m21_02_1=9998 if m21_02_1==8888

*m21_1b
replace m21_02_2=9998 if m21_02_2==8888

*m21_3a
replace m21_03_1=9998 if m21_03_1==8888

*m21_4a
replace m21_04_1=9998 if m21_04_1==8888

*m21_5a
replace m21_05_1=9998 if m21_05_1==8888

*m21_6a
replace m21_06_1=9998 if m21_06_1==8888

*m21_7a
replace m21_07_1=9998 if m21_07_1==8
replace m21_07_1=9998 if m21_07_1==0
replace m21_07_1=9999 if m21_07_1==9
replace m21_07_1=9999 if m21_07_1==.

*m21_8a
replace m21_08_1=9998 if m21_08_1==8888

*m21_9a
replace m21_09_1=9998 if m21_09_1==8888

*m21_10a
replace m21_10_1="9998" if m21_10_1=="8888"
replace m21_10_1="9998" if m21_10_1==""

*m21_10a
replace m21_10_1="9998" if m21_10_1=="8888"
replace m21_10_1="9998" if m21_10_1==""

*m21_reclass
replace m21_reclass=9998 if m21_reclass==88

*m22_1a-m22_10a
rename m22_1 m22_01_0
rename m22_1a m22_01_1
rename m22_1b m22_01_2
rename m22_2 m22_02_0
rename m22_2a m22_02_1
rename m22_2b m22_02_2
rename m22_3 m22_03_0
rename m22_3a m22_03_1
rename m22_4 m22_04_0
rename m22_4a m22_04_1
rename m22_5 m22_05_0
rename m22_5a m22_05_1
rename m22_5b m22_05_2
rename m22_6 m22_06_0
rename m22_6a m22_06_1
rename m22_7 m22_07_0
rename m22_7a m22_07_1
rename m22_8 m22_08_0
rename m22_8a m22_08_1
rename m22_9 m22_09_0
rename m22_9a m22_09_1
rename m22_10 m22_10_0
rename m22_10b m22_10_1a

*m22_1a
replace m22_01_1=9998 if m22_01_1==8888
replace m22_01_1=9998 if m22_01_1==0

*m22_1b
replace m22_01_2=9998 if m22_01_2==8888
replace m22_01_2=9998 if m22_01_2==0

*m22_2a
replace m22_02_1=9998 if m22_02_1==8888
replace m22_02_1=9998 if m22_02_1==0

*m22_2b
replace m22_02_2=9998 if m22_02_2==8888
replace m22_02_2=9998 if m22_02_2==0

*m22_3a
replace m22_03_1=9998 if m22_03_1==8888
replace m22_03_1=9998 if m22_03_1==0

*m22_4a
replace m22_04_1=9998 if m22_04_1==8888
replace m22_04_1=9998 if m22_04_1==0

*m22_5a
replace m22_05_1=9998 if m22_05_1==8888
replace m22_05_1=9998 if m22_05_1==0

*m22_6a
replace m22_06_1=9998 if m22_06_1==8888
replace m22_06_1=9998 if m22_06_1==0

*m22_7a
replace m22_07_1=9998 if m22_07_1==8
replace m22_07_1=9998 if m22_07_1==0
replace m22_07_1=9999 if m22_07_1==.

*m22_8a
replace m22_08_1=9998 if m22_08_1==8888
replace m22_08_1=9998 if m22_08_1==0

*m22_9a
replace m22_09_1=9998 if m22_09_1==8888
replace m22_09_1=9998 if m22_09_1==0
replace m22_09_1=9999 if m22_09_1==.

*m22_10-m22_10b
replace m22_10_1a="8888" if m22_10_1a==""
replace m22_10_1a="9998" if m22_10_1a=="8888"

replace m22_10_0=1 if (m22_10_1a!="9998")

*m22_reclass
replace m22_reclass=9998 if (m22_reclass==88)

*m23_1
rename m23_1 m23_1a
replace m23_1a="9998" if m23_1a==""
replace m23_1a="9998" if (substr(m23_1a,1,4)=="8888")

*m23_2
replace m23_2=9998 if m23_2==8888
replace m23_2=9999 if m23_2==999
replace m23_2=9999 if m23_2==.

*m24
replace m24=9999 if m24==999

*m26_06a_all
rename m26_06a_all m26_06_all_a
replace m26_06_all_a="9998" if m26_06_all_a==""
replace m26_06_all_a="9999" if m26_06_all_a=="9998" & m26_06!=0

*m26_12a_all
rename m26_12a_all m26_12_all_a
replace m26_12_all_a="9998" if m26_12_all_a==""
replace m26_12_all_a="9999" if m26_12_all_a=="9998" & m26_12!=0

*m26_13a_all
rename m26_13a_all m26_13_all_a
replace m26_13_all_a="9998" if m26_13_all_a==""
replace m26_13_all_a="9999" if m26_13_all_a=="9998" & m26_13!=0

*m26_15a_all
rename m26_15a_all m26_15_all_a
replace m26_15_all_a="9998" if m26_15_all_a==""
replace m26_15_all_a="9999" if m26_15_all_a=="9998" & m26_15!=0

*m26_16a_all
rename m26_16a_all m26_16_all_a
replace m26_16_all_a="9998" if m26_16_all_a==""
replace m26_16_all_a="9999" if m26_16_all_a=="9998" & m26_16!=0

*m28 production variables
foreach var of varlist m28_banana_a-m28_vine_g {
		if (substr("`var'",-1,1)=="a" | substr("`var'",-1,1)=="d")  {
		replace `var'="9998" if `var'==""
		}
}

rename m28_banana_a m28_banana_1a
rename m28_banana_b m28_banana_2
rename m28_banana_c m28_banana_3
rename m28_banana_d m28_banana_4a
rename m28_banana_e m28_banana_5
rename m28_banana_f m28_banana_6
rename m28_banana_g m28_banana_7

rename m28_beans_a m28_beans_1a
rename m28_beans_b m28_beans_2
rename m28_beans_c m28_beans_3
rename m28_beans_d m28_beans_4a
rename m28_beans_e m28_beans_5
rename m28_beans_f m28_beans_6
rename m28_beans_g m28_beans_7

rename m28_cashewfr_a m28_cashewfr_1a
rename m28_cashewfr_b m28_cashewfr_2
rename m28_cashewfr_c m28_cashewfr_3
rename m28_cashewfr_d m28_cashewfr_4a
rename m28_cashewfr_e m28_cashewfr_5
rename m28_cashewfr_f m28_cashewfr_6
rename m28_cashewfr_g m28_cashewfr_7

rename m28_cattle_a m28_cattle_1a
rename m28_cattle_b m28_cattle_2
rename m28_cattle_c m28_cattle_3
rename m28_cattle_d m28_cattle_4a
rename m28_cattle_e m28_cattle_5
rename m28_cattle_f m28_cattle_6
rename m28_cattle_g m28_cattle_7

rename m28_cheese_a m28_cheese_1a
rename m28_cheese_b m28_cheese_2
rename m28_cheese_c m28_cheese_3
rename m28_cheese_d m28_cheese_4a
rename m28_cheese_e m28_cheese_5
rename m28_cheese_f m28_cheese_6
rename m28_cheese_g m28_cheese_7

rename m28_citrus_a m28_citrus_1a
rename m28_citrus_b m28_citrus_2
rename m28_citrus_c m28_citrus_3
rename m28_citrus_d m28_citrus_4a
rename m28_citrus_e m28_citrus_5
rename m28_citrus_f m28_citrus_6
rename m28_citrus_g m28_citrus_7

rename m28_cocoa_a m28_cocoa_1a
rename m28_cocoa_b m28_cocoa_2
rename m28_cocoa_c m28_cocoa_3
rename m28_cocoa_d m28_cocoa_4a
rename m28_cocoa_e m28_cocoa_5
rename m28_cocoa_f m28_cocoa_6
rename m28_cocoa_g m28_cocoa_7

rename m28_coffee_a m28_coffee_1a
rename m28_coffee_b m28_coffee_2
rename m28_coffee_c m28_coffee_3
rename m28_coffee_d m28_coffee_4a
rename m28_coffee_e m28_coffee_5
rename m28_coffee_f m28_coffee_6
rename m28_coffee_g m28_coffee_7

rename m28_corn_a m28_corn_1a
rename m28_corn_b m28_corn_2
rename m28_corn_c m28_corn_3
rename m28_corn_d m28_corn_4a
rename m28_corn_e m28_corn_5
rename m28_corn_f m28_corn_6
rename m28_corn_g m28_corn_7

rename m28_cupu_a m28_cupu_1a
rename m28_cupu_b m28_cupu_2
rename m28_cupu_c m28_cupu_3
rename m28_cupu_d m28_cupu_4a
rename m28_cupu_e m28_cupu_5
rename m28_cupu_f m28_cupu_6
rename m28_cupu_g m28_cupu_7

rename m28_fish_a m28_fish_1a
rename m28_fish_b m28_fish_2
rename m28_fish_c m28_fish_3
rename m28_fish_d m28_fish_4a
rename m28_fish_e m28_fish_5
rename m28_fish_f m28_fish_6
rename m28_fish_g m28_fish_7

rename m28_flour_a m28_flour_1a
rename m28_flour_b m28_flour_2
rename m28_flour_c m28_flour_3
rename m28_flour_d m28_flour_4a
rename m28_flour_e m28_flour_5
rename m28_flour_f m28_flour_6
rename m28_flour_g m28_flour_7

rename m28_honey_a m28_honey_1a
rename m28_honey_b m28_honey_2
rename m28_honey_c m28_honey_3
rename m28_honey_d m28_honey_4a
rename m28_honey_e m28_honey_5
rename m28_honey_f m28_honey_6
rename m28_honey_g m28_honey_7

rename m28_horse_a m28_horse_1a
rename m28_horse_b m28_horse_2
rename m28_horse_c m28_horse_3
rename m28_horse_d m28_horse_4a
rename m28_horse_e m28_horse_5
rename m28_horse_f m28_horse_6
rename m28_horse_g m28_horse_7

rename m28_manioc_a m28_manioc_1a
rename m28_manioc_b m28_manioc_2
rename m28_manioc_c m28_manioc_3
rename m28_manioc_d m28_manioc_4a
rename m28_manioc_e m28_manioc_5
rename m28_manioc_f m28_manioc_6
rename m28_manioc_g m28_manioc_7

rename m28_milk_a m28_milk_1a
rename m28_milk_b m28_milk_2
rename m28_milk_c m28_milk_3
rename m28_milk_d m28_milk_4a
rename m28_milk_e m28_milk_5
rename m28_milk_f m28_milk_6
rename m28_milk_g m28_milk_7

rename m28_other1_a m28_other1_1a
rename m28_other1_b m28_other1_2
rename m28_other1_c m28_other1_3
rename m28_other1_d m28_other1_4a
rename m28_other1_e m28_other1_5
rename m28_other1_f m28_other1_6
rename m28_other1_g m28_other1_7
rename m28_other1_name m28_other1_a

rename m28_other2_a m28_other2_1a
rename m28_other2_b m28_other2_2
rename m28_other2_c m28_other2_3
rename m28_other2_d m28_other2_4a
rename m28_other2_e m28_other2_5
rename m28_other2_f m28_other2_6
rename m28_other2_g m28_other2_7
rename m28_other2_name m28_other2_a

rename m28_other3_a m28_other3_1a
rename m28_other3_b m28_other3_2
rename m28_other3_c m28_other3_3
rename m28_other3_d m28_other3_4a
rename m28_other3_e m28_other3_5
rename m28_other3_f m28_other3_6
rename m28_other3_g m28_other3_7
rename m28_other3_name m28_other3_a

rename m28_other4_a m28_other4_1a
rename m28_other4_b m28_other4_2
rename m28_other4_c m28_other4_3
rename m28_other4_d m28_other4_4a
rename m28_other4_e m28_other4_5
rename m28_other4_f m28_other4_6
rename m28_other4_g m28_other4_7
rename m28_other4_name m28_other4_a

rename m28_other5_a m28_other5_1a
rename m28_other5_b m28_other5_2
rename m28_other5_c m28_other5_3
rename m28_other5_d m28_other5_4a
rename m28_other5_e m28_other5_5
rename m28_other5_f m28_other5_6
rename m28_other5_g m28_other5_7
rename m28_other5_name m28_other5_a

rename m28_other6_a m28_other6_1a
rename m28_other6_b m28_other6_2
rename m28_other6_c m28_other6_3
rename m28_other6_d m28_other6_4a
rename m28_other6_e m28_other6_5
rename m28_other6_f m28_other6_6
rename m28_other6_g m28_other6_7
rename m28_other6_name m28_other6_a

rename m28_passion_a m28_passion_1a
rename m28_passion_b m28_passion_2
rename m28_passion_c m28_passion_3
rename m28_passion_d m28_passion_4a
rename m28_passion_e m28_passion_5
rename m28_passion_f m28_passion_6
rename m28_passion_g m28_passion_7

rename m28_pepper_a m28_pepper_1a
rename m28_pepper_b m28_pepper_2
rename m28_pepper_c m28_pepper_3
rename m28_pepper_d m28_pepper_4a
rename m28_pepper_e m28_pepper_5
rename m28_pepper_f m28_pepper_6
rename m28_pepper_g m28_pepper_7

rename m28_poultry_a m28_poultry_1a
rename m28_poultry_b m28_poultry_2
rename m28_poultry_c m28_poultry_3
rename m28_poultry_d m28_poultry_4a
rename m28_poultry_e m28_poultry_5
rename m28_poultry_f m28_poultry_6
rename m28_poultry_g m28_poultry_7

rename m28_pupunha_a m28_pupunha_1a
rename m28_pupunha_b m28_pupunha_2
rename m28_pupunha_c m28_pupunha_3
rename m28_pupunha_d m28_pupunha_4a
rename m28_pupunha_e m28_pupunha_5
rename m28_pupunha_f m28_pupunha_6
rename m28_pupunha_g m28_pupunha_7

rename m28_rice_a m28_rice_1a
rename m28_rice_b m28_rice_2
rename m28_rice_c m28_rice_3
rename m28_rice_d m28_rice_4a
rename m28_rice_e m28_rice_5
rename m28_rice_f m28_rice_6
rename m28_rice_g m28_rice_7

rename m28_rubber_a m28_rubber_1a
rename m28_rubber_b m28_rubber_2
rename m28_rubber_c m28_rubber_3
rename m28_rubber_d m28_rubber_4a
rename m28_rubber_e m28_rubber_5
rename m28_rubber_f m28_rubber_6
rename m28_rubber_g m28_rubber_7

rename m28_swine_a m28_swine_1a
rename m28_swine_b m28_swine_2
rename m28_swine_c m28_swine_3
rename m28_swine_d m28_swine_4a
rename m28_swine_e m28_swine_5
rename m28_swine_f m28_swine_6
rename m28_swine_g m28_swine_7

rename m28_tapioca_a m28_tapioca_1a
rename m28_tapioca_b m28_tapioca_2
rename m28_tapioca_c m28_tapioca_3
rename m28_tapioca_d m28_tapioca_4a
rename m28_tapioca_e m28_tapioca_5
rename m28_tapioca_f m28_tapioca_6
rename m28_tapioca_g m28_tapioca_7

rename m28_tucupi_a m28_tucupi_1a
rename m28_tucupi_b m28_tucupi_2
rename m28_tucupi_c m28_tucupi_3
rename m28_tucupi_d m28_tucupi_4a
rename m28_tucupi_e m28_tucupi_5
rename m28_tucupi_f m28_tucupi_6
rename m28_tucupi_g m28_tucupi_7

rename m28_vine_a m28_vine_1a
rename m28_vine_b m28_vine_2
rename m28_vine_c m28_vine_3
rename m28_vine_d m28_vine_4a
rename m28_vine_e m28_vine_5
rename m28_vine_f m28_vine_6
rename m28_vine_g m28_vine_7

*m30_13a
replace m30_13a="9998" if m30_13a=="8888"
replace m30_13a="9998" if m30_13a==""

*m30_14a
replace m30_14a="9998" if m30_14a=="8888"
replace m30_14a="9998" if m30_14a==""

*m30_15a
replace m30_15a="9998" if m30_15a=="8888"
replace m30_15a="9998" if m30_15a==""

*m31_2
replace m31_2=9998 if m31_2==0
replace m31_2=9999 if m31_2==.

*m32_2
replace m32_2=9998 if m32_2==0
replace m32_2=9999 if m32_2==9
replace m32_2=9999 if m32_2==.

*m33_2
rename m33_2 m33_2a
replace m33_2a="9998" if m33_2a==""
 
*m34_2
replace m34_2="9998" if m34_2==""
destring m34_2, replace

*m36_2
replace m36_2=9999 if m36_2==999
replace m36_2=9999 if m36_2==.
replace m36_2=9998 if m36_2==0
 
*m37
replace m37=9999 if m37==99

*m38_2
rename m38_2 m38_2a
replace m38_2a="9998" if m38_2a=="8888"
replace m38_2a="9998" if m38_2a==""

*m39_1
replace m39_1=9998 if m39_1==0
replace m39_1=9999 if m39_1==9
replace m39_1=9999 if m39_1==.
replace m39_1=9998 if m39_1==8

*m39_2
rename m39_2 m39_2a
replace m39_2a="9998" if m39_2a=="8888"
replace m39_2a="9998" if m39_2a==""
 
*m41
rename m41a m41_0
rename m41a_1 m41_0_1a
rename m41a_2 m41_0_2a
rename m41a_3 m41_0_3a

replace m41_0_1a="9998" if m41_0_1a=="8888"
replace m41_0_1a="9998" if m41_0_1a==""
replace m41_0_2a="9998" if m41_0_2a=="8888"
replace m41_0_2a="9998" if m41_0_2a==""
replace m41_0_3a="9998" if m41_0_3a=="8888"
replace m41_0_3a="9998" if m41_0_3a==""

replace m41_0_1a="9998" if m41_0==0 & m41_0_1a=="9999"
replace m41_0_1a="9998" if m41_0==0
replace m41_0_1a="9999" if m41_0==1 & m41_0_1a=="9998"

replace m41_0_2a="9998" if m41_0==0

replace m41_0_3a="9998" if m41_0==0

replace m41_1=9998 if m41_0==0
replace m41_1=9999 if m41_1==9
replace m41_1=9999 if m41_1==0

replace m41_1a="9998" if m41_0==0
replace m41_1a="9998" if m41_1==1
replace m41_1a="9999" if m41_1a==""

*m42
rename m42a m42_0_1a
rename m42b m42_0_2a
rename m42c m42_0_3a

replace m42_0_1a="9998" if m42_0_1a=="8888"
replace m42_0_1a="9998" if m42_0_1a==""
replace m42_0_2a="9998" if m42_0_2a=="8888"
replace m42_0_2a="9998" if m42_0_2a==""
replace m42_0_3a="9998" if m42_0_3a=="8888"
replace m42_0_3a="9998" if m42_0_3a==""

gen m42_0=0
replace m42_0=1 if m42_0_1a!="9998"

replace m42_1=9999 if m42_1==9
replace m42_1=9998 if m42_0==0
replace m42_1=9998 if m42_1==0

replace m42_1a="9998" if m42_1a==""
replace m42_1a="9998" if m42_1a=="8888"
replace m42_1a="9998" if m42_1==9998
replace m42_1a="9998" if m42_1==1

*m43
replace m43=9999 if m43==9
replace m43=9999 if m43==.
replace m43=9998 if m43==0

*m44
rename m44a m44
replace m44_1=9998 if m44==1
replace m44_2=9998 if m44==1
replace m44_3=9998 if m44==1
replace m44=2 if m44==0
replace m44=0 if m44==1
replace m44=1 if m44==2

*m45
rename m45_1 m45_2002
rename m45_2 m45_2001
rename m45_3 m45_2000
rename m45_4 m45_1999
rename m45_5 m45_1998

replace m45_2002=9998 if m44==0
replace m45_2001=9998 if m44==0
replace m45_2000=9998 if m44==0
replace m45_1999=9998 if m44==0
replace m45_1998=9998 if m44==0

*m49_1-m49_5
replace m49_1=9998 if m48==0
replace m49_2=9998 if m48==0
replace m49_3=9998 if m48==0
replace m49_4=9998 if m48==0
replace m49_5=9998 if m48==0

*m49_5a
replace m49_5a="9998" if m49_5a=="8888"
replace m49_5a="9998" if m49_5a==""

*m51_1
rename m51_1 m51_1a
replace m51_1a="9998" if m51_1a==""

*m51_2
rename m51_2 m51_2a
replace m51_2a="9998" if m51_2a==""

*m52_2
replace m52_2=9998 if m52_2==0
replace m52_2=9998 if m52_2!=9998 & m52_1==0

*m53 all
rename m53_wood1_2 m53_wood1_2a
rename m53_wood1_4 m53_wood1_4a
rename m53_wood2_2 m53_wood2_2a
rename m53_wood2_4 m53_wood2_4a
rename m53_wood3_2 m53_wood3_2a
rename m53_wood3_4 m53_wood3_4a
rename m53_wood4_2 m53_wood4_2a
rename m53_wood4_4 m53_wood4_4a

*m54
replace m54=9998 if m54==8888

*m55_5a
replace m55_5a="9998" if m55_5a=="8888"
replace m55_5a="9998" if m55_5a==""

*m56 all vars
rename m56_1a m56_1_2002
rename m56_1b m56_1_2001
rename m56_1c m56_1_2000
rename m56_1d m56_1_1999
rename m56_1e m56_1_1998

rename m56_2a m56_2_2002
rename m56_2b m56_2_2001
rename m56_2c m56_2_2000
rename m56_2d m56_2_1999
rename m56_2e m56_2_1998

rename m56_3a m56_3_2002
rename m56_3b m56_3_2001
rename m56_3c m56_3_2000
rename m56_3d m56_3_1999
rename m56_3e m56_3_1998

*m57 variables
rename m57_1a m57_1_1
rename m57_1b m57_1_2
rename m57_2a m57_2_1
rename m57_2b m57_2_2
rename m57_3a m57_3_1
rename m57_3b m57_3_2
rename m57_4a m57_4_1
rename m57_4b m57_4_2
rename m57_5a m57_5_1
rename m57_5b m57_5_2
rename m57_6a m57_6_1
rename m57_6b m57_6_2
rename m57_7a m57_7_1
rename m57_7b m57_7_2
rename m57_8a m57_8_1
rename m57_8b m57_8_2
rename m57_9a m57_9_1
rename m57_9b m57_9_2
rename m57_10a m57_10_1
rename m57_10b m57_10_2
rename m57_10c m57_10_a
rename m57_11a m57_11_1
rename m57_11b m57_11_2
rename m57_11c m57_11_a

replace m57_10_a="9998" if m57_10_a=="8888"
replace m57_10_a="9998" if m57_10_a==""

replace m57_11_a="9998" if m57_11_a=="8888"
replace m57_11_a="9998" if m57_11_a==""

*m58_3a
replace m58_3a="9998" if m58_3a=="8888"
replace m58_3a="9998" if m58_3a==""

*m58_3
replace m58_3=1 if m58_3a!="9998"

*m59_1b
rename m59_1a m59_1
rename m59_1b m59_1_1a
rename m59_1c m59_1_2a
replace m59_1_1a="9998" if m59_1_1a=="8888"
replace m59_1_1a="9998" if m59_1_1a==""

*m59_1c
replace m59_1_2a="9998" if m59_1_2a=="8888"
replace m59_1_2a="9998" if m59_1_2a==""

*m59_2b
rename m59_2a m59_2
rename m59_2b m59_2_1a
rename m59_2c m59_2_2a
replace m59_2_1a="9998" if m59_2_1a=="8888"
replace m59_2_1a="9998" if m59_2_1a==""

*m59_2c
replace m59_2_2a="9998" if m59_2_2a=="8888"
replace m59_2_2a="9998" if m59_2_2a==""

*m61_1
replace m61_1=9999 if m61_1==.
replace m61_1=9998 if m61_1==8888
replace m61_1=9998 if m61==0

*m61_2
replace m61_2=9999 if m61_2==.
replace m61_2=9998 if m61_2==8888
replace m61_2=9998 if m61==0

*m61_3
rename m61_3 m61_3a
replace m61_3a="9998" if m61_3a=="8888"
replace m61_3a="9998" if m61_3a==""
replace m61_3a="9998" if m61==0

*m61_4
replace m61_4=9999 if m61_4==.
replace m61_4=9998 if m61_4==8888
replace m61_4=9998 if m61==0

*m62
replace m62=9999 if m62==.
replace m62=9999 if m62==999
replace m62=9998 if m62==8888

*m62a-m65e
rename m62a m63
rename m63a m63_2002
rename m63b m63_2001
rename m63c m63_2000
rename m63d m63_1999
rename m63e m63_1998

rename m64a m64_2002
rename m64b m64_2001
rename m64c m64_2000
rename m64d m64_1999
rename m64e m64_1998

rename m65a m65_2002
rename m65b m65_2001
rename m65c m65_2000
rename m65d m65_1999
rename m65e m65_1998

replace m63_2002=9998 if m63_2002==8888
replace m63_2001=9998 if m63_2001==8888
replace m63_2000=9998 if m63_2000==8888
replace m63_1999=9998 if m63_1999==8888
replace m63_1998=9998 if m63_1998==8888

replace m64_2002=9998 if m64_2002==8888
replace m64_2001=9998 if m64_2001==8888
replace m64_2000=9998 if m64_2000==8888
replace m64_1999=9998 if m64_1999==8888
replace m64_1998=9998 if m64_1998==8888

replace m65_2002=9998 if m65_2002==8888
replace m65_2001=9998 if m65_2001==8888
replace m65_2000=9998 if m65_2000==8888
replace m65_1999=9998 if m65_1999==8888
replace m65_1998=9998 if m65_1998==8888

*m66_2
replace m66_2=9998 if m66_2==8888

*m67a-m67d
rename m67a m67_2002_1
rename m67b m67_2002_2
rename m67c m67_2001_1
rename m67d m67_2001_2

replace m67_2002_1=9998 if m67_2002_1==.
replace m67_2002_2=9998 if m67_2002_2==.
replace m67_2001_1=9998 if m67_2001_1==.
replace m67_2001_2=9998 if m67_2001_2==.

*m69 all
rename m69_1 m69_1_1
rename m69_1a m69_1_2
rename m69_2 m69_2_1
rename m69_2a m69_2_2
rename m69_3 m69_3_1
rename m69_3a m69_3_2
rename m69_4 m69_4_1
rename m69_4a m69_4_2
rename m69_5 m69_5_1
rename m69_5a m69_5_a

replace m69_1_2=9999 if m69_1_2==.
replace m69_2_2=9999 if m69_2_2==.
replace m69_3_2=9999 if m69_3_2==.
replace m69_4_2=9999 if m69_4_2==.
replace m69_5_a="9998" if m69_5_a==""

*m70 all
rename m70_2 m70_1a
rename m70_3 m70_2
rename m71_2 m71_1a
rename m71_3 m71_2
rename m72_2 m72_1a
rename m72_3 m72_2
rename m73_2 m73_1a
rename m73_3 m73_2
rename m74_2 m74_1a

replace m70_1a="9998" if m70_1a==""
replace m71_1a="9998" if m71_1a==""
replace m72_1a="9998" if m72_1a==""
replace m73_1a="9998" if m73_1a==""
replace m74_1a="9998" if m74_1a==""

*m75 all
rename m75_cr1_2 m75_cr1_2a
rename m75_cr1_6 m75_cr1_6a
rename m75_cr2_2 m75_cr2_2a
rename m75_cr2_6 m75_cr2_6a
rename m75_cr3_2 m75_cr3_2a
rename m75_cr3_6 m75_cr3_6a

replace m75_cr1_9=9999 if m75_cr1_9==9
replace m75_cr1_9=0 if m75_cr1_9==2
replace m75_cr1_9=2 if m75_cr1_9==3

*m76
replace m76=9998 if m76==8
replace m76=9998 if m76==3
replace m76=9998 if m76==0
replace m76=0 if m76==2

*m76a
replace m76a="9998" if m76a=="8888"
replace m76a="9998" if m76a==""

*m77-m79
replace m77="9998" if m77=="8888"
replace m77="9998" if m77==""

replace m78="9998" if m78=="8888"
replace m78="9998" if m78==""

replace m79="9998" if m79=="8888"
replace m79="9998" if m79==""

*mcnty
replace mcnty="Santarem" if (substr(mcnty,1,1)=="s" | substr(mcnty,1,1)=="S")
replace mcnty="9999" if mcnty==""

*mvilge
replace mvilge="9999" if mvilge==""

*int variables
rename mintrvr int_interviewer_m
rename dataentr int_entry
rename mcnty int_county_m
rename mvilge int_village_m
rename mdate int_date_m
rename mwoman id_widow
rename mroad int_road_m
rename mutm_x int_utm_x_m
rename mutm_y int_utm_y_m
rename notes int_notes

*date vars
replace int_date_m="9999" if int_date_m==""
replace int_date_m="19/06/2003" if substr(int_date_m,-3,1)=="/"
replace int_date_m="18/06/2003" if substr(int_date_m,-5,1)=="6"
replace int_date_m="17/07/2003" if substr(int_date_m,-7,2)=="/7"
replace int_date_m="13/07/2003" if substr(int_date_m,-7,2)=="/0"
replace int_date_m="12/07/2003" if substr(int_date_m,-10,5)=="07/12"
replace int_date_m="14/08/2003" if substr(int_date_m,-10,5)=="08/14"

replace int_date_m=substr(int_date_m,-4,4)+"/"+substr(int_date_m,-7,2)+"/"+substr(int_date_m,-10,2)
replace int_date_m="9999" if int_date_m=="9999//"

gen time=dofc(timstamp)
gen year=year(time)
gen month=month(time)
gen day=day(time)
tostring year, replace
tostring month, replace
tostring day, replace
replace month="0"+substr(month,1,1) if substr(month,-2,1)==""
replace day="0"+substr(day,1,1) if substr(day,-2,1)==""
gen int_entered=year+"/"+month+"/"+day
drop time year month day timstamp

*id variables
rename mhouseid id_house
rename mpropid id_prop
rename mprop_hh_id id_prop_hh
rename donalote_ id_dona
rename donolote_ id_dono
rename mfhead id_name_w_2
gen id_name_m=m1a
gen id_name_w=w1
rename finalsample id_final_sample
rename registro_ id_registro_m
rename registro_w id_registro_w

*w1
rename w1 w1a

*w2-w2b
replace w2=9999 if w2==9
rename w2a w2_5a
rename w2b w2_6a

replace w2_5a="9998" if w2_5a=="8888"
replace w2_5a="9998" if w2_5a==""
replace w2_5a="9998" if w2_5a!="9998" & w2_5a!="9999" & w2!=5

replace w2_6a="9998" if w2_6a=="8888"
replace w2_6a="9998" if w2_6a==""
replace w2_6a="9998" if w2_6a!="9998" & w2_6a!="9999" & w2!=6

*w3
rename w3 w3a

*w4a
rename w4a w4_month
replace w4_month=9999 if w4_month==0
replace w4_month=9999 if w4_month==99

*w4b
rename w4b w4_year
replace w4_year=9999 if w4_year==0

*w5a
rename w5a w5_month
replace w5_month=9999 if w5_month==0
replace w5_month=9999 if w5_month==99
replace w5_month=9998 if w5_month==88
replace w5_month=9 if w5_month==19

*w5b
rename w5b w5_year
replace w5_year=9999 if w5_year==999
replace w5_year=9998 if w5_year==8888

*w6
replace w6=9999 if w6==9
replace w6=1 if w6==.
replace w6=2 if w6==0

*w7a-w7f

replace w7a=9998 if w6==2
replace w7b=9998 if w6==2
replace w7c=9998 if w6==2
replace w7d=9998 if w6==2
replace w7e=9998 if w6==2
replace w7f=9998 if w6==2

replace w7a=9999 if w6==9999
replace w7b=9999 if w6==9999
replace w7c=9999 if w6==9999
replace w7d=9999 if w6==9999
replace w7e=9999 if w6==9999
replace w7f=9999 if w6==9999

replace w7b=9998 if w7a==1
replace w7c=9998 if w7a==1
replace w7d=9998 if w7a==1
replace w7e=9998 if w7a==1
replace w7f=9998 if w7a==1

rename w7a w7_1
rename w7b w7_2
rename w7c w7_3
rename w7d w7_4
rename w7e w7_5
rename w7f w7_6

*w9_1
replace w9_1=0 if w9_1==.
replace w9_2=0 if w9_2==.
replace w9_3_1=0 if w9_3_1==.
replace w9_3_2=0 if w9_3_2==.
replace w9_3_3=0 if w9_3_3==.
replace w9_3_4=0 if w9_3_4==.
replace w9_3_5=0 if w9_3_5==.
replace w9_3_6=0 if w9_3_6==.

*w10
replace w10=9999 if w10==9
replace w10=1 if w10==8
replace w10=9999 if w10==0

*w10a
replace w10a="9998" if w10!=5

*w11a
rename w11a w11_1
replace w11_1=9998 if w11_1==88
replace w11_1=9999 if w11_1==99
replace w11_1=9999 if w11_1==.

*w11b
rename w11b w11_2
replace w11_2=9998 if w11_2==88
replace w11_2=9999 if w11_2==99
replace w11_2=9999 if w11_2==.

replace w11_1=9999 if (w11_1==0 & w11_2==0)
replace w11_2=9999 if (w11_1==9999 & w11_2==0)

*w12_1
rename w12_1 w12_1a
replace w12_1a="Santarem" if (substr(w12_1a, 1,1)=="s" | substr(w12_1a, 1,1)=="S")

*w12_2
replace w12_2=9999 if w12_2==9
replace w12_2=9999 if w12_2==0
replace w12_2=9998 if w12_2==8

*w12_3
rename w12_3 w12_3a
replace w12_3="9999" if w12_3==""
replace w12_3="9998" if w12_3=="8888"

*w12_4
replace w12_4="9998" if w12_4=="8888"
destring w12_4, replace

*w12_5
replace w12_5=9998 if w12_5==888
replace w12_5=9999 if w12_5==999

*w12_6a-w12_6c
rename w12_6a w12_6_1a
rename w12_6b w12_6_2a
rename w12_6c w12_6_3a

replace w12_6_1a="9999" if w12_6_1a==""
replace w12_6_1a="9998" if w12_6_1a=="8888"

replace w12_6_2a="9999" if w12_6_2a==""
replace w12_6_2a="9998" if w12_6_2a=="8888"

replace w12_6_3a="9999" if w12_6_3a==""
replace w12_6_3a="9998" if w12_6_3a=="8888"

*w13_1
replace w13_1=9999 if w13_1==9
replace w13_1=9999 if w13_1==0
replace w13_1=9998 if w13_1==8

*w13_2
rename w13_2 w13_2a
replace w13_2a="9999" if w13_2a==""
replace w13_2a="9998" if w13_2a=="8888"

*w13_3
replace w13_3="9998" if w13_3=="8888"
replace w13_3="9999" if w13_3==""
replace w13_3="9998" if w13_3=="888"
replace w13_3="10" if w13_3=="10 min"
replace w13_3="120" if w13_3=="120 min"
replace w13_3="80" if w13_3=="80 min"
replace w13_3="15" if substr(w13_3,1,4)=="a pe"
replace w13_3="40" if w13_3=="40'"
destring w13_3, replace

*w13_4
replace w13_4=9999 if w13_1==9999
replace w13_4=9998 if w13_4==888
replace w13_4=9999 if w13_4==999

*w13_5a-w13_5c
rename w13_5a w13_5_1a
rename w13_5b w13_5_2a
rename w13_5c w13_5_3a

replace w13_5_1a="9999" if w13_5_1a==""
replace w13_5_1a="9998" if w13_5_1a=="8888"

replace w13_5_2a="9999" if w13_5_2a==""
replace w13_5_2a="9998" if w13_5_2a=="8888"

replace w13_5_3a="9999" if w13_5_3a==""
replace w13_5_3a="9998" if w13_5_3a=="8888"

*w14_1
rename w14_1 w14_1a
replace w14_1a="9999" if w14_1a==""
replace w14_1a="9998" if w14_1a=="8888"

*w14_2
replace w14_2=9998 if w14_2==8
replace w14_2=9999 if w14_2==9
replace w14_2=9999 if w14_2==0

*w14_3a
rename w14_3 w14_3a
replace w14_3a="9999" if w14_3a==""
replace w14_3a="9998" if w14_3a=="8888"

*w14_4
replace w14_4=subinstr(w14_4," min","",.)
replace w14_4=subinstr(w14_4,"min","",.)
replace w14_4=subinstr(w14_4,"'","",.)
replace w14_4="60" if substr(w14_4,1,3)=="a p"
replace w14_4="135" if substr(w14_4,1,5)=="120 a"
replace w14_4="135" if substr(w14_4,1,5)=="de 12"
replace w14_4="135" if substr(w14_4,1,4)=="120-"
replace w14_4="165" if substr(w14_4,1,4)=="150-"
replace w14_4="80" if substr(w14_4,1,4)=="70 o"
replace w14_4="9999" if substr(w14_4,1,3)=="nao"
replace w14_4="90" if substr(w14_4,1,5)=="90/10"
replace w14_4="60" if substr(w14_4,1,5)=="10/60"
replace w14_4="60" if substr(w14_4,1,5)=="60/10"
replace w14_4="40" if substr(w14_4,1,5)=="onibu"


replace w14_4="9999" if w14_4==""
replace w14_4="9999" if w14_4=="999"
replace w14_4="9998" if w14_4=="8888"

destring w14_4, replace

*w14_5
replace w14_5=9998 if w14_5==888
replace w14_5=9999 if w14_5==999

*w14_6a-w14_6c
rename w14_6a w14_6_1a
rename w14_6b w14_6_2a
rename w14_6c w14_6_3a

replace w14_6_1a="9999" if w14_6_1a==""
replace w14_6_1a="9998" if w14_6_1a=="8888"

replace w14_6_2a="9999" if w14_6_2a==""
replace w14_6_2a="9998" if w14_6_2a=="8888"

replace w14_6_3a="9999" if w14_6_3a==""
replace w14_6_3a="9998" if w14_6_3a=="8888"

*w101_1-w101_2
replace w101_1=9999 if w101_1==9
replace w101_1=9998 if w101_1==8
replace w101_1=9999 if w101_1==0

replace w101_2=9999 if w101_2==9
replace w101_2=9998 if w101_2==8
replace w101_2=9999 if w101_2==0

rename w101_1 w101_first
rename w101_2 w101_second

rename w101_1a w101_first_a
rename w101_2a w101_second_a

*w102_7a
replace w102_7a="9999" if w102_7a==""
replace w102_7a="9998" if w102_7a=="8888"

*w108
replace w108=9998 if w108==8888

*w109
replace w109=9998 if w109==8888

*w110
replace w110=9998 if w110==8888

*w112a
replace w112a="9999" if w112a==""
replace w112a="9998" if w112a=="8888"

*w117
replace w117=9999 if w117==999

*w119
replace w119=9999 if w119==999

*w119_a
rename w119_a w119a
replace w119a="9999" if w119a==""
replace w119a="9998" if w119a=="8888"

*w120_7a
replace w120_7a="9999" if w120_7a==""
replace w120_7a="9998" if w120_7a=="8888"

*w121_6a
replace w121_6a="9999" if w121_6a==""
replace w121_6a="9998" if w121_6a=="8888"

*w122_7a
replace w122_7a="9999" if w122_7a==""
replace w122_7a="9998" if w122_7a=="8888"

*w124
replace w124=9999 if w124==9
replace w124=9999 if w124==0
replace w124=2 if w124==20

*w125_6a
replace w125_6a="9999" if w125_6a==""
replace w125_6a="9998" if w125_6a=="8888"

foreach var of varlist w126a-w144d {
		if (substr("`var'",-2,2)=="ba" | substr("`var'",-2,2)=="ca")  {
		replace `var'="9998" if `var'=="8888"
		replace `var'="9999" if `var'==""
		}
}

forvalues k = 126/144 {
rename w`k'a w`k'_1
rename w`k'b w`k'_2
rename w`k'ba w`k'_2a
rename w`k'c w`k'_3
rename w`k'ca w`k'_3a
rename w`k'd w`k'_4
}

replace w126_1=9999 if w126_1==99

forvalues k = 126/144 {
replace w`k'_1=9999 if w126_1==9999
replace w`k'_2=9999 if w`k'_1==9999
replace w`k'_3=9999 if w`k'_1==9999
replace w`k'_4=9999 if w`k'_1==9999

replace w`k'_1=9999 if w`k'_1==.
replace w`k'_2=9999 if w`k'_2==.
replace w`k'_3=9999 if w`k'_3==.
replace w`k'_4=9999 if w`k'_4==.
replace w`k'_4=9999 if w`k'_4==0

replace w`k'_1=9998 if w`k'_1==8
replace w`k'_2=9998 if w`k'_2==8
replace w`k'_3=9998 if w`k'_3==8
replace w`k'_4=9998 if w`k'_4==8

replace w`k'_2=9999 if w`k'_2==0
replace w`k'_2=9999 if w`k'_2==9

replace w`k'_3=9999 if w`k'_3==0
replace w`k'_3=9999 if w`k'_3==9

replace w`k'_4=9999 if w`k'_4==0
replace w`k'_4=9999 if w`k'_4==9
}

*w144-w153
forvalues k = 145/153 {
replace w`k'=9999 if w`k'==9
replace w`k'=9998 if w`k'==8
replace w`k'=9999 if w`k'==0
}

*w154
replace w154=9999 if w154==9
replace w154=9998 if w154==8

*w154a
replace w154a="9998" if w154a==""
replace w154a="9998" if w154a=="8888"

*w155
replace w155=9999 if w155==9
replace w155=9998 if w155==8
replace w155=9999 if w155==0

*w155a
replace w155a="9998" if w155a==""
replace w155a="9998" if w155a=="8888"

*w156_1
replace w156_1=9999 if w156_1==99
replace w156_1=9998 if w156_1==0

*w156_1a
replace w156_1a="9998" if w156_1!=9
replace w156_1a="9999" if w156_1a=="9998" & w156_1==9
replace w156_1a="9999" if w156_1a=="" & w156_1==9

*w156_2
replace w156_2=9999 if w156_2==99
replace w156_2=9998 if w156_2==0
replace w156_2=9998 if w156_2==88
replace w156_2=9999 if w156_2==.

*w156_2a
replace w156_2a="9998" if w156_2!=9
replace w156_2a="9999" if w156_2a=="9998" & w156_2==9
replace w156_2a="9999" if w156_2a=="" & w156_2==9

*w156_3
replace w156_3=9999 if w156_3==99
replace w156_3=9998 if w156_3==0
replace w156_3=9998 if w156_3==88
replace w156_3=9999 if w156_3==.

*w156_3a
replace w156_3a="9998" if w156_3!=9
replace w156_3a="9999" if w156_3a=="9998" & w156_3==9
replace w156_3a="9999" if w156_3a=="" & w156_3==9

*w157_4a
replace w157_4a="9998" if w157_4a=="8888"
replace w157_4a="9998" if w157_4a=="N/A"
replace w157_4a="9998" if w157_4a=="n/a"
replace w157_4a="9998" if w157_4a==""
replace w157_4a="9999" if w157_4a=="9998" & w157_4==1

*w158_4a
replace w158_4a="9998" if w158_4a==""
replace w158_4a="9999" if w158_4a=="9998" & w158_4==1

*w159_5a
replace w159_5a="9998" if w159_5a=="8888"
replace w159_5a="9998" if w159_5a=="N/A"
replace w159_5a="9998" if w159_5a==""
replace w159_5a="9999" if w159_5a=="9998" & w159_5==1

*w160_5a
replace w160_5a="9998" if w160_5a==""

*w161
replace w161=9999 if w161==.
replace w161=9998 if w161==88
replace w161=9998 if w161==888
replace w161=9999 if w161==0

gen w161_1=0
gen w161_2=0
gen w161_3=0
gen w161_4=0
gen w161_5=0
gen w161_6=0

replace w161_1=1 if w161==1
replace w161_2=1 if w161==2
replace w161_3=1 if w161==3
replace w161_4=1 if w161==4
replace w161_5=1 if w161==5
replace w161_6=1 if w161==6

replace w161_1=9999 if w161==9999
replace w161_2=9999 if w161==9999
replace w161_3=9999 if w161==9999
replace w161_4=9999 if w161==9999
replace w161_5=9999 if w161==9999
replace w161_6=9999 if w161==9999

replace w161_1=9998 if w161==9998
replace w161_2=9998 if w161==9998
replace w161_3=9998 if w161==9998
replace w161_4=9998 if w161==9998
replace w161_5=9998 if w161==9998
replace w161_6=9998 if w161==9998

drop w161

*w161a
rename w161a w161_6a
replace w161_6a="9998" if w161_6a==""
replace w161_6a="9999" if w161_6a=="9998" & w161_6==1

*162_5a
replace w162_5a="9998" if w162_5a==""
replace w162_5a="9999" if w162_5a=="9998" & w162_5==1

*163_5a
replace w163_5a="9998" if w163_5a==""
replace w163_5a="9999" if w163_5a=="9998" & w163_5==1

*INT vars
replace wcnty="Santarem" if (substr(wcnty,1,1)=="S" | substr(wcnty,1,1)=="s")
replace wcnty="Belterra" if (substr(wcnty,1,1)=="B" | substr(wcnty,1,1)=="b")
replace wcnty="Santarem" if substr(wcnty,-3,3)=="rem"
replace wcnty="9999" if (wcnty=="" | wcnty=="--")

rename wdate int_date_w
rename whead id_name_m_2
rename wintrno id_w_number
rename wintrvr int_interviewer_w
rename wman id_dona_is_man
rename wnothr int_other_w
rename womanhhroster int_roster_no_w
rename womanid id_woman
rename wroad int_road_w
rename wutm_x int_utm_x_w
rename wutm_y int_utm_y_w
rename wcnty int_county_w
rename wvilge int_village_w
rename wownr int_owner_w

replace int_village_w="9999" if int_village_w==""
replace int_village_w="9999" if int_village_w=="--"

replace int_date_w="9999" if int_date_w==""
replace int_date_w="29/08/2003" if substr(int_date_w,-5,5)=="08/03"
replace int_date_w="11/08/2003" if substr(int_date_w,-5,5)=="/8/03"
replace int_date_w="01/09/2003" if substr(int_date_w,-5,5)=="/9/03"
replace int_date_w="13/08/2003" if substr(int_date_w,-7,7)=="/8/2003"
replace int_date_w="30/06/2003" if substr(int_date_w,-7,7)=="/6/2003"

replace int_date_w="13/08/2003" if substr(int_date_w,3,1)=="."

replace int_date_w="19/06/2003" if substr(int_date_m,-3,1)=="/"
replace int_date_m="18/06/2003" if substr(int_date_m,-5,1)=="6"
replace int_date_m="17/07/2003" if substr(int_date_m,-7,2)=="/7"
replace int_date_m="13/07/2003" if substr(int_date_m,-7,2)=="/0"
replace int_date_m="12/07/2003" if substr(int_date_m,-10,5)=="07/12"
replace int_date_m="14/08/2003" if substr(int_date_m,-10,5)=="08/14"

replace int_date_w=substr(int_date_w,-4,4)+"/"+substr(int_date_w,-7,2)+"/"+substr(int_date_w,-10,2)
replace int_date_w="9999" if int_date_w=="9999//"

*utm coordinates
replace int_utm_x_m=9999 if int_utm_x_m==0
replace int_utm_y_m=9999 if int_utm_y_m==0
replace int_utm_x_w=9999 if int_utm_x_w==0
replace int_utm_y_w=9999 if int_utm_y_w==0
replace int_utm_x_w=9999 if int_utm_x_w==99999
replace int_utm_y_w=9999 if int_utm_y_w==99999
replace int_utm_x_w=9999 if int_utm_x_w==999999
replace int_utm_y_w=9999 if int_utm_y_w==999999
replace int_utm_x_w=9999 if int_utm_x_w==9999999
replace int_utm_y_w=9999 if int_utm_y_w==9999999
replace int_utm_x_w=9999 if int_utm_x_w==.
replace int_utm_y_w=9999 if int_utm_y_w==.

**************************************************************
*drop duplicate vars from woman's questionairre
drop wpropid whouseid

**************************************************************
* Drop junk and questionable variables

drop m2c_1 m2c_2 m13_3reclass m21_10b m57_12a m57_12b m57_12c otherwoman_ ///
w4_01 w16 w17 

**********************************************************************
* add  variable descriptions

label variable id_dona "Dichot: Household includes dona do lote (female head of lot) [form]"
label variable id_dona_is_man "Dichot: Female head of house survey respondent is male [form]"
label variable id_dono "Dichot: Household includes dono do lote (male head of lot) [form]"
label variable id_final_sample "Dichot: Household included in final property sample [created]"
label variable id_house "Num: Household ID number [form]"
label variable id_name_m "String: Name of male head of household [form]"
label variable id_name_m_2 "String: Name of male head of household (Dona report) [form]"
label variable id_name_w "String: Name of female head of household [form]"
label variable id_name_w_2 "String: Name of female head of household (Dono report) [form]"
label variable id_prop "Num: Property ID number [form]"
label variable id_prop_hh "Num: Property ID + Household ID number [form]"
label variable id_registro_m "Dichot: Source of information from male is the initial household register [form]"
label variable id_registro_w "Dichot: Source of information from female is the initial household register [form]"
label variable id_w_number "Num: Woman interview number [form]"
label variable id_widow "Dichot: Owner is a widow [form]"
label variable id_woman "Num: Unique woman ID number (for linking) [form]"
label variable int_county_m "String: County of residence (male report) [form]"
label variable int_county_w "String: County of residence (female report) [form]"
label variable int_date_m "String: Year/month/day of interview with male head of house [form]"
label variable int_date_w "String: Year/month/day of interview with female head of house [form]"
label variable int_entered "String: Year/month/day of data entry [created]"
label variable int_entry "String: Name of person who entered data [created]"
label variable int_interviewer_m "String: Primary interviewer name (male head of household) [created]"
label variable int_interviewer_w "String: Primary interviewer name (female head of household) [created]"
label variable int_notes "String: Miscellaneous interview notes from the field [form]"
label variable int_other_w "Num: Number of other women in household [form]"
label variable int_owner_w "Dichot: Household head is the owner [form]"
label variable int_road_m "String: Nearest road and km marker (male report) [form]"
label variable int_road_w "String: Nearest road and km marker (female report) [form]"
label variable int_roster_no_w "Cat: Household roster number of female respondent [form]"
label variable int_utm_x_m "Num: House UTM coordinates x (male report) [form]"
label variable int_utm_x_w "Num: House UTM coordinates x (female report) [form]"
label variable int_utm_y_m "Num: House UTM coordinates y (male report) [form]"
label variable int_utm_y_w "Num: House UTM coordinates y (female report) [form]"
label variable int_village_m "String: Name of village (male report) [form]"
label variable int_village_w "String: Name of village (female report) [form]"
label variable m10_1 "Dichot: Used as a criteria to select this property: proximity to city [m10]"
label variable m10_2 "Dichot: Used as a criteria to select this property: soils [m10]"
label variable m10_3 "Dichot: Used as a criteria to select this property: neighbors [m10]"
label variable m10_4 "Dichot: Used as a criteria to select this property: good price [m10]"
label variable m10_5 "Dichot: Used as a criteria to select this property: water [m10]"
label variable m10_6 "Dichot: Used as a criteria to select this property: good road [m10]"
label variable m10_7 "Dichot: Used as a criteria to select this property: other criteria [m10]"
label variable m10_7a "String: Text of other criteria [m10]"
label variable m10_8 "Dichot: Used as a criteria to select this property: NA [m10]"
label variable m10_main "Cat: Main criteria utilized to select property (most important) [m10]"
label variable m11 "Cat: Where did you spend most of the year [m11]"
label variable m11a "String: Text of other location [m11]"
label variable m12_1 "Num: How many months per year do you live in each location: city/village [m12]"
label variable m12_2 "Num: How many months per year do you live in each location: rural property [m12]"
label variable m12_nap "Dichot: How many months per year do you live in each location: NA [m12]"
label variable m13_1 "String: Which city do you go to [m13]"
label variable m13_2 "Ord: How often do you go: city [m13]"
label variable m13_3 "String: Mode of transportation: city [m13]"
label variable m13_4 "Num: How much time does it take per trip [m13]"
label variable m13_5 "Num: Cost per trip: city [m13]"
label variable m13_6_1a "String: What are the main activities in city: first [m13]"
label variable m13_6_2a "String: What are the main activities in city: second [m13]"
label variable m13_6_3a "String: What are the main activities in city: third [m13]"
label variable m14_2 "Ord: How often do you go: rural property [m14]"
label variable m14_3 "String: Mode of transportation: rural property [m14]"
label variable m14_4 "Num: How much time does it take per trip: rural property [m14]"
label variable m14_5 "Num: Cost per trip: rural property [m14]"
label variable m14_6_1a "String: What are the main reasons for the rural trip: first [m14]"
label variable m14_6_2a "String: What are the main reasons for the rural trip: second [m14]"
label variable m14_6_3a "String: What are the main reasons for the rural trip: third [m14]"
label variable m15_1 "String: When you don't go who goes [m15]"
label variable m15_2 "Ord: How often does this person go [m15]"
label variable m15_3a "String: Mode of transportation: other goes [m15]"
label variable m15_4 "Num: How much time does it take per trip: other goes [m15]"
label variable m15_5 "Num: Cost per trip: other goes [m15]"
label variable m15_6_1a "String: What are this person's main activities in the city/rural property: first [m15]"
label variable m15_6_2a "String: What are this person's main activities in the city/rural property: second [m15]"
label variable m15_6_3a "String: What are this person's main activities in the city/rural property: third [m15]"
label variable m16_1 "Cat: Condition of road that runs at the frong of the lot: surface [m16]"
label variable m16_1a "String: Text of other surface [m16]"
label variable m16_2 "Cat: Condition of road that runs at the frong of the lot: width [m16]"
label variable m16_3 "Cat: Condition of road that runs at the frong of the lot: transitable [m16]"
label variable m16_3a "Num: Number of months during which road is transitable [m16]"
label variable m16_4 "Cat: Condition of road that runs at the frong of the lot: largest vehicle [m16]"
label variable m17 "Dichot: Do you have/own urban properties [m17]"
label variable m18_1_1a "String: Describe urban property [m18]"
label variable m18_1 "Dichot: Describe urban property: house [m18]"
label variable m18_2 "Dichot: Describe urban property: commerce [m18]"
label variable m18_3 "Dichot: Describe urban property: land [m18]"
label variable m18_4 "Dichot: Describe urban property: other [m18]"
label variable m18_4a "String: Text of other urban property description [m18]"
label variable m19_1 "Cat: Which activity takes up most of your time: principal [m19]"
label variable m19_1a "String: Text of other activity: principal [m19]"
label variable m19_2 "Cat: Which activity takes up most of your time: secondary [m19]"
label variable m19_2a "String: Text of other activity: secondary [m19]"
label variable m1a "String: Interviewee name [m1]"
label variable m2_1 "Dichot: When did you arrive in Para: born on lot [m2]"
label variable m2_2 "Dichot: When did you arrive in Para: born in Para [m2]"
label variable m2_month "Num: Month of arrival/birth in Para/on lot [m2]"
label variable m2_year "Num: Year of arrival/birth in Para/on lot [m2]"
label variable m20_1 "Dichot: What activity is most important for your income: farming [m20]"
label variable m20_2 "Dichot: What activity is most important for your income: business/commerce [m20]"
label variable m20_3 "Dichot: What activity is most important for your income: professional [m20]"
label variable m20_4 "Dichot: What activity is most important for your income: other [m20]"
label variable m20_4a "String: Text of other important income activity [m20]"
label variable m20_5 "Dichot: What activity is most important for your income: retired [m20]"
label variable m21_01_0 "Dichot: Where does the household water come from:  well [m21]"
label variable m21_10_0 "Dichot: Where does the household water come from:  other [m21]"
label variable m21_10_1a "String: Text of other household water source [m21]"
label variable m21_01_1 "Num: Depth of well in meters [m21]"
label variable m21_01_2 "Num: Distance between well and house in meters [m21]"
label variable m21_02_0 "Dichot: Where does the household water come from:  communal well [m21]"
label variable m21_02_1 "Num: Depth of communal well in meters [m21]"
label variable m21_02_2 "Num: Distance between communal well and your house in meters [m21]"
label variable m21_03_0 "Dichot: Where does the household water come from:  creek [m21]"
label variable m21_03_1 "Num: Distance between creek and your house in meters [m21]"
label variable m21_04_0 "Dichot: Where does the household water come from:  river [m21]"
label variable m21_04_1 "Num: Distance between river and your house in meters [m21]"
label variable m21_05_0 "Dichot: Where does the household water come from:  pond [m21]"
label variable m21_05_1 "Num: Distance between pond and your house in meters [m21]"
label variable m21_05_2 "Dichot: Is there a pump at the pond [m21]"
label variable m21_06_0 "Dichot: Where does the household water come from:  spring [m21]"
label variable m21_06_1 "Num: Distance between spring and your house in meters [m21]"
label variable m21_07_0 "Dichot: Where does the household water come from:  cistern [m21]"
label variable m21_07_1 "Cat: How is the cistern system set up [m21]"
label variable m21_08_0 "Dichot: Where does the household water come from:  delivered by truck [m21]"
label variable m21_08_1 "Num: Monthly cost of water delivery in reais [m21]"
label variable m21_09_0 "Dichot: Where does the household water come from:  plumbing [m21]"
label variable m21_09_1 "Num: Monthly cost of plumbing in reais [m21]"
label variable m21_reclass "Cat: Household water source reclassification (source 1+source 2+…+source n) [m21]"
label variable m22_01_0 "Dichot: Where does the farming and herding water come from:  well [m22]"
label variable m22_10_0 "Dichot: Where does the farming and herding water come from: other [m22]"
label variable m22_10_1a "String: Text of other farming and livestock water source [m22]"
label variable m22_01_1 "Num: Depth of well in meters [m22]"
label variable m22_01_2 "Num: Distance between well and your house in meters [m22]"
label variable m22_02_0 "Dichot: Where does the farming and herding water come from: communal well [m22]"
label variable m22_02_1 "Num: Depth of communal well in meters [m22]"
label variable m22_02_2 "Num: Distance between communal well and your house in meters [m22]"
label variable m22_03_0 "Dichot: Where does the farming and herding water come from: creek [m22]"
label variable m22_03_1 "Num: Distance between creek and your house in meters [m22]"
label variable m22_04_0 "Dichot: Where does the farming and herding water come from: river [m22]"
label variable m22_04_1 "Num: Distance between river and your house in meters [m22]"
label variable m22_05_0 "Dichot: Where does the farming and herding water come from: pond [m22]"
label variable m22_05_1 "Num: Distance between pond and your house in meters [m22]"
label variable m22_05_2 "Dichot: Is there a pump at the pond [m22]"
label variable m22_06_0 "Dichot: Where does the farming and herding water come from: spring [m22]"
label variable m22_06_1 "Num: Distance between spring and your house in meters [m22]"
label variable m22_07_0 "Dichot: Where does the farming and herding water come from: cistern [m22]"
label variable m22_07_1 "Cat: How is the cistern system set up [m22]"
label variable m22_08_0 "Dichot: Where does the farming and herding water come from: delivered by truck [m22]"
label variable m22_08_1 "Num: Monthly cost of water delivery in reais [m22]"
label variable m22_09_0 "Dichot: Where does the farming and herding water come from: plumbing [m22]"
label variable m22_09_1 "Num: Monthly cost of plumbing in reais [m22]"
label variable m22_reclass "Cat: Farming and livestock water source reclassification (source 1+source 2+…+source n) [m22]"
label variable m23 "Dichot: Do you have electricity on your property [m23]"
label variable m23_1a "String: Text of other types of energy used on the lot [m23]"
label variable m23_2 "Num: Monthy cost of other energy types in reais [m23]"
label variable m24 "Num: Lot size when you first acquired it/ started working on it in hectares [m24]"
label variable m24_04_acquired_year "String: All years in which neighboring properties were acquired [m24]"
label variable m24_04_sold_year "String: All years in which neighboring properties were sold [m24]"
label variable m24_05_acquired "Num: Cumulative size of all neighboring properties acquired in hectares [m24]"
label variable m24_05_sold "Num: Cumulative size of all neighboring properties sold in hectares [m24]"
label variable m24_1 "Dichot: Did you acquire or sell neighboring properties [m24]"
label variable m25 "Dichot: Do you have/own other rural properties [m25]"
label variable m25_02_other_year "String: All years in which other rural properties were acquired [m25]"
label variable m25_03_other "Num: Cumulative size of all other rural properties acquired in hectares [m25]"
label variable m26_01 "Num: Cumulative hectares for all lots in land use: soy [m26]"
label variable m26_02 "Num: Cumulative hectares for all lots in land use: rice [m26]"
label variable m26_03 "Num: Cumulative hectares for all lots in land use: beans [m26]"
label variable m26_04 "Num: Cumulative hectares for all lots in land use: corn [m26]"
label variable m26_05 "Num: Cumulative hectares for all lots in land use: manioc [m26]"
label variable m26_06 "Num: Cumulative hectares for all lots in land use: other annual [m26]"
label variable m26_06_all_a "String: All text of other named land uses: other annual [m26]"
label variable m26_07 "Num: Cumulative hectares for all lots in land use: all annuals  total [m26]"
label variable m26_08 "Num: Cumulative hectares for all lots in land use: cupuacu [m26]"
label variable m26_09 "Num: Cumulative hectares for all lots in land use: coffee [m26]"
label variable m26_10 "Num: Cumulative hectares for all lots in land use: pepper [m26]"
label variable m26_11 "Num: Cumulative hectares for all lots in land use: banana [m26]"
label variable m26_12 "Num: Cumulative hectares for all lots in land use: other perenniel one [m26]"
label variable m26_12_all_a "String: All text of other named land uses: other perenniel one [m26]"
label variable m26_13 "Num: Cumulative hectares for all lots in land use: other perenniel two [m26]"
label variable m26_13_all_a "String: All text of other named land uses: other  perenniel two [m26]"
label variable m26_14 "Num: Cumulative hectares for all lots in land use: all perenniels total [m26]"
label variable m26_15 "Num: Cumulative hectares for all lots in land use: combined crops one [m26]"
label variable m26_15_all_a "String: All text of other named land uses: combined crops one [m26]"
label variable m26_16 "Num: Cumulative hectares for all lots in land use: combined crops two [m26]"
label variable m26_16_all_a "String: All text of other named land uses: combined crops two [m26]"
label variable m26_17 "Num: Cumulative hectares for all lots in land use: combined crops three [m26]"
label variable m26_17a_all "String: All text of other named land uses: combined crops three [m26]"
label variable m26_18 "Num: Cumulative hectares for all lots in land use: all combined crops  total [m26]"
label variable m26_19 "Num: Cumulative hectares for all lots in land use: orchard [m26]"
label variable m26_20 "Num: Cumulative hectares for all lots in land use: pasture [m26]"
label variable m26_21 "Num: Cumulative hectares for all lots in land use: SS2 [m26]"
label variable m26_22 "Num: Cumulative hectares for all lots in land use: Forest [m26]"
label variable m26_23 "Num: Cumulative hectares for all lots in land use: Water [m26]"
label variable m26_24 "Num: Cumulative hectares for all lots in land use: all other land uses total [m26]"
label variable m26_present "Dichot: Land uses reported for present day/today (not when acquired) [m26]"
label variable m28_banana_1a "String: Unit: banana [m28]"
label variable m28_banana_2 "Num: Total production last year: banana [m28]"
label variable m28_banana_3 "Cat: Purpose of production: banana [m28]"
label variable m28_banana_4a "String: Where sold: banana [m28]"
label variable m28_banana_5 "Num: Total production sold last year: banana [m28]"
label variable m28_banana_6 "Num: Total selling price last year: banana [m28]"
label variable m28_banana_7 "Num: Unit price last year: banana [m28]"
label variable m28_beans_1a "String: Unit: beans [m28]"
label variable m28_beans_2 "Num: Total production last year: beans [m28]"
label variable m28_beans_3 "Cat: Purpose of production: beans [m28]"
label variable m28_beans_4a "String: Where sold: beans [m28]"
label variable m28_beans_5 "Num: Total production sold last year: beans [m28]"
label variable m28_beans_6 "Num: Total selling price last year: beans [m28]"
label variable m28_beans_7 "Num: Unit price last year: beans [m28]"
label variable m28_cashewfr_1a "String: Unit: cashew fruit [m28]"
label variable m28_cashewfr_2 "Num: Total production last year: cashew fruit [m28]"
label variable m28_cashewfr_3 "Cat: Purpose of production: cashew fruit [m28]"
label variable m28_cashewfr_4a "String: Where sold: cashew fruit [m28]"
label variable m28_cashewfr_5 "Num: Total production sold last year: cashew fruit [m28]"
label variable m28_cashewfr_6 "Num: Total selling price last year: cashew fruit [m28]"
label variable m28_cashewfr_7 "Num: Unit price last year: cashew fruit [m28]"
label variable m28_cattle_1a "String: Unit: cattle [m28]"
label variable m28_cattle_2 "Num: Total production last year: cattle [m28]"
label variable m28_cattle_3 "Cat: Purpose of production: cattle [m28]"
label variable m28_cattle_4a "String: Where sold: cattle [m28]"
label variable m28_cattle_5 "Num: Total production sold last year: cattle [m28]"
label variable m28_cattle_6 "Num: Total selling price last year: cattle [m28]"
label variable m28_cattle_7 "Num: Unit price last year: cattle [m28]"
label variable m28_cheese_1a "String: Unit: cheese [m28]"
label variable m28_cheese_2 "Num: Total production last year: cheese [m28]"
label variable m28_cheese_3 "Cat: Purpose of production: cheese [m28]"
label variable m28_cheese_4a "String: Where sold: cheese [m28]"
label variable m28_cheese_5 "Num: Total production sold last year: cheese [m28]"
label variable m28_cheese_6 "Num: Total selling price last year: cheese [m28]"
label variable m28_cheese_7 "Num: Unit price last year: cheese [m28]"
label variable m28_citrus_1a "String: Unit: citrus [m28]"
label variable m28_citrus_2 "Num: Total production last year: citrus [m28]"
label variable m28_citrus_3 "Cat: Purpose of production: citrus [m28]"
label variable m28_citrus_4a "String: Where sold: citrus [m28]"
label variable m28_citrus_5 "Num: Total production sold last year: citrus [m28]"
label variable m28_citrus_6 "Num: Total selling price last year: citrus [m28]"
label variable m28_citrus_7 "Num: Unit price last year: citrus [m28]"
label variable m28_citrus_name "String: Text of other types of citrus production [m28]"
label variable m28_cocoa_1a "String: Unit: cocoa [m28]"
label variable m28_cocoa_2 "Num: Total production last year: cocoa [m28]"
label variable m28_cocoa_3 "Cat: Purpose of production: cocoa [m28]"
label variable m28_cocoa_4a "String: Where sold: cocoa [m28]"
label variable m28_cocoa_5 "Num: Total production sold last year: cocoa [m28]"
label variable m28_cocoa_6 "Num: Total selling price last year: cocoa [m28]"
label variable m28_cocoa_7 "Num: Unit price last year: cocoa [m28]"
label variable m28_cocoa_name "String: Text of other types of cocoa production [m28]"
label variable m28_coffee_1a "String: Unit: coffee [m28]"
label variable m28_coffee_2 "Num: Total production last year: coffee [m28]"
label variable m28_coffee_3 "Cat: Purpose of production: coffee [m28]"
label variable m28_coffee_4a "String: Where sold: coffee [m28]"
label variable m28_coffee_5 "Num: Total production sold last year: coffee [m28]"
label variable m28_coffee_6 "Num: Total selling price last year: coffee [m28]"
label variable m28_coffee_7 "Num: Unit price last year: coffee [m28]"
label variable m28_corn_1a "String: Unit: corn [m28]"
label variable m28_corn_2 "Num: Total production last year: corn [m28]"
label variable m28_corn_3 "Cat: Purpose of production: corn [m28]"
label variable m28_corn_4a "String: Where sold: corn [m28]"
label variable m28_corn_5 "Num: Total production sold last year: corn [m28]"
label variable m28_corn_6 "Num: Total selling price last year: corn [m28]"
label variable m28_corn_7 "Num: Unit price last year: corn [m28]"
label variable m28_cupu_1a "String: Unit: cupu [m28]"
label variable m28_cupu_2 "Num: Total production last year: cupu [m28]"
label variable m28_cupu_3 "Cat: Purpose of production: cupu [m28]"
label variable m28_cupu_4a "String: Where sold: cupu [m28]"
label variable m28_cupu_5 "Num: Total production sold last year: cupu [m28]"
label variable m28_cupu_6 "Num: Total selling price last year: cupu [m28]"
label variable m28_cupu_7 "Num: Unit price last year: cupu [m28]"
label variable m28_fish_1a "String: Unit: fish [m28]"
label variable m28_fish_2 "Num: Total production last year: fish [m28]"
label variable m28_fish_3 "Cat: Purpose of production: fish [m28]"
label variable m28_fish_4a "String: Where sold: fish [m28]"
label variable m28_fish_5 "Num: Total production sold last year: fish [m28]"
label variable m28_fish_6 "Num: Total selling price last year: fish [m28]"
label variable m28_fish_7 "Num: Unit price last year: fish [m28]"
label variable m28_flour_1a "String: Unit: flour [m28]"
label variable m28_flour_2 "Num: Total production last year: flour [m28]"
label variable m28_flour_3 "Cat: Purpose of production: flour [m28]"
label variable m28_flour_4a "String: Where sold: flour [m28]"
label variable m28_flour_5 "Num: Total production sold last year: flour [m28]"
label variable m28_flour_6 "Num: Total selling price last year: flour [m28]"
label variable m28_flour_7 "Num: Unit price last year: flour [m28]"
label variable m28_honey_1a "String: Unit: honey [m28]"
label variable m28_honey_2 "Num: Total production last year: honey [m28]"
label variable m28_honey_3 "Cat: Purpose of production: honey [m28]"
label variable m28_honey_4a "String: Where sold: honey [m28]"
label variable m28_honey_5 "Num: Total production sold last year: honey [m28]"
label variable m28_honey_6 "Num: Total selling price last year: honey [m28]"
label variable m28_honey_7 "Num: Unit price last year: honey [m28]"
label variable m28_horse_1a "String: Unit: horse [m28]"
label variable m28_horse_2 "Num: Total production last year: horse [m28]"
label variable m28_horse_3 "Cat: Purpose of production: horse [m28]"
label variable m28_horse_4a "String: Where sold: horse [m28]"
label variable m28_horse_5 "Num: Total production sold last year: horse [m28]"
label variable m28_horse_6 "Num: Total selling price last year: horse [m28]"
label variable m28_horse_7 "Num: Unit price last year: horse [m28]"
label variable m28_manioc_1a "String: Unit: manioc [m28]"
label variable m28_manioc_2 "Num: Total production last year: manioc [m28]"
label variable m28_manioc_3 "Cat: Purpose of production: manioc [m28]"
label variable m28_manioc_4a "String: Where sold: manioc [m28]"
label variable m28_manioc_5 "Num: Total production sold last year: manioc [m28]"
label variable m28_manioc_6 "Num: Total selling price last year: manioc [m28]"
label variable m28_manioc_7 "Num: Unit price last year: manioc [m28]"
label variable m28_milk_1a "String: Unit: milk [m28]"
label variable m28_milk_2 "Num: Total production last year: milk [m28]"
label variable m28_milk_3 "Cat: Purpose of production: milk [m28]"
label variable m28_milk_4a "String: Where sold: milk [m28]"
label variable m28_milk_5 "Num: Total production sold last year: milk [m28]"
label variable m28_milk_6 "Num: Total selling price last year: milk [m28]"
label variable m28_milk_7 "Num: Unit price last year: milk [m28]"
label variable m28_other1_1a "String: Unit: other one [m28]"
label variable m28_other1_2 "Num: Total production last year: other one [m28]"
label variable m28_other1_3 "Cat: Purpose of production: other one [m28]"
label variable m28_other1_4a "String: Where sold: other one [m28]"
label variable m28_other1_5 "Num: Total production sold last year: other one [m28]"
label variable m28_other1_6 "Num: Total selling price last year: other one [m28]"
label variable m28_other1_7 "Num: Unit price last year: other one [m28]"
label variable m28_other1_a "String: Text of other types of production one [m28]"
label variable m28_other2_1a "String: Unit: other two [m28]"
label variable m28_other2_2 "Num: Total production last year: other two [m28]"
label variable m28_other2_3 "Cat: Purpose of production: other two [m28]"
label variable m28_other2_4a "String: Where sold: other two [m28]"
label variable m28_other2_5 "Num: Total production sold last year: other two [m28]"
label variable m28_other2_6 "Num: Total selling price last year: other two [m28]"
label variable m28_other2_7 "Num: Unit price last year: other two [m28]"
label variable m28_other2_a "String: Text of other types of production two [m28]"
label variable m28_other3_1a "String: Unit: other three [m28]"
label variable m28_other3_2 "Num: Total production last year: other three [m28]"
label variable m28_other3_3 "Cat: Purpose of production: other three [m28]"
label variable m28_other3_4a "String: Where sold: other three [m28]"
label variable m28_other3_5 "Num: Total production sold last year: other three [m28]"
label variable m28_other3_6 "Num: Total selling price last year: other three [m28]"
label variable m28_other3_7 "Num: Unit price last year: other three [m28]"
label variable m28_other3_a "String: Text of other types of production three [m28]"
label variable m28_other4_1a "String: Unit: other four [m28]"
label variable m28_other4_2 "Num: Total production last year: other four [m28]"
label variable m28_other4_3 "Cat: Purpose of production: other four [m28]"
label variable m28_other4_4a "String: Where sold:  other four [m28]"
label variable m28_other4_5 "Num: Total production sold last year: other four [m28]"
label variable m28_other4_6 "Num: Total selling price last year: other four [m28]"
label variable m28_other4_7 "Num: Unit price last year: other four [m28]"
label variable m28_other4_a "String: Text of other types of production four [m28]"
label variable m28_other5_1a "String: Unit: other five [m28]"
label variable m28_other5_2 "Num: Total production last year: other five [m28]"
label variable m28_other5_3 "Cat: Purpose of production: other five [m28]"
label variable m28_other5_4a "String: Where sold: other five [m28]"
label variable m28_other5_5 "Num: Total production sold last year: other five [m28]"
label variable m28_other5_6 "Num: Total selling price last year: other five [m28]"
label variable m28_other5_7 "Num: Unit price last year: other five [m28]"
label variable m28_other5_a "String: Text of other types of production five [m28]"
label variable m28_other6_1a "String: Unit: other six [m28]"
label variable m28_other6_2 "Num: Total production last year: other six [m28]"
label variable m28_other6_3 "Cat: Purpose of production: other six [m28]"
label variable m28_other6_4a "String: Where sold: other six [m28]"
label variable m28_other6_5 "Num: Total production sold last year: other six [m28]"
label variable m28_other6_6 "Num: Total selling price last year: other six [m28]"
label variable m28_other6_7 "Num: Unit price last year: other six [m28]"
label variable m28_other6_a "Text of other types of production: other six [m28]"
label variable m28_passion_1a "String: Unit: passion [m28]"
label variable m28_passion_2 "Num: Total production last year: passion [m28]"
label variable m28_passion_3 "Cat: Purpose of production: passion [m28]"
label variable m28_passion_4a "String: Where sold: passion [m28]"
label variable m28_passion_5 "Num: Total production sold last year: passion [m28]"
label variable m28_passion_6 "Num: Total selling price last year: passion [m28]"
label variable m28_passion_7 "Num: Unit price last year: passion [m28]"
label variable m28_pepper_1a "String: Unit: pepper [m28]"
label variable m28_pepper_2 "Num: Total production last year: pepper [m28]"
label variable m28_pepper_3 "Cat: Purpose of production: pepper [m28]"
label variable m28_pepper_4a "String: Where sold: pepper [m28]"
label variable m28_pepper_5 "Num: Total production sold last year: pepper [m28]"
label variable m28_pepper_6 "Num: Total selling price last year: pepper [m28]"
label variable m28_pepper_7 "Num: Unit price last year: pepper [m28]"
label variable m28_poultry_1a "String: Unit: poultry [m28]"
label variable m28_poultry_2 "Num: Total production last year: poultry [m28]"
label variable m28_poultry_3 "Cat: Purpose of production: poultry [m28]"
label variable m28_poultry_4a "String: Where sold: poultry [m28]"
label variable m28_poultry_5 "Num: Total production sold last year: poultry [m28]"
label variable m28_poultry_6 "Num: Total selling price last year: poultry [m28]"
label variable m28_poultry_7 "Num: Unit price last year: poultry [m28]"
label variable m28_pupunha_1a "String: Unit: pupunha [m28]"
label variable m28_pupunha_2 "Num: Total production last year: pupunha [m28]"
label variable m28_pupunha_3 "Cat: Purpose of production: pupunha [m28]"
label variable m28_pupunha_4a "String: Where sold: pupunha [m28]"
label variable m28_pupunha_5 "Num: Total production sold last year: pupunha [m28]"
label variable m28_pupunha_6 "Num: Total selling price last year: pupunha [m28]"
label variable m28_pupunha_7 "Num: Unit price last year: pupunha [m28]"
label variable m28_rice_1a "String: Unit: rice [m28]"
label variable m28_rice_2 "Num: Total production last year: rice [m28]"
label variable m28_rice_3 "Cat: Purpose of production: rice [m28]"
label variable m28_rice_4a "String: Where sold: rice [m28]"
label variable m28_rice_5 "Num: Total production sold last year: rice [m28]"
label variable m28_rice_6 "Num: Total selling price last year: rice [m28]"
label variable m28_rice_7 "Num: Unit price last year: rice [m28]"
label variable m28_rubber_1a "String: Unit: rubber [m28]"
label variable m28_rubber_2 "Num: Total production last year: rubber [m28]"
label variable m28_rubber_3 "Cat: Purpose of production: rubber [m28]"
label variable m28_rubber_4a "String: Where sold: rubber [m28]"
label variable m28_rubber_5 "Num: Total production sold last year: rubber [m28]"
label variable m28_rubber_6 "Num: Total selling price last year: rubber [m28]"
label variable m28_rubber_7 "Num: Unit price last year: rubber [m28]"
label variable m28_swine_1a "String: Unit: swine [m28]"
label variable m28_swine_2 "Num: Total production last year: swine [m28]"
label variable m28_swine_3 "Cat: Purpose of production: swine [m28]"
label variable m28_swine_4a "String: Where sold: swine [m28]"
label variable m28_swine_5 "Num: Total production sold last year: swine [m28]"
label variable m28_swine_6 "Num: Total selling price last year: swine [m28]"
label variable m28_swine_7 "Num: Unit price last year: swine [m28]"
label variable m28_tapioca_1a "String: Unit: tapioca [m28]"
label variable m28_tapioca_2 "Num: Total production last year: tapioca [m28]"
label variable m28_tapioca_3 "Cat: Purpose of production: tapioca [m28]"
label variable m28_tapioca_4a "String: Where sold:  tapioca [m28]"
label variable m28_tapioca_5 "Num: Total production sold last year: tapioca [m28]"
label variable m28_tapioca_6 "Num: Total selling price last year: tapioca [m28]"
label variable m28_tapioca_7 "Num: Unit price last year: tapioca [m28]"
label variable m28_tucupi_1a "String: Unit: tucupi [m28]"
label variable m28_tucupi_2 "Num: Total production last year: tucupi [m28]"
label variable m28_tucupi_3 "Cat: Purpose of production: tucupi [m28]"
label variable m28_tucupi_4a "String: Where sold: tucupi [m28]"
label variable m28_tucupi_5 "Num: Total production sold last year: tucupi [m28]"
label variable m28_tucupi_6 "Num: Total selling price last year: tucupi [m28]"
label variable m28_tucupi_7 "Num: Unit price last year: tucupi [m28]"
label variable m28_vine_1a "String: Unit: vine [m28]"
label variable m28_vine_2 "Num: Total production last year: vine [m28]"
label variable m28_vine_3 "Cat: Purpose of production: vine [m28]"
label variable m28_vine_4a "String: Where sold: vine [m28]"
label variable m28_vine_5 "Num: Total production sold last year: vine [m28]"
label variable m28_vine_6 "Num: Total selling price last year: vine [m28]"
label variable m28_vine_7 "Num: Unit price last year: vine [m28]"
label variable m3 "String: Where did you come from? [m3]"
label variable m3_reclass "String: Where did you come from reclassification? [m3]"
label variable m30_1 "Dichot: How do you find out about weather:  does nothing [m30]"
label variable m30_10 "Dichot: How do you find out about weather: rural extension [m30]"
label variable m30_11 "Dichot: How do you find out about weather: natural resource national agency [m30]"
label variable m30_12 "Dichot: How do you find out about weather: NGOs [m30]"
label variable m30_13 "Dichot: How do you find out about weather: animal behavior [m30]"
label variable m30_13a "String: Text of animal behavior explanation [m30]"
label variable m30_14 "Dichot: How do you find out about weather: use of salt [m30]"
label variable m30_14a "String: Text of use of salt explanation [m30]"
label variable m30_15 "Dichot: How do you find out about weather: other [m30]"
label variable m30_15a "String: Text of other explanation [m30]"
label variable m30_2 "Dichot: How do you find out about weather:  doesn't know [m30]"
label variable m30_3 "Dichot: How do you find out about weather:  television [m30]"
label variable m30_4 "Dichot: How do you find out about weather: radio [m30]"
label variable m30_5 "Dichot: How do you find out about weather: newspapers [m30]"
label variable m30_6 "Dichot: How do you find out about weather: neighbors [m30]"
label variable m30_7 "Dichot: How do you find out about weather: rural union [m30]"
label variable m30_8 "Dichot: How do you find out about weather: church [m30]"
label variable m30_9 "Dichot: How do you find out about weather: state agricultural research agency [m30]"
label variable m31_1 "Dichot: If you know rain is going to be scarce, does it influence planting: size [m31]"
label variable m31_2 "Cat: How does knowing rain is going to be scace influence planting: size [m31]"
label variable m32_1 "Dichot: If you know rain is going to be scarce, does it influence planting: timing [m32]"
label variable m32_2 "Cat: How does knowing rain is going to be scace influence planting: timing [m32]"
label variable m33_1 "Dichot: If you know rain is going to be scarce, does it influence planting: choice of crop [m33]"
label variable m33_2a "String: Text of how does knowing rain is going to be scace influence planting: choice of crop [m33]"
label variable m34_1 "Dichot: Do you remember a very dry year [m34]"
label variable m34_2 "Num: Calendar year of very dry year [m34]"
label variable m35_1 "Dichot: If there is a very dry summer season, could your forest burn accidentally [m35]"
label variable m36_1 "Dichot: Do you burn pasture [m36]"
label variable m36_2 "Num: Do you burn pasture: how frequently (every X years) [m36]"
label variable m37 "Num: How many crop field areas do you burn during the year [m37]"
label variable m38_1 "Dichot: Did you take any precautions to prevent fire spreading to your neighbor's property? [m38]"
label variable m38_2a "String: Text of what did you do to prevent fire from spreading to neighbor's property [m38]"
label variable m39_1 "Cat: Did your neighbors take precuations to prevent fire from spreading to your property [m39]"
label variable m39_2a "String: Text of type of precaution neighbor took to prevent fire from spreading to your property [m39]"
label variable m40_1 "Dichot: Did you hear information that 2002 would be dry [m40]"
label variable m40_2 "Dichot: Did you believe the information [m40]"
label variable m41_0 "Dichot: Do you remember when you did the buring this last year [m41]"
label variable m41_0_1a "String: During which months did you burn: first [m41]"
label variable m41_0_2a "String: During which months did you burn: second [m41]"
label variable m41_0_3a "String: During which months did you burn: third [m41]"
label variable m41_1 "Cat: Do you always use the same burning practice or was this time any different [m41]"
label variable m41_1a "String: Text of why did you use a different burning practice this year [m41]"
label variable m42_0 "Dichot: Did you plant last year [m42]"
label variable m42_0_1a "String: Which months did you plant last year: first [m42]"
label variable m42_0_2a "String: Which months did you plant last year: second [m42]"
label variable m42_0_3a "String: Which months did you plant last year: third [m42]"
label variable m42_1 "Cat: Do you always use the same planting practice or was this time any different [m42]"
label variable m42_1a "String: Text of why did you use a different planting practice this year [m42]"
label variable m43 "Cat: Did you increase or decrease the area cut down last year [m43]"
label variable m44 "Dichot: Doesn't have cattle [m44]"
label variable m44_1 "Num: Total cattle head on lot: your own [m44]"
label variable m44_2 "Num: Total cattle head on lot: others [m44]"
label variable m44_3 "Num: Total cattle head on others lots: your own [m44]"
label variable m45_1998 "Num: How many cattle head did you have: 1998 [m45]"
label variable m45_1999 "Num: How many cattle head did you have: 1999 [m45]"
label variable m45_2000 "Num: How many cattle head did you have: 2000 [m45]"
label variable m45_2001 "Num: How many cattle head did you have: 2001 [m45]"
label variable m45_2002 "Num: How many cattle head did you have: 2002 [m45]"
label variable m46 "Dichot: Have your pastures had any problems related to the dry seasson in the past 5 years [m46]"
label variable m47 "Dichot: Did you have to rent others' pasture (terra firma) due to the dry season [m47]"
label variable m47_1_numyr "Num: Number of years pasture was rented (out of 5) [m47]"
label variable m47_2_rent "Num: Total rent paid to rent pasture (all years) [m47]"
label variable m47_3_transp "Num: Total transportation costs to rent pasture (all years) [m47]"
label variable m47_4_total "Num: Total costs (transportation and rental) to rent pasture (all years) [m47]"
label variable m48 "Dichot: Do you take cattle to the floodplain [m48]"
label variable m49_1 "Dichot: Do you take cattle to floodplain, if yes whose area do you use: own [m49]"
label variable m49_2 "Dichot: Do you take cattle to floodplain, if yes whose area do you use: marines [m49]"
label variable m49_3 "Dichot: Do you take cattle to floodplain, if yes whose area do you use: borrows [m49]"
label variable m49_4 "Dichot: Do you take cattle to floodplain, if yes whose area do you use: rents [m49]"
label variable m49_5 "Dichot: Do you take cattle to floodplain, if yes whose area do you use: other [m49]"
label variable m49_5a "String: Text of describe other area used in floodplain [m49]"
label variable m4a "String: What did you do before coming here? [m4]"
label variable m5 "Dichot: Concerning this property, are you the owner? [m5]"
label variable m50 "Dichot: Did you have to rent others' pastures in other floodplains [m50]"
label variable m50_1_numyr "Num: Number of years pasture in floodplain was rented (out of 5) [m50]"
label variable m50_2_rent "Num: Total rent paid to rent pasture in floodplain (all years) [m50]"
label variable m50_3_transp "Num: Total transportation costs to rent pasture in floodplain (all years) [m50]"
label variable m50_4_total "Num: Total costs (transportation and rental) to rent pasture in floodplain (all years) [m50]"
label variable m50_5_where_1998 "String: Where did you rent pasture in other floodplains: 1998 [m50]"
label variable m50_5_where_1999 "String: Where did you rent pasture in other floodplains: 1999 [m50]"
label variable m50_5_where_2000 "String: Where did you rent pasture in other floodplains: 2000 [m50]"
label variable m50_5_where_2001 "String: Where did you rent pasture in other floodplains: 2001 [m50]"
label variable m50_5_where_2002 "String: Where did you rent pasture in other floodplains: 2002 [m50]"
label variable m50_5_where_2003 "String: Where did you rent pasture in other floodplains: 2003 [m50]"
label variable m51_1a "String: If you have to rent others' pasture, what time of the year do you usually move [m51]"
label variable m51_2a "String: If you have to rent others' pasture, what time of the year do you usually return [m51]"
label variable m52_1 "Dichot: If you move the cattle, do you remember any year when you had to move them to the floodplain earlier [m52]"
label variable m52_2 "Num: Which year did you have to move the cattle to the floodplain earlier [m52]"
label variable m53_1 "Dichot: Do you extract timber [m53]"
label variable m53_2 "Cat: If yes, state nature of timber extraction [m53]"
label variable m53_wood1_1 "Num: Year of extraction of wood: type 1 [m53]"
label variable m53_wood1_2a "String: Type of wood extracted: type 1 [m53]"
label variable m53_wood1_3 "Num: Quantity of extracted wood: type 1 [m53]"
label variable m53_wood1_4a "String: Use for extracted wood: type 1 [m53]"
label variable m53_wood1_5 "Num: Price obtained if wood was sold:  type 1 [m53]"
label variable m53_wood2_1 "Num: Year of extraction of wood: type 2 [m53]"
label variable m53_wood2_2a "String: Type of wood extracted: type 2 [m53]"
label variable m53_wood2_3 "Num: Quantity of extracted wood: type 2 [m53]"
label variable m53_wood2_4a "String: Use for extracted wood: type 2 [m53]"
label variable m53_wood2_5 "Num: Price obtained if wood was sold:  type 2 [m53]"
label variable m53_wood3_1 "Num: Year of extraction of wood: type 3 [m53]"
label variable m53_wood3_2a "String: Type of wood extracted: type 3 [m53]"
label variable m53_wood3_3 "Num: Quantity of extracted wood: type 3 [m53]"
label variable m53_wood3_4a "String: Use for extracted wood: type 3 [m53]"
label variable m53_wood3_5 "Num: Price obtained if wood was sold:  type 3 [m53]"
label variable m53_wood4_1 "Num: Year of extraction of wood: type 4 [m53]"
label variable m53_wood4_2a "String: Type of wood extracted: type 4 [m53]"
label variable m53_wood4_3 "Num: Quantity of extracted wood: type 4 [m53]"
label variable m53_wood4_4a "String: Use for extracted wood: type 4 [m53]"
label variable m53_wood4_5 "Num: Price obtained if wood was sold:  type 4 [m53]"
label variable m54 "Num: How many log yards do you have on your property now [m54]"
label variable m55_1 "Dichot: If you remove timber, how do you do it: bulldozer [m55]"
label variable m55_2 "Dichot: If you remove timber, how do you do it: animal [m55]"
label variable m55_3 "Dichot: If you remove timber, how do you do it: truck [m55]"
label variable m55_4 "Dichot: If you remove timber, how do you do it: trator de esquider [m55]"
label variable m55_5 "Dichot: If you remove timber, how do you do it: other [m55]"
label variable m55_5a "String: text of other mode of timber removal [m55]"
label variable m56_1_1998 "Dichot: When and where do you extract timber: primary forest: 1998 [m56]"
label variable m56_1_1999 "Dichot: When and where do you extract timber: primary forest: 1999 [m56]"
label variable m56_1_2000 "Dichot: When and where do you extract timber: primary forest: 2000 [m56]"
label variable m56_1_2001 "Dichot: When and where do you extract timber: primary forest: 2001 [m56]"
label variable m56_1_2002 "Dichot: When and where do you extract timber: primary forest: 2002 [m56]"
label variable m56_2_1998 "Dichot: When and where do you extract timber: explored forest: 1998 [m56]"
label variable m56_2_1999 "Dichot: When and where do you extract timber: explored forest: 1999 [m56]"
label variable m56_2_2000 "Dichot: When and where do you extract timber: explored forest: 2000 [m56]"
label variable m56_2_2001 "Dichot: When and where do you extract timber: explored forest: 2001 [m56]"
label variable m56_2_2002 "Dichot: When and where do you extract timber: explored forest: 2002 [m56]"
label variable m56_3_1998 "Dichot: When and where do you extract timber: advanced CC: 1998 [m56]"
label variable m56_3_1999 "Dichot: When and where do you extract timber: advanced CC: 1999 [m56]"
label variable m56_3_2000 "Dichot: When and where do you extract timber: advanced CC: 2000 [m56]"
label variable m56_3_2001 "Dichot: When and where do you extract timber: advanced CC: 2001 [m56]"
label variable m56_3_2002 "Dichot: When and where do you extract timber: advanced CC: 2002 [m56]"
label variable m57 "Dichot: Did you collect or use anything from the forest last year [m57]"
label variable m57_1_1 "Dichot: Collected: palm heart: from lot [m57]"
label variable m57_1_2 "Dichot: Collected: palm heart: from elsewhere [m57]"
label variable m57_10_1 "Dichot: Collected: other things: first: from lot [m57]"
label variable m57_10_2 "Dichot: Collected: other things: first: from elsewhere [m57]"
label variable m57_10_a "String: Text of other things collected from lot: first [m57]"
label variable m57_11_1 "Dichot: Collected: other things: second: from lot [m57]"
label variable m57_11_2 "Dichot: Collected: other things: second: from elsewhere [m57]"
label variable m57_11_a "String: Text of other things collected from lot: second [m57]"
label variable m57_2_1 "Dichot: Collected: brazil nuts: from lot [m57]"
label variable m57_2_2 "Dichot: Collected: brazil nuts: from elsewhere [m57]"
label variable m57_3_1 "Dichot: Collected: other nuts: from lot [m57]"
label variable m57_3_2 "Dichot: Collected: other nuts: from elsewhere [m57]"
label variable m57_4_1 "Dichot: Collected: rubber: from lot [m57]"
label variable m57_4_2 "Dichot: Collected: other nuts: from elsewhere [m57]"
label variable m57_5_1 "Dichot: Collected: timber: from lot [m57]"
label variable m57_5_2 "Dichot: Collected: timber: from elsewhere [m57]"
label variable m57_6_1 "Dichot: Collected: construction poles: from lot [m57]"
label variable m57_6_2 "Dichot: Collected: construction poles: from elsewhere [m57]"
label variable m57_7_1 "Dichot: Collected: fruits: from lot [m57]"
label variable m57_7_2 "Dichot: Collected: fruits: from elsewhere [m57]"
label variable m57_8_1 "Dichot: Collected: medicinal herbs: from lot [m57]"
label variable m57_8_2 "Dichot: Collected: medicinal herbs: from elsewhere [m57]"
label variable m57_9_1 "Dichot: Collected: vine (cipo): from lot [m57]"
label variable m57_9_2 "Dichot: Collected: vines (cipo): from elsewhere [m57]"
label variable m58_1 "Dichot: What uses do you get from the forest other than plants: water [m58]"
label variable m58_2 "Dichot: What uses do you get from the forest other than plants: hunting [m58]"
label variable m58_3 "Dichot: What uses do you get from the forest other than plants: other [m58]"
label variable m58_3a "String: Text of other uses gotten from forest besides plants [m58]"
label variable m59_1 "Dichot: Do you have any tee species you protect [m59]"
label variable m59_1_1a "String: Which tree species do you protect [m59]"
label variable m59_1_2a "String: Why do you protect these tree species [m59]"
label variable m59_2 "Dichot: Is there any part of the forest you want to preserve [m59]"
label variable m59_2_1a "String: Which part of the forest do you want to preserve [m59]"
label variable m59_2_2a "String: Why do you want to preserve this part of the forest [m59]"
label variable m6 "Cat: What sort of owner documents do you have [m6]"
label variable m61 "Dichot: Do you take part in communal work [m61]"
label variable m61_1 "Num: How many times did you work for others this past year [m61]"
label variable m61_2 "Num: How many times did you receive assistance this last year [m61]"
label variable m61_3a "String: For which activities do you usually take part in communal work [m61]"
label variable m61_4 "Num: Average number of people taking part in communal work [m61]"
label variable m62 "Num: How much would you have paid for the same type of work received in communal work (reais/day) [m62]"
label variable m63 "Dichot: How many people per year worked on the lot (average): just the owner worked on the lot [m63]"
label variable m63_1998 "Num: How many people per year worked on the lot (average): family labor: 1998 [m63]"
label variable m63_1999 "Num: How many people per year worked on the lot (average): family labor: 1999 [m63]"
label variable m63_2000 "Num: How many people per year worked on the lot (average): family labor: 2000 [m63]"
label variable m63_2001 "Num: How many people per year worked on the lot (average): family labor: 2001 [m63]"
label variable m63_2002 "Num: How many people per year worked on the lot (average): family labor: 2002 [m63]"
label variable m64_1998 "Num: How many people per year worked on the lot (average): sharecroppers: 1998 [m64]"
label variable m64_1999 "Num: How many people per year worked on the lot (average): sharecroppers: 1999 [m64]"
label variable m64_2000 "Num: How many people per year worked on the lot (average): sharecroppers: 2000 [m64]"
label variable m64_2001 "Num: How many people per year worked on the lot (average): sharecroppers: 2001 [m64]"
label variable m64_2002 "Num: How many people per year worked on the lot (average): sharecroppers: 2002 [m64]"
label variable m65_1998 "Num: How many people per year worked on the lot (average): permanent workers: 1998 [m64]"
label variable m65_1999 "Num: How many people per year worked on the lot (average): permanent workers: 1999 [m65]"
label variable m65_2000 "Num: How many people per year worked on the lot (average): permanent workers: 2000 [m65]"
label variable m65_2001 "Num: How many people per year worked on the lot (average): permanent workers: 2001 [m65]"
label variable m65_2002 "Num: How many people per year worked on the lot (average): permanent workers: 2002 [m65]"
label variable m66_1 "Dichot: Have you ever been employed by others and received an income [m66]"
label variable m66_2 "Num: Number of days per year and employed by others received income [m66]"
label variable m67_2001_1 "Num: How many temporary workers did you hire in 2001 [m67]"
label variable m67_2001_2 "Num: How many days did temporary workers work for you (average) in 2001 [m67]"
label variable m67_2002_1 "Num: How many temporary workers did you hire in 2002 [m67]"
label variable m67_2002_2 "Num: How many days did temporary workers work for you (average) in 2002 [m67]"
label variable m68_animalcart_2 "Dichot: Used technology  in the past: animal cart [m68]"
label variable m68_animalcart_3 "Dichot: Used technology  in the present: animal cart [m68]"
label variable m68_animalcart_4 "Num: Number of years used technology: animal cart [m68]"
label variable m68_animalcart_5 "Dichot: Own technology: animal cart [m68]"
label variable m68_animaldisc_2 "Dichot: Used technology  in the past: animal disc [m68]"
label variable m68_animaldisc_3 "Dichot: Used technology  in the present: animal disc [m68]"
label variable m68_animaldisc_4 "Num: Number of years used technology: animal disc [m68]"
label variable m68_animaldisc_5 "Dichot: Own technology: animal disc [m68]"
label variable m68_animalmeds_2 "Dichot: Used technology  in the past: animal meds [m68]"
label variable m68_animalmeds_3 "Dichot: Used technology  in the present: animal meds [m68]"
label variable m68_animalmeds_4 "Num: Number of years used technology: animal meds [m68]"
label variable m68_animalmeds_5 "Dichot: Own technology: animal meds [m68]"
label variable m68_animalplow_2 "Dichot: Used technology  in the past: animal plow [m68]"
label variable m68_animalplow_3 "Dichot: Used technology  in the present: animal plow [m68]"
label variable m68_animalplow_4 "Num: Number of years used technology: animal plow [m68]"
label variable m68_animalplow_5 "Dichot: Own technology: animal plow [m68]"
label variable m68_caminhao_2 "Dichot: Used technology  in the past: caminhao [m68]"
label variable m68_caminhao_3 "Dichot: Used technology  in the present: caminhao [m68]"
label variable m68_caminhao_4 "Num: Number of years used technology: caminhao [m68]"
label variable m68_caminhao_5 "Dichot: Own technology: caminhao [m68]"
label variable m68_cart_2 "Dichot: Used technology  in the past: cart [m68]"
label variable m68_cart_3 "Dichot: Used technology  in the present: cart [m68]"
label variable m68_cart_4 "Num: Number of years used technology: cart [m68]"
label variable m68_cart_5 "Dichot: Own technology: cart [m68]"
label variable m68_chainsaw_2 "Dichot: Used technology  in the past: chainsaw [m68]"
label variable m68_chainsaw_3 "Dichot: Used technology  in the present: chainsaw [m68]"
label variable m68_chainsaw_4 "Num: Number of years used technology: chainsaw [m68]"
label variable m68_chainsaw_5 "Dichot: Own technology: chainsaw [m68]"
label variable m68_chemfertilizer_2 "Dichot: Used technology  in the past: chemical fertilizer [m68]"
label variable m68_chemfertilizer_3 "Dichot: Used technology  in the present: chemical fertilizer [m68]"
label variable m68_chemfertilizer_4 "Num: Number of years used technology: chemical fertilizer [m68]"
label variable m68_chemfertilizer_5 "Dichot: Own technology: chemical fertilizer [m68]"
label variable m68_disc_2 "Dichot: Used technology  in the past: disc [m68]"
label variable m68_disc_3 "Dichot: Used technology  in the present: disc [m68]"
label variable m68_disc_4 "Num: Number of years used technology: disc [m68]"
label variable m68_disc_5 "Dichot: Own technology: disc [m68]"
label variable m68_fungicides_2 "Dichot: Used technology  in the past: fungicides [m68]"
label variable m68_fungicides_3 "Dichot: Used technology  in the present: fungicides [m68]"
label variable m68_fungicides_4 "Num: Number of years used technology: fungicides [m68]"
label variable m68_fungicides_5 "Dichot: Own technology: fungicides [m68]"
label variable m68_generator_2 "Dichot: Used technology  in the past: generator [m68]"
label variable m68_generator_3 "Dichot: Used technology  in the present: generator [m68]"
label variable m68_generator_4 "Num: Number of years used technology: generator [m68]"
label variable m68_generator_5 "Dichot: Own technology: generator [m68]"
label variable m68_herbicides_2 "Dichot: Used technology  in the past: herbicides [m68]"
label variable m68_herbicides_3 "Dichot: Used technology  in the present: herbicides [m68]"
label variable m68_herbicides_4 "Num: Number of years used technology: herbicides [m68]"
label variable m68_herbicides_5 "Dichot: Own technology: herbicides [m68]"
label variable m68_insecticides_2 "Dichot: Used technology  in the past: insecticides [m68]"
label variable m68_insecticides_3 "Dichot: Used technology  in the present: insecticides [m68]"
label variable m68_insecticides_4 "Num: Number of years used technology: insecticides [m68]"
label variable m68_insecticides_5 "Dichot: Own technology: insecticides [m68]"
label variable m68_mineralsalt_2 "Dichot: Used technology  in the past: mineral salt [m68]"
label variable m68_mineralsalt_3 "Dichot: Used technology  in the present: mineral salt [m68]"
label variable m68_mineralsalt_4 "Num: Number of years used technology: mineral salt [m68]"
label variable m68_mineralsalt_5 "Dichot: Own technology: mineral salt [m68]"
label variable m68_orgfertilizer_2 "Dichot: Used technology  in the past: organic fertilizer [m68]"
label variable m68_orgfertilizer_3 "Dichot: Used technology  in the present: organic fertilizer [m68]"
label variable m68_orgfertilizer_4 "Num: Number of years used technology: organic fertilizer [m68]"
label variable m68_orgfertilizer_5 "Dichot: Own technology: organic fertilizer [m68]"
label variable m68_othertech1_name "String: Name of other technology #1 used [m68]"
label variable m68_othertech2_name "String: Name of other technology #2 used [m68]"
label variable m68_othertech3_name "String: Name of other technology #3 used [m68]"
label variable m68_othertech1_2 "Dichot: Used technology  in the past: other tech #1 [m68]"
label variable m68_othertech1_3 "Dichot: Used technology  in the present: other tech #1 [m68]"
label variable m68_othertech1_4 "Num: Number of years used technology: other tech #1 [m68]"
label variable m68_othertech1_5 "Dichot: Own technology: other tech #1 [m68]"
label variable m68_othertech2_2 "Dichot: Used technology  in the past: other tech #2 [m68]"
label variable m68_othertech2_3 "Dichot: Used technology  in the present: other tech #2 [m68]"
label variable m68_othertech2_4 "Num: Number of years used technology: other tech #2 [m68]"
label variable m68_othertech2_5 "Dichot: Own technology: other tech #2 [m68]"
label variable m68_othertech3_2 "Dichot: Used technology  in the past: other tech #3 [m68]"
label variable m68_othertech3_3 "Dichot: Used technology  in the present: other tech #3 [m68]"
label variable m68_othertech3_4 "Num: Number of years used technology: other tech #3 [m68]"
label variable m68_othertech3_5 "Dichot: Own technology: other tech #3 [m68]"
label variable m68_plow_2 "Dichot: Used technology  in the past: plow [m68]"
label variable m68_plow_3 "Dichot: Used technology  in the present: plow [m68]"
label variable m68_plow_4 "Num: Number of years used technology: plow [m68]"
label variable m68_plow_5 "Dichot: Own technology: plow [m68]"
label variable m68_scythe_2 "Dichot: Used technology  in the past: scythe [m68]"
label variable m68_scythe_3 "Dichot: Used technology  in the present: scythe [m68]"
label variable m68_scythe_4 "Num: Number of years used technology: scythe [m68]"
label variable m68_scythe_5 "Dichot: Own technology: scythe [m68]"
label variable m68_seeder_2 "Dichot: Used technology  in the past: seeder [m68]"
label variable m68_seeder_3 "Dichot: Used technology  in the present: seeder [m68]"
label variable m68_seeder_4 "Num: Number of years used technology: seeder [m68]"
label variable m68_seeder_5 "Dichot: Own technology: seeder [m68]"
label variable m68_tractor_2 "Dichot: Used technology  in the past: tractor [m68]"
label variable m68_tractor_3 "Dichot: Used technology  in the present: tractor [m68]"
label variable m68_tractor_4 "Num: Number of years used technology: tractor [m68]"
label variable m68_tractor_5 "Dichot: Own technology: tractor [m68]"
label variable m68_waterengine_2 "Dichot: Used technology  in the past: water engine [m68]"
label variable m68_waterengine_3 "Dichot: Used technology  in the present: water engine [m68]"
label variable m68_waterengine_4 "Num: Number of years used technology: water engine [m68]"
label variable m68_waterengine_5 "Dichot: Own technology: water engine [m68]"
label variable m69_1_1 "Dichot: What impovements do you have on your property: fences [m69]"
label variable m69_1_2 "Num: Length of fence in meters [m69]"
label variable m69_2_1 "Dichot: What impovements do you have on your property: harvest huts [m69]"
label variable m69_2_2 "Num: Number of harvest huts [m69]"
label variable m69_3_1 "Dichot: What impovements do you have on your property: own house [m69]"
label variable m69_3_2 "Num: Number of own houses [m69]"
label variable m69_4_1 "Dichot: What impovements do you have on your property: flour barn [m69]"
label variable m69_4_2 "Num: Number of flour barns [m69]"
label variable m69_5_1 "Dichot: What impovements do you have on your property: other [m69]"
label variable m69_5_a "String: Text of describe other improvement to property [m69]"
label variable m6a "String: Text of explain other owner documentation [m6]"
label variable m7 "Cat: How did you acquire or start taking care of this property [m7]"
label variable m7_reclass "Cat: How did you acquire or start taking care of this property reclassification [m7]"
label variable m70_1 "Dichot: Do you participate in any groups: workers union [m70]"
label variable m70_1a "String: Which one: workers union [m70]"
label variable m70_2 "Dichot: Particpated in a meeting last year: workers union [m70]"
label variable m71_1 "Dichot: Do you participate in any groups: mutal help association [m71]"
label variable m71_1a "String: Which one: mutal help association [m71]"
label variable m71_2 "Dichot: Particpated in a meeting last year: mutal help association [m71]"
label variable m72_1 "Dichot: Do you participate in any groups: producer's cooperative [m72]"
label variable m72_1a "String: Which one: producer's cooperative [m72]"
label variable m72_2 "Dichot: Particpated in a meeting last year: producer's cooperative [m72]"
label variable m73_1 "Dichot: Do you participate in any groups: other association [m73]"
label variable m73_1a "String: Which one: other association [m73]"
label variable m73_2 "Dichot: Particpated in a meeting last year: other association [m73]"
label variable m74_1 "Dichot: Have you been receiving any financial loans through these associations [m74]"
label variable m74_1a "String: Text of what were these loans for [m74]"
label variable m75 "Dichot: Between 1998 and today have you received credit [m75]"
label variable m75_cr1_2a "String: Activity for which credit was received: credit #1 [m75]"
label variable m75_cr1_3 "Num: Starting year: credit #1 [m75]"
label variable m75_cr1_4 "Num: Ending year: credit #1 [m75]"
label variable m75_cr1_6a "String: Source of credit: credit #1 [m75]"
label variable m75_cr1_7 "Num: Value of credit: credit #1 [m75]"
label variable m75_cr1_8 "Num: Years until paid off: credit #1 [m75]"
label variable m75_cr1_9 "Cat: Finished paying off: credit #1 [m75]"
label variable m75_cr2_2a "String: Activity for which credit was received: credit #2 [m75]"
label variable m75_cr2_3 "Num: Starting year: credit #2 [m75]"
label variable m75_cr2_4 "Num: Ending year: credit #2 [m75]"
label variable m75_cr2_6a "String: Source of credit: credit #2 [m75]"
label variable m75_cr2_7 "Num: Value of credit: credit #2 [m75]"
label variable m75_cr2_8 "Num: Years until paid off: credit #2 [m75]"
label variable m75_cr2_9 "Cat: Finished paying off: credit #2 [m75]"
label variable m75_cr3_2a "String: Activity for which credit was received: credit #3 [m75]"
label variable m75_cr3_3 "Num: Starting year: credit #3 [m75]"
label variable m75_cr3_4 "Num: Ending year: credit #3 [m75]"
label variable m75_cr3_6a "String: Source of credit: credit #3 [m75]"
label variable m75_cr3_7 "Num: Value of credit: credit #3 [m75]"
label variable m75_cr3_8 "Num: Years until paid off: credit #3 [m75]"
label variable m75_cr3_9 "Cat: Finished paying off: credit #3 [m75]"
label variable m76 "Cat: Was it difficult to obtain financing [m76]"
label variable m76a "String: Text of if it was difficult to obtain financing, how did you get it [m76]"
label variable m77 "String: Do you know anyone who sold their lot? Why? For how much? [m77]"
label variable m78 "String: What are the main problems encountered, what were the solutions? [m78]"
label variable m79 "String: Other interviewer notes about the interview [m79]"
label variable m7_3_1a "String: Inherited: from whom (relation to interviewee) [m7]"
label variable m7_3_2a "String: Inherited: how much of the inherited property did you receive [m7]"
label variable m7_3_3a "String: Inherited: who else reveived parts of the inherited property [m7]"
label variable m7_4a "String: Text of how did you acquire this property: other [m7]"
label variable m8_month "Num: When did you acquire or start taking care of this property: month [m8]"
label variable m8_nap "Dichot: When did you acquire or start taking care of this property: not applicable [m8]"
label variable m8_year "Num: When did you acquire or start taking care of this property: year [m8]"
label variable m9_month "Num: When did you acquire or start working on this property: month [m9]"
label variable m9_year "Num: When did you acquire or start working on this property: year [m9]"
label variable w10 "Cat: Where do you live for most of the year [w10]"
label variable w100_cheese_a "Dichot: Household engages in activity: cheese [w100]"
label variable w100_cheese_b "Cat: Use, sale, or both: cheese [w100]"
label variable w100_cheese_c "Cat: Sold to whom: cheese [w100]"
label variable w100_cheese_d "Cat: How often sold: cheese [w100]"
label variable w100_cheese_f "String: Text of sold to other specify: cheese [w100]"
label variable w100_cheese_g "String: Text of how often sale other specify: cheese [w100]"
label variable w100_clothes_a "Dichot: Household engages in activity: clothes [w100]"
label variable w100_clothes_b "Cat: Use, sale, or both: clothes [w100]"
label variable w100_clothes_c "Cat: Sold to whom: clothes [w100]"
label variable w100_clothes_d "Cat: How often sold: clothes [w100]"
label variable w100_clothes_f "String: Text of sold to other specify: clothes [w100]"
label variable w100_clothes_g "String: Text of how often sale other specify: clothes [w100]"
label variable w100_crochet_a "Dichot: Household engages in activity: crochet [w100]"
label variable w100_crochet_b "Cat: Use, sale, or both: crochet [w100]"
label variable w100_crochet_c "Cat: Sold to whom: crochet [w100]"
label variable w100_crochet_d "Cat: How often sold: crochet [w100]"
label variable w100_crochet_f "String: Text of sold to other specify: crochet [w100]"
label variable w100_crochet_g "String: Text of how often sale other specify: crochet [w100]"
label variable w100_garden_a "Dichot: Household engages in activity: garden [w100]"
label variable w100_garden_b "Cat: Use, sale, or both: garden [w100]"
label variable w100_garden_c "Cat: Sold to whom: garden [w100]"
label variable w100_garden_d "Cat: How often sold: garden [w100]"
label variable w100_garden_f "String: Text of sold to other specify: garden [w100]"
label variable w100_garden_g "String: Text of how often sale other specify: garden [w100]"
label variable w100_handcraft_a "Dichot: Household engages in activity: handcraft [w100]"
label variable w100_handcraft_b "Cat: Use, sale, or both: handcraft [w100]"
label variable w100_handcraft_c "Cat: Sold to whom: handcraft [w100]"
label variable w100_handcraft_d "Cat: How often sold: handcraft [w100]"
label variable w100_handcraft_f "String: Text of sold to other specify: handcraft [w100]"
label variable w100_handcraft_g "String: Text of how often sale other specify: handcraft [w100]"
label variable w100_other1_a "Dichot: Household engages in activity: other #1 [w100]"
label variable w100_other1_b "Cat: Use, sale, or both: other #1 [w100]"
label variable w100_other1_c "Cat: Sold to whom: other #1 [w100]"
label variable w100_other1_d "Cat: How often sold: other #1 [w100]"
label variable w100_other1_e "String: Text of specify other household activity #1 [w100]"
label variable w100_other1_f "String: Text of sold to other specify: other #1 [w100]"
label variable w100_other1_g "String: Text of how often sale other specify: other #1 [w100]"
label variable w100_other2_a "Dichot: Household engages in activity: other #2 [w100]"
label variable w100_other2_b "Cat: Use, sale, or both: other #2 [w100]"
label variable w100_other2_c "Cat: Sold to whom: other #2 [w100]"
label variable w100_other2_d "Cat: How often sold: other #2 [w100]"
label variable w100_other2_e "String: Text of specify other household activity #2 [w100]"
label variable w100_other2_f "String: Text of sold to other specify: other #2 [w100]"
label variable w100_other2_g "String: Text of how often sale other specify: other #2 [w100]"
label variable w100_snacks_a "Dichot: Household engages in activity: snacks [w100]"
label variable w100_snacks_b "Cat: Use, sale, or both: snacks [w100]"
label variable w100_snacks_c "Cat: Sold to whom: snacks [w100]"
label variable w100_snacks_d "Cat: How often sold: snacks [w100]"
label variable w100_snacks_f "String: Text of sold to other specify: snacks [w100]"
label variable w100_snacks_g "String: Text of how often sale other specify: snacks [w100]"
label variable w101_first "Cat: What activities occupy most of your time (female head): principal [w101]"
label variable w101_first_a "String: Text of other activity occupies most of your time: principal [w101]"
label variable w101_second "Cat: What activities occupy most of your time (female head): secondary [w101]"
label variable w101_second_a "String: Text of other activity occupies most of your time: secondary [w101]"
label variable w102_1 "Num: Percentage of income provided by activity: farming [w102]"
label variable w102_2 "Num: Percentage of income provided by activity: public employment [w102]"
label variable w102_3 "Num: Percentage of income provided by activity: professional work [w102]"
label variable w102_4 "Num: Percentage of income provided by activity: domestic work [w102]"
label variable w102_5 "Num: Percentage of income provided by activity: handcraft [w102]"
label variable w102_6 "Num: Percentage of income provided by activity: pension [w102]"
label variable w102_7 "Num: Percentage of income provided by activity: other activities [w102]"
label variable w102_7a "String: Text of other activity percentage of income [w102]"
label variable w103 "Dichot: Does anyone in this household receive retirement income [w103]"
label variable w104 "Num: How many people receive retirement income [w104]"
label variable w105 "Num: How much income received from source last year: retirement income [w105]"
label variable w106 "Num: How much income received from source last year: farm products [w106]"
label variable w107 "Num: How much income received from source last year: cattle [w107]"
label variable w108 "Num: How much income received from source last year: produce [w108]"
label variable w109 "Num: How much income received from source last year: handcrafts [w109]"
label variable w10a "String: Text of other place lived [w10]"
label variable w11_1 "Num: How many months per year do you spend at each: city/village [w11]"
label variable w11_2 "Num: How many months per year do you spend at each: rural property [w11]"
label variable w110 "Num: How much income received from source last year: wage employment [w110]"
label variable w111 "Num: How much income received from source last year: bolsa escola [w111]"
label variable w112 "Num: How much income received from source last year: other [w112]"
label variable w112a "String: Text of other source of income received [w112]"
label variable w113 "Num: What are the household's monthly expenses with each item: food [w113]"
label variable w114 "Num: What are the household's monthly expenses with each item: medicines [w114]"
label variable w115 "Num: What are the household's monthly expenses with each item: education [w115]"
label variable w116 "Num: What are the household's monthly expenses with each item: transportation [w116]"
label variable w117 "Num: What are the household's monthly expenses with each item: clothes [w117]"
label variable w118 "Num: What are the household's monthly expenses with each item: fuel/electric [w118]"
label variable w119 "Num: What are the household's monthly expenses with each item: other [w119]"
label variable w119a "String: Text of other monthly expenses [w119]"
label variable w12_1a "String: What city do you go to? [w12]"
label variable w12_2 "Cat: How often do you go: city [w12]"
label variable w12_3a "String: Mode of transport: city [w12]"
label variable w12_4 "Num: Length of trip one way: city [w12]"
label variable w12_5 "Num: Cost of trip one way: city [w12]"
label variable w12_6_1a "String: Main activities: city: first [w12]"
label variable w12_6_2a "String: Main activities: city: second [w12]"
label variable w12_6_3a "String: Main activities: city: third [w12]"
label variable w120_1 "Dichot: Physical characteristics, walls: masonry [w120]"
label variable w120_2 "Dichot: Physical characteristics, walls: wood (permanent) [w120]"
label variable w120_3 "Dichot: Physical characteristics, walls: wood (temporary) [w120]"
label variable w120_4 "Dichot: Physical characteristics, walls: clay [w120]"
label variable w120_5 "Dichot: Physical characteristics, walls: lathe/ palm frond [w120]"
label variable w120_6 "Dichot: Physical characteristics, walls: straw [w120]"
label variable w120_7 "Dichot: Physical characteristics, walls: other [w120]"
label variable w120_7a "String: Text of other wall material [w120]"
label variable w121_1 "Dichot: Physical characteristics, floors: wood [w121]"
label variable w121_2 "Dichot: Physical characteristics, floors: ceramic tile [w121]"
label variable w121_3 "Dichot: Physical characteristics, floors: cement [w121]"
label variable w121_4 "Dichot: Physical characteristics, floors: brick [w121]"
label variable w121_5 "Dichot: Physical characteristics, floors: earth [w121]"
label variable w121_6 "Dichot: Physical characteristics, floors: other [w121]"
label variable w121_6a "String: Text of other floor material [w121]"
label variable w122_1 "Dichot: Physical characteristics, exterior: concrete lathe [w122]"
label variable w122_2 "Dichot: Physical characteristics, exterior: clay tile [w122]"
label variable w122_3 "Dichot: Physical characteristics, exterior: aluminum siding [w122]"
label variable w122_4 "Dichot: Physical characteristics, exterior: zinc [w122]"
label variable w122_5 "Dichot: Physical characteristics, exterior: wood [w122]"
label variable w122_6 "Dichot: Physical characteristics, exterior: straw [w122]"
label variable w122_7 "Dichot: Physical characteristics, exterior: other [w122]"
label variable w122_7a "String: Text of other exterior material [w122]"
label variable w123_1 "Dichot: Physical characteristics, bathroom: interior of house [w123]"
label variable w123_2 "Dichot: Physical characteristics, bathroom: exterior to house [w123]"
label variable w124 "Cat: Physical characteristics, sewer [w124]"
label variable w125_1 "Dichot: Physical characteristics, electricity: utility service [w125]"
label variable w125_2 "Dichot: Physical characteristics, electricity: private generator [w125]"
label variable w125_3 "Dichot: Physical characteristics, electricity: gas lantern [w125]"
label variable w125_4 "Dichot: Physical characteristics, electricity: other lantern [w125]"
label variable w125_5 "Dichot: Physical characteristics, electricity: lamp [w125]"
label variable w125_6 "Dichot: Physical characteristics, electricity: other source [w125]"
label variable w125_6a "String: Text of other electricity source [w125]"
label variable w126_1 "Num: Number of items: wood stove [w126]"
label variable w126_2 "Cat: Who purchased: wood stove [w126]"
label variable w126_2a "String: Text of other who purchased: wood stove [w126]"
label variable w126_3 "Cat: Method of payment: wood stoves [w126]"
label variable w126_3a "String: Text of other method of payment: wood stove [w126]"
label variable w126_4 "Cat: Purchase location: wood stove [w126]"
label variable w127_1 "Num: Number of items: gas stove [w127]"
label variable w127_2 "Cat: Who purchased: gas stove [w127]"
label variable w127_2a "String: Text of other who purchased: gas stove [w127]"
label variable w127_3 "Cat: Method of payment: gas stove [w127]"
label variable w127_3a "String: Text of other method of payment: gas stove [w127]"
label variable w127_4 "Cat: Purchase location: gas stove [w127]"
label variable w128_1 "Num: Number of items: refrigerator [w128]"
label variable w128_2 "Cat: Who purchased: refrigerator [w128]"
label variable w128_2a "String: Text of other who purchased: refrigerator [w128]"
label variable w128_3 "Cat: Method of payment: refrigerator [w128]"
label variable w128_3a "String: Text of other method of payment: refrigerator [w128]"
label variable w128_4 "Cat: Purchase location: refrigerator [w128]"
label variable w129_1 "Num: Number of items: radio [w129]"
label variable w129_2 "Cat: Who purchased: radio [w129]"
label variable w129_2a "String: Text of other who purchased: radio [w129]"
label variable w129_3 "Cat: Method of payment: radio [w129]"
label variable w129_3a "String: Text of other method of payment: radio [w129]"
label variable w129_4 "Cat: Purchase location: radio [w129]"
label variable w13_1 "Cat: How often do you go: rural property [w13]"
label variable w13_2a "String: Mode of transport: rural property [w13]"
label variable w13_3 "Num: Length of trip one way: rural property [w13]"
label variable w13_4 "Num: Cost of trip one way: rural property [w13]"
label variable w13_5_1a "String: Main activities: city: rural property [w13]"
label variable w13_5_2a "String: Main activities: city: rural property [w13]"
label variable w13_5_3a "String: Main activities: city: rural property [w13]"
label variable w130_1 "Num: Number of items: clock/watch [w130]"
label variable w130_2 "Cat: Who purchased: clock/watch [w130]"
label variable w130_2a "String: Text of other who purchased: clock/watch [w130]"
label variable w130_3 "Cat: Method of payment: clock/watch [w130]"
label variable w130_3a "String: Text of other method of payment: clock/watch [w130]"
label variable w130_4 "Cat: Purchase location: clock/watch [w130]"
label variable w131_1 "Num: Number of items: sewing machine [w131]"
label variable w131_2 "Cat: Who purchased: sewing machine [w131]"
label variable w131_2a "String: Text of other who purchased: sewing machine [w131]"
label variable w131_3 "Cat: Method of payment: sewing machine [w131]"
label variable w131_3a "String: Text of other method of payment: sewing machine [w131]"
label variable w131_4 "Cat: Purchase location: sewing machine [w131]"
label variable w132_1 "Num: Number of items: b/w television [w132]"
label variable w132_2 "Cat: Who purchased: b/w television [w132]"
label variable w132_2a "String: Text of other who purchased: b/w television [w132]"
label variable w132_3 "Cat: Method of payment: b/w television [w132]"
label variable w132_3a "String: Text of other method of payment: b/w television [w132]"
label variable w132_4 "Cat: Purchase location: b/w television [w132]"
label variable w133_1 "Num: Number of items: color television [w133]"
label variable w133_2 "Cat: Who purchased: color television [w133]"
label variable w133_2a "String: Text of other who purchased: color television [w133]"
label variable w133_3 "Cat: Method of payment: color television [w133]"
label variable w133_3a "String: Text of other method of payment: color television [w133]"
label variable w133_4 "Cat: Purchase location: color television [w133]"
label variable w134_1 "Num: Number of items: antenna [w134]"
label variable w134_2 "Cat: Who purchased: antenna [w134]"
label variable w134_2a "String: Text of other who purchased: antenna [w134]"
label variable w134_3 "Cat: Method of payment: antenna [w134]"
label variable w134_3a "String: Text of other method of payment: antenna [w134]"
label variable w134_4 "Cat: Purchase location: antenna [w134]"
label variable w135_1 "Num: Number of items: stereo [w135]"
label variable w135_2 "Cat: Who purchased: stereo [w135]"
label variable w135_2a "String: Text of other who purchased: stereo [w135]"
label variable w135_3 "Cat: Method of payment: stereo [w135]"
label variable w135_3a "String: Text of other method of payment: stereo [w135]"
label variable w135_4 "Cat: Purchase location: stereo [w135]"
label variable w136_1 "Num: Number of items: cell phone [w136]"
label variable w136_2 "Cat: Who purchased: cell phone [w136]"
label variable w136_2a "String: Text of other who purchased: cell phone [w136]"
label variable w136_3 "Cat: Method of payment: cell phone [w136]"
label variable w136_3a "String: Text of other method of payment: cell phone [w136]"
label variable w136_4 "Cat: Purchase location: cell phone [w136]"
label variable w137_1 "Num: Number of items: chain saw [w137]"
label variable w137_2 "Cat: Who purchased: chain saw [w137]"
label variable w137_2a "String: Text of other who purchased: chain saw [w137]"
label variable w137_3 "Cat: Method of payment: chain saw [w137]"
label variable w137_3a "String: Text of other method of payment: chain saw [w137]"
label variable w137_4 "Cat: Purchase location: chain saw [w137]"
label variable w138_1 "Num: Number of items: rifle [w138]"
label variable w138_2 "Cat: Who purchased: rifle [w138]"
label variable w138_2a "String: Text of other who purchased: rifle [w138]"
label variable w138_3 "Cat: Method of payment: rifle [w138]"
label variable w138_3a "String: Text of other method of payment: rifle [w138]"
label variable w138_4 "Cat: Purchase location: rifle [w138]"
label variable w139_1 "Num: Number of items: car [w139]"
label variable w139_2 "Cat: Who purchased: car [w139]"
label variable w139_2a "String: Text of other who purchased: car [w139]"
label variable w139_3 "Cat: Method of payment: car [w139]"
label variable w139_3a "String: Text of other method of payment: car [w139]"
label variable w139_4 "Cat: Purchase location: car [w139]"
label variable w14_1a "String: When you don't go, who goes [w14]"
label variable w14_2 "Cat: How often does this person go [w14]"
label variable w14_3a "String: Mode of transport [w14]"
label variable w14_4 "Num: Length of trip one way [w14]"
label variable w14_5 "Num: Cost of trip one way [w14]"
label variable w14_6_1a "String: What are this person's main activities: first [w14]"
label variable w14_6_2a "String: What are this person's main activities: second [w14]"
label variable w14_6_3a "String: What are this person's main activities: third [w14]"
label variable w140_1 "Num: Number of items: small truck [w140]"
label variable w140_2 "Cat: Who purchased: small truck [w140]"
label variable w140_2a "String: Text of other who purchased: small truck [w140]"
label variable w140_3 "Cat: Method of payment: small truck [w140]"
label variable w140_3a "String: Text of other method of payment: small truck [w140]"
label variable w140_4 "Cat: Purchase location: small truck [w140]"
label variable w141_1 "Num: Number of items: truck [w141]"
label variable w141_2 "Cat: Who purchased: truck [w141]"
label variable w141_2a "String: Text of other who purchased: truck [w141]"
label variable w141_3 "Cat: Method of payment: truck [w141]"
label variable w141_3a "String: Text of other method of payment: truck [w141]"
label variable w141_4 "Cat: Purchase location: truck [w141]"
label variable w142_1 "Num: Number of items: tractor [w142]"
label variable w142_2 "Cat: Who purchased: tractor [w142]"
label variable w142_2a "String: Text of other who purchased: tractor [w142]"
label variable w142_3 "Cat: Method of payment: tractor [w142]"
label variable w142_3a "String: Text of other method of payment: tractor [w142]"
label variable w142_4 "Cat: Purchase location: tractor [w142]"
label variable w143_1 "Num: Number of items: bicycle [w143]"
label variable w143_2 "Cat: Who purchased: bicycle [w143]"
label variable w143_2a "String: Text of other who purchased: bicycle [w143]"
label variable w143_3 "Cat: Method of payment: bicycle [w143]"
label variable w143_3a "String: Text of other method of payment: bicycle [w143]"
label variable w143_4 "Cat: Purchase location: bicycle [w143]"
label variable w144_1 "Num: Number of items: motorcycle [w144]"
label variable w144_2 "Cat: Who purchased: motorcycle [w144]"
label variable w144_2a "String: Text of other who purchased: motorcycle [w144]"
label variable w144_3 "Cat: Method of payment: motorcycle [w144]"
label variable w144_3a "String: Text of other method of payment: motorcycle [w144]"
label variable w144_4 "Cat: Purchase location: motorcycle [w144]"
label variable w145 "Cat: Who decides about: care of children [w145]"
label variable w146 "Cat: Who decides about: number of children [w146]"
label variable w147 "Cat: Who decides about: stopping childbearing [w147]"
label variable w148 "Cat: Who decides about: money [w148]"
label variable w149 "Cat: Who decides about: where to live/migrate [w149]"
label variable w15 "Num: How many people live in your house on this property [w15]"
label variable w150 "Cat: Who decides about: who can live with the family [w150]"
label variable w151 "Cat: Who decides about: with whom can the wife speak [w151]"
label variable w152 "Cat: Who decides about: when and where to work [w152]"
label variable w153 "Cat: Who decides about: what to plant [w153]"
label variable w154 "Cat: What is your religion [w154]"
label variable w154a "String: Text for other religion: yours [w154]"
label variable w155 "Cat: What is your husband/spouses religion [w155]"
label variable w155a "String: Text for other religion: husband/spouse [w155]"
label variable w156_1 "Cat: What are the main problems with the lives of those who live here: rank #1 [w156]"
label variable w156_1a "String: Text of specify other problem: rank #1 [w156]"
label variable w156_2 "Cat: What are the main problems with the lives of those who live here: rank #2 [w156]"
label variable w156_2a "String: Text of specify other problem: rank #2 [w156]"
label variable w156_3 "Cat: What are the main problems with the lives of those who live here: rank #3 [w156]"
label variable w156_3a "String: Text of specify other problem: rank #3 [w156]"
label variable w157_1 "Dichot: What do you want in the future, this lot: sell it [w157]"
label variable w157_2 "Dichot: What do you want in the future, this lot: expand it [w157]"
label variable w157_3 "Dichot: What do you want in the future, this lot: leave it to the children [w157]"
label variable w157_4 "Dichot: What do you want in the future, this lot: other [w157]"
label variable w157_4a "String: Textof specify other desire: this lot [w157]"
label variable w158_1 "Dichot: What do you want in the future, other lots: sell it [w158]"
label variable w158_2 "Dichot: What do you want in the future, other lots: expand it [w158]"
label variable w158_3 "Dichot: What do you want in the future, other lots: leave it to the children [w158]"
label variable w158_4 "Dichot: What do you want in the future, other lots: other [w158]"
label variable w158_4a "String: Text of specify other desire: other lots [w158]"
label variable w158_5 "Dichot: No other lots owned [w158]"
label variable w159_1 "Dichot: What do you want in the future, this house: sell it [w159]"
label variable w159_2 "Dichot: What do you want in the future, this house: remodel it [w159]"
label variable w159_3 "Dichot: What do you want in the future, this house: build a new one [w159]"
label variable w159_4 "Dichot: What do you want in the future, this house: move away [w159]"
label variable w159_5 "Dichot: What do you want in the future, this house: other [w159]"
label variable w159_5a "String: Text of specify other desire: this house [w159]"
label variable w160_1 "Dichot: What do you want in the future, other house: sell it [w160]"
label variable w160_2 "Dichot: What do you want in the future, other house: remodel it [w160]"
label variable w160_3 "Dichot: What do you want in the future, other house: build a new one [w160]"
label variable w160_4 "Dichot: What do you want in the future, other house: move away [w160]"
label variable w160_5 "Dichot: What do you want in the future, other house: other [w160]"
label variable w160_5a "String: Text of specify other desire: other house [w160]"
label variable w160_6 "Dichot: No other house owned [w160]"
label variable w161_1 "Dichot: To whom will you pass on this lot in the future: divide it among all children [w161]"
label variable w161_2 "Dichot: To whom will you pass on this lot in the future: divide it among the sons [w161]"
label variable w161_3 "Dichot: To whom will you pass on this lot in the future: divide it among the daughters [w161]"
label variable w161_4 "Dichot: To whom will you pass on this lot in the future: divided it among unmarried children [w161]"
label variable w161_5 "Dichot: To whom will you pass on this lot in the future: give it to a single child [w161]"
label variable w161_6 "Dichot: To whom will you pass on this lot in the future: other [w161]"
label variable w161_6a "String: Text of specify other person lot will be passed to [w161]"
label variable w162_1 "Dichot: What do you want in the future for sons: continue to work on lot [w162]"
label variable w162_2 "Dichot: What do you want in the future for sons: do another type of work [w162]"
label variable w162_3 "Dichot: What do you want in the future for sons: move away [w162]"
label variable w162_4 "Dichot: What do you want in the future for sons: study [w162]"
label variable w162_5 "Dichot: What do you want in the future for sons: other [w162]"
label variable w162_5a "String: Text of other wish for sons in future [w162]"
label variable w162_8 "Dichot: No sons, or all are established [w162]"
label variable w163_1 "Dichot: What do you want in the future for daughters: continue to work on lot [w163]"
label variable w163_2 "Dichot: What do you want in the future for daughters: do another type of work [w163]"
label variable w163_3 "Dichot: What do you want in the future for daughters: move away [w163]"
label variable w163_4 "Dichot: What do you want in the future for daughters: study [w163]"
label variable w163_5 "Dichot: What do you want in the future for daughters: other [w163]"
label variable w163_5a "String: Text of other wish for daughters in future [w163]"
label variable w163_8 "Dichot: No daughters, or all are established [w163]"
label variable w1a "String: Name of female household head [w1]"
label variable w2 "Cat: Is the head of household here for the interview [w2]"
label variable w2_5a "String: Text of where the woman is living elsewhere [w2]"
label variable w2_6a "String: Text of why the woman is absent [w2]"
label variable w32 "Dichot: At least one member of this household does: housework [w32]"
label variable w33 "Dichot: At least one member of this household does: watches the kids [w33]"
label variable w34 "Dichot: At least one member of this household does: works in the garden [w34]"
label variable w35 "Dichot: At least one member of this household does: cares for animals [w35]"
label variable w36 "Dichot: At least one member of this household does: cares for cattle [w36]"
label variable w37 "Dichot: At least one member of this household does: milks the cows [w37]"
label variable w38 "Dichot: At least one member of this household does: forms pasture [w38]"
label variable w39 "Dichot: At least one member of this household does: helps clear the forests [w39]"
label variable w3a "String: List of all people helping to answer questionnaire [w3]"
label variable w4_month "Num: When did you arrive in Para: month [w4]"
label variable w4_year "Num: When did you arrive in Para: year [w4]"
label variable w40 "Dichot: At least one member of this household does: helps with burning [w40]"
label variable w41 "Dichot: At least one member of this household does: works in the fields [w41]"
label variable w42 "Dichot: At least one member of this household does: helps weed [w42]"
label variable w43 "Dichot: At least one member of this household does: helps collect [w43]"
label variable w44 "Dichot: At least one member of this household does: helps bag/dry the coffee, cocoa, and pepper [w44]"
label variable w45 "Dichot: At least one member of this household does: makes flour [w45]"
label variable w5_month "Num: When did you start living on the lot: month [w5]"
label variable w5_year "Num: When did you start living on the lot: year [w5]"
label variable w6 "Cat: Were there any families living on the lot before your family arrived [w6]"
label variable w7_1 "Dichot: How many people lived on the lot before your family arrived: doesn't know [w7]"
label variable w7_2 "Num: How many people lived on the lot before your family arrived: children [w7]"
label variable w7_3 "Num: How many people lived on the lot before your family arrived: men [w7]"
label variable w7_4 "Num: How many people lived on the lot before your family arrived: women [w7]"
label variable w7_5 "Num: How many people lived on the lot before your family arrived: elderly men [w7]"
label variable w7_6 "Num: How many people lived on the lot before your family arrived: elderly women [w7]"
label variable w8 "Dichot: Are there any other families living on this lot now? [w8]"
label variable w9_1 "Num: Count of number of other families living on this lot now [w9]"
label variable w9_2 "Num: Count of number of people in other families living on this lot now [w9]"
label variable w9_3_1 "Num: Count of families on lot who are: sharecroppers [w9]"
label variable w9_3_2 "Num: Count of families on lot who are: workers [w9]"
label variable w9_3_3 "Num: Count of families on lot who are: tenants [w9]"
label variable w9_3_4 "Num: Count of families on lot who are: sons/daughters [w9]"
label variable w9_3_5 "Num: Count of families on lot who are: other relatives [w9]"
label variable w9_3_6 "Num: Count of families on lot who are: other[w9]"

**********************************************************************
* Create value labels and apply

label define lb_id_dona 0 "No" 1 "Yes" 
label define lb_id_dona_is_man 0 "No" 1 "Yes" 
label define lb_id_dono 0 "No" 1 "Yes" 
label define lb_id_final_sample 0 "No" 1 "Yes" 
label define lb_id_registro_m 0 "No" 1 "Yes" 
label define lb_id_registro_w 0 "No" 1 "Yes" 
label define lb_id_widow 0 "No" 1 "Yes" 
label define lb_int_owner_w 0 "No" 1 "Yes" 
label define lb_int_roster_no_w 0 "NA/out of household/deceased" 1 "Roster Number 1" 2 "Roster number 2" 3 "Roster number 3" 
label define lb_m10_1 0 "No" 1 "Yes" 
label define lb_m10_2 0 "No" 1 "Yes" 
label define lb_m10_3 0 "No" 1 "Yes" 
label define lb_m10_4 0 "No" 1 "Yes" 
label define lb_m10_5 0 "No" 1 "Yes" 
label define lb_m10_6 0 "No" 1 "Yes" 
label define lb_m10_7 0 "No" 1 "Yes" 
label define lb_m10_8 0 "No" 1 "Yes" 
label define lb_m10_main 1 "Proximity to the city" 2 "Soil" 3 "Neighbors" 4 "Price" 5 "Water" 6 "Road" 7 "Other" 10 "Precisava de terra sua para trabalhar / morar" 11 "Falta de Alternativa / Oportunidade de compra" 12 "Conhecia (mora/trabalha) na regiao / propriedade" 13 "Proximity to school, village, access to energy,etc" 14 "other property attribute" 15 "Negocio com amigos/ familia / parentes" 16 "Casamento" 17 "inherited (same generation)" 18 "inherited (previous generation)" 19 "Trabalho na propriedade" 20 "Lote doado / cedido" 21 "Assentamento" 
label define lb_m11 1 "In this property" 2 "In another rural property" 3 "City/Village" 4 "Both (property and city/village)" 5 "Other" 
label define lb_m12_nap 0 "No" 1 "Yes" 
label define lb_m13_2 1 "Daily" 2 "Weekly" 3 "Bi-weekly" 4 "Monthly" 5 "Annually" 
label define lb_m14_2 1 "Daily" 2 "Weekly" 3 "Bi-weekly" 4 "Monthly" 5 "Annually" 
label define lb_m15_2 1 "Daily" 2 "Weekly" 3 "Bi-weekly" 4 "Monthly" 5 "Annually" 
label define lb_m16_1 1 "Earthen" 2 "Asphalt" 3 "Other" 
label define lb_m16_2 1 "Simple/Normal (1 vehicle)" 2 "Double (2 vehicles)" 
label define lb_m16_3 1 "Year-round" 2 "Only in summer" 
label define lb_m16_4 1 "Small truck sometimes" 2 "Small truck only" 3 "Bus" 4 "All vehicles with risk" 5 "All vehicles safely" 
label define lb_m17 0 "No" 1 "Yes" 
label define lb_m18_2 0 "No" 1 "Yes" 
label define lb_m18_3 0 "No" 1 "Yes" 
label define lb_m18_4 0 "No" 1 "Yes" 
label define lb_m19_1 1 "Farming" 2 "Business/Commerce" 3 "Professional" 4 "Other" 5 "No occupation" 
label define lb_m19_2 1 "Farming" 2 "Business/Commerce" 3 "Professional" 4 "Other" 5 "No occupation" 
label define lb_m20_1 0 "No" 1 "Yes" 
label define lb_m20_2 0 "No" 1 "Yes" 
label define lb_m20_3 0 "No" 1 "Yes" 
label define lb_m20_4 0 "No" 1 "Yes" 
label define lb_m20_5 0 "No" 1 "Yes" 
label define lb_m21_01_0 0 "No" 1 "Yes" 
label define lb_m21_02_0 0 "No" 1 "Yes" 
label define lb_m21_03_0 0 "No" 1 "Yes" 
label define lb_m21_04_0 0 "No" 1 "Yes" 
label define lb_m21_05_0 0 "No" 1 "Yes" 
label define lb_m21_05_2 0 "No" 1 "Yes" 
label define lb_m21_06_0 0 "No" 1 "Yes" 
label define lb_m21_07_0 0 "No" 1 "Yes" 
label define lb_m21_07_1 1 "Truck" 2 "Rain" 3 "Well" 
label define lb_m21_08_0 0 "No" 1 "Yes" 
label define lb_m21_09_0 0 "No" 1 "Yes" 
label define lb_m21_10_0 0 "No" 1 "Yes" 
label define lb_m22_01_0 0 "No" 1 "Yes" 
label define lb_m22_02_0 0 "No" 1 "Yes" 
label define lb_m22_03_0 0 "No" 1 "Yes" 
label define lb_m22_04_0 0 "No" 1 "Yes" 
label define lb_m22_05_0 0 "No" 1 "Yes" 
label define lb_m22_05_2 0 "No" 1 "Yes"
label define lb_m22_06_0 0 "No" 1 "Yes" 
label define lb_m22_07_0 0 "No" 1 "Yes" 
label define lb_m22_07_1 1 "Truck" 2 "Rain" 3 "Well" 
label define lb_m22_08_0 0 "No" 1 "Yes" 
label define lb_m22_09_0 0 "No" 1 "Yes" 
label define lb_m22_10_0 0 "No" 1 "Yes" 
label define lb_m23 0 "No" 1 "Yes" 
label define lb_m24_1 0 "No" 1 "Yes" 
label define lb_m25 0 "No" 1 "Yes" 
label define lb_m28_banana_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_beans_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_cashewfr_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_cattle_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_cheese_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_citrus_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_cocoa_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_coffee_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_corn_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_cupu_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_fish_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_flour_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_honey_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_horse_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_manioc_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_milk_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_other1_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_other2_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_other3_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_other4_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_other5_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_other6_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_passion_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_pepper_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_poultry_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_pupunha_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_rice_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_rubber_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_swine_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_tapioca_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_tucupi_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m28_vine_3 1 "Domestic use or consumption" 2 "Sale" 3 "Barter or donation" 4 "Both (use and sale or barter)" 
label define lb_m30_1 0 "No" 1 "Yes" 
label define lb_m30_10 0 "No" 1 "Yes" 
label define lb_m30_11 0 "No" 1 "Yes" 
label define lb_m30_12 0 "No" 1 "Yes" 
label define lb_m30_13 0 "No" 1 "Yes" 
label define lb_m30_14 0 "No" 1 "Yes" 
label define lb_m30_15 0 "No" 1 "Yes" 
label define lb_m30_2 0 "No" 1 "Yes" 
label define lb_m30_3 0 "No" 1 "Yes" 
label define lb_m30_4 0 "No" 1 "Yes" 
label define lb_m30_5 0 "No" 1 "Yes" 
label define lb_m30_6 0 "No" 1 "Yes" 
label define lb_m30_7 0 "No" 1 "Yes" 
label define lb_m30_8 0 "No" 1 "Yes" 
label define lb_m30_9 0 "No" 1 "Yes" 
label define lb_m31_1 0 "No" 1 "Yes" 
label define lb_m31_2 1 "Increase it" 2 "Decrease it" 
label define lb_m32_1 0 "No" 1 "Yes" 
label define lb_m32_2 1 "Advances it" 2 "Delays it" 
label define lb_m33_1 0 "No" 1 "Yes" 
label define lb_m34_1 0 "No" 1 "Yes" 
label define lb_m35_1 0 "No" 1 "Yes" 
label define lb_m36_1 0 "No" 1 "Yes" 
label define lb_m38_1 0 "No" 1 "Yes" 
label define lb_m39_1 0 "No" 1 "Yes" 3 "Don't know" 
label define lb_m40_1 0 "No" 1 "Yes" 
label define lb_m40_2 0 "No" 1 "Yes"
label define lb_m41_0 0 "No" 1 "Yes"
label define lb_m41_1 1 "Always the same practice" 2 "Different"
label define lb_m42_0 0 "No" 1 "Yes"
label define lb_m42_1 1 "Always the same practice" 2 "Different"
label define lb_m43 1 "Increase" 2 "Decrease" 3 "Same"
label define lb_m44 0 "No" 1 "Yes"
label define lb_m46 0 "No" 1 "Yes"
label define lb_m47 0 "No" 1 "Yes"
label define lb_m48 0 "No" 1 "Yes"
label define lb_m49_1 0 "No" 1 "Yes"
label define lb_m49_2 0 "No" 1 "Yes"
label define lb_m49_3 0 "No" 1 "Yes"
label define lb_m49_4 0 "No" 1 "Yes"
label define lb_m49_5 0 "No" 1 "Yes"
label define lb_m5 0 "No" 1 "Yes"
label define lb_m50 0 "No" 1 "Yes"
label define lb_m52_1 0 "No" 1 "Yes"
label define lb_m53_1 0 "No" 1 "Yes"
label define lb_m53_2 1 "Extracts from lot" 2 "Buys" 3 "Sells"
label define lb_m55_1 0 "No" 1 "Yes"
label define lb_m55_2 0 "No" 1 "Yes"
label define lb_m55_3 0 "No" 1 "Yes"
label define lb_m55_4 0 "No" 1 "Yes"
label define lb_m55_5 0 "No" 1 "Yes"
label define lb_m56_1_1998 0 "No" 1 "Yes"
label define lb_m56_1_1999 0 "No" 1 "Yes"
label define lb_m56_1_2000 0 "No" 1 "Yes"
label define lb_m56_1_2001 0 "No" 1 "Yes"
label define lb_m56_1_2002 0 "No" 1 "Yes"
label define lb_m56_2_1998 0 "No" 1 "Yes"
label define lb_m56_2_1999 0 "No" 1 "Yes"
label define lb_m56_2_2000 0 "No" 1 "Yes"
label define lb_m56_2_2001 0 "No" 1 "Yes"
label define lb_m56_2_2002 0 "No" 1 "Yes"
label define lb_m56_3_1998 0 "No" 1 "Yes"
label define lb_m56_3_1999 0 "No" 1 "Yes"
label define lb_m56_3_2000 0 "No" 1 "Yes"
label define lb_m56_3_2001 0 "No" 1 "Yes"
label define lb_m56_3_2002 0 "No" 1 "Yes"
label define lb_m57 0 "No" 1 "Yes"
label define lb_m57_1_1 0 "No" 1 "Yes"
label define lb_m57_1_2 0 "No" 1 "Yes"
label define lb_m57_10_1 0 "No" 1 "Yes"
label define lb_m57_10_2 0 "No" 1 "Yes"
label define lb_m57_11_1 0 "No" 1 "Yes"
label define lb_m57_11_2 0 "No" 1 "Yes"
label define lb_m57_2_1 0 "No" 1 "Yes"
label define lb_m57_2_2 0 "No" 1 "Yes"
label define lb_m57_3_1 0 "No" 1 "Yes"
label define lb_m57_3_2 0 "No" 1 "Yes"
label define lb_m57_4_1 0 "No" 1 "Yes"
label define lb_m57_4_2 0 "No" 1 "Yes"
label define lb_m57_5_1 0 "No" 1 "Yes"
label define lb_m57_5_2 0 "No" 1 "Yes"
label define lb_m57_6_1 0 "No" 1 "Yes"
label define lb_m57_6_2 0 "No" 1 "Yes"
label define lb_m57_7_1 0 "No" 1 "Yes"
label define lb_m57_7_2 0 "No" 1 "Yes"
label define lb_m57_8_1 0 "No" 1 "Yes"
label define lb_m57_8_2 0 "No" 1 "Yes"
label define lb_m57_9_1 0 "No" 1 "Yes"
label define lb_m57_9_2 0 "No" 1 "Yes"
label define lb_m58_1 0 "No" 1 "Yes"
label define lb_m58_2 0 "No" 1 "Yes"
label define lb_m58_3 0 "No" 1 "Yes"
label define lb_m59_1 0 "No" 1 "Yes"
label define lb_m59_2 0 "No" 1 "Yes"
label define lb_m6 1 "Property title in your name" 2 "Receipt from previous owner" 3 "Notarized document" 4 "Possession paper" 5 "Other"
label define lb_m61 0 "No" 1 "Yes"
label define lb_m63 0 "No" 1 "Yes"
label define lb_m66_1 0 "No" 1 "Yes"
label define lb_m68_animalcart_2 0 "No" 1 "Yes"
label define lb_m68_animalcart_3 0 "No" 1 "Yes"
label define lb_m68_animalcart_5 0 "No" 1 "Yes"
label define lb_m68_animaldisc_2 0 "No" 1 "Yes"
label define lb_m68_animaldisc_3 0 "No" 1 "Yes"
label define lb_m68_animaldisc_5 0 "No" 1 "Yes"
label define lb_m68_animalmeds_2 0 "No" 1 "Yes"
label define lb_m68_animalmeds_3 0 "No" 1 "Yes"
label define lb_m68_animalmeds_5 0 "No" 1 "Yes"
label define lb_m68_animalplow_2 0 "No" 1 "Yes"
label define lb_m68_animalplow_3 0 "No" 1 "Yes"
label define lb_m68_animalplow_5 0 "No" 1 "Yes"
label define lb_m68_caminhao_2 0 "No" 1 "Yes"
label define lb_m68_caminhao_3 0 "No" 1 "Yes"
label define lb_m68_caminhao_5 0 "No" 1 "Yes"
label define lb_m68_cart_2 0 "No" 1 "Yes"
label define lb_m68_cart_3 0 "No" 1 "Yes"
label define lb_m68_cart_5 0 "No" 1 "Yes"
label define lb_m68_chainsaw_2 0 "No" 1 "Yes"
label define lb_m68_chainsaw_3 0 "No" 1 "Yes"
label define lb_m68_chainsaw_5 0 "No" 1 "Yes"
label define lb_m68_chemfertilizer_2 0 "No" 1 "Yes"
label define lb_m68_chemfertilizer_3 0 "No" 1 "Yes"
label define lb_m68_chemfertilizer_5 0 "No" 1 "Yes"
label define lb_m68_disc_2 0 "No" 1 "Yes"
label define lb_m68_disc_3 0 "No" 1 "Yes"
label define lb_m68_disc_5 0 "No" 1 "Yes"
label define lb_m68_fungicides_2 0 "No" 1 "Yes"
label define lb_m68_fungicides_3 0 "No" 1 "Yes"
label define lb_m68_fungicides_5 0 "No" 1 "Yes"
label define lb_m68_generator_2 0 "No" 1 "Yes"
label define lb_m68_generator_3 0 "No" 1 "Yes"
label define lb_m68_generator_5 0 "No" 1 "Yes"
label define lb_m68_herbicides_2 0 "No" 1 "Yes"
label define lb_m68_herbicides_3 0 "No" 1 "Yes"
label define lb_m68_herbicides_5 0 "No" 1 "Yes"
label define lb_m68_insecticides_2 0 "No" 1 "Yes"
label define lb_m68_insecticides_3 0 "No" 1 "Yes"
label define lb_m68_insecticides_5 0 "No" 1 "Yes"
label define lb_m68_mineralsalt_2 0 "No" 1 "Yes"
label define lb_m68_mineralsalt_3 0 "No" 1 "Yes"
label define lb_m68_mineralsalt_5 0 "No" 1 "Yes"
label define lb_m68_orgfertilizer_2 0 "No" 1 "Yes"
label define lb_m68_orgfertilizer_3 0 "No" 1 "Yes"
label define lb_m68_orgfertilizer_5 0 "No" 1 "Yes"
label define lb_m68_othertech1_2 0 "No" 1 "Yes"
label define lb_m68_othertech1_3 0 "No" 1 "Yes"
label define lb_m68_othertech1_5 0 "No" 1 "Yes"
label define lb_m68_othertech2_2 0 "No" 1 "Yes"
label define lb_m68_othertech2_3 0 "No" 1 "Yes"
label define lb_m68_othertech2_5 0 "No" 1 "Yes"
label define lb_m68_othertech3_2 0 "No" 1 "Yes"
label define lb_m68_othertech3_3 0 "No" 1 "Yes"
label define lb_m68_othertech3_5 0 "No" 1 "Yes"
label define lb_m68_plow_2 0 "No" 1 "Yes"
label define lb_m68_plow_3 0 "No" 1 "Yes"
label define lb_m68_plow_5 0 "No" 1 "Yes"
label define lb_m68_scythe_2 0 "No" 1 "Yes"
label define lb_m68_scythe_3 0 "No" 1 "Yes"
label define lb_m68_scythe_5 0 "No" 1 "Yes"
label define lb_m68_seeder_2 0 "No" 1 "Yes"
label define lb_m68_seeder_3 0 "No" 1 "Yes"
label define lb_m68_seeder_5 0 "No" 1 "Yes"
label define lb_m68_tractor_2 0 "No" 1 "Yes"
label define lb_m68_tractor_3 0 "No" 1 "Yes"
label define lb_m68_tractor_5 0 "No" 1 "Yes"
label define lb_m68_waterengine_2 0 "No" 1 "Yes"
label define lb_m68_waterengine_3 0 "No" 1 "Yes"
label define lb_m68_waterengine_5 0 "No" 1 "Yes"
label define lb_m69_1_1 0 "No" 1 "Yes"
label define lb_m69_2_1 0 "No" 1 "Yes"
label define lb_m69_3_1 0 "No" 1 "Yes"
label define lb_m69_4_1 0 "No" 1 "Yes"
label define lb_m69_5_1 0 "No" 1 "Yes"
label define lb_m7 1 "Bought" 2 "Received from INCRA, ITERPA, etc" 3 "Inherited" 4 "Other"
label define lb_m70_1 0 "No" 1 "Yes"
label define lb_m70_2 0 "No" 1 "Yes"
label define lb_m71_1 0 "No" 1 "Yes"
label define lb_m71_2 0 "No" 1 "Yes"
label define lb_m72_1 0 "No" 1 "Yes"
label define lb_m72_2 0 "No" 1 "Yes"
label define lb_m73_1 0 "No" 1 "Yes"
label define lb_m73_2 0 "No" 1 "Yes"
label define lb_m74_1 0 "No" 1 "Yes"
label define lb_m75 0 "No" 1 "Yes"
label define lb_m75_cr1_9 1 "No" 2 "Yes" 3 "Continue"
label define lb_m75_cr2_9 1 "No" 2 "Yes" 3 "Continue"
label define lb_m75_cr3_9 1 "No" 2 "Yes" 3 "Continue"
label define lb_m76 0 "No" 1 "Yes"
label define lb_m8_nap 0 "No" 1 "Yes"
label define lb_w10 1 "In this property" 2 "In another rural property" 3 "City/village" 4 "Both property and city/village" 5 "Other"
label define lb_w100_cheese_a 0 "No" 1 "Yes"
label define lb_w100_cheese_b 1 "Household use or consumption" 2 "Sale or barter" 3 "Both use and sale"
label define lb_w100_cheese_c 1 "Local market" 2 "Santarem" 3 "Neighbors" 4 "Other"
label define lb_w100_cheese_d 1 "Weekly" 2 "Bi-weekly" 3 "Monthly" 4 "Occasionally" 5 "Rarely" 6 "Other"
label define lb_w100_clothes_a 0 "No" 1 "Yes"
label define lb_w100_clothes_b 1 "Household use or consumption" 2 "Sale or barter" 3 "Both use and sale"
label define lb_w100_clothes_c 1 "Local market" 2 "Santarem" 3 "Neighbors" 4 "Other"
label define lb_w100_clothes_d 1 "Weekly" 2 "Bi-weekly" 3 "Monthly" 4 "Occasionally" 5 "Rarely" 6 "Other"
label define lb_w100_crochet_a 0 "No" 1 "Yes"
label define lb_w100_crochet_b 1 "Household use or consumption" 2 "Sale or barter" 3 "Both use and sale"
label define lb_w100_crochet_c 1 "Local market" 2 "Santarem" 3 "Neighbors" 4 "Other"
label define lb_w100_crochet_d 1 "Weekly" 2 "Bi-weekly" 3 "Monthly" 4 "Occasionally" 5 "Rarely" 6 "Other"
label define lb_w100_garden_a 0 "No" 1 "Yes"
label define lb_w100_garden_b 1 "Household use or consumption" 2 "Sale or barter" 3 "Both use and sale"
label define lb_w100_garden_c 1 "Local market" 2 "Santarem" 3 "Neighbors" 4 "Other"
label define lb_w100_garden_d 1 "Weekly" 2 "Bi-weekly" 3 "Monthly" 4 "Occasionally" 5 "Rarely" 6 "Other"
label define lb_w100_handcraft_a 0 "No" 1 "Yes"
label define lb_w100_handcraft_b 1 "Household use or consumption" 2 "Sale or barter" 3 "Both use and sale"
label define lb_w100_handcraft_c 1 "Local market" 2 "Santarem" 3 "Neighbors" 4 "Other"
label define lb_w100_handcraft_d 1 "Weekly" 2 "Bi-weekly" 3 "Monthly" 4 "Occasionally" 5 "Rarely" 6 "Other"
label define lb_w100_other1_a 0 "No" 1 "Yes"
label define lb_w100_other1_b 1 "Household use or consumption" 2 "Sale or barter" 3 "Both use and sale"
label define lb_w100_other1_c 1 "Local market" 2 "Santarem" 3 "Neighbors" 4 "Other"
label define lb_w100_other1_d 1 "Weekly" 2 "Bi-weekly" 3 "Monthly" 4 "Occasionally" 5 "Rarely" 6 "Other"
label define lb_w100_other2_a 0 "No" 1 "Yes"
label define lb_w100_other2_b 1 "Household use or consumption" 2 "Sale or barter" 3 "Both use and sale"
label define lb_w100_other2_c 1 "Local market" 2 "Santarem" 3 "Neighbors" 4 "Other"
label define lb_w100_other2_d 1 "Weekly" 2 "Bi-weekly" 3 "Monthly" 4 "Occasionally" 5 "Rarely" 6 "Other"
label define lb_w100_snacks_a 0 "No" 1 "Yes"
label define lb_w100_snacks_b 1 "Household use or consumption" 2 "Sale or barter" 3 "Both use and sale"
label define lb_w100_snacks_c 1 "Local market" 2 "Santarem" 3 "Neighbors" 4 "Other"
label define lb_w100_snacks_d 1 "Weekly" 2 "Bi-weekly" 3 "Monthly" 4 "Occasionally" 5 "Rarely" 6 "Other"
label define lb_w101_first 1 "Farming Activities" 2 "Public Employment" 3 "Professional (doctor, lawyer, etc)" 4 "Domestic Work" 5 "Handcraft" 6 "Doesn't have activities" 7 "Other"
label define lb_w101_second 1 "Farming Activities" 2 "Public Employment" 3 "Professional (doctor, lawyer, etc)" 4 "Domestic Work" 5 "Handcraft" 6 "Doesn't have activities" 7 "Other"
label define lb_w103 0 "No" 1 "Yes"
label define lb_w12_2 1 "Daily" 2 "Weekly" 3 "Bi-monthly" 4 "Monthly" 5 "Annually"
label define lb_w120_1 0 "No" 1 "Yes"
label define lb_w120_2 0 "No" 1 "Yes"
label define lb_w120_3 0 "No" 1 "Yes"
label define lb_w120_4 0 "No" 1 "Yes"
label define lb_w120_5 0 "No" 1 "Yes"
label define lb_w120_6 0 "No" 1 "Yes"
label define lb_w120_7 0 "No" 1 "Yes"
label define lb_w121_1 0 "No" 1 "Yes"
label define lb_w121_2 0 "No" 1 "Yes"
label define lb_w121_3 0 "No" 1 "Yes"
label define lb_w121_4 0 "No" 1 "Yes"
label define lb_w121_5 0 "No" 1 "Yes"
label define lb_w121_6 0 "No" 1 "Yes"
label define lb_w122_1 0 "No" 1 "Yes"
label define lb_w122_2 0 "No" 1 "Yes"
label define lb_w122_3 0 "No" 1 "Yes"
label define lb_w122_4 0 "No" 1 "Yes"
label define lb_w122_5 0 "No" 1 "Yes"
label define lb_w122_6 0 "No" 1 "Yes"
label define lb_w122_7 0 "No" 1 "Yes"
label define lb_w123_1 0 "No" 1 "Yes"
label define lb_w123_2 0 "No" 1 "Yes"
label define lb_w124 1 "Septic system" 2 "Cesspit" 3 "Doesn't have"
label define lb_w125_1 0 "No" 1 "Yes"
label define lb_w125_2 0 "No" 1 "Yes"
label define lb_w125_3 0 "No" 1 "Yes"
label define lb_w125_4 0 "No" 1 "Yes"
label define lb_w125_5 0 "No" 1 "Yes"
label define lb_w125_6 0 "No" 1 "Yes"
label define lb_w126_2 1 "Someone in the house" 2 "Some relative who left the house" 3 "Someone outside the house" 4 "Other"
label define lb_w126_3 1 "Cash" 2 "Credit" 3 "Present" 4 "Other"
label define lb_w126_4 1 "Local" 2 "Santarem" 3 "Other location in Para" 4 "Outside Para"
label define lb_w127_2 1 "Someone in the house" 2 "Some relative who left the house" 3 "Someone outside the house" 4 "Other"
label define lb_w127_3 1 "Cash" 2 "Credit" 3 "Present" 4 "Other"
label define lb_w127_4 1 "Local" 2 "Santarem" 3 "Other location in Para" 4 "Outside Para"
label define lb_w128_2 1 "Someone in the house" 2 "Some relative who left the house" 3 "Someone outside the house" 4 "Other"
label define lb_w128_3 1 "Cash" 2 "Credit" 3 "Present" 4 "Other"
label define lb_w128_4 1 "Local" 2 "Santarem" 3 "Other location in Para" 4 "Outside Para"
label define lb_w129_2 1 "Someone in the house" 2 "Some relative who left the house" 3 "Someone outside the house" 4 "Other"
label define lb_w129_3 1 "Cash" 2 "Credit" 3 "Present" 4 "Other"
label define lb_w129_4 1 "Local" 2 "Santarem" 3 "Other location in Para" 4 "Outside Para"
label define lb_w130_2 1 "Someone in the house" 2 "Some relative who left the house" 3 "Someone outside the house" 4 "Other"
label define lb_w130_3 1 "Cash" 2 "Credit" 3 "Present" 4 "Other"
label define lb_w130_4 1 "Local" 2 "Santarem" 3 "Other location in Para" 4 "Outside Para"
label define lb_w131_2 1 "Someone in the house" 2 "Some relative who left the house" 3 "Someone outside the house" 4 "Other"
label define lb_w131_3 1 "Cash" 2 "Credit" 3 "Present" 4 "Other"
label define lb_w131_4 1 "Local" 2 "Santarem" 3 "Other location in Para" 4 "Outside Para"
label define lb_w132_2 1 "Someone in the house" 2 "Some relative who left the house" 3 "Someone outside the house" 4 "Other"
label define lb_w132_3 1 "Cash" 2 "Credit" 3 "Present" 4 "Other"
label define lb_w132_4 1 "Local" 2 "Santarem" 3 "Other location in Para" 4 "Outside Para"
label define lb_w133_2 1 "Someone in the house" 2 "Some relative who left the house" 3 "Someone outside the house" 4 "Other"
label define lb_w133_3 1 "Cash" 2 "Credit" 3 "Present" 4 "Other"
label define lb_w133_4 1 "Local" 2 "Santarem" 3 "Other location in Para" 4 "Outside Para"
label define lb_w134_2 1 "Someone in the house" 2 "Some relative who left the house" 3 "Someone outside the house" 4 "Other"
label define lb_w134_3 1 "Cash" 2 "Credit" 3 "Present" 4 "Other"
label define lb_w134_4 1 "Local" 2 "Santarem" 3 "Other location in Para" 4 "Outside Para"
label define lb_w135_2 1 "Someone in the house" 2 "Some relative who left the house" 3 "Someone outside the house" 4 "Other"
label define lb_w135_3 1 "Cash" 2 "Credit" 3 "Present" 4 "Other"
label define lb_w135_4 1 "Local" 2 "Santarem" 3 "Other location in Para" 4 "Outside Para"
label define lb_w136_2 1 "Someone in the house" 2 "Some relative who left the house" 3 "Someone outside the house" 4 "Other"
label define lb_w136_3 1 "Cash" 2 "Credit" 3 "Present" 4 "Other"
label define lb_w136_4 1 "Local" 2 "Santarem" 3 "Other location in Para" 4 "Outside Para"
label define lb_w137_2 1 "Someone in the house" 2 "Some relative who left the house" 3 "Someone outside the house" 4 "Other"
label define lb_w137_3 1 "Cash" 2 "Credit" 3 "Present" 4 "Other"
label define lb_w137_4 1 "Local" 2 "Santarem" 3 "Other location in Para" 4 "Outside Para"
label define lb_w138_2 1 "Someone in the house" 2 "Some relative who left the house" 3 "Someone outside the house" 4 "Other"
label define lb_w138_3 1 "Cash" 2 "Credit" 3 "Present" 4 "Other"
label define lb_w138_4 1 "Local" 2 "Santarem" 3 "Other location in Para" 4 "Outside Para"
label define lb_w139_2 1 "Someone in the house" 2 "Some relative who left the house" 3 "Someone outside the house" 4 "Other"
label define lb_w139_3 1 "Cash" 2 "Credit" 3 "Present" 4 "Other"
label define lb_w139_4 1 "Local" 2 "Santarem" 3 "Other location in Para" 4 "Outside Para"
label define lb_w14_2 1 "Daily" 2 "Weekly" 3 "Bi-weekly" 4 "Monthly" 5 "Annually"
label define lb_w140_2 1 "Cash" 2 "Credit" 3 "Present" 4 "Other"
label define lb_w140_3 1 "Local" 2 "Santarem" 3 "Other location in Para" 4 "Outside Para"
label define lb_w140_4 1 "Daily" 2 "Weekly" 3 "Bi-weekly" 4 "Monthly"
label define lb_w141_2 1 "Cash" 2 "Credit" 3 "Present" 4 "Other"
label define lb_w141_3 1 "Local" 2 "Santarem" 3 "Other location in Para" 4 "Outside Para"
label define lb_w141_4 1 "Daily" 2 "Weekly" 3 "Bi-weekly" 4 "Monthly"
label define lb_w142_2 1 "Cash" 2 "Credit" 3 "Present" 4 "Other"
label define lb_w142_3 1 "Local" 2 "Santarem" 3 "Other location in Para" 4 "Outside Para"
label define lb_w142_4 1 "Daily" 2 "Weekly" 3 "Bi-weekly" 4 "Monthly"
label define lb_w143_2 1 "Cash" 2 "Credit" 3 "Present" 4 "Other"
label define lb_w143_3 1 "Local" 2 "Santarem" 3 "Other location in Para" 4 "Outside Para"
label define lb_w143_4 1 "Daily" 2 "Weekly" 3 "Bi-weekly" 4 "Monthly"
label define lb_w144_2 1 "Cash" 2 "Credit" 3 "Present" 4 "Other"
label define lb_w144_3 1 "Local" 2 "Santarem" 3 "Other location in Para" 4 "Outside Para"
label define lb_w144_4 1 "Daily" 2 "Weekly" 3 "Bi-weekly" 4 "Monthly"
label define lb_w145 1 "You/wife" 2 "Spouse/husband" 3 "Both" 4 "Family" 5 "Other"
label define lb_w146 1 "You/wife" 2 "Spouse/husband" 3 "Both" 4 "Family" 5 "Other"
label define lb_w147 1 "You/wife" 2 "Spouse/husband" 3 "Both" 4 "Family" 5 "Other"
label define lb_w148 1 "You/wife" 2 "Spouse/husband" 3 "Both" 4 "Family" 5 "Other"
label define lb_w149 1 "You/wife" 2 "Spouse/husband" 3 "Both" 4 "Family" 5 "Other"
label define lb_w150 1 "You/wife" 2 "Spouse/husband" 3 "Both" 4 "Family" 5 "Other"
label define lb_w151 1 "You/wife" 2 "Spouse/husband" 3 "Both" 4 "Family" 5 "Other"
label define lb_w152 1 "You/wife" 2 "Spouse/husband" 3 "Both" 4 "Family" 5 "Other"
label define lb_w153 1 "You/wife" 2 "Spouse/husband" 3 "Both" 4 "Family" 5 "Other"
label define lb_w154 1 "Not religious" 2 "Catholic" 3 "Protestant" 4 "Spiritualist" 5 "Other"
label define lb_w155 1 "Not religious" 2 "Catholic" 3 "Protestant" 4 "Spiritualist" 5 "Other"
label define lb_w156_1 1 "Education" 2 "Health" 3 "Transportation/Health" 4 "Leisure" 5 "Technical Assistance" 6 "Low Prices" 7 "Electric Energy" 8 "Water" 9 "Other"
label define lb_w156_2 1 "Education" 2 "Health" 3 "Transportation/Health" 4 "Leisure" 5 "Technical Assistance" 6 "Low Prices" 7 "Electric Energy" 8 "Water" 9 "Other"
label define lb_w156_3 1 "Education" 2 "Health" 3 "Transportation/Health" 4 "Leisure" 5 "Technical Assistance" 6 "Low Prices" 7 "Electric Energy" 8 "Water" 9 "Other"
label define lb_w157_1 0 "No" 1 "Yes"
label define lb_w157_2 0 "No" 1 "Yes"
label define lb_w157_3 0 "No" 1 "Yes"
label define lb_w157_4 0 "No" 1 "Yes"
label define lb_w158_1 0 "No" 1 "Yes"
label define lb_w158_2 0 "No" 1 "Yes"
label define lb_w158_3 0 "No" 1 "Yes"
label define lb_w158_4 0 "No" 1 "Yes"
label define lb_w158_5 0 "No" 1 "Yes"
label define lb_w159_1 0 "No" 1 "Yes"
label define lb_w159_2 0 "No" 1 "Yes"
label define lb_w159_3 0 "No" 1 "Yes"
label define lb_w159_4 0 "No" 1 "Yes"
label define lb_w159_5 0 "No" 1 "Yes"
label define lb_w160_1 0 "No" 1 "Yes"
label define lb_w160_2 0 "No" 1 "Yes"
label define lb_w160_3 0 "No" 1 "Yes"
label define lb_w160_4 0 "No" 1 "Yes"
label define lb_w160_5 0 "No" 1 "Yes"
label define lb_w160_6 0 "No" 1 "Yes"
label define lb_w161_1 0 "No" 1 "Yes"
label define lb_w161_2 0 "No" 1 "Yes"
label define lb_w161_3 0 "No" 1 "Yes"
label define lb_w161_4 0 "No" 1 "Yes"
label define lb_w161_5 0 "No" 1 "Yes"
label define lb_w161_6 0 "No" 1 "Yes"
label define lb_w162_1 0 "No" 1 "Yes"
label define lb_w162_2 0 "No" 1 "Yes"
label define lb_w162_3 0 "No" 1 "Yes"
label define lb_w162_4 0 "No" 1 "Yes"
label define lb_w162_5 0 "No" 1 "Yes"
label define lb_w162_8 0 "No" 1 "Yes"
label define lb_w163_1 0 "No" 1 "Yes"
label define lb_w163_2 0 "No" 1 "Yes"
label define lb_w163_3 0 "No" 1 "Yes"
label define lb_w163_4 0 "No" 1 "Yes"
label define lb_w163_5 0 "No" 1 "Yes"
label define lb_w163_8 0 "No" 1 "Yes"
label define lb_w2 1 "Yes" 2 "No, the head of household was never married" 3 "No, she is deceased" 4 "No, the head of household/owned is divorced" 5 "No, at the moment the woman is living elsewhere" 6 "No, the woman is absent for some reason"
label define lb_w32 0 "No" 1 "Yes"
label define lb_w33 0 "No" 1 "Yes"
label define lb_w34 0 "No" 1 "Yes"
label define lb_w35 0 "No" 1 "Yes"
label define lb_w36 0 "No" 1 "Yes"
label define lb_w37 0 "No" 1 "Yes"
label define lb_w38 0 "No" 1 "Yes"
label define lb_w39 0 "No" 1 "Yes"
label define lb_w40 0 "No" 1 "Yes"
label define lb_w41 0 "No" 1 "Yes"
label define lb_w42 0 "No" 1 "Yes"
label define lb_w43 0 "No" 1 "Yes"
label define lb_w44 0 "No" 1 "Yes"
label define lb_w45 0 "No" 1 "Yes"
label define lb_w6 1 "Yes" 2 "No" 3 "Don't know" 
label define lb_w7_1 0 "No" 1 "Yes" 
label define lb_w8 0 "No" 1 "Yes" 
  
* Apply variable value labels
label values id_dona lb_id_dona
label values id_dona_is_man lb_id_dona_is_man
label values id_dono lb_id_dono
label values id_final_sample lb_id_final_sample
label values id_registro_m lb_id_registro_m
label values id_registro_w lb_id_registro_w
label values id_widow lb_id_widow
label values int_owner_w lb_int_owner_w
label values int_roster_no_w lb_int_roster_no_w
label values m10_1 lb_m10_1
label values m10_2 lb_m10_2
label values m10_3 lb_m10_3
label values m10_4 lb_m10_4
label values m10_5 lb_m10_5
label values m10_6 lb_m10_6
label values m10_7 lb_m10_7
label values m10_8 lb_m10_8
label values m10_main lb_m10_main
label values m11 lb_m11
label values m12_nap lb_m12_nap
label values m13_2 lb_m13_2
label values m14_2 lb_m14_2
label values m15_2 lb_m15_2
label values m16_1 lb_m16_1
label values m16_2 lb_m16_2
label values m16_3 lb_m16_3
label values m16_4 lb_m16_4
label values m17 lb_m17
label values m18_2 lb_m18_2
label values m18_3 lb_m18_3 
label values m18_4 lb_m18_4 
label values m19_1 lb_m19_1
label values m19_2 lb_m19_2
label values m2_1 lb_m2_1
label values m2_2 lb_m2_2
label values m20_1 lb_m20_1
label values m20_2 lb_m20_2
label values m20_3 lb_m20_3
label values m20_4 lb_m20_4
label values m20_5 lb_m20_5
label values m21_01_0 lb_m21_01_0
label values m21_02_0 lb_m21_02_0
label values m21_03_0 lb_m21_03_0
label values m21_04_0 lb_m21_04_0
label values m21_05_0 lb_m21_05_0
label values m21_05_2 lb_m21_05_2
label values m21_06_0 lb_m21_06_0
label values m21_07_0 lb_m21_07_0
label values m21_07_1 lb_m21_07_1
label values m21_08_0 lb_m21_08_0
label values m21_09_0 lb_m21_09_0
label values m21_10_0 lb_m21_10_0
label values m22_01_0 lb_m22_01_0
label values m22_02_0 lb_m22_02_0
label values m22_03_0 lb_m22_03_0
label values m22_04_0 lb_m22_04_0
label values m22_05_0 lb_m22_05_0
label values m22_05_2 lb_m22_05_2
label values m22_06_0 lb_m22_06_0
label values m22_07_0 lb_m22_07_0
label values m22_07_1 lb_m22_07_1
label values m22_08_0 lb_m22_08_0
label values m22_09_0 lb_m22_09_0
label values m22_09_0 lb_m22_09_0
label values m22_10_0 lb_m22_10_0
label values m23 lb_m23
label values m24_1 lb_m24_1
label values m25 lb_m25
label values m28_banana_3 lb_m28_banana_3
label values m28_beans_3 lb_m28_beans_3
label values m28_cashewfr_3 lb_m28_cashewfr_3
label values m28_cattle_3 lb_m28_cattle_3
label values m28_cheese_3 lb_m28_cheese_3
label values m28_citrus_3 lb_m28_citrus_3
label values m28_cocoa_3 lb_m28_cocoa_3
label values m28_coffee_3 lb_m28_coffee_3
label values m28_corn_3 lb_m28_corn_3
label values m28_cupu_3 lb_m28_cupu_3
label values m28_fish_3 lb_m28_fish_3
label values m28_flour_3 lb_m28_flour_3
label values m28_honey_3 lb_m28_honey_3
label values m28_horse_3 lb_m28_horse_3
label values m28_manioc_3 lb_m28_manioc_3
label values m28_milk_3 lb_m28_milk_3
label values m28_other1_3 lb_m28_other1_3
label values m28_other2_3 lb_m28_other2_3
label values m28_other3_3 lb_m28_other3_3
label values m28_other4_3 lb_m28_other4_3
label values m28_other5_3 lb_m28_other5_3
label values m28_other6_3 lb_m28_other6_3
label values m28_passion_3 lb_m28_passion_3
label values m28_pepper_3 lb_m28_pepper_3
label values m28_poultry_3 lb_m28_poultry_3
label values m28_pupunha_3 lb_m28_pupunha_3
label values m28_rice_3 lb_m28_rice_3
label values m28_rubber_3 lb_m28_rubber_3
label values m28_swine_3 lb_m28_swine_3
label values m28_tapioca_3 lb_m28_tapioca_3
label values m28_tucupi_3 lb_m28_tucupi_3
label values m28_vine_3 lb_m28_vine_3
label values m30_1 lb_m30_1
label values m30_10 lb_m30_10
label values m30_11 lb_m30_11
label values m30_12 lb_m30_12
label values m30_13 lb_m30_13
label values m30_14 lb_m30_14
label values m30_15 lb_m30_15
label values m30_2 lb_m30_2
label values m30_3 lb_m30_3
label values m30_4 lb_m30_4
label values m30_5 lb_m30_5
label values m30_6 lb_m30_6
label values m30_7 lb_m30_7
label values m30_8 lb_m30_8
label values m30_9 lb_m30_9
label values m31_1 lb_m31_1
label values m31_2 lb_m31_2
label values m32_1 lb_m32_1
label values m32_2 lb_m32_2
label values m33_1 lb_m33_1
label values m34_1 lb_m34_1
label values m35_1 lb_m35_1
label values m36_1 lb_m36_1
label values m38_1 lb_m38_1
label values m39_1 lb_m39_1
label values m40_1 lb_m40_1
label values m40_2 lb_m40_2
label values m41_0 lb_m41_0
label values m41_1 lb_m41_1
label values m42_0 lb_m42_0
label values m42_1 lb_m42_1
label values m43 lb_m43
label values m44 lb_m44
label values m46 lb_m46
label values m47 lb_m47
label values m48 lb_m48
label values m49_1 lb_m49_1
label values m49_2 lb_m49_2
label values m49_3 lb_m49_3
label values m49_4 lb_m49_4
label values m49_5 lb_m49_5
label values m5 lb_m5
label values m50 lb_m50
label values m52_1 lb_m52_1
label values m53_1 lb_m53_1
label values m53_2 lb_m53_2
label values m55_1 lb_m55_1
label values m55_2 lb_m55_2
label values m55_3 lb_m55_3
label values m55_4 lb_m55_4
label values m55_5 lb_m55_5
label values m56_1_1998 lb_m56_1_1998
label values m56_1_1999 lb_m56_1_1999
label values m56_1_2000 lb_m56_1_2000
label values m56_1_2001 lb_m56_1_2001
label values m56_1_2002 lb_m56_1_2002
label values m56_2_1998 lb_m56_2_1998
label values m56_2_1999 lb_m56_2_1999
label values m56_2_2000 lb_m56_2_2000
label values m56_2_2001 lb_m56_2_2001
label values m56_2_2002 lb_m56_2_2002
label values m56_3_1998 lb_m56_3_1998
label values m56_3_1999 lb_m56_3_1999
label values m56_3_2000 lb_m56_3_2000
label values m56_3_2001 lb_m56_3_2001
label values m56_3_2002 lb_m56_3_2002
label values m57 lb_m57
label values m57_1_1 lb_m57_1_1
label values m57_1_2 lb_m57_1_2
label values m57_10_1 lb_m57_10_1
label values m57_10_2 lb_m57_10_2
label values m57_11_1 lb_m57_11_1
label values m57_11_2 lb_m57_11_2
label values m57_2_1 lb_m57_2_1
label values m57_2_2 lb_m57_2_2
label values m57_3_1 lb_m57_3_1
label values m57_3_2 lb_m57_3_2
label values m57_4_1 lb_m57_4_1
label values m57_4_2 lb_m57_4_2
label values m57_5_1 lb_m57_5_1
label values m57_5_2 lb_m57_5_2
label values m57_6_1 lb_m57_6_1
label values m57_6_2 lb_m57_6_2
label values m57_7_1 lb_m57_7_1
label values m57_7_2 lb_m57_7_2
label values m57_8_1 lb_m57_8_1
label values m57_8_2 lb_m57_8_2
label values m57_9_1 lb_m57_9_1
label values m57_9_2 lb_m57_9_2
label values m58_1 lb_m58_1
label values m58_2 lb_m58_2
label values m58_3 lb_m58_3
label values m59_1 lb_m59_1
label values m59_2 lb_m59_2
label values m6 lb_m6
label values m61 lb_m61
label values m63 lb_m63
label values m66_1 lb_m66_1
label values m68_animalcart_2 lb_m68_animalcart_2
label values m68_animalcart_3 lb_m68_animalcart_3
label values m68_animalcart_5 lb_m68_animalcart_5
label values m68_animaldisc_2 lb_m68_animaldisc_2
label values m68_animaldisc_3 lb_m68_animaldisc_3
label values m68_animaldisc_5 lb_m68_animaldisc_5
label values m68_animalmeds_2 lb_m68_animalmeds_2
label values m68_animalmeds_3 lb_m68_animalmeds_3
label values m68_animalmeds_5 lb_m68_animalmeds_5
label values m68_animalplow_2 lb_m68_animalplow_2
label values m68_animalplow_3 lb_m68_animalplow_3
label values m68_animalplow_5 lb_m68_animalplow_5
label values m68_caminhao_2 lb_m68_caminhao_2
label values m68_caminhao_3 lb_m68_caminhao_3
label values m68_caminhao_5 lb_m68_caminhao_5
label values m68_cart_2 lb_m68_cart_2
label values m68_cart_3 lb_m68_cart_3
label values m68_cart_5 lb_m68_cart_5
label values m68_chainsaw_2 lb_m68_chainsaw_2
label values m68_chainsaw_3 lb_m68_chainsaw_3
label values m68_chainsaw_5 lb_m68_chainsaw_5
label values m68_chemfertilizer_2 lb_m68_chemfertilizer_2
label values m68_chemfertilizer_3 lb_m68_chemfertilizer_3
label values m68_chemfertilizer_5 lb_m68_chemfertilizer_5
label values m68_disc_2 lb_m68_disc_2
label values m68_disc_3 lb_m68_disc_3
label values m68_disc_5 lb_m68_disc_5
label values m68_fungicides_2 lb_m68_fungicides_2
label values m68_fungicides_3 lb_m68_fungicides_3
label values m68_fungicides_5 lb_m68_fungicides_5
label values m68_generator_2 lb_m68_generator_2
label values m68_generator_3 lb_m68_generator_3
label values m68_generator_5 lb_m68_generator_5
label values m68_herbicides_2 lb_m68_herbicides_2
label values m68_herbicides_3 lb_m68_herbicides_3
label values m68_herbicides_5 lb_m68_herbicides_5
label values m68_insecticides_2 lb_m68_insecticides_2
label values m68_insecticides_3 lb_m68_insecticides_3
label values m68_insecticides_5 lb_m68_insecticides_5
label values m68_mineralsalt_2 lb_m68_mineralsalt_2
label values m68_mineralsalt_3 lb_m68_mineralsalt_3
label values m68_mineralsalt_5 lb_m68_mineralsalt_5
label values m68_orgfertilizer_2 lb_m68_orgfertilizer_2
label values m68_orgfertilizer_3 lb_m68_orgfertilizer_3
label values m68_orgfertilizer_5 lb_m68_orgfertilizer_5
label values m68_othertech1_2 lb_m68_othertech1_2
label values m68_othertech1_3 lb_m68_othertech1_3
label values m68_othertech1_5 lb_m68_othertech1_5
label values m68_othertech2_2 lb_m68_othertech2_2
label values m68_othertech2_3 lb_m68_othertech2_3
label values m68_othertech2_5 lb_m68_othertech2_5
label values m68_othertech3_2 lb_m68_othertech3_2
label values m68_othertech3_3 lb_m68_othertech3_3
label values m68_othertech3_5 lb_m68_othertech3_5
label values m68_plow_2 lb_m68_plow_2
label values m68_plow_3 lb_m68_plow_3
label values m68_plow_5 lb_m68_plow_5
label values m68_scythe_2 lb_m68_scythe_2
label values m68_scythe_3 lb_m68_scythe_3
label values m68_scythe_5 lb_m68_scythe_5
label values m68_seeder_2 lb_m68_seeder_2
label values m68_seeder_3 lb_m68_seeder_3
label values m68_seeder_5 lb_m68_seeder_5
label values m68_tractor_2 lb_m68_tractor_2
label values m68_tractor_3 lb_m68_tractor_3
label values m68_tractor_5 lb_m68_tractor_5
label values m68_waterengine_2 lb_m68_waterengine_2
label values m68_waterengine_3 lb_m68_waterengine_3
label values m68_waterengine_5 lb_m68_waterengine_5
label values m69_1_1 lb_m69_1_1
label values m69_2_1 lb_m69_2_1
label values m69_3_1 lb_m69_3_1
label values m69_4_1 lb_m69_4_1
label values m69_5_1 lb_m69_5_1
label values m7 lb_m7
label values m70_1 lb_m70_1
label values m70_2 lb_m70_2
label values m71_1 lb_m71_1
label values m71_2 lb_m71_2
label values m72_1 lb_m72_1
label values m72_2 lb_m72_2
label values m73_1 lb_m73_1
label values m73_2 lb_m73_2
label values m74_1 lb_m74_1
label values m75 lb_m75
label values m75_cr1_9 lb_m75_cr1_9
label values m75_cr2_9 lb_m75_cr2_9
label values m75_cr3_9 lb_m75_cr3_9
label values m76 lb_m76
label values m8_nap lb_m8_nap
label values w10 lb_w10
label values w100_cheese_a lb_w100_cheese_a
label values w100_cheese_b lb_w100_cheese_b
label values w100_cheese_c lb_w100_cheese_c
label values w100_cheese_d lb_w100_cheese_d
label values w100_clothes_a lb_w100_clothes_a
label values w100_clothes_b lb_w100_clothes_b
label values w100_clothes_c lb_w100_clothes_c
label values w100_clothes_d lb_w100_clothes_d
label values w100_crochet_a lb_w100_crochet_a
label values w100_crochet_b lb_w100_crochet_b
label values w100_crochet_c lb_w100_crochet_c
label values w100_crochet_d lb_w100_crochet_d
label values w100_garden_a lb_w100_garden_a
label values w100_garden_b lb_w100_garden_b
label values w100_garden_c lb_w100_garden_c
label values w100_garden_d lb_w100_garden_d
label values w100_handcraft_a lb_w100_handcraft_a
label values w100_handcraft_b lb_w100_handcraft_b
label values w100_handcraft_c lb_w100_handcraft_c
label values w100_handcraft_d lb_w100_handcraft_d
label values w100_other1_a lb_w100_other1_a
label values w100_other1_b lb_w100_other1_b
label values w100_other1_c lb_w100_other1_c
label values w100_other1_d lb_w100_other1_d
label values w100_other2_a lb_w100_other2_a
label values w100_other2_b lb_w100_other2_b
label values w100_other2_c lb_w100_other2_c
label values w100_other2_d lb_w100_other2_d
label values w100_snacks_a lb_w100_snacks_a
label values w100_snacks_b lb_w100_snacks_b
label values w100_snacks_c lb_w100_snacks_c
label values w100_snacks_d lb_w100_snacks_d
label values w101_first lb_w101_first
label values w101_second lb_w101_second
label values w103 lb_w103
label values w12_2 lb_w12_2
label values w120_1 lb_w120_1
label values w120_2 lb_w120_2
label values w120_3 lb_w120_3
label values w120_4 lb_w120_4
label values w120_5 lb_w120_5
label values w120_6 lb_w120_6
label values w120_7 lb_w120_7
label values w121_1 lb_w121_1
label values w121_2 lb_w121_2
label values w121_3 lb_w121_3
label values w121_4 lb_w121_4
label values w121_5 lb_w121_5
label values w121_6 lb_w121_6
label values w122_1 lb_w122_1
label values w122_2 lb_w122_2
label values w122_3 lb_w122_3
label values w122_4 lb_w122_4
label values w122_5 lb_w122_5
label values w122_6 lb_w122_6
label values w122_7 lb_w122_7
label values w123_1 lb_w123_1
label values w123_2 lb_w123_2
label values w124 lb_w124
label values w125_1 lb_w125_1
label values w125_2 lb_w125_2
label values w125_3 lb_w125_3
label values w125_4 lb_w125_4
label values w125_5 lb_w125_5
label values w125_6 lb_w125_6
label values w126_2 lb_w126_2
label values w126_3 lb_w126_3
label values w126_4 lb_w126_4
label values w127_2 lb_w127_2
label values w127_3 lb_w127_3
label values w127_4 lb_w127_4
label values w128_2 lb_w128_2
label values w128_3 lb_w128_3
label values w128_4 lb_w128_4
label values w129_2 lb_w129_2
label values w129_3 lb_w129_3
label values w129_4 lb_w129_4
label values w130_2 lb_w130_2
label values w130_3 lb_w130_3
label values w130_4 lb_w130_4
label values w131_2 lb_w131_2
label values w131_3 lb_w131_3
label values w131_4 lb_w131_4
label values w132_2 lb_w132_2
label values w132_3 lb_w132_3
label values w132_4 lb_w132_4
label values w133_2 lb_w133_2
label values w133_3 lb_w133_3
label values w133_4 lb_w133_4
label values w134_2 lb_w134_2
label values w134_3 lb_w134_3
label values w134_4 lb_w134_4
label values w135_2 lb_w135_2
label values w135_3 lb_w135_3
label values w135_4 lb_w135_4
label values w136_2 lb_w136_2
label values w136_3 lb_w136_3
label values w136_4 lb_w136_4
label values w137_2 lb_w137_2
label values w137_3 lb_w137_3
label values w137_4 lb_w137_4
label values w138_2 lb_w138_2
label values w138_3 lb_w138_3
label values w138_4 lb_w138_4
label values w139_2 lb_w139_2
label values w139_3 lb_w139_3
label values w139_4 lb_w139_4
label values w14_2 lb_w14_2
label values w140_2 lb_w140_2
label values w140_3 lb_w140_3
label values w140_4 lb_w140_4
label values w141_2 lb_w141_2
label values w141_3 lb_w141_3
label values w141_4 lb_w141_4
label values w142_2 lb_w142_2
label values w142_3 lb_w142_3
label values w142_4 lb_w142_4
label values w143_2 lb_w143_2
label values w143_3 lb_w143_3
label values w143_4 lb_w143_4
label values w144_2 lb_w144_2
label values w144_3 lb_w144_3
label values w144_4 lb_w144_4
label values w145 lb_w145
label values w146 lb_w146
label values w147 lb_w147
label values w148 lb_w148
label values w149 lb_w149
label values w150 lb_w150
label values w151 lb_w151
label values w152 lb_w152
label values w153 lb_w153
label values w154 lb_w154
label values w155 lb_w155
label values w156_1 lb_w156_1
label values w156_2 lb_w156_2
label values w156_3 lb_w156_3
label values w157_1 lb_w157_1
label values w157_2 lb_w157_2
label values w157_3 lb_w157_3
label values w157_4 lb_w157_4
label values w158_1 lb_w158_1
label values w158_2 lb_w158_2
label values w158_3 lb_w158_3
label values w158_4 lb_w158_4
label values w158_5 lb_w158_5
label values w159_1 lb_w159_1
label values w159_2 lb_w159_2
label values w159_3 lb_w159_3
label values w159_4 lb_w159_4
label values w159_5 lb_w159_5
label values w160_1 lb_w160_1
label values w160_2 lb_w160_2
label values w160_3 lb_w160_3
label values w160_4 lb_w160_4
label values w160_5 lb_w160_5
label values w160_6 lb_w160_6

label values w161_1 lb_w161_1
label values w161_2 lb_w161_2
label values w161_3 lb_w161_3
label values w161_4 lb_w161_4
label values w161_5 lb_w161_5
label values w161_6 lb_w161_6

label values w162_1 lb_w162_1
label values w162_2 lb_w162_2
label values w162_3 lb_w162_3
label values w162_4 lb_w162_4
label values w162_5 lb_w162_5
label values w162_8 lb_w162_8
label values w163_1 lb_w163_1
label values w163_2 lb_w163_2
label values w163_3 lb_w163_3
label values w163_4 lb_w163_4
label values w163_5 lb_w163_5
label values w163_8 lb_w163_8
label values w2 lb_w2
label values w32 lb_w32
label values w33 lb_w33
label values w34 lb_w34
label values w35 lb_w35
label values w36 lb_w36
label values w37 lb_w37
label values w38 lb_w38
label values w39 lb_w39
label values w40 lb_w40
label values w41 lb_w41
label values w42 lb_w42
label values w43 lb_w43
label values w44 lb_w44
label values w45 lb_w45
label values w6 lb_w6
label values w7_1 lb_w7_1
label values w8 lb_w8

label data "2003 Santarem Rural: Household Level Data" 

**********************************************************************
* Add form and lot-level missing codes (9997, 9996, 9995, etc)

* Finish bringing variable naming into full compliance with a-coding for strings
rename m13_1 m13_1a
rename m13_3 m13_3a
rename m14_3 m14_3a
rename m15_1 m15_1a
rename m24_04_acquired_year m24_04_acquired_year_a
rename m24_04_sold_year m24_04_sold_year_a
rename m25_02_other_year m25_02_other_year_a
rename m26_17a_all m26_17_all_a
rename m3 m3a
rename m3_reclass m3_reclass_a
rename m50_5_where_1998 m50_5_where_1998a
rename m50_5_where_1999 m50_5_where_1999a
rename m50_5_where_2000 m50_5_where_2000a
rename m50_5_where_2001 m50_5_where_2001a
rename m50_5_where_2002 m50_5_where_2002a
rename m50_5_where_2003 m50_5_where_2003a
rename m68_othertech1_name m68_othertech1_name_a
rename m68_othertech2_name m68_othertech2_name_a
rename m68_othertech3_name m68_othertech3_name_a
rename m77 m77a
rename m78 m78a
rename m79 m79a
rename m28_citrus_name m28_citrus_name_a
rename m28_cocoa_name m28_cocoa_name_a

foreach var of varlist w100_cheese_a-w100_snacks_g {
	    local front = reverse(substr((reverse("`var'")),2,30))
		if substr("`var'",-1,1)=="a" {
			rename `var' `front'1
		}
if substr("`var'",-1,1)=="b" {
			rename `var' `front'2
		}
if substr("`var'",-1,1)=="c" {
			rename `var' `front'3
		}
if substr("`var'",-1,1)=="d" {
			rename `var' `front'4
		}
if substr("`var'",-1,1)=="e" {
			rename `var' `front'1a
		}
if substr("`var'",-1,1)=="f" {
			rename `var' `front'3a
		}
if substr("`var'",-1,1)=="g" {
			rename `var' `front'4a
		}
}

* The following code turns on three additional missing codes
/*		
sort id_prop_hh
order _all, seq

foreach var of varlist m1a-w163_8 {
		if substr("`var'",-1,1)=="a" {
		      replace `var'="9995" if `var'=="9999" & (id_registro_m==1 & id_registro_w==1)
		      replace `var'="9996" if `var'=="9999" & (id_registro_m==1 & id_registro_w==0)
			  replace `var'="9997" if `var'=="9999" & (id_registro_m==0 & id_registro_w==1)
		}	
		if substr("`var'",-1,1)~="a" {
		      replace `var'=9995 if `var'==9999 & (id_registro_m==1 & id_registro_w==1)
		      replace `var'=9996 if `var'==9999 & (id_registro_m==1 & id_registro_w==0)
			  replace `var'=9997 if `var'==9999 & (id_registro_m==0 & id_registro_w==1)
		}
}

*/
  
**********************************************************************
* Save finished file
sort id_prop_hh
order _all, seq
save stm2003r_hh.dta, replace

**********************************************************************
* Codebook 

mvdecode _all, mv(9999=.\9998=.\9997=.\9996=.\9995=.)
capture log close
* Note that if folder is moved, all directory path prior to "stm_analysis" must be changed
log using "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\log\codebook\stm_2003r_hh_codebook", replace
codebook, header all
capture log close

******************************************************************************************************
** End processing basic HH-level datafile for STM 2003 Rural 
******************************************************************************************************
******************************************************************************************************
** Begin processing end-user (deidentified) HH-level datafile for STM 2003 Rural 
******************************************************************************************************

**************************************************************
* Prepare linking file for later merging

use stm2003r_link.dta, clear
keep id_prop_hh id_prop_rand id_house_rand id_prop_hh_rand
sort id_prop_hh
by id_prop_hh: gen dup=_n
drop if dup>1
save id_add_01.dta, replace

use stm2003r_hh.dta, clear

**************************************************************
* Drop identifying variables
drop int_entry m1a m3a m6a m7_3_1a m7_3_2a m7_3_3a m7_4a m10_7a m11a m13_1a m15_1 m18_1 m77 m78 m79 /// 
w1a w3a w10a w14_1 id_name_m id_name_m_2 id_name_w id_name_w_2 int_road_m int_road_w /// 
int_utm_x_m int_utm_y_m int_utm_x_w int_utm_y_w int_village_m int_village_w int_notes ///
int_interviewer_m int_interviewer_w id_woman int_roster_no_w int_date_m int_date_w int_entered ///
m2_month m8_month w4_month w5_month m4a m18_1_1a m18_4a m19_1a m19_2a m20_4a m21_10_1a ///
m22_10_1a m30_13a m30_14a m30_15a m38_2a m39_2a m49_5a m59_1_1a m59_1_2a m59_2_1a m59_2_2a ///
m61_3a m69_5_a m70_1a m71_1a m72_1a m73_1a m74_1a m75_cr1_2a m75_cr1_6a m75_cr2_2a m75_cr2_6a ///
m75_cr3_2a m75_cr3_6a m76a w2_6a w100_cheese_3a w100_cheese_4a w100_clothes_3a w100_clothes_4a ///
w100_crochet_3a w100_crochet_4a w100_garden_3a w100_garden_4a w100_handcraft_3a w100_handcraft_4a ///
w100_other1_3a w100_other1_4a w100_other2_3a w100_other2_4a w100_snacks_3a w100_snacks_4a ///
w101_first_a w101_second_a w102_7a w112a w119a w154a w155a w156_1a w156_2a w156_3a w157_4a ///
w158_4a w159_5a w160_5a w161_6a w162_5a w163_5a 

forvalues k = 126/144 {
drop w`k'_2a
drop w`k'_3a
}


**************************************************************
* Select only those cases included in the final sample
keep if id_final_sample==1

**************************************************************
* Uncomment next line to compress data file by converting to smaller variable types(saves about 1M space at present)
* compress _all

***************************************************************
* Swap out identifiers for randomized identifiers

merge 1:1 id_prop_hh using id_add_01.dta, keepusing(id_prop_hh id_prop_rand id_house_rand id_prop_hh_rand) update replace
drop if _merge==2
drop _merge
order id_prop_rand id_house_rand id_prop_hh_rand, after (id_final_sample)
drop id_prop id_house id_prop_hh
rename id_prop_rand id_prop_r
rename id_house_rand id_house_r
rename id_prop_hh_rand id_prop_hh_r

label data "2003 Santarem Rural: Household Level Data Public" 

save stm2003r_hh_public.dta, replace

**********************************************************************
* Codebook 

mvdecode _all, mv(9999=.\9998=.\9997=.\9996=.\9995=.)
capture log close
* Note that if folder is moved, all directory path prior to "stm_analysis" must be changed
log using "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\log\codebook\stm_2003r_hh_public_codebook", replace
codebook, header all 
capture log close

******************************************************************************************************
** Cleanup Directory
******************************************************************************************************

capture erase id_add_01.dta
