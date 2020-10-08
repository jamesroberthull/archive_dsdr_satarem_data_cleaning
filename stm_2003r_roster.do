************************************************************************************
** file: \\stm_analysis\do\stm_2003r_roster.do
** Programmer: james r. hull
** Date started: 2012 05 15
** Date finished: 
** Updates: None at Present
** Data Input: w_subtable_q16_31_household_roster.dta
**             stm2003r_link.dta
**             stm2003r_hh.dta
** Data Output: stm2003r_roster.dta
**              stm2003r_roster_public.dta
** STATA Version: 11
** Purpose: Complete Merge and Clean of 2003 Rural Santarem HH Roster Data
** Notes: 
************************************************************************************

****************************************************************************************

***********************************************************************************************
**************************************************************** SET ENVIRONMENTAL PARAMETERS
***********************************************************************************************

capture log close
* Note that if folder is moved, all directory path prior to "stm_analysis" must be changed
log using "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\log\stm_2003r_roster", replace text

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
** 1. Format w_subtable_q16_31_household_roster.dta 
*******************************************************

**************************************************************
** ADD NEW IDENTIFIERS

** Prepare Linking File

use stm2003r_link.dta, clear
keep id_prop id_house id_prop_hh id_roster id_w_number id_person
drop if id_roster==9999999998
sort id_roster
by id_roster: gen dup=_n
drop if dup>1
drop dup
save add0001.dta, replace

** Merge New Identifiers onto existing file

use w_subtable_q16_31_household_roster.dta, clear
rename personid id_roster
rename childid id_child
format id_child %12.0g
sort id_roster

merge 1:1 id_roster using add0001.dta, update replace
tab _merge
drop if _merge==2
drop _merge 
drop key wintrno propid hhid prophhid 
order id_prop id_house id_prop_hh id_w_number id_roster id_person, first


**************************************************************
** RECODES and RENAMES

*id_child
replace id_child=9999999998 if id_child==.

*w16
rename _2w_16 w16

*w17
rename _2w_17 w17a

*w18
rename _2w_18 w18a
replace w18a="9999" if substr(w18a,1,4)=="9999"

*w19
rename _2w_19 w19_month
rename _2w_19a w19_year
replace w19_month=9999 if w19_month==99
replace w19_month=10 if w19_month==100

*w20
rename _2w_20 w20a

*w21
rename _2w_21 w21
replace w21=9999 if w21==3
replace w21=0 if w21==1
replace w21=01 if w21==2

*w22
rename _2w_22 w22
replace w22=9999 if w22==9

*w23
rename _2w_23 w23_month
rename _2w_23a w23_year
replace w23_month=9999 if w23_month==99
replace w23_month=9998 if w23_month==88
replace w23_year=9998 if w23_year==8888

*w24
rename _2w_24 w24
replace w24=9998 if w24==888

*w25
rename _2w_25 w25
replace w25=9998 if w25==8
replace w25=9999 if w25==9
replace w25=0 if w25==2

*w26
rename _2w_26 w26_month
rename _2w_26a w26_year
replace w26_month=9999 if w26_month==99
replace w26_month=9998 if w26_month==88
replace w26_month=6 if w26_month==66
replace w26_year=9998 if w26_year==8888

*w27
rename _2w_27 w27
rename _2w_27a w27a
replace w27=9998 if w27==8
replace w27=9999 if w27==9

*w28
rename _2w_28 w28
replace w28="1" if w28=="Yes"
replace w28="0" if w28=="No"
destring(w28), replace

*w29
rename _2w_29 w29a
replace w29a="9998" if w29a=="8888"
replace w29a="9999" if w29a==""

*w30
rename _2w_30 w30
replace w30=9998 if w30==8888
replace w30=9999 if w30==0

*w31
rename _2w_31 w31
rename _2w_31a w31a
replace w31=9998 if w31==8
replace w31=9999 if w31==9
replace w31=9999 if w31==0
replace w31=4 if w31==5

*w32_age
rename _2w_age w32_age
replace w32_age=9999 if w32_age==999
replace w32_age=9999 if w32_age==0

*w32
rename _2w_32 w32
replace w32="1" if w32=="Yes"
replace w32="0" if w32=="No"
destring(w32), replace

*w33
rename _2w_33 w33

