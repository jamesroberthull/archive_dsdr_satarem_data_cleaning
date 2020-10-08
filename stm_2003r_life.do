************************************************************************************
** file: \\stm_analysis\do\stm_2003r_life.do
** Programmer: james r. hull
** Date started: 2012 05 20
** Date finished: 2012 05 21
** Updates: None at Present
** Data Input:  w_subtable_q89_99_life_history.dta
**              stm2003r_link.dta
**              stm2003r_hh.dta
** Data Output: stm2003r_life.dta
**              stm2003r_life_public.dta
** STATA Version: 11
** Purpose: Complete Merge and Clean of 2003 Rural Santarem Individual-Level Data
** Notes: 
************************************************************************************

****************************************************************************************

***********************************************************************************************
**************************************************************** SET ENVIRONMENTAL PARAMETERS
***********************************************************************************************

capture log close
* Note that if folder is moved, all directory path prior to "stm_analysis" must be changed
log using "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\log\stm_2003r_life", replace text

* Note that if folder is moved, all directory path prior to "stm_analysis" must be changed
cd "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\data\stm_2003r\data\stata\"

* Tell Stata to create all new variables in type double in order to prevent truncation of ID vars and so forth
set type double, permanently

* Tell Stata not to pause in displaying results of this do-file
set more off

****************************************************************************************

******************************************************************************************************************
**************************************************************** CLEANING AND FORMATTING OF INDIVIDUAL DATA FILES
******************************************************************************************************************

***************************************************************************************************
** 1. Format w_subtable_q89_99_life_history.dta
*******************************************************

**************************************************************
** ADD NEW IDENTIFIERS

** Prepare Linking File

use stm2003r_link.dta, clear
keep id_prop id_house id_prop_hh id_roster id_person id_w_number form_life form_fhead
drop if (form_fhead==2 | form_fhead==0)
drop if id_w_number==9999999998
sort id_w_number
by id_w_number: gen dup=_n
drop if dup>1
drop dup
save add0001.dta, replace

** Merge New Identifiers onto existing file

use w_subtable_q89_99_life_history.dta, clear
rename wintrno id_w_number
sort id_w_number

merge m:1 id_w_number using add0001.dta, update replace
tab _merge
drop if _merge==2
drop _merge 
*drop wpropid whouseid wprop_hh_id womanhhroster
order id_prop id_house id_prop_hh id_roster id_person id_w_number, first
rename _5w_89 w89_age
sort id_roster w89_age
drop form_life form_fhead

**************************************************************
** DROP JUNK AND QUESTIONABLE VARIABLES
drop key 

**************************************************************
** RECODES and RENAMES

*w89
replace w89_age=9999 if (w89_age==0 | w89_age==3 | w89_age==.)

*w90
rename _5w_90 w90a
replace w90="9999" if w90==""

*w91
rename _5w_91 w91

*w92
rename _5w_92 w92a
replace w92a="9999" if w92a==""

*w93
rename _5w_93 w93a
replace w93a="9998" if w93a=="8888"

*w94
rename _5w_94 w94
replace w94=9998 if w94==8
replace w94=9998 if w94==0
replace w94=9999 if w94==9
replace w94=9999 if w94==.

*w95
rename _5w_95 w95a
replace w95a="9998" if w95a=="8888"
replace w95a="9998" if w95a==""

*w96
rename _5w_96 w96a
replace w96a="9998" if w96a=="8888"
replace w96a="9998" if w96a==""

*w97
rename _5w_97 w97
replace w97=9998 if w97==8
replace w97=9998 if w97==0
replace w97=9999 if w97==9

*w98
rename _5w_98 w98a
replace w98a="9998" if w98a==""

*w99
rename _5w_99 w99
replace w99=9998 if w99==0
replace w99=9999 if w99==.

*w99a
rename _5w_99 w99a
replace w99a="9998" if w99a==""

**************************************************************
** ADD VARIABLE DESCRIPTIONS

label variable id_w_number "Num: Woman interview number ID variable for linking [id_prop_hh+00] [form]"
label variable w89_age "Num: Age on life history calendar of events [w89]"
label variable w90a "String: Name of child born [w90]"
label variable w91 "Dichot: Was child born alive [w91]"
label variable w92a "String: Name of partner in union formation [w92]"
label variable w93a "String: Name of partner in union dissolution[w93]"
label variable w94 "Cat: Reason for dissolution [w94]"
label variable w95a "Num: Code for origin of move [w95]"
label variable w96a "Num: Code for destination of move [w96]"
label variable w97 "Cat: Type of migration [w97]"
label variable w98 "Num: School grade attended [w97]"
label variable w99 "Cat: Main occupation [w99]"
label variable w99a "String: Text of other main occupation [w99]"

**************************************************************
** ADD VALUE LABELS

label define w91_lb 0 "No" 1 "Yes"
label define w94_lb 1 "Divorce/Separation" 2 "Spouse's Death"
label define w97_lb 1 "Rural-Rural" 2 "Rural-Urban" 3 "Urban-Rural" 4 "Urban-Urban"
label define w99_lb 1 "Agropastoral" 2 "Commerce" 3 "Professional" 4 "Domestic Work" 5 "Other" 6 "None" 

label values w91 w91_lb
label values w94 w94_lb
label values w97 w97_lb
label values w99 w99_lb

label data "2003 Santarem Rural: Life History Calendar" 

**************************************************************
** REPORT, CODEBOOK, AND SAVE

describe, short
save stm2003r_life.dta, replace

mvdecode _all, mv(9999=.\9998=.\9997=.\9996=.\9995=.)
capture log close
* Note that if folder is moved, all directory path prior to "stm_analysis" must be changed
log using "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\log\codebook\stm_2003r_life_codebook", replace
codebook, header all 
capture log close

**************************************************************
** SWAP OUT IDENTIFIERS FOR RANDOMIZED (PUBLIC) IDENTIFIERS

* Prepare linking file for later merging

use stm2003r_link.dta, clear
keep id_prop_rand id_house_rand id_prop_hh_rand id_roster id_w_number
sort id_w_number
by id_w_number: gen dup=_n
drop if dup>1
drop if id_w_number==9999999998
drop dup
save id_add_02.dta, replace

use stm2003r_life.dta, clear
sort id_w_number
merge m:1 id_w_number using id_add_02.dta, update replace
drop if _merge==2
drop _merge id_prop id_house id_prop_hh id_roster id_w_number
order id_prop_rand id_house_rand id_prop_hh_rand, first
rename id_prop_rand id_prop_r
rename id_house_rand id_house_r
rename id_prop_hh_rand id_prop_hh_r

save stm2003r_life_public.dta, replace

**************************************************************
** DELETE IDENTIFYING VARIABLES FOR PUBLIC DATASET

use stm2003r_life_public.dta, clear
drop w90a w92a w93a w95a w96a w99a
**************************************************************
** CODEBOOK AND SAVE PUBLIC VERSION

label data "2003 Santarem Rural: Life History Calendar Public" 

describe, short
save stm2003r_life_public.dta, replace

mvdecode _all, mv(9999=.\9998=.\9997=.\9996=.\9995=.)
capture log close
* Note that if folder is moved, all directory path prior to "stm_analysis" must be changed
log using "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\log\codebook\stm_2003r_life_public_codebook", replace
codebook, header all 
capture log close

******************************************************************************************************
** Cleanup Directory
******************************************************************************************************

capture erase id_add_01.dta
capture erase id_add_02.dta
capture erase add0001.dta
