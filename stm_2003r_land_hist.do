************************************************************************************
** file: \\stm_analysis\do\stm_2003r_land_hist.do
** Programmer: james r. hull
** Date started: 2012 05 20
** Date finished: 2012 05 21
** Updates: None at Present
** Data Input:  w_subtable_q89_99_land_hist_history.dta
**              stm2003r_link.dta
**              stm2003r_hh.dta
** Data Output: stm2003r_land_hist.dta
**              stm2003r_land_hist_public.dta
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
log using "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\log\stm_2003r_land_hist", replace text

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
** 1. Format w_subtable_q74_88_land_hist_members.dta
*******************************************************

**************************************************************
** ADD NEW IDENTIFIERS

** Prepare Linking File - just property level first

use stm2003r_link.dta, clear
keep id_prop id_house id_prop_hh id_w_number id_prop_rand id_house_rand id_prop_hh_rand
sort id_prop_hh
by id_prop_hh: gen dup=_n
drop if dup>1
drop dup
sort id_prop_hh
save add0001.dta, replace

** Merge New Property-level Identifiers onto existing file

use m_subtable_q27_landusehistory.dta, clear
rename mprop_hh_id id_prop_hh
sort id_prop_hh

merge m:1 id_prop_hh using add0001.dta, update replace
tab _merge
drop if _merge==2
drop _merge 
order id_prop id_house id_prop_hh id_prop_rand id_house_rand id_prop_hh_rand id_w_number, first
save stm_2003r_land_hist.dta, replace

**************************************************************
** DROP JUNK AND QUESTIONABLE VARIABLES
drop uniqueid donolote_ mpropid mhouseid 

**************************************************************
** RECODES and RENAMES

*m27_1
drop if m27_1==0                           /*These cases contain no informative data of any sort */
replace m27_1=9998 if m27_1==8888

*m27_2
replace m27_2=9999 if m27_2==999
replace m27_2=9999 if m27_2==.

*m27_3
replace m27_3=9999 if m27_3==.

*m27_4
replace m27_4=9999 if m27_4==.

*m27_5
replace m27_5=9999 if m27_5==.

*m27_6
replace m27_6=9999 if m27_6==.

*m27_7
replace m27_7="9998" if m27_7==""

*m27_8
rename m27_8 m27_8a
replace m27_8a="9998" if m27_8a==""

*m27_9
replace m27_9=9999 if m27_9==.

*m27_10
replace m27_10=9999 if m27_10==.

*m27_11
rename m27_11 m27_11a
replace m27_11a="9998" if m27_11a==""
* format m27_11 %-20s

**************************************************************
** ADD VARIABLE DESCRIPTIONS

label variable m27_1 "Num: Year of reporting on lot [m27]"
label variable m27_2 "Num: Hectares planted: Annuals [m27]"
label variable m27_3 "Num: Hectares planted: Perrenials [m27]"
label variable m27_4 "Num: Hectares planted: Pasture [m27]"
label variable m27_5 "Num: Hectares planted: Forest [m27]"
label variable m27_6 "Num: Hectares affected: Fire [m27]"
label variable m27_7 "Num: Credit in Reals [m27]"
label variable m27_8 "String: Technology used [m27]"
label variable m27_9 "Num: Hectares bought [m27]"
label variable m27_10 "Num: Hectares sold [m27]"
label variable m27_11 "String: Text of reason [m27]"

**************************************************************
** ADD VALUE LABELS

* NO LABELS

label data "2003 Santarem Rural: Land Use History Report" 

**************************************************************
** REPORT, CODEBOOK, AND SAVE

describe, short
save stm2003r_land_hist_public.dta, replace
drop id_prop_rand id_house_rand id_prop_hh_rand
save stm2003r_land_hist.dta, replace

mvdecode _all, mv(9999=.\9998=.\9997=.\9996=.\9995=.)
capture log close
* Note that if folder is moved, all directory path prior to "stm_analysis" must be changed
log using "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\log\codebook\stm_2003r_land_hist_codebook", replace
codebook, header all 
capture log close

**************************************************************
** SWAP OUT IDENTIFIERS FOR RANDOMIZED (PUBLIC) IDENTIFIERS

* Prepare linking file for later merging

use stm2003r_land_hist_public.dta, clear
rename id_prop_rand id_prop_r
rename id_house_rand id_house_r
rename id_prop_hh_rand id_prop_hh_r

**************************************************************
** DELETE IDENTIFYING VARIABLES FOR PUBLIC DATASET

drop id_prop id_house id_prop_hh id_w_number m27_8a m27_11a

**************************************************************
** CODEBOOK AND SAVE PUBLIC VERSION

label data "2003 Santarem Rural: Land Use History Report Public" 

describe, short
save stm2003r_land_hist_public.dta, replace

mvdecode _all, mv(9999=.\9998=.\9997=.\9996=.\9995=.)
capture log close
* Note that if folder is moved, all directory path prior to "stm_analysis" must be changed
log using "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\log\codebook\stm_2003r_land_hist_public_codebook", replace
codebook, header all 
capture log close

******************************************************************************************************
** Cleanup Directory
******************************************************************************************************

capture erase id_add_01.dta
capture erase id_add_02.dta
capture erase add0001.dta