*w34
rename _2w_34 w34

*w35
rename _2w_35 w35

*w36
rename _2w_36 w36

*w37
rename _2w_37 w37

*w38
rename _2w_38 w38

*w39
rename _2w_39 w39

*w40
rename _2w_40 w40

*w41
rename _2w_41 w41

*w42
rename _2w_42 w42

*w43
rename _2w_43 w43

*w44
rename _2w_44 w44

*w45
rename _2w_45 w45

*w46
rename _2w_46 w46
replace w46=9998 if w46==888
replace w46=9999 if w46==999
replace w46=9999 if w46==0

*w47
rename _2w_47 w47

*w48
rename _2w_48 w48
replace w48=9998 if w48==888
replace w48=9999 if w48==999
replace w48=9998 if w48==0
replace w48=9999 if w48==99

replace w47=1 if w48==15     /* fix one illogical code */

*w49
rename _2w_49 w49
replace w49=9998 if w49==8888
replace w49=9999 if w49==0

*w49
rename _2w_49a w49_unit
replace w49_unit=9998 if w49_unit==8
replace w49_unit=9999 if w49_unit==9
replace w49_unit=9999 if w49_unit==0
replace w49_unit=1 if w49_unit==3

**************************************************************
** DROP JUNK AND QUESTIONABLE VARIABLES


**************************************************************
** ADD VARIABLE DESCRIPTIONS

label variable w16 "Num: Listing Number on Household Roster [w16]"
label variable w17a "String: Name of household member [w17]"
label variable w18a "String: Relation to interviewee [w18]"
label variable w19_month "Num: Date of birth (month) [w19]"
label variable w19_year "Num: Date of birth (year) [w19]"
label variable w20a "String: Place of birth [w20]"
label variable w21 "Dichot: Household member is male [w21]"
label variable w22 "Cat: Marital status [w22]"
label variable w23_month "Num: Date of marriage/union (month) [w23]"
label variable w23_year "Num: Date of marriage/union (year) [w23]"
label variable w24 "Num: Years of education [w24]"
label variable w25 "Dichot: Currently in school [w25]"
label variable w26_month "Num: Date of arrival on lot (month) [w26]"
label variable w26_year "Num: Date of arrival on lot (year)  [w26]"
label variable w27 "Cat: Occupation [w27]"
label variable w27a "String: Text of other occupation [w27]"
label variable w28 "Dichot: Slept here last night [w28]"
label variable w29a "String: Text of where is person now [w29]"
label variable w30 "Num: How many days since person slept here [w30]"
label variable w31 "Cat: Why is person absent [w31]"
label variable w31a "String: Text of other reason for absence [w31]"
label variable w32_age "Num: Age [w32]"
label variable w32 "Dichot: Household Member Activities: does housework [w32]"
label variable w33 "Dichot: Household Member Activities: watches the kids [w33]"
label variable w34 "Dichot: Household Member Activities: works in the garden [w34]"
label variable w35 "Dichot: Household Member Activities: cares for animals [w35]"
label variable w36 "Dichot: Household Member Activities: cares for cattle [w36]"
label variable w37 "Dichot: Household Member Activities: milks cows [w37]"
label variable w38 "Dichot: Household Member Activities: forms pasture [w38]"
label variable w39 "Dichot: Household Member Activities: helps clear forests [w39]"
label variable w40 "Dichot: Household Member Activities: helps with burning [w40]"
label variable w41 "Dichot: Household Member Activities: works in fields [w41]"
label variable w42 "Dichot: Household Member Activities: helps weed [w42]"
label variable w43 "Dichot: Household Member Activities: helps collect [w43]"
label variable w44 "Dichot: Household Member Activities: helps bag/dry coffee, cocoa, pepper [w44]"
label variable w45 "Dichot: Household Member Activities: makes flour [w45]"
label variable w46 "Num: At what age did member start helping [w46]"
label variable w47 "Dichot: Member has another activity outside the lot [w47]"
label variable w48 "Num: How long has member worked outside the lot [w48]"
label variable w49 "Num: How much does member earn [w49]"
label variable w49_unit "Cat: Unit of earnings per period [w49]"


**************************************************************
** ADD VALUE LABELS

label define w21_lb 0 "No" 1 "Yes" 
label define w22_lb 1 "Single" 2 "Married" 3 "Common law" 4 "Divorced" 5 "Widowed"
label define w25_lb 0 "No" 1 "Yes" 
label define w27_lb 1 "Agropastoral" 2 "Business" 3 "Professional" 4 "Housework" 5 "Other" 6 "None"
label define w28_lb 0 "No" 1 "Yes" 
label define w31_lb 1 "Work" 2 "School" 3 "Vacation" 4 "Other"
label define w32_lb 0 "No" 1 "Yes" 
label define w33_lb 0 "No" 1 "Yes" 
label define w34_lb 0 "No" 1 "Yes" 
label define w35_lb 0 "No" 1 "Yes" 
label define w36_lb 0 "No" 1 "Yes" 
label define w37_lb 0 "No" 1 "Yes" 
label define w38_lb 0 "No" 1 "Yes" 
label define w39_lb 0 "No" 1 "Yes" 
label define w40_lb 0 "No" 1 "Yes" 
label define w41_lb 0 "No" 1 "Yes" 
label define w42_lb 0 "No" 1 "Yes" 
label define w43_lb 0 "No" 1 "Yes" 
label define w44_lb 0 "No" 1 "Yes" 
label define w45_lb 0 "No" 1 "Yes" 
label define w47_lb 0 "No" 1 "Yes" 
label define w49_unit_lb 1 "Per day" 2 "Per month" 

label values w21 w21_lb
label values w22 w22_lb
label values w25 w25_lb
label values w27 w27_lb
label values w28 w28_lb
label values w31 w31_lb
label values w32 w32_lb
label values w33 w33_lb
label values w34 w34_lb
label values w35 w35_lb
label values w36 w36_lb
label values w37 w37_lb
label values w38 w38_lb
label values w39 w39_lb
label values w40 w40_lb
label values w41 w41_lb
label values w42 w42_lb
label values w43 w43_lb
label values w44 w44_lb
label values w45 w45_lb
label values w47 w47_lb
label values w49_unit w49_unit_lb

label data "2003 Santarem Rural: Household Roster" 

**************************************************************
** REPORT, CODEBOOK, AND SAVE

describe, short
save stm2003r_roster.dta, replace

mvdecode _all, mv(9999=.\9998=.\9997=.\9996=.\9995=.)
capture log close
* Note that if folder is moved, all directory path prior to "stm_analysis" must be changed
log using "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\log\codebook\stm_2003r_roster_codebook", replace
codebook, header all 
capture log close

**************************************************************
** SWAP OUT IDENTIFIERS FOR RANDOMIZED (PUBLIC) IDENTIFIERS

* Prepare linking file for later merging

use stm2003r_link.dta, clear
keep id_prop_rand id_house_rand id_prop_hh_rand id_roster
sort id_roster
by id_roster: gen dup=_n
drop if dup>1
drop if id_roster==9999999998
drop dup
save id_add_02.dta, replace

use stm2003r_roster.dta, clear
merge 1:1 id_roster using id_add_02.dta, update replace
drop if _merge==2
drop _merge id_prop id_house id_prop_hh id_w_number id_roster id_child
order id_prop_rand id_house_rand id_prop_hh_rand, first
rename id_prop_rand id_prop_r
rename id_house_rand id_house_r
rename id_prop_hh_rand id_prop_hh_r

save stm2003r_roster_public.dta, replace

**************************************************************
** DELETE IDENTIFYING VARIABLES FOR PUBLIC DATASET

use stm2003r_roster_public.dta, clear
drop w17a w18a w20a w19_month w23_month w26_month w27a w29a w31a

**************************************************************
** CODEBOOK AND SAVE PUBLIC VERSION

label data "2003 Santarem Rural: Household Roster Public" 

describe, short
save stm2003r_roster_public.dta, replace

mvdecode _all, mv(9999=.\9998=.\9997=.\9996=.\9995=.)
capture log close
* Note that if folder is moved, all directory path prior to "stm_analysis" must be changed
log using "C:\Documents and Settings\jh51\Desktop\PAPERSHEIT\My Dropbox\stm_analysis\log\codebook\stm_2003r_roster_public_codebook", replace
codebook, header all 
capture log close

******************************************************************************************************
** Cleanup Directory
******************************************************************************************************

capture erase id_add_02.dta
capture erase add0001.dta
